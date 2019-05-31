# default options (settable by user)
SERIAL_PORT ?= /dev/ttyUSB0
UPLOAD_VERBOSE ?= quiet

PLATFORM := arduino
PROCESSOR_FAMILY := avr
PACKAGE_DIR := $(HOME)/.arduino15/packages/$(PLATFORM)
PACKAGE_VERSION := 1.6.23
COMPILER_FAMILY := avr-gcc
COMPILER_VERSION := 5.4.0-atmel3.6.1-arduino2

runtime.ide.version := 10809
runtime.platform.path := $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/$(PACKAGE_VERSION)
runtime.tools.$(COMPILER_FAMILY).path := $(PACKAGE_DIR)/tools/$(COMPILER_FAMILY)/$(COMPILER_VERSION)
runtime.tools.avrdude.path := $(PACKAGE_DIR)/tools/avrdude/6.3.0-arduino14

-include $(runtime.platform.path)/boards.txt
-include platform.mk

build.board := $(BOARD)
BOARD_CPU_MENU := $(build.board).menu.cpu.$(BOARD_CPU)
build.mcu := $($(BOARD_CPU_MENU).build.mcu)
build.f_cpu := $($(BOARD_CPU_MENU).build.f_cpu)
CORE := $(runtime.platform.path)/cores/$(PLATFORM)
includes := -I$(CORE) -I$(runtime.platform.path)/variants/$($(build.board).build.variant)
UPLOAD_TOOL := $($(build.board).upload.tool)
upload.protocol := $($(build.board).upload.protocol)
upload.speed := $($(BOARD_CPU_MENU).upload.speed)
upload.verbose := $(tools.$(UPLOAD_TOOL).upload.params.$(UPLOAD_VERBOSE))
serial.port := $(SERIAL_PORT)

-include common.mk

define upload-sketch
upload: path = $$(runtime.tools.$(UPLOAD_TOOL).path)
upload: cmd.path = $$(tools.$(UPLOAD_TOOL).cmd.path)
upload: config.path = $$(tools.$(UPLOAD_TOOL).config.path)
upload: $(SKETCH_BIN)
	$$(tools.$(UPLOAD_TOOL).upload.pattern)
endef

$(eval $(call upload-sketch))
