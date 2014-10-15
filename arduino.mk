COMPILER_FAMILY := avr
CPUFLAGS = -mmcu=$(BUILD_MCU)
CFLAGS = -Os -Wall -ffunction-sections $(CPUFLAGS)
CXXFLAGS = -fno-exceptions $(CFLAGS)
LDFLAGS = -Os -Wl,--gc-sections $(CPUFLAGS)
LD = $(COMPILER_FAMILY)-gcc
OBJCOPY_FLAGS = -O ihex -R .eeprom

# add more here as needed
U_atmega328p = m328p
U_atmega168 = m168
U_atmega2560 = m2560
U_atmega1280 = m1281
U_atmega32u4 = m32u4
U_atmega8 = m8

UPLOADER = avrdude
UPLOAD_SPEED = $(shell sed -ne "s/$(BOARD).upload.speed=\(.*\)/\1/p" $(BOARDS)) 
UPLOAD_FLAGS = -b $(UPLOAD_SPEED) -c $(UPLOAD_PROTOCOL) -P $(UPLOAD_PORT) -p ${U_${BUILD_MCU}} -D -Uflash:w:$(SKETCH_BIN):i
