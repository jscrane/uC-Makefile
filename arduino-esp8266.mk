# default options (settable by user)
LWIP_OPTS ?= lm2f
F_CPU ?= 80
DEBUG_PORT ?= Disabled
DEBUG_LEVEL ?= None____
EXCEPTIONS ?= disabled
VTABLES ?= flash
SSL ?= all
UPLOAD_SPEED ?= 921600
UPLOAD_ERASE ?= version
UPLOAD_PORT ?= /dev/ttyUSB0

PROCESSOR_FAMILY := esp8266
PACKAGE_DIR := $(HOME)/.arduino15/packages/$(PROCESSOR_FAMILY)
PACKAGE_VERSION := 2.5.2
COMPILER_FAMILY := xtensa-lx106-elf-gcc
COMPILER_VERSION := 2.5.0-3-20ed2b9

runtime.ide.version := 10809
runtime.platform.path := $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/$(PACKAGE_VERSION)
runtime.tools.$(COMPILER_FAMILY).path := $(PACKAGE_DIR)/tools/$(COMPILER_FAMILY)/$(COMPILER_VERSION)
runtime.tools.python.path := /usr/bin

-include $(runtime.platform.path)/boards.txt
-include platform.mk

build.board := $(BOARD)
build.arch := $($(build.board).build.mcu)
CORE := $(runtime.platform.path)/cores/$(build.arch)
includes := -I$(CORE) -I$(runtime.platform.path)/variants/$(build.board) \
	-I$(runtime.platform.path)/tools/sdk/$($(build.board).menu.ip.$(LWIP_OPTS).build.lwip_include)
build.f_cpu := $($(build.board).menu.xtal.$(F_CPU).build.f_cpu)
build.debug_port := $($(build.board).menu.dbg.$(DEBUG_PORT).build.debug_port)
build.debug_level := $($(build.board).menu.lvl.$(DEBUG_LEVEL).build.debug_level)
build.flash_flags := $($(build.board).build.flash_flags)
build.flash_mode := $($(build.board).build.flash_mode)
build.flash_freq := $($(build.board).build.flash_freq)
build.flash_size := $($(build.board).menu.eesz.$(FLASH_SIZE).build.flash_size)
build.flash_size_bytes := $($(build.board).menu.eesz.$(FLASH_SIZE).build.flash_size_bytes)
build.flash_ld := $($(build.board).menu.eesz.$(FLASH_SIZE).build.flash_ld)
build.spiffs_pagesize := $($(build.board).menu.eesz.$(FLASH_SIZE).build.spiffs_pagesize)
build.spiffs_start := $($(build.board).menu.eesz.$(FLASH_SIZE).build.spiffs_start)
build.spiffs_end := $($(build.board).menu.eesz.$(FLASH_SIZE).build.spiffs_end)
build.spiffs_blocksize := $($(build.board).menu.eesz.$(FLASH_SIZE).build.spiffs_blocksize)
UPLOAD_TOOL := $($(build.board).upload.tool)
upload.erase_cmd = $(UPLOAD_ERASE)
upload.speed = $(UPLOAD_SPEED)
upload.verbose = $(tools.$(UPLOAD_TOOL).upload.params.verbose)
serial.port = $(UPLOAD_PORT)

build.lwip_flags := $($(build.board).menu.ip.$(LWIP_OPTS).build.lwip_flags)
#build.lwip_lib := $($(build.board).menu.ip.$(LWIP_OPTS).build.lwip_lib)
build.vtable_flags := $($(build.board).menu.vt.$(VTABLES).build.vtable_flags)
build.ssl_flags := $($(build.board).menu.ssl.$(SSL).build.ssl_flags)
build.exception_flags := $($(build.board).menu.exception.$(EXCEPTIONS).build.exception_flags)
build.stdcpp_lib := $($(build.board).menu.exception.$(EXCEPTIONS).build.stdcpp_lib)

OBJCOPY_HEX_PATTERN ?= $(recipe.objcopy.hex.1.pattern)

-include common.mk

define upload-sketch
upload: cmd = $$(tools.$(UPLOAD_TOOL).cmd)
upload: $(SKETCH_BIN)
	$$(tools.$(UPLOAD_TOOL).upload.pattern)
endef

$(eval $(call upload-sketch))
