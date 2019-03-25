COMPILER_FAMILY := xtensa-esp32-elf
TOOL_DIR := $(HARDWARE_FAMILY)/tools
TOOLS := $(TOOL_DIR)/$(COMPILER_FAMILY)
PATH := $(PATH):$(TOOL_DIR)/mkspiffs:$(TOOL_DIR)/esptool

SDK := $(HARDWARE_FAMILY)/tools/sdk
FLASH_MODE = $(shell sed -ne "s/$(BOARD).build.flash_mode=\(.*\)/\1/p" $(BOARDS))
FLASH_SIZE = $(shell sed -ne "s/$(BOARD).build.flash_size=\(.*\)/\1/p" $(BOARDS))
FLASH_FREQ ?= 80m

CPPFLAGS += -DESP_PLATFORM -DESP32 -DMBEDTLS_CONFIG_FILE="mbedtls/esp_config.h" -DHAVE_CONFIG_H $(foreach i, $(wildcard $(SDK)/include/*), -I$(i))

CFLAGS += -std=gnu99 -Os -g3 -fstack-protector -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -mlongcalls -nostdlib -Wpointer-arith -w -Wno-error=unused-function -Wno-error=unused-but-set-variable -Wno-error=unused-variable -Wno-error=deprecated-declarations -Wno-unused-parameter -Wno-sign-compare -Wno-old-style-declaration -MMD

CXXFLAGS += -std=gnu++11 -fno-exceptions -Os -g3 -Wpointer-arith -fexceptions -fstack-protector -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -mlongcalls -nostdlib -w -Wno-error=unused-function -Wno-error=unused-but-set-variable -Wno-error=unused-variable -Wno-error=deprecated-declarations -Wno-unused-parameter -Wno-sign-compare -fno-rtti -MMD

LD := $(COMPILER_FAMILY)-gcc
LDFLAGS := -nostdlib -L$(SDK)/lib -L$(SDK)/ld -L$(BUILD_DIR) -T esp32_out.ld -T esp32.common.ld -T esp32.rom.ld -T esp32.peripherals.ld -T esp32.rom.spiram_incompatible_fns.ld -u ld_include_panic_highint_hdl -u call_user_start_cpu0 -Wl,--gc-sections -Wl,-static -Wl,--undefined=uxTopUsedPriority  -u __cxa_guard_dummy -u __cxx_fatal_exception  -Wl,--start-group

LDLIBS := $(BUILD_DIR)/libcore.a -lgcc -lopenssl -lbtdm_app -lfatfs -lwps -lcoexist -lwear_levelling -lhal -lnewlib -ldriver -lbootloader_support -lpp -lmesh -lsmartconfig -lsmartconfig_ack -ljsmn -lwpa -lethernet -lphy -lapp_trace -lconsole -lulp -lwpa_supplicant -lfreertos -lbt -lmicro-ecc -lcxx -lxtensa-debug-module -lmdns -lvfs -lsoc -lcore -lsdmmc -lcoap -ltcpip_adapter -lc_nano -lrtc -lspi_flash -lwpa2 -lesp32 -lapp_update -lnghttp -lspiffs -lespnow -lnvs_flash -lesp_adc_cal -llog -lexpat -lm -lc -lheap -lmbedtls -llwip -lnet80211 -lpthread -ljson -lstdc++ -Wl,--end-group

LDPOST := esptool.py
LDPOST_FLAGS = --chip esp32 elf2image --flash_mode $(FLASH_MODE) --flash_freq $(FLASH_FREQ) --flash_size $(FLASH_SIZE) -o $@ $<

SKETCH_EEP := $(SKETCH).partitions.bin

UPLOAD_TOOL = esptool.py
UPLOAD_FLAGS = --chip esp32 --port $(UPLOAD_PORT) --baud $(UPLOAD_SPEED) --before default_reset --after hard_reset write_flash -z --flash_mode $(FLASH_MODE) --flash_freq $(FLASH_FREQ) --flash_size detect 0xe000 $(TOOL_DIR)/partitions/boot_app0.bin 0x1000 $(SDK)/bin/bootloader_$(FLASH_MODE)_$(FLASH_FREQ).bin 0x10000 $(SKETCH_BIN) 0x8000 $(SKETCH_EEP)

PARTITIONS := $(TOOL_DIR)/partitions/default.csv
SPIFFS_PART := $(shell sed -ne "/^spiffs/p" $(PARTITIONS))
SPIFFS_START := $(shell echo $(SPIFFS_PART) | cut -f4 -d, -)
SPIFFS_SIZE := $(shell echo $(SPIFFS_PART) | cut -f5 -d, -)
SPIFFS_DIR ?= data
SPIFFS_PAGESIZE := 256
SPIFFS_BLOCKSIZE := 4096
SPIFFS_IMAGE ?= spiffs.img

SIZE_FLAGS =

EXTRA_TARGETS := $(SKETCH_EEP) $(SPIFFS_IMAGE)
