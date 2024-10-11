ifndef FLASH
$(error FLASH required)
endif

SERIAL_PORT ?= /dev/ttyACM0
LITTLEFS_IMAGE ?= littlefs.bin
FS_DIR ?= data

VENDOR := rp2040
PROCESSOR_FAMILY := rp2040

FREQ ?= 133
OPT ?= Small
RTTI ?= Disabled
STACKPROTECT ?= Disabled
EXCEPTIONS ?= Disabled
DBGPORT ?= Disabled
DBGLVL ?= None
USBSTACK ?= picosdk
IPBTSTACK ?= ipv4only
BOOT2 ?= boot2_w25q080_2_padded_checksum
UPLOADMETHOD ?= default

-include hardware.mk

# alternative is "bin" (for OTA)
SUFFIX_HEX ?= uf2

-include build-targets.mk

serial.port = $(SERIAL_PORT)

FS_PAGESIZE := 256
FS_BLOCKSIZE := 4096
FS_START := $($(BOARD).menu.flash.$(FLASH).build.fs_start)
FS_SIZE = $(shell echo $($(BOARD).menu.flash.$(FLASH).build.fs_end) " - " $(FS_START) | bc)
FS_START_HEX := $(shell printf "0x%x" $(FS_START))
LITTLEFS_IMAGE_UF2 := $(LITTLEFS_IMAGE).uf2

BUILD_EXTRAS := $(LITTLEFS_IMAGE) $(LITTLEFS_IMAGE_UF2)

$(LITTLEFS_IMAGE): $(wildcard $(FS_DIR)/*)
	$(runtime.tools.pqt-mklittlefs.path)/mklittlefs -c $(FS_DIR) -b $(FS_BLOCKSIZE) -p $(FS_PAGESIZE) -s $(FS_SIZE) $@

$(LITTLEFS_IMAGE_UF2): $(LITTLEFS_IMAGE)
	$(runtime.tools.pqt-picotool.path)/picotool uf2 convert $(LITTLEFS_IMAGE) -t bin $@ -o $(FS_START_HEX) --family data

littlefs: $(LITTLEFS_IMAGE_UF2)

upload-littlefs: littlefs
	$(runtime.tools.pqt-python3.path)/python3 -I $(runtime.platform.path)/tools/uf2conv.py --serial $(serial.port) --family RP2040 --deploy $(LITTLEFS_IMAGE_UF2)

.PHONY: littlefs upload-littlefs
