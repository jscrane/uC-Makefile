IDE_HOME ?= /usr/local/energia
SKETCHBOOK ?= $(HOME)/energia
PLATFORM := energia
PLATFORM_HEADER := Energia.h
CPPFLAGS += -DENERGIA=13 -DARDUINO=105
LIBRARIES := $(SKETCHBOOK)/libraries $(HARDWARE_FAMILY)/libraries

include ucmk.mk
