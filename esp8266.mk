COMPILER_FAMILY := xtensa-lx106-elf
TOOL_DIR := $(HARDWARE_FAMILY)/tools
TOOLS := $(TOOL_DIR)/$(COMPILER_FAMILY)
PATH := $(PATH):$(TOOL_DIR)/esptool:$(TOOL_DIR)/mkspiffs

SDK := $(HARDWARE_FAMILY)/tools/sdk
BUILD_BOARD = $(shell sed -ne "s/$(BOARD).build.board=\(.*\)/\1/p" $(BOARDS))
FLASH_MENU = $(BOARD).menu.FlashSize.$(FLASH_SIZE).build
FLASH_LD = $(shell sed -ne "s/$(FLASH_MENU).flash_ld=\(.*\)/\1/p" $(BOARDS))

CPPFLAGS += -D__ets__ -DICACHE_FLASH -U__STRICT_ANSI__ -I$(SDK)/include -I$(SDK)/lwip2/include -I$(SDK)/libc/$(COMPILER_FAMILY)/include -DLWIP_OPEN_SRC -DTCP_MSS=536 -DARDUINO_$(BUILD_BOARD) -DARDUINO_ARCH_ESP8266 -DARDUINO_BOARD=\"$(BUILD_BOARD)\" -DESP8266

CFLAGS = -Os -Wpointer-arith -Wno-implicit-function-declaration -Wl,-EL -fno-inline-functions -nostdlib -mlongcalls -mtext-section-literals -falign-functions=4 -MMD -std=gnu99 -ffunction-sections -fdata-sections

CXXFLAGS = -Os -mlongcalls -mtext-section-literals -fno-exceptions -fno-rtti -falign-functions=4 -std=c++11 -MMD -ffunction-sections -fdata-sections

LD := $(COMPILER_FAMILY)-gcc
LDFLAGS := -Os -nostdlib -Wl,--no-check-sections -u call_user_start -Wl,-static -L$(SDK)/lib -L$(SDK)/ld -L$(SDK)/libc/$(COMPILER_FAMILY)/lib -T$(FLASH_LD) -Wl,--gc-sections -Wl,-wrap,system_restart_local -Wl,-wrap,spi_flash_read -Wl,--start-group
LDLIBS := -lcore -lhal -lphy -lpp -lnet80211 -llwip2 -lwpa -lcrypto -lmain -lwps -laxtls -lespnow -lsmartconfig -lairkiss -lwpa2 -lstdc++ -lm -lc -lgcc -Wl,--end-group -L$(BUILD_DIR)

LDPOST := esptool
LDPOST_FLAGS = -eo $(HARDWARE_FAMILY)/bootloaders/eboot/eboot.elf -bo $@ -bm dio -bf 40 -bz 4M -bs .text -bp 4096 -ec -eo $<  -bs .irom0.text -bs .text -bs .data -bs .rodata -bc -ec

UPLOAD_TOOL = $(shell sed -ne "s/$(BOARD).upload.tool=\(.*\)/\1/p" $(BOARDS))
UPLOAD_RESET = $(shell sed -ne "s/$(BOARD).upload.resetmethod=\(.*\)/\1/p" $(BOARDS))
UPLOAD_FLAGS = -cd $(UPLOAD_RESET) -cb $(UPLOAD_SPEED) -cp $(UPLOAD_PORT) -ca 0x00000 -cf $<

MKSPIFFS := mkspiffs
SPIFFS_DIR := data
SPIFFS_START_ADDRESS = $(shell sed -ne "s/$(FLASH_MENU).spiffs_start=\(.*\)/\1/p" $(BOARDS))

SIZE_FLAGS = -A
