IDE_HOME ?= /usr/local/arduino
SKETCHBOOK ?= $(HOME)/sketchbook
UPLOAD_PORT ?= /dev/ttyUSB0
PROCESSOR_FAMILY := esp8266
PLATFORM := esp8266com
PLATFORM_HEADER := Arduino.h
HARDWARE_FAMILY := $(SKETCHBOOK)/hardware/$(PLATFORM)/$(PROCESSOR_FAMILY)
CORE := $(HARDWARE_FAMILY)/cores/$(PROCESSOR_FAMILY)
CPPFLAGS += -DARDUINO=10804
LDPOST := esptool
LDPOST_FLAGS = -eo $(HARDWARE_FAMILY)/bootloaders/eboot/eboot.elf -bo $@ -bm dio -bf 40 -bz 4M -bs .text -bp 4096 -ec -eo $<  -bs .irom0.text -bs .text -bs .data -bs .rodata -bc -ec
UPLOAD_TOOL = $(shell sed -ne "s/$(BOARD).upload.tool=\(.*\)/\1/p" $(BOARDS))
UPLOAD_RESET = $(shell sed -ne "s/$(BOARD).upload.resetmethod=\(.*\)/\1/p" $(BOARDS))
UPLOAD_FLAGS = -cd $(UPLOAD_RESET) -cb $(UPLOAD_SPEED) -cp $(UPLOAD_PORT) -ca 0x00000 -cf $<

include ucmk.mk
