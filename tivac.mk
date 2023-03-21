# default options (settable by user)
SERIAL_PORT ?= /dev/ttyACM0

VENDOR := energia
PROCESSOR_FAMILY := tivac
PACKAGE_DIR := $(HOME)/.arduino15/packages/$(VENDOR)
COMPILER_FAMILY := arm-none-eabi-gcc
COMPILER_PATH := $(wildcard $(PACKAGE_DIR)/tools/$(COMPILER_FAMILY)/*)
COMPILER_VERSION := $(notdir $(COMPILER_PATH))
PLATFORM_H = Energia.h

runtime.ide.version := 10809
runtime.platform.path := $(wildcard $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/*)
runtime.tools.$(COMPILER_FAMILY)-$(COMPILER_VERSION).path := $(COMPILER_PATH)
runtime.tools.dslite-9.3.0.1863.path := $(wildcard $(PACKAGE_DIR)/tools/dslite/*)

-include hardware.mk

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
upload.tool := $($(build.board).upload.tool)

-include build-targets.mk

upload: path = $(runtime.tools.dslite-9.3.0.1863.path)
upload: config.path = $(path)
upload: cmd.path = $(tools.$(upload.tool).cmd.path)
upload: $(SKETCH_BIN)
	$(subst ',, $(tools.$(upload.tool).upload.pattern))
