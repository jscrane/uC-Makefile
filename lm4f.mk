CPUFLAGS = -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -fsingle-precision-constant
CFLAGS = -O0 -Wall -ffunction-sections -fdata-sections $(CPUFLAGS)
CXXFLAGS = -fno-rtti -fno-exceptions $(CFLAGS)
LDFLAGS = -O0 -nostartfiles -nostdlib -Wl,--gc-sections -T $(PROCESSOR_CORE)/lm4fcpp_blizzard.ld -Wl,--entry=ResetISR $(CPUFLAGS)
LD = $(COMPILER_FAMILY)-g++
OBJCOPY_FLAGS = -O binary
UPLOADER = lm4flash
COMPILER_FAMILY := arm-none-eabi
