# device ids for avr include files: add more as needed
P_attiny84 = __AVR_ATtiny84__

# avrdude part ids: add more here as needed
U_attiny84 = t84

COMPILER_FAMILY := avr
CPPFLAGS += -D${P_${BUILD_MCU}}
CPUFLAGS = -mmcu=$(BUILD_MCU)
CFLAGS = -Os -Wall -ffunction-sections -fdata-sections $(CPUFLAGS)
CXXFLAGS = -fno-exceptions $(CFLAGS)
LDFLAGS = -Os -Wl,--gc-sections $(CPUFLAGS)
LD = $(COMPILER_FAMILY)-gcc
OBJCOPY_FLAGS = -O ihex -R .eeprom

UPLOAD_FLAGS = $(UPLOAD_PORT):$(UPLOAD_SPEED) fw $(SKETCH_BIN)

PATH := $(HARDWARE_FAMILY)/tools:$(PATH)
