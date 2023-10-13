# default options (settable by user)
SERIAL_PORT ?= /dev/ttyUSB0
FS_DIR ?= data
SPIFFS_IMAGE ?= spiffs.img
LITTLEFS_IMAGE ?= littlefs.img

# menus
JTAGADAPTER ?= default
PSRAM ?= disabled
PARTITIONSCHEME ?= default
CPUFREQ ?= 240
FLASHMODE ?= qio
FLASHFREQ ?= 80
FLASHSIZE ?= 4M
UPLOADSPEED ?= 921600
LOOPCORE ?= 1
EVENTSCORE ?= 1
DEBUGLEVEL ?= none
ERASEFLASH ?= none

VENDOR := esp32
PROCESSOR_FAMILY := esp32

build.tarch := xtensa
build.target := esp32

-include hardware.mk

# this is required for recipel.hooks.prebuild.4.pattern (but shouldn't be)
tools.esptool_py.cmd := $(call os-override,tools.esptool_py.cmd)

SUFFIX_EEP := partitions.bin

-include build-targets.mk

serial.port = $(SERIAL_PORT)

ota: network_cmd = $(tools.$(upload.tool).network_cmd)
ota: serial.port = $(OTA_HOST)
ota: network.port = $(OTA_PORT)
ota: network.password = $(OTA_PASSWORD)
ota: prebuild $(SKETCH_BIN)
	$(tools.$(upload.tool).upload.network_pattern)

BUILD_EXTRAS := $(SPIFFS_IMAGE) $(LITTLEFS_IMAGE)

PARTITIONS := $(build.path)/partitions.csv
SPIFFS_PART := $(shell sed -ne "/^spiffs/p" $(PARTITIONS))
FS_START := $(shell echo $(SPIFFS_PART) | cut -f4 -d, -)
FS_SIZE := $(shell echo $(SPIFFS_PART) | cut -f5 -d, -)
FS_PAGESIZE := 256
FS_BLOCKSIZE := 4096
$(SPIFFS_IMAGE): $(wildcard $(FS_DIR)/*)
	$(runtime.tools.mkspiffs.path)/$(runtime.tools.mkspiffs.cmd) -c $(FS_DIR) -b $(FS_BLOCKSIZE) -p $(FS_PAGESIZE) -s $(FS_SIZE) $@

spiffs: $(SPIFFS_IMAGE)

upload-spiffs: cmd = $(tools.$(upload.tool).cmd)
upload-spiffs: $(SPIFFS_IMAGE)
	$(runtime.tools.$(upload.tool).path)/$(cmd) --chip esp32 --port $(serial.port) --before default_reset --after hard_reset write_flash -z --flash_mode $(build.flash_mode) --flash_freq $(build.flash_freq) --flash_size detect $(FS_START) $(SPIFFS_IMAGE)

$(LITTLEFS_IMAGE): $(wildcard $(FS_DIR)/*)
	$(runtime.tools.mklittlefs.path)/$(runtime.tools.mklittlefs.cmd) -c $(FS_DIR) -b $(FS_BLOCKSIZE) -p $(FS_PAGESIZE) -s $(FS_SIZE) $@

littlefs: $(LITTLEFS_IMAGE)

upload-littlefs: cmd = $(tools.$(upload.tool).cmd)
upload-littlefs: $(LITTLEFS_IMAGE)
	$(runtime.tools.$(upload.tool).path)/$(cmd) --chip esp32 --port $(serial.port) --before default_reset --after hard_reset write_flash -z --flash_mode $(build.flash_mode) --flash_freq $(build.flash_freq) --flash_size detect $(FS_START) $(LITTLEFS_IMAGE)

.PHONY: upload spiffs upload-spiffs littlefs upload-littlefs ota
