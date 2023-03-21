# default options (settable by user)
SERIAL_PORT ?= /dev/ttyACM0

VENDOR := energia
PROCESSOR_FAMILY := msp430
PACKAGE_DIR := $(HOME)/.arduino15/packages/$(VENDOR)
COMPILER_FAMILY := msp430-gcc
COMPILER_PATH := $(wildcard $(PACKAGE_DIR)/tools/$(COMPILER_FAMILY)/*)

runtime.ide.version := 10809
runtime.platform.path := $(wildcard $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/*)
runtime.tools.msp430-gcc.path := $(COMPILER_PATH)
runtime.tools.mspdebug.path := $(wildcard $(PACKAGE_DIR)/tools/mspdebug/*)
runtime.tools.dslite-9.3.0.1863.path := $(wildcard $(PACKAGE_DIR)/tools/*)

-include hardware.mk

build.board := $(BOARD)
build.core := $($(build.board).build.core)
build.variant := $($(build.board).build.variant)
build.mcu := $($(build.board).build.mcu)
build.arch := $(PROCESSOR_FAMILY)
build.f_cpu := $($(build.board).build.f_cpu)
upload.tool := $($(build.board).upload.tool)
upload.protocol := $($(build.board).upload.protocol)

-include build-targets.mk

tools.boot430load.cmd.path := /usr/local/bin/boot430load
tools.boot430load.upload.pattern := $(tools.boot430load.cmd.path) $(build.path)/$(build.project_name).hex

upload: path = $(runtime.tools.$(upload.tool).path)
upload: cmd.path = $(tools.$(upload.tool).cmd.path)
upload: $(SKETCH_BIN)
	$(subst ',, $(tools.$(upload.tool).upload.pattern))
