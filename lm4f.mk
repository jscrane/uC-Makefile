CPUFLAGS = -mthumb -mcpu=$(BUILD_MCU) -mfloat-abi=hard -mfpu=fpv4-sp-d16 -fsingle-precision-constant
CFLAGS += -O3 -Wall -ffunction-sections -fdata-sections $(CPUFLAGS)
CXXFLAGS += -fno-rtti -fno-exceptions $(CFLAGS)
LD_SCRIPT = $(shell sed -ne "s/$(BOARD).ldscript=\(.*\)/\1/p" $(BOARDS))
LDFLAGS = -Os -nostartfiles -nostdlib -Wl,--gc-sections,--entry=ResetISR -T $(CORE)/$(LD_SCRIPT) $(CPUFLAGS)
LD = $(COMPILER_FAMILY)-g++
OBJCOPY_FLAGS = -O binary
UPLOAD_TOOL = lm4flash 
UPLOAD_FLAGS = $(SKETCH_BIN)
UPLOAD_PORT ?= /dev/ttyACM0
TERM_SPEED ?= 115200
COMPILER_FAMILY := arm-none-eabi
