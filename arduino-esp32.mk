# default options (settable by user)
UPLOAD_SPEED ?= 921600
UPLOAD_PORT ?= /dev/ttyUSB0
FLASH_FREQ ?= 80

PROCESSOR_FAMILY := esp32
PACKAGE_DIR := $(HOME)/.arduino15/packages/$(PROCESSOR_FAMILY)
PACKAGE_VERSION := 1.0.2

runtime.ide.version := 10809
runtime.platform.path := $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/$(PACKAGE_VERSION)
runtime.tools.xtensa-esp32-elf-gcc.path := $(PACKAGE_DIR)/tools/xtensa-esp32-elf-gcc/1.22.0-80-g6c4433a-5.2.0
runtime.tools.python.path := /usr/bin
runtime.tools.esptool_py.path := $(PACKAGE_DIR)/tools/esptool_py/2.6.1

-include $(runtime.platform.path)/boards.txt
-include platform.mk

build.board := $(BOARD)
build.arch := $($(build.board).build.mcu)
CORE := $(runtime.platform.path)/cores/$(build.arch)
includes := -I$(CORE) -I$(runtime.platform.path)/variants/$(build.board)
build.f_cpu := $($(build.board).build.f_cpu)
build.flash_mode := $($(build.board).build.flash_mode)
build.flash_size := $($(build.board).build.flash_size)
build.flash_freq := $($(build.board).menu.FlashFreq.$(FLASH_FREQ).build.flash_freq)
build.boot := $($(build.board).build.boot)
build.partitions := $($(build.board).build.partitions)
UPLOAD_TOOL := $($(build.board).upload.tool)
upload.speed = $(UPLOAD_SPEED)
serial.port = $(UPLOAD_PORT)

SKETCH ?= $(wildcard *.ino)
SKETCH_ELF := $(SKETCH).elf
SKETCH_BIN := $(SKETCH).bin
SKETCH_EEP := $(SKETCH).partitions.bin
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

all: objcopy

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

define objcopy-sketch
$1: tools.esptool_py.cmd = $(tools.esptool_py.cmd.linux)
$1:
	$$(recipe.objcopy.hex.pattern.linux)
endef

$(eval $(call objcopy-sketch,$(SKETCH_BIN)))

define objcopy-eep
$1:
	$$(recipe.objcopy.eep.pattern)
endef

$(eval $(call objcopy-eep,$(SKETCH_EEP)))

define upload-sketch
upload: path = $$(runtime.tools.$(UPLOAD_TOOL).path)
upload: cmd = $$(tools.$(UPLOAD_TOOL).cmd.linux)
upload: objcopy
	$$(tools.$(UPLOAD_TOOL).upload.pattern)
endef

$(eval $(call upload-sketch))

.PHONY: clean all objects core-library link eep objcopy upload

objects: $(OBJECTS)

core-library: $(BUILD_CORE) | $(CORE_OBJECTS) $(ARCHIVE_TARGETS)

libraries: $(LIBRARY_OBJECTS)

link: objects core-library libraries $(SKETCH_ELF)

eep: link $(SKETCH_EEP)

objcopy: eep $(SKETCH_BIN)

$(BUILD_CORE):
	-mkdir -p $@

platform.mk: $(runtime.platform.path)/platform.txt
	@sed -e 's/{/$${/g' -e '/^\#/d' -e '/^$$/d' < $< > $@

clean:
	-rm -f $(OBJECTS) $(DEPS) platform.mk
	-rm -fr $(build.path) $(BUILD_CORE) $(BUILD_LIBS)

-include $(DEPS)
