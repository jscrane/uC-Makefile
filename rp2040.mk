SERIAL_PORT ?= /dev/ttyACM0

VENDOR := rp2040
PROCESSOR_FAMILY := rp2040

FLASH ?= 8388608_0
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
