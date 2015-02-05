IDE_HOME ?= /usr/local/arduino
SKETCHBOOK ?= $(HOME)/sketchbook
UPLOAD_PORT ?= /dev/ttyUSB0
PLATFORM ?= arduino

PLATFORM_HEADER := Arduino.h
CPPFLAGS := -DARDUINO=106 

SKETCH_EEP = $(SKETCH:.ino=.eep)
EXTRA_TARGETS = $(SKETCH_EEP)

include ucmk.mk

$(SKETCH_EEP): $(SKETCH_ELF)
	$(OBJCOPY) -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 $< $@
