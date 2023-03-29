VENDOR := STMicroelectronics
PROCESSOR_FAMILY := stm32

MENU_XSERIAL ?= generic
MENU_USB ?= none
MENU_XUSB ?= FS
MENU_OPT ?= osstd
MENU_DBG ?= none
MENU_RTLIB ?= nano
MENU_UPLOAD_METHOD ?= dfuoMethod

-include hardware.mk

FAMILY := $(firstword $(subst ., ,$(BOARD)))
build.board := $($(BOARD).build.board)
build.mcu := $($(FAMILY).build.mcu)
build.core := $($(FAMILY).build.core)
build.series := $($(FAMILY).build.series)
build.cmsis_lib_gcc := $($(FAMILY).build.cmsis_lib_gcc)
build.product_line := $($(BOARD).build.product_line)
build.variant := $($(BOARD).build.variant)
build.variant_h := $($(BOARD).build.variant_h)
upload.maximum_size := $($(BOARD).upload.maximum_size)
upload.maximum_data_size := $($(BOARD).upload.maximum_data_size)

build.xserial := $($(FAMILY).menu.xserial.$(MENU_XSERIAL).build.xSerial)
build.enable_usb := $($(FAMILY).menu.usb.$(MENU_USB).build.enable_usb)
build.usb_speed := $($(FAMILY).menu.xusb.$(MENU_XUSB).build.usb_speed)
build.flags.optimize := $($(FAMILY).menu.opt.$(MENU_OPT).build.flags.optimize)
build.flags.debug := $($(FAMILY).menu.dbg.$(MENU_DBG).build.flags.debug)
build.flags.ldspecs := $($(FAMILY).menu.rtlib.$(MENU_RTLIB).build.flags.ldspecs)
build.flash_offset := $($(FAMILY).menu.upload_method.$(MENU_UPLOAD_METHOD).build.flash_offset)
build.bootloader_flags := $($(FAMILY).menu.upload_method.$(MENU_UPLOAD_METHOD).build.bootloader_flags)

build.st_extra_flags := $($(FAMILY).build.st_extra_flags)

LIBRARIES += SrcWrapper

-include build-targets.mk
