COMPILER_FAMILY := xtensa-lx106-elf
TOOLS := $(HARDWARE_FAMILY)/tools/$(COMPILER_FAMILY)

SDK := $(HARDWARE_FAMILY)/tools/sdk
CPPFLAGS += -DLWIP_OPEN_SRC -D__ets__ -DICACHE_FLASH -I$(SDK)/include -I$(SDK)/lwip/include -I$(SDK)/libc/$(COMPILER_FAMILY)/include
CFLAGS = -w -Os -Wpointer-arith -Wno-implicit-function-declaration -Wl,-EL -fno-inline-functions -nostdlib -mlongcalls -mtext-section-literals -falign-functions=4 -MMD -std=gnu99 -ffunction-sections -fdata-sections
CXXFLAGS = -w -Os -mlongcalls -mtext-section-literals -fno-exceptions -fno-rtti -falign-functions=4 -std=c++11 -MMD -ffunction-sections -fdata-sections
LD := $(COMPILER_FAMILY)-gcc
LDFLAGS := -w -Os -nostdlib -Wl,--no-check-sections -u call_user_start -u _printf_float -u _scanf_float -Wl,-static -Teagle.flash.4m.ld -Wl,--gc-sections -Wl,-wrap,system_restart_local -Wl,-wrap,spi_flash_read
LDLIBS := -L$(SDK)/lib -L$(SDK)/ld -L$(SDK)/libc/$(COMPILER_FAMILY)/lib -L. -Wl,--start-group -lhal -lphy -lpp -lnet80211 -llwip_gcc -lwpa -lcrypto -lmain -lwps -laxtls -lespnow -lsmartconfig -lairkiss -lmesh -lwpa2 -lstdc++ -lcore -lm -lc -lgcc -Wl,--end-group 
