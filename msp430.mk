SERIAL_PORT ?= /dev/ttyACM0

VENDOR := energia
PROCESSOR_FAMILY := msp430

-include hardware.mk
-include build-targets.mk

upload: path = $(tools.$(upload.tool).path)
upload: cmd.path = $(tools.$(upload.tool).cmd.path)
upload: prebuild $(SKETCH_BIN)
	$(subst ',, $(tools.$(upload.tool).upload.pattern))
