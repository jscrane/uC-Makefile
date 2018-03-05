COMPILER_FAMILY := xtensa-lx106-elf
TOOLS := $(HARDWARE_FAMILY)/tools/$(COMPILER_FAMILY)

SDK := $(HARDWARE_FAMILY)/tools/sdk
CPPFLAGS += -D__ets__ -DICACHE_FLASH -U__STRICT_ANSI__ -I$(SDK)/include -I$(SDK)/lwip2/include -I$(SDK)/libc/$(COMPILER_FAMILY)/include -DLWIP_OPEN_SRC -DTCP_MSS=536 -DARDUINO_ESP8266_WEMOS_D1MINI -DARDUINO_ARCH_ESP8266 -DARDUINO_BOARD=\"ESP8266_WEMOS_D1MINI\" -DESP8266
CFLAGS = -w -Os -g -Wpointer-arith -Wno-implicit-function-declaration -Wl,-EL -fno-inline-functions -nostdlib -mlongcalls -mtext-section-literals -falign-functions=4 -MMD -std=gnu99 -ffunction-sections -fdata-sections
CXXFLAGS = -w -Os -g -mlongcalls -mtext-section-literals -fno-exceptions -fno-rtti -falign-functions=4 -std=c++11 -MMD -ffunction-sections -fdata-sections
LD := $(COMPILER_FAMILY)-gcc
LDFLAGS := -g -w -Os -nostdlib -Wl,--no-check-sections -u call_user_start -u _printf_float -u _scanf_float -Wl,-static -L$(SDK)/lib -L$(SDK)/ld -L$(SDK)/libc/$(COMPILER_FAMILY)/lib -L. -Teagle.flash.4m1m.ld -Wl,--gc-sections -Wl,-wrap,system_restart_local -Wl,-wrap,spi_flash_read -Wl,--start-group
LDLIBS := -lhal -lphy -lpp -lnet80211 -llwip2 -lwpa -lcrypto -lmain -lwps -laxtls -lespnow -lsmartconfig -lairkiss -lwpa2 -lstdc++ -lcore -lm -lc -lgcc -Wl,--end-group
