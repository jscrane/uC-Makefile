IDE_HOME ?= /usr/local/energia
SKETCHBOOK ?= $(HOME)/energia
PLATFORM_HEADER := Energia.h
CPPFLAGS := -DENERGIA=13 -DARDUINO=101 

include ucmk.mk
