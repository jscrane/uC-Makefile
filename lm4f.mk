CPUFLAGS = -mthumb -mcpu=$(BUILD_MCU) -mfloat-abi=hard -mfpu=fpv4-sp-d16 -fsingle-precision-constant
CFLAGS = -O0 -Wall -ffunction-sections -fdata-sections $(CPUFLAGS)
CXXFLAGS = -fno-rtti -fno-exceptions $(CFLAGS)
LD_SCRIPT = $(shell sed -ne "s/$(BOARD).ldscript=\(.*\)/\1/p" $(BOARDS))
LDFLAGS = -O0 -nostartfiles -nostdlib -Wl,--gc-sections,--entry=ResetISR -T $(PROCESSOR_CORE)/$(LD_SCRIPT) $(CPUFLAGS)
LD = $(COMPILER_FAMILY)-g++
OBJCOPY_FLAGS = -O binary
UPLOADER = lm4flash
COMPILER_FAMILY := arm-none-eabi
