ifndef PROCESSOR_FAMILY
$(error PROCESSOR_FAMILY required)
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

define define-variable
$1 = $2
endef

define define-prefix-variables
$(foreach v, $(filter $1.%, $(.VARIABLES)), $(eval $(call define-variable,$(v:$1.%=%), $($(v)))))
endef

define define-menu-variables
$(call define-prefix-variables,menu.$1.$($(shell echo $1 | tr a-z A-Z)))
endef

$(eval $(call define-prefix-variables,$(BOARD)))

build.arch := $(PROCESSOR_FAMILY)
build.variant.path := $(runtime.platform.path)/variants/$(build.variant)
build.system.path := $(runtime.platform.path)/system
