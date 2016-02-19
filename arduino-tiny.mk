IDE_HOME ?= /usr/local/arduino
SKETCHBOOK ?= $(HOME)/sketchbook
UPLOAD_PORT ?= /dev/ttyUSB0
PROCESSOR_FAMILY := avr
PLATFORM := $(PROCESSOR_FAMILY)
HARDWARE_FAMILY := $(SKETCHBOOK)/hardware/attiny/avr
CORE := $(IDE_HOME)/hardware/arduino/avr/cores/arduino

LIBRARIES := $(SKETCHBOOK)/libraries $(IDE_HOME)/hardware/arduino/avr/libraries $(IDE_HOME)/libraries
PLATFORM_HEADER := Arduino.h

EXTRA_TARGETS := eep size
include ucmk.mk
include targets-avr.mk
