IDE_HOME ?= /usr/local/arduino
SKETCHBOOK ?= $(HOME)/sketchbook
UPLOAD_PORT ?= /dev/ttyUSB0
PROCESSOR_FAMILY := esp8266
PLATFORM := esp8266com
PLATFORM_HEADER := Arduino.h
HARDWARE_FAMILY := $(SKETCHBOOK)/hardware/$(PLATFORM)/$(PROCESSOR_FAMILY)
CORE := $(HARDWARE_FAMILY)/cores/$(PROCESSOR_FAMILY)
CPPFLAGS += -DARDUINO=10804
PATH := $(PATH):$(HARDWARE_FAMILY)/tools/esptool

include ucmk.mk
include targets-esp.mk
