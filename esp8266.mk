LWIP_OPTS ?= lm2f
F_CPU ?= 80
DEBUG_PORT ?= Disabled
DEBUG_LEVEL ?= None____
EXCEPTIONS ?= disabled
VTABLES ?= flash
SSL ?= all
WIPE ?= none
UPLOAD_SPEED ?= 921600
UPLOAD_VERBOSE ?= quiet
SERIAL_PORT ?= /dev/ttyUSB0
FS_DIR ?= data
SPIFFS_IMAGE ?= spiffs.img
LITTLEFS_IMAGE ?= littlefs.img
MMU ?= 3232

VENDOR := esp8266
PROCESSOR_FAMILY := esp8266
PACKAGE_DIR := $(HOME)/.arduino15/packages/$(VENDOR)
PREBUILD := esp8266-prebuild

-include hardware.mk

build.board := $(BOARD)
build.arch := $($(build.board).build.mcu)
build.core := $($(build.board).build.core)
build.variant := $($(build.board).build.variant)

build.f_cpu := $($(build.board).menu.xtal.$(F_CPU).build.f_cpu)
build.debug_port := $($(build.board).menu.dbg.$(DEBUG_PORT).build.debug_port)
build.debug_level := $($(build.board).menu.lvl.$(DEBUG_LEVEL).build.debug_level)
build.flash_flags := $($(build.board).build.flash_flags)
build.flash_mode := $($(build.board).build.flash_mode)
build.flash_freq := $($(build.board).build.flash_freq)

FLASH_MENU := $(build.board).menu.eesz.$(FLASH_SIZE)
build.flash_size := $($(FLASH_MENU).build.flash_size)
build.flash_ld := $($(FLASH_MENU).build.flash_ld)
build.rfcal_addr := $($(FLASH_MENU).build.rfcal_addr)
build.spiffs_pagesize := $($(FLASH_MENU).build.spiffs_pagesize)
build.spiffs_blocksize := $($(FLASH_MENU).build.spiffs_blocksize)
build.spiffs_start := $($(FLASH_MENU).build.spiffs_start)
build.spiffs_end := $($(FLASH_MENU).build.spiffs_end)

upload.maximum_size := $($(build.board).menu.eesz.autoflash.upload.maximum_size)
upload.erase_cmd := $($(build.board).menu.wipe.$(WIPE).upload.erase_cmd)
upload.speed = $(UPLOAD_SPEED)
upload.verbose = $(tools.$(upload.tool).upload.params.$(UPLOAD_VERBOSE))
serial.port = $(SERIAL_PORT)

build.lwip_flags := $($(build.board).menu.ip.$(LWIP_OPTS).build.lwip_flags)
build.lwip_lib := $($(build.board).menu.ip.$(LWIP_OPTS).build.lwip_lib)
build.lwip_include := $($(build.board).menu.ip.$(LWIP_OPTS).build.lwip_include)
build.vtable_flags := $($(build.board).menu.vt.$(VTABLES).build.vtable_flags)
build.ssl_flags := $($(build.board).menu.ssl.$(SSL).build.ssl_flags)
build.exception_flags := $($(build.board).menu.exception.$(EXCEPTIONS).build.exception_flags)
build.stdcpp_lib := $($(build.board).menu.exception.$(EXCEPTIONS).build.stdcpp_lib)
build.mmuflags := $($(build.board).menu.mmu.$(MMU).build.mmuflags)

OBJCOPY_HEX_PATTERN ?= $(recipe.objcopy.hex.1.pattern)

-include build-targets.mk

upload: cmd = $(tools.$(upload.tool).cmd)
upload: $(SKETCH_BIN)
	$(subst "",, $(tools.$(upload.tool).upload.pattern))

ota: network_cmd = $(tools.$(upload.tool).network_cmd)
ota: serial.port = $(OTA_HOST)
ota: network.port = $(OTA_PORT)
ota: network.password = $(OTA_PASSWORD)
ota: $(SKETCH_BIN)
	$(tools.$(upload.tool).upload.network_pattern)

esp8266-prebuild: build.core.path := $(CORE)
esp8266-prebuild:
	$(recipe.hooks.prebuild.1.pattern)
	$(recipe.hooks.prebuild.2.pattern)

BUILD_EXTRAS := $(SPIFFS_IMAGE) $(LITTLEFS_IMAGE)

$(SPIFFS_IMAGE): $(wildcard $(FS_DIR)/*)
	$(tools.mkspiffs.path)/$(tools.mkspiffs.cmd) -c $(FS_DIR) -b $(build.spiffs_blocksize) -p $(build.spiffs_pagesize) -s $$(( $(build.spiffs_end) - $(build.spiffs_start) )) $@

spiffs: $(SPIFFS_IMAGE)

upload-spiffs: $(SPIFFS_IMAGE)
	$(tools.esptool.cmd) $(runtime.platform.path)/tools/upload.py --chip esp8266 --port $(serial.port) --baud $(upload.speed) $(upload.verbose) write_flash $(build.spiffs_start) $<

$(LITTLEFS_IMAGE): $(wildcard $(FS_DIR)/*)
	$(runtime.tools.mklittlefs.path)/$(tools.mklittlefs.cmd) -c $(FS_DIR) -b $(build.spiffs_blocksize) -p $(build.spiffs_pagesize) -s $$(( $(build.spiffs_end) - $(build.spiffs_start) )) $@

fs: $(LITTLEFS_IMAGE)

upload-fs: $(LITTLEFS_IMAGE)
	$(tools.esptool.cmd) $(runtime.platform.path)/tools/upload.py --chip esp8266 --port $(serial.port) --baud $(upload.speed) $(upload.verbose) write_flash $(build.spiffs_start) $<

.PHONY: esp8266-prebuild upload ota spiffs fs upload-fs
