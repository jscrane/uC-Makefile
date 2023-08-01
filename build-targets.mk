SUFFIX_HEX ?= hex
SUFFIX_BIN ?= bin
SUFFIX_EEP ?= eep

SKETCH_ELF := $(build.path)/$(SKETCH).elf
SKETCH_BIN := $(build.path)/$(SKETCH).$(SUFFIX_BIN)
SKETCH_HEX := $(build.path)/$(SKETCH).$(SUFFIX_HEX)
SKETCH_EEP := $(build.path)/$(SKETCH).$(SUFFIX_EEP)
SOURCES += $(wildcard *.cpp) $(wildcard *.c)
OBJECTS := $(foreach s,$(SOURCES), $s.o) $(SKETCH).cpp.o
DEPS := $(foreach s,$(OBJECTS), $(s:.o=.d))

TERMINAL ?= minicom
TERMINAL_FLAGS ?= -D $(SERIAL_PORT) -b $(TERMINAL_SPEED) $(TERMINAL_EXTRA_FLAGS)
CPPFLAGS += -DTERMINAL_SPEED=$(TERMINAL_SPEED)

SKETCHBOOK ?= $(HOME)/Arduino
LIBRARY_PATH := $(LOCAL_LIBRARY_PATH) $(SKETCHBOOK)/libraries $(runtime.platform.path)/libraries
LIBRARIES += $(sort $(shell sed -ne "s/^ *\# *include *[<\"]\(.*\)\.h[>\"]/\1/p" $(SKETCH)))
REQUIRED_ROOTS := $(foreach r, $(LIBRARIES), $(firstword $(foreach d, $(LIBRARY_PATH), $(wildcard $d/$r))))

BUILD_CORE := $(build.path)/core
BUILD_LIBS := $(build.path)/libs

includes := -I$(build.core.path) -I"$(build.variant.path)" $(foreach r, $(REQUIRED_ROOTS), -I$r -I$r/src)
CORE_SOURCES := $(shell find $(build.core.path) -type f \( -name \*.c -o -name \*.cpp -o -name \*.S \)) $(wildcard $(addprefix $(build.variant.path)/, *.c *.cpp *.S))
CORE_OBJECTS := $(foreach s, $(CORE_SOURCES), $(BUILD_CORE)/$s.o)

