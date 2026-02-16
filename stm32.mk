SERIAL_PORT ?= /dev/ttyACM0
TERMINAL_SPEED ?= 115200
STM_TOOLS ?= /usr/local

# menus
ifndef pnum
$(error pnum required)
endif
xserial ?= generic
usb ?= CDCgen
xusb ?= FS
opt ?= osstd
dbg ?= none
rtlib ?= nano
upload_method ?= dfu2Method

VENDOR := STMicroelectronics
PROCESSOR_FAMILY := stm32

export PATH := $(PATH):$(STM_TOOLS)/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin

-include hardware.mk

LIBRARIES += SrcWrapper

serial.port.file = $(notdir $(SERIAL_PORT))

-include build-targets.mk
