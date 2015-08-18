IDE_HOME ?= /usr/local/arduino
SKETCHBOOK ?= $(HOME)/sketchbook
UPLOAD_PORT ?= /dev/ttyUSB0
PROCESSOR_FAMILY := avr
PLATFORM := attiny
HARDWARE_FAMILY := $(SKETCHBOOK)/hardware/attiny/avr
CORE := $(IDE_HOME)/hardware/arduino/avr/cores/arduino

LIBRARIES := $(SKETCHBOOK)/libraries $(IDE_HOME)/hardware/arduino/avr/libraries $(IDE_HOME)/libraries
PLATFORM_HEADER := Arduino.h
CPPFLAGS := -DARDUINO=154 

SKETCH_EEP = $(SKETCH:.ino=.eep)
EXTRA_TARGETS = $(SKETCH_EEP) size

include ucmk.mk

$(SKETCH_EEP): $(SKETCH_ELF)
	$(OBJCOPY) -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 $< $@
