# default options (settable by user)
IDE_HOME ?= /usr/local/energia
SKETCHBOOK ?= $(HOME)/energia

PLATFORM := energia
PROCESSOR_FAMILY := tivac
PACKAGE_DIR := $(HOME)/.energia15/packages/$(PLATFORM)
PACKAGE_VERSION := 1.0.3
COMPILER_FAMILY := arm-none-eabi-gcc
COMPILER_VERSION := 6.3.1-20170620
PLATFORM_H = Energia.h

runtime.ide.version := 10809
runtime.platform.path := $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/$(PACKAGE_VERSION)
runtime.tools.$(COMPILER_FAMILY)-$(COMPILER_VERSION).path := $(PACKAGE_DIR)/tools/$(COMPILER_FAMILY)/$(COMPILER_VERSION)
runtime.tools.mspdebug.path := $(PACKAGE_DIR)/tools/mspdebug/0.24
runtime.tools.dslite-7.2.0.2096.path := $(PACKAGE_DIR)/tools/dslite/7.2.0.2096

-include $(runtime.platform.path)/boards.txt
-include platform.mk

build.board := $(BOARD)
build.mcu := $($(build.board).build.mcu)
build.arch := $(PROCESSOR_FAMILY)
build.f_cpu := $($(build.board).build.f_cpu)
build.system.path := $(runtime.platform.path)/system
build.ldscript := $($(build.board).build.ldscript)
build.variant := $($(build.board).build.variant)
build.variant.path := $(runtime.platform.path)/variants/$(build.variant)
CORE := $(runtime.platform.path)/cores/$(PROCESSOR_FAMILY)
includes := -I$(CORE) -I$(build.variant.path) -I$(runtime.platform.path)/system
UPLOAD_TOOL := $($(build.board).upload.tool)
upload.protocol := $($(build.board).upload.protocol)

-include common.mk

define upload-sketch
upload: path = $$(runtime.tools.dslite-7.2.0.2096.path)
upload: config.path = $$(path)
upload: cmd.path = $$(tools.$(UPLOAD_TOOL).cmd.path)
upload: $(SKETCH_BIN)
	$$(subst ',, $$(tools.$(UPLOAD_TOOL).upload.pattern))
endef

$(eval $(call upload-sketch))
