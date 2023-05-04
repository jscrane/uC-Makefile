# default options (settable by user)
UPLOAD_SPEED ?= 921600
SERIAL_PORT ?= /dev/ttyUSB0
FLASH_FREQ ?= 80
FS_DIR ?= data
SPIFFS_IMAGE ?= spiffs.img
PARTITION_SCHEME ?= default

VENDOR := esp32
PROCESSOR_FAMILY := esp32

build.tarch := xtensa
build.target := esp32

-include hardware.mk

tools.esptool_py.path := ${runtime.tools.esptool_py.path}
tools.esptool_py.cmd = $(tools.esptool_py.cmd.linux)

build.flash_mode := $($(build.board).build.flash_mode)
build.flash_size := $($(build.board).build.flash_size)
build.flash_freq := $($(build.board).menu.FlashFreq.$(FLASH_FREQ).build.flash_freq)
build.boot := $($(build.board).build.boot)
build.partitions := $($(build.board).menu.PartitionScheme.$(PARTITION_SCHEME).build.partitions)

upload.maximum_size := $(firstword $($(build.board).menu.PartitionScheme.$(PARTITION_SCHEME).upload.maximum_size) $($(build.mcu).upload.maximum_size))
upload.speed = $(UPLOAD_SPEED)
serial.port = $(SERIAL_PORT)

SUFFIX_EEP := partitions.bin

-include build-targets.mk

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
