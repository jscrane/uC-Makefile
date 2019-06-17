# default options (settable by user)
BOARD_PINMAPPING ?= anew
SERIAL_PORT ?= /dev/ttyUSB0
UPLOAD_VERIFY ?= noverify
PROGRAM_VERIFY ?= $(UPLOAD_VERIFY)
UPLOAD_VERBOSE ?= quiet
PROGRAM_VERBOSE ?= $(UPLOAD_VERBOSE)
ERASE_VERBOSE ?= $(UPLOAD_VERBOSE)
BOOTLOADER_VERBOSE ?= $(UPLOAD_VERBOSE)
PROGRAMMER ?= arduinoasisp
EESAVE ?= aenable
BOD ?= 1v8

VENDOR := ATTinyCore
PROCESSOR_FAMILY := avr
PACKAGES := $(HOME)/.arduino15/packages
PACKAGE_DIR := $(PACKAGES)/$(VENDOR)
ARDUINO_TOOLS := $(PACKAGES)/arduino/tools
PACKAGE_VERSION := 1.2.4
COMPILER_FAMILY := avr-gcc
COMPILER_VERSION := 5.4.0-atmel3.6.1-arduino2
COMPILER_PATH := $(ARDUINO_TOOLS)/$(COMPILER_FAMILY)/$(COMPILER_VERSION)

runtime.ide.version := 10809
runtime.platform.path := $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/$(PACKAGE_VERSION)
runtime.tools.$(COMPILER_FAMILY).path := $(COMPILER_PATH)
runtime.tools.avrdude.path := $(ARDUINO_TOOLS)/avrdude/6.3.0-arduino14

-include boards.txt.mk
include boards.local.txt.mk
-include platform.txt.mk

build.board := $(BOARD)
board.chip := $($(build.board).chip)
board.chip ?= $(BOARD_CHIP)
build.mcu := $($(build.board).build.mcu)
BOARD_CPU_MENU := $(build.board).menu.chip.$(board.chip)
build.mcu ?= $($(BOARD_CPU_MENU).build.mcu)
build.core := $($(build.board).build.core)
board.clock := $($(build.board).clock)
board.clock ?= $(BOARD_CLOCK)
build.f_cpu ?= $($(build.board).build.f_cpu)
BOARD_CLOCK_MENU := $(build.board).menu.clock.$(board.clock)
build.f_cpu ?= $($(BOARD_CLOCK_MENU).build.f_cpu)

ifndef BOARD
$(error BOARD required)
endif
ifndef board.chip
$(error BOARD_CHIP required)
endif
ifndef board.clock
$(error BOARD_CLOCK required)
endif

ifeq ($(board.chip),85)
build.variant := $($(build.board).build.variant)
endif
ifeq ($(board.chip),84)
board.pinmapping := $($(build.board).pinmapping)
build.variant := $($(build.board).build.variant)
board.pinmapping ?= $(BOARD_PINMAPPING)
build.variant ?= $($(build.board).menu.pinmapping.$(board.pinmapping).build.variant)
endif

CORE := $(runtime.platform.path)/cores/$(build.core)
includes := -I$(CORE) -I$(runtime.platform.path)/variants/$(build.variant)
upload.tool := $($(build.board).upload.tool)
serial.port := $(SERIAL_PORT)
upload.protocol := $($(build.board).upload.protocol)
upload.speed := $($(build.board).upload.speed)
upload.speed ?= $($(BOARD_CLOCK_MENU).upload.speed)
upload.verbose := $(tools.$(upload.tool).upload.params.$(UPLOAD_VERBOSE))
upload.verify := $(tools.$(upload.tool).upload.params.$(UPLOAD_VERIFY))
program.verbose := $(tools.$(upload.tool).program.params.$(PROGRAM_VERBOSE))
program.verify := $(tools.$(upload.tool).programs.params.$(PROGRAM_VERIFY))
program.extra_params := $(PROGRAM_EXTRA_PARAMS)
erase.verbose := $(tools.$(upload.tool).erase.params.$(ERASE_VERBOSE))
bootloader.verbose := $(tools.$(upload.tool).bootloader.params.$(BOOTLOADER_VERBOSE))
bootloader.file := $($(build.board).bootloader.file)
bootloader.low_fuses := $($(build.board).bootloader.low_fuses)
bootloader.low_fuses ?= $($(BOARD_CLOCK_MENU).bootloader.low_fuses)
bootloader.bod_bits := $($(build.board).menu.bod.$(BOD).bootloader.bod_bits)
bootloader.eesave_bit := $($(build.board).menu.eesave.$(EESAVE).bootloader.eesave_bit)
bootloader.high_fuses := $($(build.board).bootloader.high_fuses)
bootloader.extended_fuses := $($(build.board).bootloader.extended_fuses)
bootloader.lock_bits := $($(build.board).bootloader.lock_bits)
bootloader.unlock_bits := $($(build.board).bootloader.unlock_bits)

SKETCH_EEP = $(SKETCH_ELF:.elf=.eep)

-include common.mk
-include programmers.mk
-include $(upload.tool).mk
