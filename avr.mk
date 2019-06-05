# default options (settable by user)
SERIAL_PORT ?= /dev/ttyUSB0
UPLOAD_VERIFY ?= -V
UPLOAD_VERBOSE ?= quiet
PROGRAM_VERBOSE ?= $(UPLOAD_VERBOSE)
ERASE_VERBOSE ?= $(UPLOAD_VERBOSE)
BOOTLOADER_VERBOSE ?= $(UPLOAD_VERBOSE)
PROGRAMMER ?= arduinoasisp

VENDOR := arduino
PROCESSOR_FAMILY := avr
PACKAGE_DIR := $(HOME)/.arduino15/packages/$(VENDOR)
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
CORE := $(runtime.platform.path)/cores/$(VENDOR)
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

SKETCH_EEP = $(SKETCH_ELF:.elf=.eep)

-include common.mk
-include programmers.mk
