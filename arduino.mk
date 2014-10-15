COMPILER_FAMILY := avr
CPUFLAGS = -mmcu=$(BUILD_MCU)
CFLAGS = -Os -Wall -ffunction-sections $(CPUFLAGS)
CXXFLAGS = -fno-exceptions $(CFLAGS)
LDFLAGS = -Os -Wl,--gc-sections $(CPUFLAGS)
LD = $(COMPILER_FAMILY)-gcc
OBJCOPY_FLAGS = -O ihex -R .eeprom
UPLOADER = avrdude
UPLOAD_SPEED = $(shell sed -ne "s/$(BOARD).upload.speed=\(.*\)/\1/p" $(BOARDS)) 
UPLOAD_FLAGS = -b $(UPLOAD_SPEED) -c $(UPLOAD_PROTOCOL) -P $(UPLOAD_PORT)
