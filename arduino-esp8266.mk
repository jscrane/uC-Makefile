# default options (settable by user)
LWIP_OPTS ?= lm2f
F_CPU ?= 80
DEBUG_PORT ?= Disabled
DEBUG_LEVEL ?= None____
EXCEPTIONS ?= disabled
VTABLES ?= flash
SSL ?= all
UPLOAD_SPEED ?= 921600
UPLOAD_ERASE ?= version
UPLOAD_PORT ?= /dev/ttyUSB0

PROCESSOR_FAMILY := esp8266
PACKAGE_DIR := $(HOME)/.arduino15/packages/$(PROCESSOR_FAMILY)
PACKAGE_VERSION := 2.5.2

runtime.ide.version := 10809
runtime.platform.path := $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/$(PACKAGE_VERSION)
runtime.tools.xtensa-lx106-elf-gcc.path := $(PACKAGE_DIR)/tools/xtensa-lx106-elf-gcc/2.5.0-3-20ed2b9
runtime.tools.python.path := /usr/bin

-include $(runtime.platform.path)/boards.txt
-include platform.mk

build.board := $(BOARD)
build.arch := $($(build.board).build.mcu)
CORE := $(runtime.platform.path)/cores/$(build.arch)
includes := -I$(CORE) -I$(runtime.platform.path)/variants/$(build.board) \
	-I$(runtime.platform.path)/tools/sdk/$($(build.board).menu.ip.$(LWIP_OPTS).build.lwip_include)
build.f_cpu := $($(build.board).menu.xtal.$(F_CPU).build.f_cpu)
build.debug_port := $($(build.board).menu.dbg.$(DEBUG_PORT).build.debug_port)
build.debug_level := $($(build.board).menu.lvl.$(DEBUG_LEVEL).build.debug_level)
build.flash_flags := $($(build.board).build.flash_flags)
build.flash_mode := $($(build.board).build.flash_mode)
build.flash_freq := $($(build.board).build.flash_freq)
build.flash_size := $($(build.board).menu.eesz.$(FLASH_SIZE).build.flash_size)
build.flash_size_bytes := $($(build.board).menu.eesz.$(FLASH_SIZE).build.flash_size_bytes)
build.flash_ld := $($(build.board).menu.eesz.$(FLASH_SIZE).build.flash_ld)
build.spiffs_pagesize := $($(build.board).menu.eesz.$(FLASH_SIZE).build.spiffs_pagesize)
build.spiffs_start := $($(build.board).menu.eesz.$(FLASH_SIZE).build.spiffs_start)
build.spiffs_end := $($(build.board).menu.eesz.$(FLASH_SIZE).build.spiffs_end)
build.spiffs_blocksize := $($(build.board).menu.eesz.$(FLASH_SIZE).build.spiffs_blocksize)
UPLOAD_TOOL := $($(build.board).upload.tool)
upload.erase_cmd = $(UPLOAD_ERASE)
upload.speed = $(UPLOAD_SPEED)
upload.verbose = $(tools.$(UPLOAD_TOOL).upload.params.verbose)
serial.port = $(UPLOAD_PORT)

build.lwip_flags := $($(build.board).menu.ip.$(LWIP_OPTS).build.lwip_flags)
#build.lwip_lib := $($(build.board).menu.ip.$(LWIP_OPTS).build.lwip_lib)
build.vtable_flags := $($(build.board).menu.vt.$(VTABLES).build.vtable_flags)
build.ssl_flags := $($(build.board).menu.ssl.$(SSL).build.ssl_flags)
build.exception_flags := $($(build.board).menu.exception.$(EXCEPTIONS).build.exception_flags)
build.stdcpp_lib := $($(build.board).menu.exception.$(EXCEPTIONS).build.stdcpp_lib)

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
$1:
	$$(recipe.objcopy.hex.1.pattern)
endef

$(eval $(call objcopy-sketch,$(SKETCH_BIN)))

define upload-sketch
upload: cmd = $$(tools.$(UPLOAD_TOOL).cmd)
upload: objcopy
	$$(tools.$(UPLOAD_TOOL).upload.pattern)
endef

$(eval $(call upload-sketch))

.PHONY: clean all objects core-library link objcopy upload

objects: $(OBJECTS)

core-library: $(BUILD_CORE) | $(CORE_OBJECTS) $(ARCHIVE_TARGETS)

libraries: $(LIBRARY_OBJECTS)

link: objects core-library libraries $(SKETCH_ELF)

objcopy: link $(SKETCH_BIN)

$(BUILD_CORE):
	-mkdir -p $@

platform.mk: $(runtime.platform.path)/platform.txt
	@sed -e 's/{/$${/g' -e '/^\#/d' -e '/^$$/d' < $< > $@

clean:
	-rm -f $(OBJECTS) $(DEPS) platform.mk
	-rm -fr $(build.path) $(BUILD_CORE) $(BUILD_LIBS)

-include $(DEPS)
