IDE_HOME ?= /usr/local/arduino
SKETCHBOOK ?= $(HOME)/sketchbook
UPLOAD_PORT ?= /dev/ttyUSB0
PLATFORM_HEADER := Arduino.h
CPPFLAGS := -DARDUINO=105 

include ucmk.mk
