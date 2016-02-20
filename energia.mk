IDE_HOME ?= /usr/local/energia
SKETCHBOOK ?= $(HOME)/energia
PLATFORM := $(PROCESSOR_FAMILY)
PLATFORM_HEADER := Energia.h
CPPFLAGS += -DENERGIA=13 -DARDUINO=105
LIBRARIES := $(SKETCHBOOK)/libraries $(IDE_HOME)/hardware/$(PROCESSOR_FAMILY)/libraries

include ucmk.mk
