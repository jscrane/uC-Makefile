SERIAL_PORT ?= /dev/ttyACM0

VENDOR := energia
PROCESSOR_FAMILY := tivac

-include hardware.mk
-include build-targets.mk

upload: path = $(runtime.tools.$(upload.tool).path)
upload: config.path = $(path)
upload: cmd.path = $(tools.$(upload.tool).cmd.path)
upload: prebuild $(SKETCH_BIN)
	$(subst ',, $(tools.$(upload.tool).upload.pattern))
