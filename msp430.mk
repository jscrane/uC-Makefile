CPUFLAGS = -mmcu=msp430g2553
CFLAGS = -Os -Wall -ffunction-sections -fdata-sections $(CPUFLAGS)
CXXFLAGS = $(CFLAGS)
LDFLAGS = -Os -Wl,--gc-sections -u main $(CPUFLAGS)
LD = $(COMPILER_FAMILY)-gcc
OBJCOPYFLAGS = -O ihex -R eeprom
UPLOADER = mspdebug
COMPILER_FAMILY := msp430
