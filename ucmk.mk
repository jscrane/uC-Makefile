BUILD_DIR := .lib
HARDWARE_FAMILY ?= $(IDE_HOME)/hardware/$(PLATFORM)/$(PROCESSOR_FAMILY)
BOARDS := $(HARDWARE_FAMILY)/boards.txt
BOARD ?= $(shell sed -ne "s/\(.*\).name=$(BOARD_NAME)/\1/p" $(BOARDS))
BP := $(if $(BOARD_CPU),$(BOARD).menu.cpu.$(BOARD_CPU),$(BOARD))
BUILD_MCU ?= $(shell sed -ne "s/$(BP).build.mcu=\(.*\)/\1/p" $(BOARDS))

SKETCH ?= $(wildcard *.ino)
SOURCES += $(wildcard *.cpp) $(wildcard *.c) $(wildcard $(BUILD_MCU)/*.cpp) $(wildcard $(BUILD_MCU)/*.c)
OBJECTS := $(SKETCH:.ino=.cpp.o) $(foreach s, $(SOURCES), $s.o)
DEPS := $(OBJECTS:.o=.d)
SKETCH_ELF := $(SKETCH).elf
SKETCH_BIN := $(SKETCH).bin

BUILD_FCPU ?= $(shell sed -ne "s/$(BP).build.f_cpu=\(.*\)/\1/p" $(BOARDS))
BUILD_VARIANT ?= $(shell sed -ne "s/$(BOARD).build.variant=\(.*\)/\1/p" $(BOARDS))
UPLOAD_PROTOCOL ?= $(shell sed -ne "s/$(BOARD).upload.protocol=\(.*\)/\1/p" $(BOARDS))
TERM_SPEED ?= $(UPLOAD_SPEED)

LIBRARIES ?= $(SKETCHBOOK)/libraries $(HARDWARE_FAMILY)/libraries $(IDE_HOME)/libraries
REQUIRED_LIBS := $(sort $(shell sed -ne "s/^ *\# *include *[<\"]\(.*\)\.h[>\"]/\1/p" $(SKETCH)))
REQUIRED_ROOTS := $(foreach r, $(REQUIRED_LIBS), $(firstword $(foreach d, $(LIBRARIES), $(wildcard $d/$r))))
LIBSUBDIRS := . src src/detail utility $(BUILD_MCU)
LIBDIRS := $(foreach r, $(REQUIRED_ROOTS), $(foreach s, $(LIBSUBDIRS), $(wildcard $r/$s)))
LIBRARY_SOURCES = $(foreach d, $(LIBDIRS), $(wildcard $d/*.c) $(wildcard $d/*.cpp))

include $(PROCESSOR_FAMILY).mk

COMPILER_FAMILY ?= $(PROCESSOR_FAMILY)
TOOLS ?= $(IDE_HOME)/hardware/tools/$(COMPILER_FAMILY)
export PATH := $(TOOLS)/bin:$(PATH)

CORE ?= $(HARDWARE_FAMILY)/cores/$(PLATFORM)
CORE_LIB := $(BUILD_DIR)/libcore.a
CORE_SOURCES := $(wildcard $(addprefix $(CORE)/, *.c *.cpp *.S) $(addprefix $(CORE)/*/, *.c))
CORE_OBJECTS := $(foreach b, $(LIBRARY_SOURCES) $(CORE_SOURCES), $(BUILD_DIR)/$b.o)

CPPFLAGS += $(LOCAL_CPPFLAGS) -DF_CPU=$(BUILD_FCPU) -I$(CORE) -I$(CORE)/driverlib -I$(HARDWARE_FAMILY)/variants/$(BUILD_VARIANT) -I.
CPPFLAGS += $(foreach d, $(LIBDIRS), -I$d)
LDLIBS ?= -L$(BUILD_DIR) -lcore -lm -lc -lgcc

CC := $(COMPILER_FAMILY)-gcc
CXX := $(COMPILER_FAMILY)-g++
RANLIB := $(COMPILER_FAMILY)-ranlib
AR := $(COMPILER_FAMILY)-ar
NM := $(COMPILER_FAMILY)-nm
OBJCOPY := $(COMPILER_FAMILY)-objcopy
SIZE := $(COMPILER_FAMILY)-size
AS := $(COMPILER_FAMILY)-as
LDPOST ?= $(OBJCOPY)
LDPOST_FLAGS ?= $(OBJCOPY_FLAGS) $< $@

TARGETS := $(SKETCH_ELF) $(SKETCH_BIN) $(EXTRA_TARGETS)

.PHONY: all upload clean size nm term

all: $(TARGETS)

$(SKETCH_BIN): $(SKETCH_ELF)
	$(LDPOST) $(LDPOST_FLAGS)

$(SKETCH_ELF): $(OBJECTS) $(CORE_LIB)
	$(LD) -o $@ $(LDFLAGS) $(OBJECTS) $(LDLIBS)

$(CORE_LIB): $(CORE_OBJECTS)
	$(AR) rcs $@ $?
	$(RANLIB) $@

$(BUILD_DIR)/%.S.o: %.S
	mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -o $@ $<

$(BUILD_DIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.cpp.o: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

%.cpp.o: %.ino
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -x c++ -include $(CORE)/$(PLATFORM_HEADER) -c -o $@ $<

%.cpp.o: %.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

%.c.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

size: $(SKETCH_ELF)
	$(SIZE) $(SIZE_FLAGS) $<

upload: $(SKETCH_BIN) $(SKETCH_EEP)
	$(UPLOAD_TOOL) $(UPLOAD_FLAGS)

nm: $(SKETCH_ELF)
	$(NM) -n $<

term:
	minicom -D $(UPLOAD_PORT) -b $(TERM_SPEED)

clean:
	rm -fr $(BUILD_DIR) $(DEPS) $(OBJECTS) $(TARGETS)

-include $(DEPS)
