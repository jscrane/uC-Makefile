SERIAL_PORT ?= /dev/ttyUSB0
UPLOAD_VERIFY ?= -V
UPLOAD_VERBOSE ?= quiet
PROGRAM_VERBOSE ?= $(UPLOAD_VERBOSE)
ERASE_VERBOSE ?= $(UPLOAD_VERBOSE)
BOOTLOADER_VERBOSE ?= $(UPLOAD_VERBOSE)
PROGRAMMER ?= arduinoasisp

VENDOR := arduino
PROCESSOR_FAMILY := avr

-include hardware.mk

serial.port := $(SERIAL_PORT)
upload.verbose := $(tools.$(upload.tool).upload.params.$(UPLOAD_VERBOSE))
upload.verify := $(UPLOAD_VERIFY)
program.verbose := $(tools.$(upload.tool).program.params.$(PROGRAM_VERBOSE))
program.verify := $(PROGRAM_VERIFY)
program.extra_params := $(PROGRAM_EXTRA_PARAMS)
erase.verbose := $(tools.$(upload.tool).erase.params.$(ERASE_VERBOSE))
bootloader.verbose := $(tools.$(upload.tool).bootloader.params.$(BOOTLOADER_VERBOSE))

-include build-targets.mk
-include programmers.mk
