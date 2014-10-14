CPUFLAGS = -mmcu=msp430g2553
CFLAGS = -Os -Wall -ffunction-sections -fdata-sections $(CPUFLAGS)
CXXFLAGS = $(CFLAGS)
LDFLAGS = -Os -Wl,--gc-sections -u main $(CPUFLAGS)
LD = $(COMPILER_FAMILY)-gcc
OBJCOPY_FLAGS = -O ihex -R eeprom
UPLOADER = mspdebug
UPLOAD_FLAGS = rf2500 --force-reset prog
COMPILER_FAMILY := msp430
