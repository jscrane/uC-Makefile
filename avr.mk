# default options (settable by user)
SERIAL_PORT ?= /dev/ttyUSB0
UPLOAD_VERIFY ?= -V
UPLOAD_VERBOSE ?= quiet
PROGRAM_VERBOSE ?= $(UPLOAD_VERBOSE)
ERASE_VERBOSE ?= $(UPLOAD_VERBOSE)
BOOTLOADER_VERBOSE ?= $(UPLOAD_VERBOSE)
PROGRAMMER_PROTOCOL ?= arduinoisp

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
serial.port := $(SERIAL_PORT)
upload.protocol := $($(build.board).upload.protocol)
upload.speed := $($(BOARD_CPU_MENU).upload.speed)
upload.verbose := $(tools.$(UPLOAD_TOOL).upload.params.$(UPLOAD_VERBOSE))
upload.verify := $(UPLOAD_VERIFY)
program.verbose := $(tools.$(UPLOAD_TOOL).program.params.$(PROGRAM_VERBOSE))
program.verify := $(PROGRAM_VERIFY)
program.extra_params := $(PROGRAM_EXTRA_PARAMS)
erase.verbose := $(tools.$(UPLOAD_TOOL).erase.params.$(ERASE_VERBOSE))
bootloader.verbose := $(tools.$(UPLOAD_TOOL).bootloader.params.$(BOOTLOADER_VERBOSE))
bootloader.file := $($(BOARD_CPU_MENU).bootloader.file)
bootloader.low_fuses := $($(BOARD_CPU_MENU).bootloader.low_fuses)
bootloader.high_fuses := $($(BOARD_CPU_MENU).bootloader.high_fuses)
bootloader.extended_fuses := $($(BOARD_CPU_MENU).bootloader.extended_fuses)
bootloader.lock_bits := $($(build.board).bootloader.lock_bits)

SKETCH ?= $(wildcard *.ino)
SKETCH_EEP := $(SKETCH:.ino=.eep)

-include common.mk

upload: path = $(runtime.tools.$(UPLOAD_TOOL).path)
upload: cmd.path = $(tools.$(UPLOAD_TOOL).cmd.path)
upload: config.path = $(tools.$(UPLOAD_TOOL).config.path)
upload: $(SKETCH_BIN)
	$(tools.$(UPLOAD_TOOL).upload.pattern)

program: path = $(runtime.tools.$(UPLOAD_TOOL).path)
program: cmd.path = $(tools.$(UPLOAD_TOOL).cmd.path)
program: config.path = $(tools.$(UPLOAD_TOOL).config.path)
program: protocol = $(PROGRAMMER_PROTOCOL)
program: $(SKETCH_BIN)
	$(tools.$(UPLOAD_TOOL).program.pattern)

erase: path = $(runtime.tools.$(UPLOAD_TOOL).path)
erase: cmd.path = $(tools.$(UPLOAD_TOOL).cmd.path)
erase: config.path = $(tools.$(UPLOAD_TOOL).config.path)
erase: protocol = $(PROGRAMMER_PROTOCOL)
erase:
	$(tools.$(UPLOAD_TOOL).erase.pattern)

bootloader: path = $(runtime.tools.$(UPLOAD_TOOL).path)
bootloader: cmd.path = $(tools.$(UPLOAD_TOOL).cmd.path)
bootloader: config.path = $(tools.$(UPLOAD_TOOL).config.path)
bootloader: protocol = $(PROGRAMMER_PROTOCOL)
bootloader:
	$(tools.$(UPLOAD_TOOL).bootloader.pattern)
