SKETCH ?= $(wildcard *.ino)
SKETCH_ELF := $(SKETCH).elf
SKETCH_BIN := $(SKETCH).bin
SOURCES += $(wildcard *.cpp) $(wildcard *.c)
OBJECTS := $(foreach s,$(SOURCES), $s.o) $(SKETCH).cpp.o
DEPS := $(foreach s,$(OBJECTS), $(s:.o=.d))

IDE_HOME ?= /usr/local/arduino
SKETCHBOOK ?= $(HOME)/sketchbook

LIBRARY_PATH ?= $(SKETCHBOOK)/libraries $(runtime.platform.path)/libraries $(IDE_HOME)/libraries
LIBRARIES += $(sort $(shell sed -ne "s/^ *\# *include *[<\"]\(.*\)\.h[>\"]/\1/p" $(SKETCH)))
REQUIRED_ROOTS := $(foreach r, $(LIBRARIES), $(firstword $(foreach d, $(LIBRARY_PATH), $(wildcard $d/$r))))
LIBSUBDIRS := . src src/detail utility src/utility $(BUILD_MCU)
LIBDIRS := $(foreach r, $(REQUIRED_ROOTS), $(foreach s, $(LIBSUBDIRS), $(wildcard $r/$s)))
includes += $(foreach d, $(LIBDIRS), -I$d)

build.project_name := $(SKETCH)
build.path := .build
BUILD_CORE := $(build.path)/core
archive_file := libcore.a
archive_file_path := $(build.path)/$(archive_file)
BUILD_LIBS := $(build.path)/libs

CORE_SOURCES := $(wildcard $(addprefix $(CORE)/, *.c *.cpp *.S) $(addprefix $(CORE)/*/, *.c *.cpp))
CORE_OBJECTS := $(foreach s, $(CORE_SOURCES), $(BUILD_CORE)/$s.o)

LIBRARY_SOURCES := $(foreach d, $(LIBDIRS), $(wildcard $d/*.c) $(wildcard $d/*.cpp))
LIBRARY_OBJECTS := $(foreach s, $(LIBRARY_SOURCES), $(BUILD_LIBS)/$s.o)

all: $(SKETCH_BIN)

define compile-sources
$1.o: source_file = $1
$1.o: object_file = $1.o

ifeq ($(suffix $1),.c)
$1.o: compiler.c.extra_flags = $(CPPFLAGS)
$1.o:
	$$(recipe.c.o.pattern)
endif

ifeq ($(suffix $1),.cpp)
$1.o: compiler.cpp.extra_flags = $(CPPFLAGS)
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
$1.cpp.o: compiler.cpp.extra_flags = -x c++ -include Arduino.h $(CPPFLAGS)
$1.cpp.o:
	$$(recipe.cpp.o.pattern)
endef

$(eval $(call compile-sketch,$(SKETCH)))

define core-compile-targets
$(BUILD_CORE)/$1.o: source_file = $1
$(BUILD_CORE)/$1.o: object_file = $(BUILD_CORE)/$1.o

ifeq ($(suffix $1),.c)
$(BUILD_CORE)/$1.o:
	mkdir -p $$(dir $$@)
	$$(recipe.c.o.pattern)
endif

ifeq ($(suffix $1),.cpp)
$(BUILD_CORE)/$1.o:
	mkdir -p $$(dir $$@)
	$$(recipe.cpp.o.pattern)
endif

ifeq ($(suffix $1),.S)
$(BUILD_CORE)/$1.o:
	mkdir -p $$(dir $$@)
	$$(recipe.S.o.pattern)
endif
endef

$(foreach s,$(CORE_SOURCES), $(eval $(call core-compile-targets,$s)))

define core-archive-targets
$(archive_file_path)($(notdir $1)): object_file = $1
$(archive_file_path)($(notdir $1)):
	$$(recipe.ar.pattern)
endef

$(foreach o,$(CORE_OBJECTS), $(eval $(call core-archive-targets,$o)))

ARCHIVE_TARGETS := $(foreach o,$(CORE_OBJECTS), $(archive_file_path)($(notdir $o)))

define library-compile-targets
$(BUILD_LIBS)/$1.o: source_file = $1
$(BUILD_LIBS)/$1.o: object_file = $(BUILD_LIBS)/$1.o

ifeq ($(suffix $1),.c)
$(BUILD_LIBS)/$1.o: compiler.c.extra_flags = $(CPPFLAGS)
$(BUILD_LIBS)/$1.o:
	mkdir -p $$(dir $$@)
	$$(recipe.c.o.pattern)
endif

ifeq ($(suffix $1),.cpp)
$(BUILD_LIBS)/$1.o: compiler.cpp.extra_flags = $(CPPFLAGS)
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
$1:
	$$(recipe.hooks.linking.prelink.1.pattern)
	$$(recipe.c.combine.pattern)
endef

$(eval $(call link-sketch,$(SKETCH_ELF),$(OBJECTS) $(LIBRARY_OBJECTS)))

OBJCOPY_HEX_PATTERN ?= $(recipe.objcopy.hex.pattern)

define objcopy-sketch
$1: tools.esptool_py.cmd = $(tools.esptool_py.cmd.linux)
$1:
	$$(OBJCOPY_HEX_PATTERN)
endef

$(eval $(call objcopy-sketch,$(SKETCH_BIN)))

define objcopy-eep
$1:
	$$(recipe.objcopy.eep.pattern)
endef

$(eval $(call objcopy-eep,$(SKETCH_EEP)))

.PHONY: clean all upload

$(ARCHIVE_TARGETS): $(BUILD_CORE) | $(CORE_OBJECTS)

$(archive_file_path): $(ARCHIVE_TARGETS)

$(SKETCH_ELF): $(OBJECTS) $(archive_file_path) $(LIBRARY_OBJECTS)

$(SKETCH_BIN): $(SKETCH_ELF) $(SKETCH_EEP)

$(BUILD_CORE):
	-mkdir -p $@

platform.mk: $(runtime.platform.path)/platform.txt
	@sed -e 's/{/$${/g' -e '/^\#/d' -e '/^$$/d' < $< > $@

clean:
	-rm -f $(OBJECTS) $(DEPS) platform.mk
	-rm -fr $(build.path) $(BUILD_CORE) $(BUILD_LIBS)

-include $(DEPS)
