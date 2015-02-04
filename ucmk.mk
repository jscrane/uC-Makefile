export PATH := $(IDE_HOME)/hardware/tools/$(PROCESSOR_FAMILY)/bin:$(PATH)

BOARDS = $(HARDWARE_FAMILY)/boards.txt
BUILD_MCU = $(shell sed -ne "s/$(BOARD).build.mcu=\(.*\)/\1/p" $(BOARDS))

SKETCH ?= $(wildcard *.ino)
SOURCES += $(wildcard *.cpp) $(wildcard *.c) $(wildcard $(BUILD_MCU)/*.cpp) $(wildcard $(BUILD_MCU)/*.c)
OBJECTS = $(SKETCH:.ino=.o) $(SOURCES:.cpp=.o)
DEPS = $(foreach d, $(SKETCH) $(SOURCES), .deps/$d.d)
HARDWARE_FAMILY ?= $(IDE_HOME)/hardware/$(PLATFORM)
CORE ?= $(HARDWARE_FAMILY)/cores/$(PLATFORM)
SKETCH_ELF = $(SKETCH:.ino=.elf)
SKETCH_BIN = $(SKETCH:.ino=.bin)

BUILD_FCPU = $(shell sed -ne "s/$(BOARD).build.f_cpu=\(.*\)/\1/p" $(BOARDS))
BUILD_VARIANT = $(shell sed -ne "s/$(BOARD).build.variant=\(.*\)/\1/p" $(BOARDS))
UPLOAD_PROTOCOL = $(shell sed -ne "s/$(BOARD).upload.protocol=\(.*\)/\1/p" $(BOARDS))

REQUIRED_LIBS = $(sort $(shell sed -ne "s/^ *\# *include *[<\"]\(.*\)\.h[>\"]/\1/p" $(SKETCH)))
SKETCHBOOK_LIBS = $(filter $(notdir $(wildcard $(SKETCHBOOK)/libraries/*)), $(REQUIRED_LIBS))
SKETCHBOOK_LIBRARIES = $(foreach lib, $(SKETCHBOOK_LIBS), $(SKETCHBOOK)/libraries/$(lib) $(SKETCHBOOK)/libraries/$(lib)/utility) 
IDE_LIBS = $(filter $(notdir $(wildcard $(HARDWARE_FAMILY)/libraries/*)), $(REQUIRED_LIBS))
IDE_LIBRARIES = $(foreach lib, $(IDE_LIBS), $(HARDWARE_FAMILY)/libraries/$(lib) $(HARDWARE_FAMILY)/libraries/$(lib)/utility)
LIBRARY_SOURCES = $(foreach lib, $(SKETCHBOOK_LIBRARIES) $(IDE_LIBRARIES), $(wildcard $(lib)/*.c) $(wildcard $(lib)/*.cpp))

CORE_LIB = libcore.a
CORE_SOURCES = $(wildcard $(addprefix $(CORE)/, *.c *.cpp) $(addprefix $(CORE)/driverlib/, *.c))
CORE_OBJECTS = $(foreach b, $(LIBRARY_SOURCES) $(CORE_SOURCES), .lib/$b.o)

TARGETS = $(DEPS) $(SKETCH_ELF) $(SKETCH_BIN) $(EXTRA_TARGETS)

.PHONY: all upload clean size

include $(PLATFORM).mk

all: $(TARGETS)

CPPFLAGS += $(LOCAL_CPPFLAGS) -DF_CPU=$(BUILD_FCPU) -I$(CORE) -I$(CORE)/driverlib -I$(HARDWARE_FAMILY)/variants/$(BUILD_VARIANT) -I.
CPPFLAGS += $(foreach lib, $(SKETCHBOOK_LIBRARIES), -I$(lib)) $(foreach lib, $(IDE_LIBRARIES), -I$(lib)) 
DEPFLAGS = -MM -MP -MF 

CC = $(COMPILER_FAMILY)-gcc
CXX = $(COMPILER_FAMILY)-g++
RANLIB = $(COMPILER_FAMILY)-ranlib
AR = $(COMPILER_FAMILY)-ar
OBJCOPY = $(COMPILER_FAMILY)-objcopy
SIZE = $(COMPILER_FAMILY)-size
LDLIBS = -L. -lcore -lm -lc -lgcc

$(SKETCH_BIN): $(SKETCH_ELF)
	$(OBJCOPY) $(OBJCOPY_FLAGS) $< $@

$(SKETCH_ELF): $(OBJECTS) $(CORE_LIB)
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS) $(LDLIBS)

$(CORE_LIB): $(CORE_OBJECTS)
	$(AR) rcs $@ $?
	$(RANLIB) $@

.deps/%.cpp.d: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(DEPFLAGS) $@ $<

.deps/%.ino.d: %.ino
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) -x c++ -include $(CORE)/$(PLATFORM_HEADER) $(DEPFLAGS) $@ $<

.lib/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

.lib/%.cpp.o: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

%.o: %.ino
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -x c++ -include $(CORE)/$(PLATFORM_HEADER) -c -o $@ $<

size: $(SKETCH_BIN)
	$(SIZE) $<

upload: $(SKETCH_BIN)
	$(UPLOAD_TOOL) $(UPLOAD_FLAGS)

clean:
	rm -fr .lib .deps $(OBJECTS) $(CORE_LIB) $(TARGETS)

include $(DEPS)
