BUILD_SKETCH := $(build.path)/sketch
BUILD_CORE := $(build.path)/core
BUILD_LIBS := $(build.path)/libraries

SKETCH_ELF := $(build.path)/$(SKETCH).elf
SOURCE_PATTERN := *.c *.cpp *.S
SOURCES += $(foreach s,$(SOURCE_PATTERN),$(wildcard $s))
OBJECTS := $(foreach s,$(SOURCES), $(BUILD_SKETCH)/$s.o) $(BUILD_SKETCH)/$(SKETCH).cpp.o
DEPS := $(foreach o,$(OBJECTS), $(o:.o=.d))

TERMINAL ?= minicom
TERMINAL_FLAGS ?= -D $(SERIAL_PORT) -b $(TERMINAL_SPEED) $(TERMINAL_EXTRA_FLAGS)
CPPFLAGS += -DTERMINAL_SPEED=$(TERMINAL_SPEED) -DBOARD=$(BOARD)

SKETCHBOOK ?= $(HOME)/Arduino
LIBRARY_PATH := $(LOCAL_LIBRARY_PATH) $(SKETCHBOOK)/libraries $(runtime.platform.path)/libraries
LIBRARIES += $(sort $(shell sed -ne "s/^ *\# *include *[<\"]\(.*\)\.h[>\"]/\1/p" $(SKETCH)))
REQUIRED_ROOTS := $(foreach r, $(LIBRARIES), $(firstword $(foreach d, $(LIBRARY_PATH), $(wildcard $d/$r))))

includes := -I$(build.core.path) -I"$(build.variant.path)" $(foreach r, $(REQUIRED_ROOTS), -I$r -I$r/src)
CORE_FIND_EXPR := $(foreach p,$(SOURCE_PATTERN),-name "$p" -o) -false
CORE_SOURCES := $(shell find $(build.core.path) -type f \( $(CORE_FIND_EXPR) \)) $(wildcard $(addprefix $(build.variant.path)/, $(SOURCE_PATTERN)))
CORE_OBJECTS := $(foreach s, $(CORE_SOURCES), $(BUILD_CORE)/$(notdir $s).o)

OBJCOPY_SUFFIXES := $(sort $(patsubst recipe.objcopy.%.pattern,%,$(filter recipe.objcopy.%.pattern,$(.VARIABLES))))
OBJCOPY_TARGETS := $(foreach s,$(OBJCOPY_SUFFIXES),$(build.path)/$(SKETCH).$s)

all: prebuild $(SKETCH_ELF) objcopy build-summary

define compile-source
$2: source_file = $1
$2: object_file = $2
$2: compiler$(suffix $1).extra_flags += $(CPPFLAGS)
$2: $1
	@mkdir -p $$(dir $$@)
	$$(recipe$(suffix $1).o.pattern)

-include $(2:.o=.d)
endef

$(foreach s,$(SOURCES), $(eval $(call compile-source,$s,$(BUILD_SKETCH)/$s.o)))

define compile-sketch
$2: source_file = $1
$2: object_file = $2
$2: compiler.cpp.extra_flags += -x c++ -include Arduino.h $(CPPFLAGS)
$2: $1
	@mkdir -p $$(dir $$@)
	$$(recipe.cpp.o.pattern)

-include $(2:.o=.d)
endef

$(eval $(call compile-sketch,$(SKETCH),$(BUILD_SKETCH)/$(SKETCH).cpp.o))

define compile-core-source
$2: source_file = $1
$2: object_file = $2
$2: $1
	mkdir -p "$$(dir $$@)"
	$$(recipe$(suffix $1).o.pattern)

-include $(2:.o=.d)
endef

define archive-core-object
$(archive_file_path)($(notdir $1)): object_file = $1
$(archive_file_path)($(notdir $1)):
	$$(recipe.ar.pattern)
endef

ifdef build.core
$(foreach s,$(CORE_SOURCES), $(eval $(call compile-core-source,$s,$(BUILD_CORE)/$(notdir $s).o)))
$(foreach o,$(CORE_OBJECTS), $(eval $(call archive-core-object,$o)))
endif

CORE_ARCHIVE_TARGETS := $(foreach o,$(CORE_OBJECTS),$(archive_file_path)($(notdir $o)))

define compile-library-source
$2: source_file = $1
$2: object_file = $2
$2: compiler$(suffix $1).extra_flags += $(CPPFLAGS)
$2: $1
	@mkdir -p $$(dir $$@)
	$$(recipe$(suffix $1).o.pattern)

-include $(2:.o=.d)
endef

$(foreach r,$(REQUIRED_ROOTS), \
    $(eval _CUR_SRCS := $(wildcard $(addprefix $r/, $(SOURCE_PATTERN) $(addprefix utility/, $(SOURCE_PATTERN)) $(addprefix src/, $(SOURCE_PATTERN))))) \
    $(foreach s,$(_CUR_SRCS), \
        $(eval _OBJ := $(patsubst $(dir $r)%,$(BUILD_LIBS)/%,$(s)).o) \
        $(eval LIBRARY_OBJECTS += $(_OBJ)) \
        $(eval $(call compile-library-source,$(s),$(_OBJ)))))

define link-sketch
$1: compiler.c.elf.extra_flags += $(LDFLAGS)
$1: object_files = $2
$1: $3
	$$(recipe.c.combine.pattern)
endef

get-recipes = $(sort $(filter $(1).pattern $(1).%.pattern, $(.VARIABLES)))

ALL_HOOKS := $(call get-recipes,recipe.hooks)

define define-hook
$1:
	$($1)
endef

$(foreach h,$(ALL_HOOKS), $(eval $(call define-hook,$h)))

PRELINK_HOOKS := $(call get-recipes,recipe.hooks.linking.prelink)

