VENDOR := STMicroelectronics
PROCESSOR_FAMILY := stm32

SERIAL_PORT ?= /dev/ttyACM0
TERMINAL_SPEED ?= 115200
STM_TOOLS ?= /usr/local

export PATH := $(PATH):$(STM_TOOLS)/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin

# menus
XSERIAL ?= generic
USB ?= CDCgen
XUSB ?= FS
OPT ?= osstd
DBG ?= none
RTLIB ?= nano
UPLOAD_METHOD ?= dfu2Method

-include hardware.mk

FAMILY := $(firstword $(subst ., ,$(BOARD)))
build.xserial := $($(FAMILY).menu.xserial.$(MENU_XSERIAL).build.xSerial)
build.st_extra_flags := $($(FAMILY).build.st_extra_flags)

LIBRARIES += SrcWrapper

-include build-targets.mk

upload: path = $(tools.$(upload.tool).path)
upload: cmd = $(tools.$(upload.tool).cmd)
upload: script = $(tools.$(upload.tool).script)
upload: upload.params = $(tools.$(upload.tool).upload.params)
upload: serial.port.file = $(notdir $(MENU_SERIAL_PORT))
upload: prebuild $(SKETCH_BIN)
	$(subst "",, $(tools.$(upload.tool).upload.pattern))
