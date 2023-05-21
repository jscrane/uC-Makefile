# default options (settable by user)
SERIAL_PORT ?= /dev/ttyUSB0
UPLOAD_VERIFY ?= verify
UPLOAD_VERBOSE ?= quiet
PROGRAM_VERBOSE ?= $(UPLOAD_VERBOSE)
PROGRAM_VERIFY ?= $(UPLOAD_VERIFY)
ERASE_VERBOSE ?= $(UPLOAD_VERBOSE)
BOOTLOADER_VERBOSE ?= $(UPLOAD_VERBOSE)
PROGRAMMER ?= arduinoasisp

VENDOR := ATTinyCore
PROCESSOR_FAMILY := avr
PACKAGES := $(HOME)/.arduino15/packages
COMPILER_FAMILY := avr-gcc
TOOLS_DIR := $(PACKAGES)/arduino/tools
COMPILER_PATH := $(lastword $(wildcard $(TOOLS_DIR)/$(COMPILER_FAMILY)/*))

runtime.tools.$(COMPILER_FAMILY).path := $(COMPILER_PATH)

# menus
PINMAPPING ?= anew
LTO ?= enable
BOD ?= 1v8
EESAVE ?= aenable
MILLIS ?= enabled
NEOPIXELPORT ?= porta

-include hardware.mk

serial.port := $(SERIAL_PORT)
upload.verbose := $(tools.$(upload.tool).upload.params.$(UPLOAD_VERBOSE))
upload.verify := $(tools.$(upload.tool).upload.params.$(UPLOAD_VERIFY))
program.verbose := $(tools.$(program.tool).program.params.$(PROGRAM_VERBOSE))
program.verify := $(tools.$(program.tool).program.params.$(PROGRAM_VERIFY))
program.extra_params := $(tools.$(program.tool).program.extra_params)
erase.verbose := $(tools.$(program.tool).erase.params.$(ERASE_VERBOSE))
bootloader.verbose := $(tools.$(bootloader.tool).bootloader.params.$(BOOTLOADER_VERBOSE))

-include build-targets.mk
-include programmers.mk
-include $(upload.tool).mk
