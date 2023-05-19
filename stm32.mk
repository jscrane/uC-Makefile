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

build.bootloader_flags := $($(BOARD).menu.upload_method.$(UPLOAD_METHOD).build.bootloader_flags)
build.st_extra_flags := $($(BOARD).build.st_extra_flags)

LIBRARIES += SrcWrapper

-include build-targets.mk

upload: path = $(tools.$(upload.tool).path)
upload: cmd = $(tools.$(upload.tool).cmd)
upload: script = $(tools.$(upload.tool).script)
upload: upload.params = $(tools.$(upload.tool).upload.params)
upload: serial.port.file = $(notdir $(SERIAL_PORT))
upload: prebuild $(SKETCH_BIN)
	$(subst "",, $(tools.$(upload.tool).upload.pattern))
