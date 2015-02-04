# device ids for avr include files: add more as needed
P_atmega328p = __AVR_ATmega328P__
P_atmega168 = __AVR_ATmega168__
P_atmega2560 = __AVR_ATmega2560__
P_atmega1280 = __AVR_ATmega1280__
P_atmega32u4 = __AVR_ATmega32U4__
P_atmega8 = __AVR_ATmega8__

# avrdude part ids: add more here as needed
U_atmega328p = m328p
U_atmega168 = m168
U_atmega2560 = m2560
U_atmega1280 = m1281
U_atmega32u4 = m32u4
U_atmega8 = m8

COMPILER_FAMILY := avr
CPPFLAGS = -D${P_${BUILD_MCU}}
CPUFLAGS = -mmcu=$(BUILD_MCU)
CFLAGS = -Os -Wall -ffunction-sections $(CPUFLAGS)
CXXFLAGS = -fno-exceptions $(CFLAGS)
LDFLAGS = -Os -Wl,--gc-sections $(CPUFLAGS)
LD = $(COMPILER_FAMILY)-gcc
OBJCOPY_FLAGS = -O ihex -R .eeprom

UPLOAD_TOOL ?= avrdude
UPLOAD_SPEED = $(shell sed -ne "s/$(BOARD).upload.speed=\(.*\)/\1/p" $(BOARDS)) 

ifneq ("$(wildcard $(TOOLS)/etc/avrdude.conf)","") 
UPLOAD_FLAGS = -C $(TOOLS)/etc/avrdude.conf
endif
UPLOAD_FLAGS += -b $(UPLOAD_SPEED) -c $(UPLOAD_PROTOCOL) -P $(UPLOAD_PORT) -p ${U_${BUILD_MCU}} -D -Uflash:w:$(SKETCH_BIN):i
