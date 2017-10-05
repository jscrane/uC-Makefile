IDE_HOME ?= /usr/local/energia
SKETCHBOOK ?= $(HOME)/energia
PLATFORM := energia
PLATFORM_HEADER := Energia.h
CPPFLAGS += -DENERGIA=10610 -DARDUINO=10610
LIBRARIES := $(SKETCHBOOK)/libraries $(HARDWARE_FAMILY)/libraries

include ucmk.mk
