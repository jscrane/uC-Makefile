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

-include hardware.mk

build.board := $(BOARD)
BOARD_CPU_MENU := $(build.board).menu.cpu.$(BOARD_CPU)

build.mcu := $(firstword $($(BOARD).build.mcu) $($(BOARD_CPU_MENU).build.mcu))
build.f_cpu := $(firstword $($(BOARD).build.f_cpu) $($(BOARD_CPU_MENU).build.f_cpu))
build.core := $($(build.board).build.core)
build.variant := $($(build.board).build.variant)

serial.port := $(SERIAL_PORT)
upload.maximum_size := $(firstword $($(BOARD).upload.maximum_size) $($(BOARD_CPU_MENU).upload.maximum_size))
upload.maximum_data_size := $(firstword $($(BOARD).upload.maximum_data_size) $($(BOARD_CPU_MENU).upload.maximum_data_size))
upload.protocol := $($(BOARD).upload.protocol)
upload.speed := $(firstword $($(BOARD).upload.speed) $($(BOARD_CPU_MENU).upload.speed))
upload.verbose := $(tools.$(upload.tool).upload.params.$(UPLOAD_VERBOSE))
upload.verify := $(UPLOAD_VERIFY)
program.verbose := $(tools.$(upload.tool).program.params.$(PROGRAM_VERBOSE))
program.verify := $(PROGRAM_VERIFY)
program.extra_params := $(PROGRAM_EXTRA_PARAMS)
erase.verbose := $(tools.$(upload.tool).erase.params.$(ERASE_VERBOSE))
bootloader.verbose := $(tools.$(upload.tool).bootloader.params.$(BOOTLOADER_VERBOSE))
bootloader.file := $($(BOARD_CPU_MENU).bootloader.file)
bootloader.low_fuses := $($(BOARD_CPU_MENU).bootloader.low_fuses)
bootloader.high_fuses := $($(BOARD_CPU_MENU).bootloader.high_fuses)
bootloader.extended_fuses := $($(BOARD_CPU_MENU).bootloader.extended_fuses)
bootloader.lock_bits := $($(build.board).bootloader.lock_bits)

-include build-targets.mk
-include programmers.mk
