# default options (settable by user)
#UPLOAD_PORT ?= /dev/ttyUSB0
#UPLOAD_VERBOSE ?= quiet

IDE_HOME ?= /usr/local/energia
SKETCHBOOK ?= $(HOME)/energia

PLATFORM := energia
PROCESSOR_FAMILY := msp430
PACKAGE_DIR := $(HOME)/.energia15/packages/$(PLATFORM)
PACKAGE_VERSION := 1.0.4
COMPILER_FAMILY := msp430-gcc
COMPILER_VERSION := 4.6.6
PLATFORM_H = Energia.h

runtime.ide.version := 10809
runtime.platform.path := $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/$(PACKAGE_VERSION)
runtime.tools.$(COMPILER_FAMILY)-$(COMPILER_VERSION).path := $(PACKAGE_DIR)/tools/$(COMPILER_FAMILY)/$(COMPILER_VERSION)
runtime.tools.mspdebug.path := $(PACKAGE_DIR)/tools/mspdebug/0.24
runtime.tools.dslite-8.2.0.1400.path := $(PACKAGE_DIR)/tools/8.2.0.1400

-include $(runtime.platform.path)/boards.txt
-include platform.mk

build.board := $(BOARD)
build.mcu := $($(build.board).build.mcu)
build.arch := $(PROCESSOR_FAMILY)
build.f_cpu := $($(build.board).build.f_cpu)
CORE := $(runtime.platform.path)/cores/$(PROCESSOR_FAMILY)
includes := -I$(CORE) -I$(runtime.platform.path)/variants/$($(build.board).build.variant)
UPLOAD_TOOL := $($(build.board).upload.tool)
upload.protocol := $($(build.board).upload.protocol)

-include common.mk

define upload-sketch
upload: path = $$(runtime.tools.$(UPLOAD_TOOL).path)
upload: cmd.path = $$(tools.$(UPLOAD_TOOL).cmd.path)
upload: $(SKETCH_BIN)
	$$(subst ',, $$(tools.$(UPLOAD_TOOL).upload.pattern))
endef

$(eval $(call upload-sketch))
