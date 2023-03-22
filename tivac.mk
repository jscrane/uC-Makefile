SERIAL_PORT ?= /dev/ttyACM0

VENDOR := energia
PROCESSOR_FAMILY := tivac
PACKAGE_DIR := $(HOME)/.arduino15/packages/$(VENDOR)

-include hardware.mk

build.board := $(BOARD)
build.core := $($(build.board).build.core)
build.mcu := $($(build.board).build.mcu)
build.arch := $(PROCESSOR_FAMILY)
build.f_cpu := $($(build.board).build.f_cpu)
build.system.path := $(runtime.platform.path)/system
build.ldscript := $($(build.board).build.ldscript)
build.variant := $($(build.board).build.variant)
build.variant.path := $(runtime.platform.path)/variants/$(build.variant)
build.system.path := $(runtime.platform.path)/system
upload.tool := $($(build.board).upload.tool)

-include build-targets.mk

upload: path = $(runtime.tools.$(upload.tool).path)
upload: config.path = $(path)
upload: cmd.path = $(tools.$(upload.tool).cmd.path)
upload: $(SKETCH_BIN)
	$(subst ',, $(tools.$(upload.tool).upload.pattern))
