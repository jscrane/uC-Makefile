# default options (settable by user)
SKETCHBOOK ?= $(HOME)/energia
SERIAL_PORT ?= /dev/ttyACM0

VENDOR := energia
PROCESSOR_FAMILY := tivac
PACKAGE_DIR := $(HOME)/.energia15/packages/$(VENDOR)
COMPILER_FAMILY := arm-none-eabi-gcc
COMPILER_PATH := $(wildcard $(PACKAGE_DIR)/tools/$(COMPILER_FAMILY)/*)
COMPILER_VERSION := $(notdir $(COMPILER_PATH))
PLATFORM_H = Energia.h

runtime.ide.version := 10809
runtime.platform.path := $(wildcard $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/*)
runtime.tools.$(COMPILER_FAMILY)-$(COMPILER_VERSION).path := $(COMPILER_PATH)
runtime.tools.mspdebug.path := $(PACKAGE_DIR)/tools/mspdebug/0.24
runtime.tools.dslite-7.2.0.2096.path := $(PACKAGE_DIR)/tools/dslite/7.2.0.2096

-include $(runtime.platform.path)/boards.txt
-include platform.txt.mk

build.board := $(BOARD)
build.core := $($(build.board).build.core)
build.mcu := $($(build.board).build.mcu)
build.arch := $(PROCESSOR_FAMILY)
build.f_cpu := $($(build.board).build.f_cpu)
build.system.path := $(runtime.platform.path)/system
build.ldscript := $($(build.board).build.ldscript)
build.variant := $($(build.board).build.variant)
build.variant.path := $(runtime.platform.path)/variants/$(build.variant)
build.system.path := $(runtime.platform.path)/system
upload.protocol := $($(build.board).upload.protocol)

-include common.mk

upload: path = $(runtime.tools.dslite-7.2.0.2096.path)
upload: config.path = $(path)
upload: cmd.path = $(tools.$(upload.tool).cmd.path)
upload: $(SKETCH_BIN)
	$(subst ',, $(tools.$(upload.tool).upload.pattern))
