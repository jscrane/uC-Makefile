# default options (settable by user)
UPLOAD_SPEED ?= 921600
SERIAL_PORT ?= /dev/ttyUSB0
FLASH_FREQ ?= 80
FS_DIR ?= data
SPIFFS_IMAGE ?= spiffs.img
PARTITION_SCHEME ?= default

VENDOR := esp32
PROCESSOR_FAMILY := esp32
PACKAGE_DIR := $(HOME)/.arduino15/packages/$(VENDOR)
COMPILER_FAMILY := xtensa-esp32-elf-gcc
COMPILER_PATH := $(wildcard $(PACKAGE_DIR)/tools/$(COMPILER_FAMILY)/*)

build.tarch := xtensa
build.target := esp32
runtime.ide.version := 10809
runtime.platform.path := $(wildcard $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/*)
runtime.tools.$(COMPILER_FAMILY).path := $(COMPILER_PATH)
runtime.tools.python.path := /usr/bin
runtime.tools.esptool_py.path := $(wildcard $(PACKAGE_DIR)/tools/esptool_py/*)
tools.mkspiffs.cmd := mkspiffs
tools.mkspiffs.path := $(wildcard $(PACKAGE_DIR)/tools/mkspiffs/*)

-include $(runtime.platform.path)/boards.txt
-include platform.txt.mk

build.board := $(BOARD)
build.mcu := $($(build.board).build.mcu)
build.arch := $(build.mcu)
build.core := $($(build.board).build.core)
build.variant := $($(build.board).build.variant)

build.f_cpu := $($(build.board).build.f_cpu)
build.flash_mode := $($(build.board).build.flash_mode)
build.flash_size := $($(build.board).build.flash_size)
build.flash_freq := $($(build.board).menu.FlashFreq.$(FLASH_FREQ).build.flash_freq)
build.boot := $($(build.board).build.boot)
build.partitions := $($(build.board).menu.PartitionScheme.$(PARTITION_SCHEME).build.partitions)
upload.maximum_size := $($(build.board).menu.PartitionScheme.$(PARTITION_SCHEME).upload.maximum_size)
ifndef upload.maximum_size
upload.maximum_size := $($(build.mcu).upload.maximum_size)
endif
upload.speed = $(UPLOAD_SPEED)
serial.port = $(SERIAL_PORT)

SUFFIX_HEX := bin
SUFFIX_EEP := partitions.bin

-include common.mk

upload: path = $(runtime.tools.$(upload.tool).path)
upload: cmd = $(tools.$(upload.tool).cmd.linux)
upload: upload.pattern_args = $(tools.$(upload.tool).upload.pattern_args)
upload: $(SKETCH_BIN)
	$(tools.$(upload.tool).upload.pattern.linux)

ota: network_cmd = $(tools.$(upload.tool).network_cmd)
ota: serial.port = $(OTA_HOST)
ota: network.port = $(OTA_PORT)
ota: network.password = $(OTA_PASSWORD)
ota: $(SKETCH_BIN)
	$(tools.$(upload.tool).upload.network_pattern)

PARTITIONS := $(build.path)/partitions.csv
SPIFFS_PART := $(shell sed -ne "/^spiffs/p" $(PARTITIONS))
SPIFFS_START := $(shell echo $(SPIFFS_PART) | cut -f4 -d, -)
SPIFFS_SIZE := $(shell echo $(SPIFFS_PART) | cut -f5 -d, -)
SPIFFS_PAGESIZE := 256
SPIFFS_BLOCKSIZE := 4096

$(SPIFFS_IMAGE): $(wildcard $(SPIFFS_DIR)/*)
	$(tools.mkspiffs.path)/$(tools.mkspiffs.cmd) -c $(FS_DIR) -b $(SPIFFS_BLOCKSIZE) -p $(SPIFFS_PAGESIZE) -s $(SPIFFS_SIZE) $@

upload-fs:  $(SPIFFS_IMAGE)
	$(runtime.tools.$(upload.tool).path)/$(tools.$(upload.tool).cmd.linux) --chip esp32 --port $(serial.port) --before default_reset --after hard_reset write_flash -z --flash_mode $(build.flash_mode) --flash_freq $(build.flash_freq) --flash_size detect $(SPIFFS_START) $(SPIFFS_IMAGE)

.PHONY: upload upload-fs ota
