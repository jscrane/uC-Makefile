COMPILER_FAMILY := xtensa-lx106-elf
TOOL_VERSION ?= 2.5.0-3-20ed2b9
TOOL_DIR := $(PLATFORM_PACKAGE)/tools
PATH := $(PATH):$(TOOL_DIR)/esptool/$(TOOL_VERSION):$(TOOL_DIR)/mkspiffs/$(TOOL_VERSION)
TOOLS := $(TOOL_DIR)/$(COMPILER_FAMILY)-gcc/$(TOOL_VERSION)

SDK := $(HARDWARE_FAMILY)/tools/sdk
BUILD_BOARD != sed -ne "s/$(BOARD).build.board=\(.*\)/\1/p" $(BOARDS)
FLASH_MENU = $(BOARD).menu.eesz.$(FLASH_SIZE).build
FLASH_LD != sed -ne "s/$(FLASH_MENU).flash_ld=\(.*\)/\1/p" $(BOARDS)

LWIP_OPTS ?= lm2f
LWIP_INC != sed -ne "s/$(BOARD).menu.ip.$(LWIP_OPTS).build.lwip_include=\(.*\)/\1/p" $(BOARDS)
LWIP_LIB != sed -ne "s/$(BOARD).menu.ip.$(LWIP_OPTS).build.lwip_lib=\(.*\)/\1/p" $(BOARDS)
LWIP_FLAGS != sed -ne "s/$(BOARD).menu.ip.$(LWIP_OPTS).build.lwip_flags=\(.*\)/\1/p" $(BOARDS)

VTABLE_FLAGS ?= -DVTABLES_IN_FLASH

CPPFLAGS += -D__ets__ -DICACHE_FLASH -U__STRICT_ANSI__ -I$(SDK)/include -I$(SDK)/$(LWIP_INC) -I$(SDK)/libc/$(COMPILER_FAMILY)/include $(LWIP_FLAGS) -DARDUINO_$(BUILD_BOARD) -DARDUINO_ARCH_ESP8266 -DARDUINO_BOARD=\"$(BUILD_BOARD)\" -DESP8266

CFLAGS = -Os -w -Wpointer-arith -Wno-implicit-function-declaration -Wl,-EL -fno-inline-functions -nostdlib -mlongcalls -mtext-section-literals -falign-functions=4 -MMD -std=gnu99 -ffunction-sections -fdata-sections

CXXFLAGS = -Os -w -mlongcalls -mtext-section-literals -fno-exceptions -fno-rtti -falign-functions=4 -std=c++11 -MMD -ffunction-sections -fdata-sections

LD := $(COMPILER_FAMILY)-gcc
LDFLAGS := -Os -w -nostdlib -Wl,--no-check-sections -u call_user_start -u _printf_float -u _scanf_float -Wl,-static -L$(SDK)/lib -L$(SDK)/ld -L$(SDK)/libc/$(COMPILER_FAMILY)/lib -L$(BUILD_DIR) -T$(FLASH_LD) -Wl,--gc-sections -Wl,-wrap,system_restart_local -Wl,-wrap,spi_flash_read -Wl,--start-group
LDLIBS := -lcore -lhal -lphy -lpp -lnet80211 $(LWIP_LIB) -lwpa -lcrypto -lmain -lwps -laxtls -lespnow -lsmartconfig -lairkiss -lwpa2 -lstdc++ -lm -lc -lgcc -Wl,--end-group

LDPOST := esptool
LDPOST_FLAGS = -eo $(HARDWARE_FAMILY)/bootloaders/eboot/eboot.elf -bo $@ -bm dio -bf 40 -bz 4M -bs .text -bp 4096 -ec -eo $<  -bs .irom0.text -bs .text -bs .data -bs .rodata -bc -ec

UPLOAD_TOOL != sed -ne "s/$(BOARD).upload.tool=\(.*\)/\1/p" $(BOARDS)
UPLOAD_RESET != sed -ne "s/$(BOARD).upload.resetmethod=\(.*\)/\1/p" $(BOARDS)
UPLOAD_FLAGS = -cd $(UPLOAD_RESET) -cb $(UPLOAD_SPEED) -cp $(UPLOAD_PORT) -ca 0x00000 -cf $<

SPIFFS_DIR ?= data
SPIFFS_START != sed -ne "s/$(FLASH_MENU).spiffs_start=\(.*\)/\1/p" $(BOARDS)
SPIFFS_END != sed -ne "s/$(FLASH_MENU).spiffs_end=\(.*\)/\1/p" $(BOARDS)
SPIFFS_BLOCKSIZE != sed -ne "s/$(FLASH_MENU).spiffs_blocksize=\(.*\)/\1/p" $(BOARDS)
SPIFFS_PAGESIZE != sed -ne "s/$(FLASH_MENU).spiffs_pagesize=\(.*\)/\1/p" $(BOARDS)
SPIFFS_SIZE != echo $$(( $(SPIFFS_END) - $(SPIFFS_START) ))
SPIFFS_IMAGE ?= spiffs.img

SIZE_FLAGS :=

EXTRA_TARGETS := $(SPIFFS_IMAGE)
