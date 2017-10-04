CPUFLAGS = -mmcu=$(BUILD_MCU)
CFLAGS += -Os -Wall -ffunction-sections -fdata-sections $(CPUFLAGS)
CXXFLAGS += $(CFLAGS)
LDFLAGS = -Os -Wl,--gc-sections -u main $(CPUFLAGS)
LD = $(COMPILER_FAMILY)-gcc
OBJCOPY_FLAGS = -O ihex -R eeprom
UPLOAD_TOOL = mspdebug
UPLOAD_FLAGS = $(UPLOAD_PROTOCOL) --force-reset "prog $(SKETCH_BIN)"
COMPILER_FAMILY := msp430
CORE := $(HARDWARE_FAMILY)/cores/msp430
