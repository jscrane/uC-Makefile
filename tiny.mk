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
LTO ?= enable

VENDOR := ATTinyCore
PROCESSOR_FAMILY := avr
PACKAGES := $(HOME)/.arduino15/packages
PACKAGE_DIR := $(PACKAGES)/$(VENDOR)
COMPILER_FAMILY := avr-gcc
COMPILER_PATH := $(lastword $(wildcard $(PACKAGES)/arduino/tools/$(COMPILER_FAMILY)/*))

runtime.tools.$(COMPILER_FAMILY).path := $(COMPILER_PATH)

-include hardware.mk

ifndef BOARD
$(error BOARD required)
endif
build.board := $(BOARD)
build.core := $($(build.board).build.core)
board.chip := $(firstword $($(build.board).chip) $(BOARD_CHIP))
build.mcu := $(firstword $($(build.board).build.mcu) $($(build.board).menu.chip.$(board.chip).build.mcu))

board.clock := $(firstword $($(build.board).clock) $(BOARD_CLOCK))
BOARD_CLOCK_MENU := $(build.board).menu.clock.$(board.clock)
build.f_cpu := $(firstword $($(build.board).build.f_cpu) $($(BOARD_CLOCK_MENU).build.f_cpu))
build.clocksource := $(firstword $($(build.board).build.clocksource) $($(BOARD_CLOCK_MENU).build.clocksource))

ifeq ($(board.chip),85)
build.variant := $($(build.board).build.variant)
endif

ifeq ($(board.chip),84)
board.pinmapping := $(firstword $($(build.board).pinmapping) $(BOARD_PINMAPPING))
build.variant := $(firstword $($(build.board).build.variant) $($(build.board).menu.pinmapping.$(board.pinmapping).build.variant))
endif

ltocflags := $(firstword $($(build.board).ltocflags) $($(build.board).menu.LTO.$(LTO).ltocflags))
ltocppflags := $(firstword $($(build.board).ltocppflags) $($(build.board).menu.LTO.$(LTO).ltocppflags))
ltoelfflags := $(firstword $($(build.board).ltoelfflags) $($(build.board).menu.LTO.$(LTO).ltoelfflags))
ltoarcmd := $(firstword $($(build.board).ltoarcmd) $($(build.board).menu.LTO.$(LTO).ltoarcmd))

serial.port := $(SERIAL_PORT)
upload.protocol := $($(build.board).upload.protocol)
upload.speed := $(firstword $($(build.board).upload.speed) $($(BOARD_CLOCK_MENU).upload.speed))
upload.maximum_size := $(firstword $($(build.board).upload.maximum_size) $($(build.board).menu.chip.$(board.chip).upload.maximum_size))
upload.maximum_data_size := $(firstword $($(build.board).upload.maximum_data_size) $($(build.board).menu.chip.$(board.chip).upload.maximum_data_size))
upload.verbose := $(tools.$(upload.tool).upload.params.$(UPLOAD_VERBOSE))
upload.verify := $(tools.$(upload.tool).upload.params.$(UPLOAD_VERIFY))
program.verbose := $(tools.$(upload.tool).program.params.$(PROGRAM_VERBOSE))
program.verify := $(tools.$(upload.tool).programs.params.$(PROGRAM_VERIFY))
program.extra_params := $(PROGRAM_EXTRA_PARAMS)
erase.verbose := $(tools.$(upload.tool).erase.params.$(ERASE_VERBOSE))
bootloader.verbose := $(tools.$(upload.tool).bootloader.params.$(BOOTLOADER_VERBOSE))
bootloader.file := $($(build.board).bootloader.file)
bootloader.low_fuses := $(firstword $($(build.board).bootloader.low_fuses) $($(BOARD_CLOCK_MENU).bootloader.low_fuses))
bootloader.bod_bits := $($(build.board).menu.bod.$(BOD).bootloader.bod_bits)
bootloader.eesave_bit := $($(build.board).menu.eesave.$(EESAVE).bootloader.eesave_bit)
bootloader.high_fuses := $($(build.board).bootloader.high_fuses)
bootloader.extended_fuses := $($(build.board).bootloader.extended_fuses)
bootloader.lock_bits := $($(build.board).bootloader.lock_bits)
bootloader.unlock_bits := $($(build.board).bootloader.unlock_bits)

-include build-targets.mk
-include programmers.mk
-include $(upload.tool).mk
