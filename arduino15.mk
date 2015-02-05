IDE_HOME ?= /usr/local/arduino-1.5
SKETCHBOOK ?= $(HOME)/sketchbook
UPLOAD_PORT ?= /dev/ttyUSB0
PROCESSOR_FAMILY ?= avr
PLATFORM ?= arduino
HARDWARE_FAMILY ?= $(IDE_HOME)/hardware/$(PLATFORM)/$(PROCESSOR_FAMILY)

IDE_LIBRARIES := $(IDE_HOME)/libraries
PLATFORM_HEADER := Arduino.h
CPPFLAGS := -DARDUINO=154 

SKETCH_EEP = $(SKETCH:.ino=.eep)
EXTRA_TARGETS = $(SKETCH_EEP)

include ucmk.mk

$(SKETCH_EEP): $(SKETCH_ELF)
	$(OBJCOPY) -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 $< $@
