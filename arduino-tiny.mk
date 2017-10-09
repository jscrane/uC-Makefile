IDE_HOME ?= /usr/local/arduino
SKETCHBOOK ?= $(HOME)/sketchbook
UPLOAD_PORT ?= /dev/ttyUSB0
PROCESSOR_FAMILY := avr
PLATFORM := arduino
PLATFORM_HEADER := Arduino.h
CPPFLAGS += -DARDUINO=10804
HARDWARE_FAMILY := $(SKETCHBOOK)/hardware/attiny/avr
CORE := $(IDE_HOME)/hardware/arduino/avr/cores/arduino

LIBRARIES := $(SKETCHBOOK)/libraries $(IDE_HOME)/hardware/arduino/avr/libraries $(IDE_HOME)/libraries

EXTRA_TARGETS := eep size
include ucmk.mk
include targets-avr.mk
