# device ids for avr include files: add more as needed
P_atmega328p := __AVR_ATmega328P__
P_atmega168 := __AVR_ATmega168__
P_atmega2560 := __AVR_ATmega2560__
P_atmega1280 := __AVR_ATmega1280__
P_atmega32u4 := __AVR_ATmega32U4__
P_atmega8 := __AVR_ATmega8__
P_attiny84 := __AVR_ATtiny84__
P_attiny85 := __AVR_ATtiny85__

# avrdude part ids: add more here as needed
U_atmega328p := m328p
U_atmega168 := m168
U_atmega2560 := m2560
U_atmega1280 := m1281
U_atmega32u4 := m32u4
U_atmega8 := m8
U_attiny84 := t84
U_attiny85 := t85

CPPFLAGS += -D${P_${BUILD_MCU}}
CPUFLAGS += -mmcu=$(BUILD_MCU)
CFLAGS += -Os -w -ffunction-sections -fdata-sections $(CPUFLAGS)
CXXFLAGS += -fno-exceptions $(CFLAGS)
LDFLAGS = -Os -Wl,--gc-sections $(CPUFLAGS)
LD = $(COMPILER_FAMILY)-gcc
OBJCOPY_FLAGS = -O ihex -R .eeprom
SKETCH_EEP := $(SKETCH:.ino=.eep)

UPLOAD_TOOL ?= $(shell sed -ne "s/$(BOARD).upload.tool=\(.*\)/\1/p" $(BOARDS))
UPLOAD_SPEED ?= $(shell sed -ne "s/$(BP).upload.speed=\(.*\)/\1/p" $(BOARDS)) 

ifeq ("$(UPLOAD_TOOL)", "avrdude")
UPLOAD_FLAGS := -C $(TOOLS)/etc/avrdude.conf -b $(UPLOAD_SPEED) -c $(UPLOAD_PROTOCOL) -P $(UPLOAD_PORT) -p ${U_${BUILD_MCU}} -D -Uflash:w:$(SKETCH_BIN):i
endif

ifeq ("$(UPLOAD_TOOL)", "tsb")
PATH := $(HARDWARE_FAMILY)/tools:$(PATH)
UPLOAD_FLAGS := $(UPLOAD_PORT):$(UPLOAD_SPEED) fw $(SKETCH_BIN)
endif

EXTRA_TARGETS := $(SKETCH_EEP)
