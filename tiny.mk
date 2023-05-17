# default options (settable by user)
SERIAL_PORT ?= /dev/ttyUSB0
UPLOAD_VERIFY ?= noverify
PROGRAM_VERIFY ?= $(UPLOAD_VERIFY)
UPLOAD_VERBOSE ?= quiet
PROGRAM_VERBOSE ?= $(UPLOAD_VERBOSE)
ERASE_VERBOSE ?= $(UPLOAD_VERBOSE)
BOOTLOADER_VERBOSE ?= $(UPLOAD_VERBOSE)
PROGRAMMER ?= arduinoasisp

VENDOR := ATTinyCore
PROCESSOR_FAMILY := avr
PACKAGES := $(HOME)/.arduino15/packages
COMPILER_FAMILY := avr-gcc
COMPILER_PATH := $(lastword $(wildcard $(PACKAGES)/arduino/tools/$(COMPILER_FAMILY)/*))

runtime.tools.$(COMPILER_FAMILY).path := $(COMPILER_PATH)

-include hardware.mk

# menus
PINMAPPING ?= anew
LTO ?= enable
BOD ?= 1v8
EESAVE ?= aenable
MILLIS ?= enabled
NEOPIXELPORT ?= porta

CHIP := $(firstword $(chip) $(CHIP))
CLOCK := $(firstword $(clock) $(CLOCK))
PINMAPPING := $(firstword $(pinmapping) $(PINMAPPING))

$(call define-menus,chip clock pinmapping LTO bod eesave millis neopixelport)

serial.port := $(SERIAL_PORT)
upload.verbose := $(tools.$(upload.tool).upload.params.$(UPLOAD_VERBOSE))
upload.verify := $(tools.$(upload.tool).upload.params.$(UPLOAD_VERIFY))
program.verbose := $(tools.$(upload.tool).program.params.$(PROGRAM_VERBOSE))
program.verify := $(tools.$(upload.tool).programs.params.$(PROGRAM_VERIFY))
program.extra_params := $(PROGRAM_EXTRA_PARAMS)
erase.verbose := $(tools.$(upload.tool).erase.params.$(ERASE_VERBOSE))
bootloader.verbose := $(tools.$(upload.tool).bootloader.params.$(BOOTLOADER_VERBOSE))

-include build-targets.mk
-include programmers.mk
-include $(upload.tool).mk
