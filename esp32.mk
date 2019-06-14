# default options (settable by user)
UPLOAD_SPEED ?= 921600
SERIAL_PORT ?= /dev/ttyUSB0
FLASH_FREQ ?= 80
SPIFFS_DIR ?= data
SPIFFS_IMAGE ?= spiffs.img

VENDOR := esp32
PROCESSOR_FAMILY := esp32
PACKAGE_DIR := $(HOME)/.arduino15/packages/$(VENDOR)
PACKAGE_VERSION := 1.0.2
COMPILER_FAMILY := xtensa-esp32-elf-gcc
COMPILER_VERSION := 1.22.0-80-g6c4433a-5.2.0
COMPILER_PATH := $(PACKAGE_DIR)/tools/$(COMPILER_FAMILY)/$(COMPILER_VERSION)

runtime.ide.version := 10809
runtime.platform.path := $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/$(PACKAGE_VERSION)
runtime.tools.$(COMPILER_FAMILY).path := $(COMPILER_PATH)
runtime.tools.python.path := /usr/bin
runtime.tools.esptool_py.path := $(PACKAGE_DIR)/tools/esptool_py/2.6.1
tools.mkspiffs.cmd := mkspiffs
tools.mkspiffs.path := $(PACKAGE_DIR)/tools/mkspiffs/0.2.3

-include $(runtime.platform.path)/boards.txt
-include platform.txt.mk

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
upload.tool := $($(build.board).upload.tool)
upload.speed = $(UPLOAD_SPEED)
serial.port = $(SERIAL_PORT)

SKETCH ?= $(wildcard *.ino)
SKETCH_EEP := $(SKETCH).partitions.bin

-include common.mk

upload: path = $(runtime.tools.$(upload.tool).path)
upload: cmd = $(tools.$(upload.tool).cmd.linux)
upload: $(SKETCH_BIN)
	$(tools.$(upload.tool).upload.pattern)

ota: network_cmd = $(tools.$(upload.tool).network_cmd)
ota: serial.port = $(OTA_HOST)
ota: network.port = $(OTA_PORT)
ota: network.password = $(OTA_PASSWORD)
ota: $(SKETCH_BIN)
	$(tools.$(upload.tool).upload.network_pattern)

PARTITIONS := $(runtime.platform.path)/tools/partitions/default.csv
SPIFFS_PART := $(shell sed -ne "/^spiffs/p" $(PARTITIONS))
SPIFFS_START := $(shell echo $(SPIFFS_PART) | cut -f4 -d, -)
SPIFFS_SIZE := $(shell echo $(SPIFFS_PART) | cut -f5 -d, -)
SPIFFS_PAGESIZE := 256
SPIFFS_BLOCKSIZE := 4096

$(SPIFFS_IMAGE): $(wildcard $(SPIFFS_DIR)/*)
	$(tools.mkspiffs.path)/$(tools.mkspiffs.cmd) -c $(SPIFFS_DIR) -b $(SPIFFS_BLOCKSIZE) -p $(SPIFFS_PAGESIZE) -s $(SPIFFS_SIZE) $@

fs: $(SPIFFS_IMAGE)

upload-fs: fs
	$(runtime.tools.$(upload.tool).path)/$(tools.$(upload.tool).cmd.linux) --chip esp32 --port $(serial.port) --before default_reset --after hard_reset write_flash -z --flash_mode $(build.flash_mode) --flash_freq $(build.flash_freq) --flash_size detect $(SPIFFS_START) $(SPIFFS_IMAGE)

.PHONY: upload fs upload-fs ota
