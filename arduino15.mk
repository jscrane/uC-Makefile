IDE_HOME ?= /usr/local/arduino
SKETCHBOOK ?= $(HOME)/sketchbook
UPLOAD_PORT ?= /dev/ttyUSB0
PROCESSOR_FAMILY ?= avr
CPPFLAGS += -DARDUINO=105
PLATFORM := arduino
HARDWARE_FAMILY ?= $(IDE_HOME)/hardware/$(PLATFORM)/$(PROCESSOR_FAMILY)

LIBRARIES := $(SKETCHBOOK)/libraries $(HARDWARE_FAMILY)/libraries $(IDE_HOME)/libraries
PLATFORM_HEADER := Arduino.h

EXTRA_TARGETS := eep size
include ucmk.mk
include targets-avr.mk
