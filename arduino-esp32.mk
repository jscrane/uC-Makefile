IDE_HOME ?= /usr/local/arduino
SKETCHBOOK ?= $(HOME)/sketchbook
UPLOAD_PORT ?= /dev/ttyUSB0
PROCESSOR_FAMILY := esp32
PLATFORM := espressif
PLATFORM_HEADER := Arduino.h
HARDWARE_FAMILY := $(SKETCHBOOK)/hardware/$(PLATFORM)/$(PROCESSOR_FAMILY)
CORE := $(HARDWARE_FAMILY)/cores/$(PROCESSOR_FAMILY)
CPPFLAGS += -DARDUINO=10804

include ucmk.mk
include targets-esp32.mk