$(eval $(call link-sketch,$(SKETCH_ELF),$(OBJECTS) $(LIBRARY_OBJECTS),$(PRELINK_HOOKS)))

define \n


endef

PREOBJCOPY_HOOKS := $(call get-recipes,recipe.hooks.objcopy.preobjcopy)

POSTOBJCOPY_HOOKS := $(call get-recipes,recipe.hooks.objcopy.postobjcopy)

define objcopy-recipe
$(build.path)/$(SKETCH).$1: $(SKETCH_ELF)
	$(foreach r,$(call get-recipes,recipe.objcopy.$1),$(value $r)$(\n))
endef

$(foreach s,$(OBJCOPY_SUFFIXES),$(eval $(call objcopy-recipe,$s)))

objcopy: $(PREOBJCOPY_HOOKS) $(OBJCOPY_TARGETS) $(POSTOBJCOPY_HOOKS)

$(CORE_ARCHIVE_TARGETS): $(BUILD_CORE) | $(CORE_OBJECTS)

$(archive_file_path): $(CORE_ARCHIVE_TARGETS)

CORE_PREBUILD_HOOKS := $(call get-recipes,recipe.hooks.core.prebuild)

CORE_POSTBUILD_HOOKS := $(call get-recipes,recipe.hooks.core.postbuild)

$(SKETCH_ELF): $(OBJECTS) $(BUILD_CORE) $(CORE_PREBUILD_HOOKS) $(archive_file_path) $(CORE_POSTBUILD_HOOKS) $(LIBRARY_OBJECTS)

$(BUILD_CORE):
	-mkdir -p $@

# convert .txt files into .mk files:
# - dollar protection: $XYZ -> \$$XYZ
# - brace translation: {} -> $()
# - quote shielding: -DVAR="value" -> -DVAR=\"value\"
# - deleting comments and empty lines
# - renaming host-specific properties: property$(HOST_SUFFIX)=value -> property=value
# - deleting other OS-specific properties
%.txt.mk: $(runtime.platform.path)/%.txt
	@sed -e 's/\$$/\\$$\$$/g' \
	  -e 's/{/\$$(/g' -e 's/}/)/g' \
	  -e 's/-D\([A-Z0-9_]*\)="\([^"]*\)"/-D\1=\\"\2\\"/g' \
	  -e '/^\#/d' -e '/^$$/d' \
	  -e 's/\(.*\)$(HOST_SUFFIX)=\(.*\)/\1=\2/g' \
	  $(foreach s,$(DELETE_SUFFIXES),-e '/$(s)=/d') \
	  < $< > $@

$(build.path):
	-mkdir -p $(build.path)

build-variables:
	$(foreach v, $(sort $(filter build.%, $(.VARIABLES))), $(info $(v) = $($(v))))

PRESAVEHEX_HOOKS := $(call get-recipes,recipe.hooks.savehex.presavehex)

POSTSAVEHEX_HOOKS := $(call get-recipes,recipe.hooks.savehex.postsavehex)

savehex: all $(PRESAVEHEX_HOOKS)
	$(foreach h,$(POSTSAVEHEX_HOOKS),$($h)$(\n)	)

menu-variables:
	$(foreach v, $(sort $(filter menu.%, $(.VARIABLES))), $(info $(v) = $($(v))))

PREBUILD_HOOKS := $(call get-recipes,recipe.hooks.prebuild)

SKETCH_PREBUILD_HOOKS := $(call get-recipes,recipe.hooks.sketch.prebuild)

prebuild: $(build.path) $(PREBUILD_HOOKS) $(SKETCH_PREBUILD_HOOKS)

clean:
	-rm -fr *.txt.mk build $(build.path) $(BUILD_EXTRAS)

path:
	@echo $(PATH)

term:
	$(TERMINAL) $(TERMINAL_FLAGS)

build-summary:
	$(eval FLASH_SIZE = $(shell $(recipe.size.pattern) | pcre2grep -o1 "$(recipe.size.regex)" | paste -sd "+" | bc))
	$(eval FLASH_PC = $(shell echo $(FLASH_SIZE) "* 100 /" $(upload.maximum_size) | bc))
	@echo program: $(FLASH_SIZE) / $(upload.maximum_size) bytes \($(FLASH_PC)%\)
	$(eval DATA_SIZE = $(shell $(recipe.size.pattern) | pcre2grep -o1 "$(recipe.size.regex.data)" | paste -sd "+" | bc))
	$(eval DATA_PC = $(shell echo $(DATA_SIZE) "* 100 /" $(upload.maximum_data_size) | bc))
	@echo data: $(DATA_SIZE) / $(upload.maximum_data_size) bytes \($(DATA_PC)%\)

$(call define-scoped-prefix-variables,tools.$(upload.tool),upload)
upload: all
	$(tools.$(upload.tool).upload.pattern)

$(call define-scoped-prefix-variables,tools.$(program.tool),program)
program: all
	$(tools.$(upload.tool).program.pattern)

$(call define-scoped-prefix-variables,tools.$(program.tool),erase)
erase:
	$(tools.$(upload.tool).erase.pattern)

$(call define-scoped-prefix-variables,tools.$(bootloader.tool),bootloader)
bootloader:
	$(tools.$(upload.tool).bootloader.pattern)

version:
	@echo "$(name) $(notdir $(runtime.platform.path))"

.gitignore:
	@echo ".build" >> $@
	@echo "build" >> $@
	@echo "*.txt.mk" >> $@
	@echo "serialout.txt" >> $@

.PHONY: clean all path term version objcopy savehex build-summary prebuild build-variables upload program erase bootloader .gitignore
.PHONY: $(ALL_HOOKS)

-include $(DEPS)
