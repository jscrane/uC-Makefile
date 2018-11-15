IDE_HOME ?= /usr/local/arduino
SKETCHBOOK ?= $(HOME)/sketchbook
UPLOAD_PORT ?= /dev/ttyUSB0
PROCESSOR_FAMILY := avr
PLATFORM := arduino
PLATFORM_HEADER := Arduino.h
CPPFLAGS += -DARDUINO=10804
HARDWARE_FAMILY := $(SKETCHBOOK)/hardware/attiny/avr
CORE := $(IDE_HOME)/hardware/arduino/avr/cores/arduino

LIBRARY_PATH := $(SKETCHBOOK)/libraries $(HARDWARE_FAMILY)/libraries $(IDE_HOME)/hardware/arduino/avr/libraries $(IDE_HOME)/libraries

include ucmk.mk
include targets-avr.mk
