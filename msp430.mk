SERIAL_PORT ?= /dev/ttyACM0

VENDOR := energia
PROCESSOR_FAMILY := msp430
PACKAGE_DIR := $(HOME)/.arduino15/packages/$(VENDOR)

-include hardware.mk

build.board := $(BOARD)
build.core := $($(build.board).build.core)
build.variant := $($(build.board).build.variant)
build.mcu := $($(build.board).build.mcu)
build.arch := $(PROCESSOR_FAMILY)
build.f_cpu := $($(build.board).build.f_cpu)
upload.tool := $($(build.board).upload.tool)
upload.protocol := $($(build.board).upload.protocol)

-include build-targets.mk

upload: path = $(runtime.tools.$(upload.tool).path)
upload: cmd.path = $(tools.$(upload.tool).cmd.path)
upload: $(SKETCH_BIN)
	$(subst ',, $(tools.$(upload.tool).upload.pattern))
