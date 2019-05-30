# default options (settable by user)
UPLOAD_SPEED ?= 921600
UPLOAD_PORT ?= /dev/ttyUSB0
FLASH_FREQ ?= 80

PROCESSOR_FAMILY := esp32
PACKAGE_DIR := $(HOME)/.arduino15/packages/$(PROCESSOR_FAMILY)
PACKAGE_VERSION := 1.0.2
COMPILER_FAMILY := xtensa-esp32-elf-gcc
COMPILER_VERSION := 1.22.0-80-g6c4433a-5.2.0

runtime.ide.version := 10809
runtime.platform.path := $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/$(PACKAGE_VERSION)
runtime.tools.$(COMPILER_FAMILY).path := $(PACKAGE_DIR)/tools/$(COMPILER_FAMILY)/$(COMPILER_VERSION)
runtime.tools.python.path := /usr/bin
runtime.tools.esptool_py.path := $(PACKAGE_DIR)/tools/esptool_py/2.6.1

-include $(runtime.platform.path)/boards.txt
-include platform.mk

build.board := $(BOARD)
build.arch := $($(build.board).build.mcu)
CORE := $(runtime.platform.path)/cores/$(build.arch)
includes := -I$(CORE) -I$(runtime.platform.path)/variants/$(build.board)
build.f_cpu := $($(build.board).build.f_cpu)
build.flash_mode := $($(build.board).build.flash_mode)
build.flash_size := $($(build.board).build.flash_size)
build.flash_freq := $($(build.board).menu.FlashFreq.$(FLASH_FREQ).build.flash_freq)
build.boot := $($(build.board).build.boot)
build.partitions := $($(build.board).build.partitions)
UPLOAD_TOOL := $($(build.board).upload.tool)
upload.speed = $(UPLOAD_SPEED)
serial.port = $(UPLOAD_PORT)

SKETCH ?= $(wildcard *.ino)
SKETCH_EEP := $(SKETCH).partitions.bin

-include common.mk

define upload-sketch
upload: path = $$(runtime.tools.$(UPLOAD_TOOL).path)
upload: cmd = $$(tools.$(UPLOAD_TOOL).cmd.linux)
upload: $(SKETCH_BIN)
	$$(tools.$(UPLOAD_TOOL).upload.pattern)
endef

$(eval $(call upload-sketch))