LIBSRC1 := $(foreach r, $(REQUIRED_ROOTS), $(wildcard $r/*.c $r/*.cpp $r/utility/*.c $r/utility/*.cpp))
LIBSRC2 := $(foreach r, $(REQUIRED_ROOTS), $(wildcard $r/src/*.c $r/src/*.cpp $r/src/*/*.c $r/src/*/*.cpp))
LIBRARY_SOURCES := $(LIBSRC1) $(LIBSRC2)
LIBRARY_OBJECTS := $(foreach s, $(LIBRARY_SOURCES), $(BUILD_LIBS)/$s.o)

all: prebuild $(SKETCH_BIN) $(SKETCH_HEX) $(SKETCH_ELF) build-summary

define compile-sources
$1.o: source_file = $1
$1.o: object_file = $1.o

ifeq ($(suffix $1),.c)
$1.o: compiler.c.extra_flags += $(CPPFLAGS)
$1.o:
	$$(recipe.c.o.pattern)
endif

ifeq ($(suffix $1),.cpp)
$1.o: compiler.cpp.extra_flags += $(CPPFLAGS)
$1.o:
	$$(recipe.cpp.o.pattern)
endif

ifeq ($(suffix $1),.S)
$1.o:
	$$(recipe.S.o.pattern)
endif
endef

$(foreach s,$(SOURCES), $(eval $(call compile-sources,$s)))

define compile-sketch
$1.cpp.o: source_file = $1
$1.cpp.o: object_file = $1.cpp.o
$1.cpp.o: compiler.cpp.extra_flags += -x c++ -include Arduino.h $(CPPFLAGS)
$1.cpp.o:
	$$(recipe.cpp.o.pattern)
endef

$(eval $(call compile-sketch,$(SKETCH)))

define core-compile-targets
$(BUILD_CORE)/$1.o: source_file = $1
$(BUILD_CORE)/$1.o: object_file = $(BUILD_CORE)/$1.o

ifeq ($(suffix $1),.c)
$(BUILD_CORE)/$1.o:
	mkdir -p "$$(dir $$@)"
	$$(recipe.c.o.pattern)
endif

ifeq ($(suffix $1),.cpp)
$(BUILD_CORE)/$1.o:
	mkdir -p "$$(dir $$@)"
	$$(recipe.cpp.o.pattern)
endif

ifeq ($(suffix $1),.S)
$(BUILD_CORE)/$1.o:
	mkdir -p "$$(dir $$@)"
	$$(recipe.S.o.pattern)
endif
endef

$(foreach s,$(CORE_SOURCES), $(eval $(call core-compile-targets,$s)))

define core-archive-targets
$(archive_file_path)($(notdir $1)): object_file = $1
$(archive_file_path)($(notdir $1)):
	$$(recipe.ar.pattern)
endef

ifdef build.core
$(foreach o,$(CORE_OBJECTS), $(eval $(call core-archive-targets,$o)))
endif

ARCHIVE_TARGETS := $(foreach o,$(CORE_OBJECTS),$(archive_file_path)($(notdir $o)))

define define-hook
$1:
	$($1)
endef

define library-compile-targets
$(BUILD_LIBS)/$1.o: source_file = $1
$(BUILD_LIBS)/$1.o: object_file = $(BUILD_LIBS)/$1.o

ifeq ($(suffix $1),.c)
$(BUILD_LIBS)/$1.o: compiler.c.extra_flags += $(CPPFLAGS)
$(BUILD_LIBS)/$1.o:
	mkdir -p $$(dir $$@)
	$$(recipe.c.o.pattern)
endif

ifeq ($(suffix $1),.cpp)
$(BUILD_LIBS)/$1.o: compiler.cpp.extra_flags += $(CPPFLAGS)
$(BUILD_LIBS)/$1.o:
	mkdir -p $$(dir $$@)
	$$(recipe.cpp.o.pattern)
endif

ifeq ($(suffix $1),.S)
$(BUILD_LIBS)/$1.o:
	mkdir -p $$(dir $$@)
	$$(recipe.S.o.pattern)
endif
endef

$(foreach s,$(LIBRARY_SOURCES), $(eval $(call library-compile-targets,$s)))

define link-sketch
$1: object_files = $2
$1: $3
	$$(recipe.c.combine.pattern)
endef

PRELINK_HOOKS := $(sort $(filter recipe.hooks.linking.prelink.%.pattern, $(.VARIABLES)))

$(foreach h,$(PRELINK_HOOKS), $(eval $(call define-hook,$h)))

$(eval $(call link-sketch,$(SKETCH_ELF),$(OBJECTS) $(LIBRARY_OBJECTS),$(PRELINK_HOOKS)))

$(SKETCH_HEX):
	$(recipe.objcopy.$(SUFFIX_HEX).pattern)
	$(recipe.objcopy.$(SUFFIX_HEX).1.pattern)
	$(recipe.objcopy.$(SUFFIX_HEX).2.pattern)
	$(recipe.objcopy.$(SUFFIX_HEX).3.pattern)

$(SKETCH_BIN):
	$(recipe.objcopy.$(SUFFIX_BIN).pattern)

$(SKETCH_EEP):
	$(recipe.objcopy.$(SUFFIX_EEP).pattern)

$(ARCHIVE_TARGETS): $(BUILD_CORE) | $(CORE_OBJECTS)

$(archive_file_path): $(ARCHIVE_TARGETS)

$(SKETCH_ELF): $(OBJECTS) $(archive_file_path) $(LIBRARY_OBJECTS)

$(SKETCH_BIN): $(SKETCH_ELF) $(SKETCH_EEP)

$(BUILD_CORE):
	-mkdir -p $@

%.txt.mk: $(runtime.platform.path)/%.txt
	@sed -e 's/{/$${/g' -e '/^\#/d' -e '/^$$/d' -e 's/-D\([A-Z_]*\)="\([a-zA-Z0-9$${}/_.-]*\)"/-D\1=\\"\2\\"/g' < $< > $@

$(build.path):
	-mkdir -p $(build.path)

build-variables:
	$(foreach v, $(sort $(filter build.%, $(.VARIABLES))), $(info $(v) = $($(v))))

PREBUILD_HOOKS := $(sort $(filter recipe.hooks.prebuild.%.pattern, $(.VARIABLES)))

$(foreach h,$(PREBUILD_HOOKS), $(eval $(call define-hook,$h)))

prebuild: $(build.path) $(PREBUILD_HOOKS)

clean:
	-rm -f $(OBJECTS) $(DEPS) *.txt.mk
	-rm -fr $(build.path) $(BUILD_CORE) $(BUILD_LIBS) $(BUILD_EXTRAS)

path:
	@echo $(PATH)

term:
	$(TERMINAL) $(TERMINAL_FLAGS)

build-summary:
	$(eval FLASH_SIZE = $(shell $(recipe.size.pattern) | pcregrep -o1 "$(recipe.size.regex)" | paste -sd "+" | bc))
	$(eval FLASH_PC = $(shell echo $(FLASH_SIZE) "* 100 /" $(upload.maximum_size) | bc))
	@echo program: $(FLASH_SIZE) / $(upload.maximum_size) bytes \($(FLASH_PC)%\)
	$(eval DATA_SIZE = $(shell $(recipe.size.pattern) | pcregrep -o1 "$(recipe.size.regex.data)" | paste -sd "+" | bc))
	$(eval DATA_PC = $(shell echo $(DATA_SIZE) "* 100 /" $(upload.maximum_data_size) | bc))
	@echo data: $(DATA_SIZE) / $(upload.maximum_data_size) bytes \($(DATA_PC)%\)

$(call define-scoped-prefix-variables,tools.$(upload.tool),upload)
upload: all
	$(subst "",,$(call os-override,tools.$(upload.tool).upload.pattern))

$(call define-scoped-prefix-variables,tools.$(program.tool),program)
program: prebuild $(SKETCH_BIN)
	$(subst "",,$(call os-override,tools.$(program.tool).program.pattern))

$(call define-scoped-prefix-variables,tools.$(program.tool),erase)
erase:
	$(subst "",,$(call os-override,tools.$(program.tool).erase.pattern))

$(call define-scoped-prefix-variables,tools.$(bootloader.tool),bootloader)
bootloader:
	$(subst "",,$(call os-override,tools.$(bootloader.tool).bootloader.pattern))

version:
	@echo "$(name) $(notdir $(runtime.platform.path))"

.PHONY: clean all path term version build-summary prebuild build-variables upload program erase bootloader $(PREBUILD_HOOKS) $(PRELINK_HOOKS)

-include $(DEPS)
