ifndef FLASH
$(error FLASH required)
endif

SERIAL_PORT ?= /dev/ttyACM0
LITTLEFS_IMAGE ?= littlefs.img
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
FS_SIZE := $(shell echo $($(BOARD).menu.flash.$(FLASH).build.fs_end) " - " $($(BOARD).menu.flash.$(FLASH).build.fs_start) | bc)

#  -p 256 -b 4096 -s 1048576
$(LITTLEFS_IMAGE): $(wildcard $(FS_DIR)/*)
	$(runtime.tools.pqt-mklittlefs.path)/mklittlefs -c $(FS_DIR) -b $(FS_BLOCKSIZE) -p $(FS_PAGESIZE) -s $(FS_SIZE) $@

littlefs: $(LITTLEFS_IMAGE)
