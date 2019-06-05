# default options (settable by user)
BOARD_PINMAPPING ?= old
SERIAL_PORT ?= /dev/ttyUSB0
UPLOAD_VERIFY ?= noverify
PROGRAM_VERIFY ?= $(UPLOAD_VERIFY)
UPLOAD_VERBOSE ?= quiet
PROGRAM_VERBOSE ?= $(UPLOAD_VERBOSE)
ERASE_VERBOSE ?= $(UPLOAD_VERBOSE)
BOOTLOADER_VERBOSE ?= $(UPLOAD_VERBOSE)
PROGRAMMER_PROTOCOL ?= avrisp
EESAVE ?= aenable
BOD ?= 1v8

VENDOR := ATTinyCore
PROCESSOR_FAMILY := avr
PACKAGES := $(HOME)/.arduino15/packages
PACKAGE_DIR := $(PACKAGES)/$(VENDOR)
ARDUINO_TOOLS := $(PACKAGES)/arduino/tools
PACKAGE_VERSION := 1.2.4
COMPILER_FAMILY := avr-gcc
COMPILER_VERSION := 5.4.0-atmel3.6.1-arduino2

runtime.ide.version := 10809
runtime.platform.path := $(PACKAGE_DIR)/hardware/$(PROCESSOR_FAMILY)/$(PACKAGE_VERSION)
runtime.tools.$(COMPILER_FAMILY).path := $(ARDUINO_TOOLS)/$(COMPILER_FAMILY)/$(COMPILER_VERSION)
runtime.tools.avrdude.path := $(ARDUINO_TOOLS)/avrdude/6.3.0-arduino14

-include $(runtime.platform.path)/boards.txt
-include platform.mk

build.board := $(BOARD)
BOARD_CPU_MENU := $(build.board).menu.chip.$(BOARD_CHIP)
build.mcu := $($(BOARD_CPU_MENU).build.mcu)
build.core := $($(build.board).build.core)
BOARD_CLOCK_MENU := $(build.board).menu.clock.$(BOARD_CLOCK)
build.f_cpu := $($(BOARD_CLOCK_MENU).build.f_cpu)
build.variant := $($(build.board).menu.pinmapping.$(BOARD_PINMAPPING).build.variant)
CORE := $(runtime.platform.path)/cores/$(build.core)
includes := -I$(CORE) -I$(runtime.platform.path)/variants/$(build.variant)
UPLOAD_TOOL := $($(build.board).upload.tool)
serial.port := $(SERIAL_PORT)
upload.protocol := $($(build.board).upload.protocol)
upload.speed := $($(build.board).upload.speed)
upload.speed ?= $($(BOARD_CLOCK_MENU).upload.speed)
upload.verbose := $(tools.$(UPLOAD_TOOL).upload.params.$(UPLOAD_VERBOSE))
upload.verify := $(tools.$(UPLOAD_TOOL).upload.params.$(UPLOAD_VERIFY))
program.verbose := $(tools.$(UPLOAD_TOOL).program.params.$(PROGRAM_VERBOSE))
program.verify := $(tools.$(UPLOAD_TOOL).programs.params.$(PROGRAM_VERIFY))
program.extra_params := $(PROGRAM_EXTRA_PARAMS)
erase.verbose := $(tools.$(UPLOAD_TOOL).erase.params.$(ERASE_VERBOSE))
bootloader.verbose := $(tools.$(UPLOAD_TOOL).bootloader.params.$(BOOTLOADER_VERBOSE))
# ugh
bf := $($(build.board).bootloader.file)
bf ?= $($(BOARD_CLOCK_MENU).bootloader.file)
bf2 := $(subst {build.mcu},$(build.mcu),$(bf))
bootloader.file := $(subst {build.f_cpu},$(build.f_cpu),$(bf2))
bootloader.low_fuses := $($(BOARD_CLOCK_MENU).bootloader.low_fuses)
bootloader.bod_bits := $($(build.board).menu.bod.$(BOD).bootloader.bod_bits)
bootloader.eesave_bit := $($(build.board).menu.eesave.$(EESAVE).bootloader.eesave_bit)
bhf := $(subst {bootloader.bod_bits},$(bootloader.bod_bits),$($(build.board).bootloader.high_fuses))
bootloader.high_fuses := $(subst {bootloader.eesave_bit},$(bootloader.eesave_bit),$(bhf))
bootloader.extended_fuses := $($(build.board).bootloader.extended_fuses)
bootloader.lock_bits := $($(build.board).bootloader.lock_bits)

SKETCH_EEP = $(SKETCH_ELF:.elf=.eep)

-include common.mk

upload program erase bootloader: path = $(runtime.tools.$(UPLOAD_TOOL).path)
upload program erase bootloader: cmd.path = $(tools.$(UPLOAD_TOOL).cmd.path)
upload program erase bootloader: config.path = $(tools.$(UPLOAD_TOOL).config.path)
upload: $(SKETCH_BIN)
	$(tools.$(UPLOAD_TOOL).upload.pattern)

program erase bootloader: protocol = $(PROGRAMMER_PROTOCOL)
program: $(SKETCH_BIN)
	$(tools.$(UPLOAD_TOOL).program.pattern)

erase:
	$(tools.$(UPLOAD_TOOL).erase.pattern)

bootloader:
	$(tools.$(UPLOAD_TOOL).bootloader.pattern)

# FIXME: programmers.txt
PROGRAMMER_FLAGS := -P $(SERIAL_PORT) -c $(PROGRAMMER_PROTOCOL) -b 19200 -p $(build.mcu)

read-fuses read-flash read-eeprom write-fuses write-eeprom: path = $(runtime.tools.$(UPLOAD_TOOL).path)
read-fuses read-flash read-eeprom write-fuses write-eeprom: cmd.path = $(tools.$(UPLOAD_TOOL).cmd.path)

read-fuses:
	$(cmd.path) -C $(tools.$(UPLOAD_TOOL).config.path) $(PROGRAMMER_FLAGS) -U lfuse:r:-:h -U hfuse:r:-:h -U efuse:r:-:h -q -q

read-flash:
	$(cmd.path) -C $(tools.$(UPLOAD_TOOL).config.path) $(PROGRAMMER_FLAGS) -U flash:r:$(SKETCH_BIN)

read-eeprom:
	$(cmd.path) -C $(tools.$(UPLOAD_TOOL).config.path) $(PROGRAMMER_FLAGS) -U eeprom:r:$(SKETCH_EEP)

write-fuses:
	$(cmd.path) -C $(tools.$(UPLOAD_TOOL).config.path) $(PROGRAMMER_FLAGS) -U lfuse:w:$(bootloader.low_fuses) -U hfuse:w:$(bootloader.high_fuses) -U efuse:w:$(bootloader.extended_fuses)

write-eeprom:
	$(cmd.path) -C $(tools.$(UPLOAD_TOOL).config.path) $(PROGRAMMER_FLAGS) -U eeprom:w:$(SKETCH_EEP)
