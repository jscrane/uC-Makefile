SERIAL_PORT ?= /dev/ttyACM0

VENDOR := energia
PROCESSOR_FAMILY := msp430

-include hardware.mk

upload.protocol := $($(build.board).upload.protocol)

-include build-targets.mk

upload: path = $(runtime.tools.$(upload.tool).path)
upload: cmd.path = $(tools.$(upload.tool).cmd.path)
upload: $(SKETCH_BIN)
	$(subst ',, $(tools.$(upload.tool).upload.pattern))
