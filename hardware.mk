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
