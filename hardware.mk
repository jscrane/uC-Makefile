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
TOOLS_DIR ?= $(PACKAGE_DIR)/tools

runtime.hardware.path := $(PACKAGE_DIR)/hardware
runtime.platform.path := $(wildcard $(runtime.hardware.path)/$(PROCESSOR_FAMILY)/*)
runtime.ide.path := /usr/local/arduino
runtime.ide.version := 10815
ide_version := $(runtime.ide.version)
runtime.os := linux
software := ARDUINO
name := $(VENDOR)
_id := $(BOARD)

define os-override
$(if $($1.$(runtime.os)),$($1.$(runtime.os)),$($1))
endef

define define-tool
runtime.tools.$1.cmd := $1
tools.$1.path := $2
runtime.tools.$1.path := $2
runtime.tools.$1-$(notdir $2).path := $2
endef

$(foreach t,$(wildcard $(TOOLS_DIR)/*), $(eval $(call define-tool,$(notdir $t),$(lastword $(wildcard $t/*)))))

-include boards.txt.mk
-include boards.local.txt.mk
-include platform.txt.mk
-include platform.local.txt.mk
-include programmers.txt.mk

define define-variable
$(1:%.$(runtime.os)=%) = $(value $2)
endef

define define-prefix-variables
$(foreach v,$(filter $1.%, $(.VARIABLES)), $(eval $(call define-variable,$(v:$1.%=%),$(v))))
endef

define define-menu-variables
$(call define-prefix-variables,$(BOARD).menu.$1.$($(shell echo $1 | tr a-z A-Z)))
endef

define define-menus
$(foreach m, $1, $(call define-menu-variables,$m))
endef

define define-scoped-variable
$3: $(call define-variable,$1,$2)
endef

define define-scoped-prefix-variables
$(foreach v,$(filter $1.%, $(.VARIABLES)), $(eval $(call define-scoped-variable,$(v:$1.%=%),$(v),$2)))
endef

$(call define-prefix-variables,$(BOARD))

$(call define-menus,$(foreach m,$(filter menu.%,$(.VARIABLES)),$(m:menu.%=%)))

SKETCH ?= $(firstword $(wildcard *.ino))
COMPILER_WARNINGS ?= default

build.project_name := $(SKETCH)
build.arch := $(PROCESSOR_FAMILY)
build.fqbn := $(VENDOR):$(PROCESSOR_FAMILY):$(BOARD)
build.core.path = $(runtime.platform.path)/cores/$(build.core)
build.variant.path = $(runtime.platform.path)/variants/$(build.variant)
build.system.path = $(runtime.platform.path)/system
build.path := .build
build.source.path ?= .
archive_file := libcore.a
archive_file_path := $(build.path)/$(archive_file)
compiler.warning_flags := $(compiler.warning_flags.$(COMPILER_WARNINGS))
