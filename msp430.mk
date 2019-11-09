# default options (settable by user)
SERIAL_PORT ?= /dev/ttyACM0

SKETCHBOOK ?= $(HOME)/energia

VENDOR := energia
PROCESSOR_FAMILY := msp430
PACKAGE_DIR := $(HOME)/.energia15/packages/$(VENDOR)
COMPILER_FAMILY := msp430-gcc
COMPILER_PATH := $(wildcard $(PACKAGE_DIR)/tools/$(COMPILER_FAMILY)/*)
COMPILER_VERSION := $(notdir $(COMPILER_PATH))
PLATFORM_H = Energia.h

runtime.ide.version := 10809
runtime.platform.path := $(wildcard $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/*)
runtime.tools.$(COMPILER_FAMILY)-$(COMPILER_VERSION).path := $(COMPILER_PATH)
runtime.tools.mspdebug.path := $(PACKAGE_DIR)/tools/mspdebug/0.24
runtime.tools.dslite-8.2.0.1400.path := $(PACKAGE_DIR)/tools/8.2.0.1400

-include $(runtime.platform.path)/boards.txt
-include platform.txt.mk

build.board := $(BOARD)
build.core := $($(build.board).build.core)
build.variant := $($(build.board).build.variant)
build.mcu := $($(build.board).build.mcu)
build.arch := $(PROCESSOR_FAMILY)
build.f_cpu := $($(build.board).build.f_cpu)
upload.tool := $($(build.board).upload.tool)
upload.protocol := $($(build.board).upload.protocol)

-include common.mk

upload: path = $(runtime.tools.$(upload.tool).path)
upload: cmd.path = $(tools.$(upload.tool).cmd.path)
upload: $(SKETCH_BIN)
	$(subst ',, $(tools.$(upload.tool).upload.pattern))
