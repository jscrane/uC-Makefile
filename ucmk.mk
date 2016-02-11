HARDWARE_FAMILY ?= $(IDE_HOME)/hardware/$(PLATFORM)
BOARDS = $(HARDWARE_FAMILY)/boards.txt
BUILD_MCU = $(shell sed -ne "s/$(BOARD).build.mcu=\(.*\)/\1/p" $(BOARDS))
TOOLS = $(IDE_HOME)/hardware/tools/$(PROCESSOR_FAMILY)

export PATH := $(TOOLS)/bin:$(PATH)

SKETCH ?= $(wildcard *.ino)
SOURCES += $(wildcard *.cpp) $(wildcard *.c) $(wildcard $(BUILD_MCU)/*.cpp) $(wildcard $(BUILD_MCU)/*.c)
OBJECTS = $(SKETCH:.ino=.o) $(SOURCES:.cpp=.o)
DEPS = $(foreach d, $(SKETCH) $(SOURCES), .deps/$d.d)
CORE ?= $(HARDWARE_FAMILY)/cores/$(PLATFORM)
SKETCH_ELF = $(SKETCH:.ino=.elf)
SKETCH_BIN = $(SKETCH:.ino=.bin)

BUILD_FCPU = $(shell sed -ne "s/$(BOARD).build.f_cpu=\(.*\)/\1/p" $(BOARDS))
BUILD_VARIANT = $(shell sed -ne "s/$(BOARD).build.variant=\(.*\)/\1/p" $(BOARDS))
UPLOAD_PROTOCOL = $(shell sed -ne "s/$(BOARD).upload.protocol=\(.*\)/\1/p" $(BOARDS))

REQUIRED_LIBS = $(sort $(shell sed -ne "s/^ *\# *include *[<\"]\(.*\)\.h[>\"]/\1/p" $(SKETCH)))
LIBDIRS = $(foreach r, $(REQUIRED_LIBS), $(foreach d, $(LIBRARIES), $(wildcard $d/$r) $(wildcard $d/$r/utility) $(wildcard $d/$r/$(BUILD_MCU))))
LIBRARY_SOURCES = $(foreach d, $(LIBDIRS), $(wildcard $d/*.c) $(wildcard $d/*.cpp))

CORE_LIB = libcore.a
CORE_SOURCES = $(wildcard $(addprefix $(CORE)/, *.c *.cpp) $(addprefix $(CORE)/driverlib/, *.c))
CORE_OBJECTS = $(foreach b, $(LIBRARY_SOURCES) $(CORE_SOURCES), .lib/$b.o)

include $(PLATFORM).mk

CPPFLAGS += $(LOCAL_CPPFLAGS) -DF_CPU=$(BUILD_FCPU) -I$(CORE) -I$(CORE)/driverlib -I$(HARDWARE_FAMILY)/variants/$(BUILD_VARIANT) -I.
CPPFLAGS += $(foreach d, $(LIBDIRS), -I$d)
DEPFLAGS = -MM -MP -MF 

CC = $(COMPILER_FAMILY)-gcc
CXX = $(COMPILER_FAMILY)-g++
RANLIB = $(COMPILER_FAMILY)-ranlib
AR = $(COMPILER_FAMILY)-ar
NM = $(COMPILER_FAMILY)-nm
OBJCOPY = $(COMPILER_FAMILY)-objcopy
SIZE = $(COMPILER_FAMILY)-size
LDLIBS = -L. -lcore -lm -lc -lgcc

TARGETS = $(DEPS) $(SKETCH_ELF) $(SKETCH_BIN) $(EXTRA_TARGETS)

.PHONY: all upload clean size nm

all: $(TARGETS)

$(SKETCH_BIN): $(SKETCH_ELF)
	$(OBJCOPY) $(OBJCOPY_FLAGS) $< $@

$(SKETCH_ELF): $(OBJECTS) $(CORE_LIB)
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS) $(LDLIBS)

$(CORE_LIB): $(CORE_OBJECTS)
	$(AR) rcs $@ $?
	$(RANLIB) $@

.deps/%.cpp.d: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPUFLAGS) $(CPPFLAGS) $(DEPFLAGS) $@ $<

.deps/%.ino.d: %.ino
	mkdir -p $(dir $@)
	$(CXX) $(CPUFLAGS) $(CPPFLAGS) -x c++ -include $(CORE)/$(PLATFORM_HEADER) $(DEPFLAGS) $@ $<

.lib/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

.lib/%.cpp.o: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

%.o: %.ino
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -x c++ -include $(CORE)/$(PLATFORM_HEADER) -c -o $@ $<

size: $(SKETCH_ELF)
	$(SIZE) $<

upload: $(SKETCH_BIN)
	$(UPLOAD_TOOL) $(UPLOAD_FLAGS)

nm: $(SKETCH_ELF)
	$(NM) -n $<

clean:
	rm -fr .lib .deps $(OBJECTS) $(CORE_LIB) $(TARGETS)

-include $(DEPS)
