# default options (settable by user)
SERIAL_PORT ?= /dev/ttyUSB0
FS_DIR ?= data
SPIFFS_IMAGE ?= spiffs.img

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

upload: path = $(tools.$(upload.tool).path)
upload: cmd = $(call os-override,tools.$(upload.tool).cmd)
upload: upload.pattern_args = $(tools.$(upload.tool).upload.pattern_args)
upload: prebuild $(SKETCH_BIN)
	$(tools.$(upload.tool).upload.pattern.linux)

ota: network_cmd = $(tools.$(upload.tool).network_cmd)
ota: serial.port = $(OTA_HOST)
ota: network.port = $(OTA_PORT)
ota: network.password = $(OTA_PASSWORD)
ota: prebuild $(SKETCH_BIN)
	$(tools.$(upload.tool).upload.network_pattern)

PARTITIONS := $(build.path)/partitions.csv
SPIFFS_PART := $(shell sed -ne "/^spiffs/p" $(PARTITIONS))
SPIFFS_START := $(shell echo $(SPIFFS_PART) | cut -f4 -d, -)
SPIFFS_SIZE := $(shell echo $(SPIFFS_PART) | cut -f5 -d, -)
SPIFFS_PAGESIZE := 256
SPIFFS_BLOCKSIZE := 4096
$(SPIFFS_IMAGE): $(wildcard $(SPIFFS_DIR)/*)
	$(runtime.tools.mkspiffs.path)/$(runtime.tools.mkspiffs.cmd) -c $(FS_DIR) -b $(SPIFFS_BLOCKSIZE) -p $(SPIFFS_PAGESIZE) -s $(SPIFFS_SIZE) $@

upload-fs: cmd = $(call os-override,tools.$(upload.tool).cmd)
upload-fs: $(SPIFFS_IMAGE)
	$(runtime.tools.$(upload.tool).path)/$(cmd) --chip esp32 --port $(serial.port) --before default_reset --after hard_reset write_flash -z --flash_mode $(build.flash_mode) --flash_freq $(build.flash_freq) --flash_size detect $(SPIFFS_START) $(SPIFFS_IMAGE)

.PHONY: upload upload-fs ota
