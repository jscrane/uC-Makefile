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

tools.esptool_py.path := ${runtime.tools.esptool_py.path}
tools.esptool_py.cmd = $(tools.esptool_py.cmd.linux)

$(call define-menu-variables,JTAGAdapter)
$(call define-menu-variables,PSRAM)
$(call define-menu-variables,PartitionScheme)
$(call define-menu-variables,CPUFreq)
$(call define-menu-variables,FlashMode)
$(call define-menu-variables,FlashFreq)
$(call define-menu-variables,FlashSize)
$(call define-menu-variables,UploadSpeed)
$(call define-menu-variables,LoopCore)
$(call define-menu-variables,EventsCore)
$(call define-menu-variables,DebugLevel)
$(call define-menu-variables,EraseFlash)

upload.maximum_size ?= $($(build.mcu).upload.maximum_size)
upload.speed = $(UPLOAD_SPEED)
serial.port = $(SERIAL_PORT)

SUFFIX_EEP := partitions.bin

-include build-targets.mk

upload: path = $(runtime.tools.$(upload.tool).path)
upload: cmd = $(tools.$(upload.tool).cmd.linux)
upload: upload.pattern_args = $(tools.$(upload.tool).upload.pattern_args)
upload: prebuild $(SKETCH_BIN)
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

upload-fs: $(SPIFFS_IMAGE)
	$(runtime.tools.$(upload.tool).path)/$(tools.$(upload.tool).cmd.linux) --chip esp32 --port $(serial.port) --before default_reset --after hard_reset write_flash -z --flash_mode $(build.flash_mode) --flash_freq $(build.flash_freq) --flash_size detect $(SPIFFS_START) $(SPIFFS_IMAGE)

.PHONY: upload upload-fs ota
