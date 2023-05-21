SERIAL_PORT ?= /dev/ttyACM0

VENDOR := energia
PROCESSOR_FAMILY := msp430

-include hardware.mk
-include build-targets.mk
