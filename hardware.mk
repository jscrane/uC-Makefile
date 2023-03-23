ifndef PROCESSOR_FAMILY
$(error PROCESSOR_FAMILY
endif
ifndef VENDOR
$(error VENDOR required)
endif
ifndef BOARD
$(error BOARD required)
endif

PACKAGE_DIR := $(HOME)/.arduino15/packages/$(VENDOR)

runtime.ide.path := /usr/local/arduino
runtime.ide.version := 10815
runtime.platform.path := $(wildcard $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/*)

define define-tool
runtime.tools.$1.path := $2
runtime.tools.$1-$(notdir $2).path := $2
endef

$(foreach t,$(wildcard $(PACKAGE_DIR)/tools/*), $(eval $(call define-tool,$(notdir $t),$(lastword $(wildcard $t/*)))))

-include boards.txt.mk
-include boards.local.txt.mk
-include platform.txt.mk
-include platform.local.txt.mk
-include programmers.txt.mk

build.board := $(BOARD)
build.arch := $(PROCESSOR_FAMILY)
build.mcu := $($(build.board).build.mcu)
build.f_cpu := $($(build.board).build.f_cpu)
build.core := $($(build.board).build.core)
build.variant := $($(build.board).build.variant)
build.variant.path := $(runtime.platform.path)/variants/$(build.variant)
build.system.path := $(runtime.platform.path)/system

upload.maximum_size := $($(build.board).upload.maximum_size)
upload.maximum_data_size := $($(build.board).upload.maximum_data_size)
