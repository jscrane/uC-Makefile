IDE_HOME ?= /usr/local/arduino
SKETCHBOOK ?= $(HOME)/sketchbook
UPLOAD_PORT ?= /dev/ttyUSB0
PROCESSOR_FAMILY ?= avr
PLATFORM := arduino
PLATFORM_HEADER := Arduino.h
CPPFLAGS += -DARDUINO=10804
LIBRARIES := $(SKETCHBOOK)/libraries $(HARDWARE_FAMILY)/libraries $(IDE_HOME)/libraries

EXTRA_TARGETS := eep size
include ucmk.mk
include targets-avr.mk
