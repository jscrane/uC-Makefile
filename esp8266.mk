ifndef EESZ
$(error EESZ required)
endif

UPLOAD_VERBOSE ?= quiet
SERIAL_PORT ?= /dev/ttyUSB0
FS_DIR ?= data
SPIFFS_IMAGE ?= spiffs.img
LITTLEFS_IMAGE ?= littlefs.img

# menus
XTAL ?= 80
VT ?= flash
EXCEPTION ?= disabled
STACKSMASH ?= disabled
SSL ?= all
MMU ?= 3232
NON32XFER ?= fast
RESETMETHOD ?= nodemcu
CRYSTALFREQ ?= 26
FLASHFREQ ?= 40
FLASHMODE ?= dout
LED ?= 2
SDK ?= nonosdk_190703
IP ?= lm2f
DBG ?= Disabled
LVL ?= None____
WIPE ?= none
BAUD ?= 115200

VENDOR := esp8266
PROCESSOR_FAMILY := esp8266

-include hardware.mk

# ???
upload.maximum_size := $(menu.eesz.autoflash.upload.maximum_size)
upload.verbose = $(tools.$(upload.tool).upload.params.$(UPLOAD_VERBOSE))
serial.port = $(SERIAL_PORT)

-include build-targets.mk

ota: network_cmd = $(tools.$(upload.tool).network_cmd)
ota: serial.port = $(OTA_HOST)
ota: network.port = $(OTA_PORT)
ota: network.password = $(OTA_PASSWORD)
ota: prebuild $(SKETCH_BIN)
	$(tools.$(upload.tool).upload.network_pattern)

BUILD_EXTRAS := $(SPIFFS_IMAGE) $(LITTLEFS_IMAGE)

$(SPIFFS_IMAGE): $(wildcard $(FS_DIR)/*)
	$(tools.mkspiffs.path)/$(tools.mkspiffs.cmd) -c $(FS_DIR) -b $(build.spiffs_blocksize) -p $(build.spiffs_pagesize) -s $$(( $(build.spiffs_end) - $(build.spiffs_start) )) $@

spiffs: $(SPIFFS_IMAGE)

upload-spiffs: $(SPIFFS_IMAGE)
	$(tools.esptool.cmd) $(runtime.platform.path)/tools/upload.py --chip esp8266 --port $(serial.port) --baud $(upload.speed) $(upload.verbose) write_flash $(build.spiffs_start) $<

$(LITTLEFS_IMAGE): $(wildcard $(FS_DIR)/*)
	$(runtime.tools.mklittlefs.path)/$(tools.mklittlefs.cmd) -c $(FS_DIR) -b $(build.spiffs_blocksize) -p $(build.spiffs_pagesize) -s $$(( $(build.spiffs_end) - $(build.spiffs_start) )) $@

littlefs: $(LITTLEFS_IMAGE)

upload-littlefs: $(LITTLEFS_IMAGE)
	$(tools.esptool.cmd) $(runtime.platform.path)/tools/upload.py --chip esp8266 --port $(serial.port) --baud $(upload.speed) $(upload.verbose) write_flash $(build.spiffs_start) $<

.PHONY: ota spiffs upload-spiffs littlefs upload-littlefs
