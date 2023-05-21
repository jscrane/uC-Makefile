ifndef PNUM
$(error PNUM required)
endif

SERIAL_PORT ?= /dev/ttyACM0
TERMINAL_SPEED ?= 115200
STM_TOOLS ?= /usr/local

# menus
XSERIAL ?= generic
USB ?= CDCgen
XUSB ?= FS
OPT ?= osstd
DBG ?= none
RTLIB ?= nano
UPLOAD_METHOD ?= dfu2Method

VENDOR := STMicroelectronics
PROCESSOR_FAMILY := stm32

export PATH := $(PATH):$(STM_TOOLS)/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin

-include hardware.mk

LIBRARIES += SrcWrapper

serial.port.file = $(notdir $(SERIAL_PORT))

-include build-targets.mk
