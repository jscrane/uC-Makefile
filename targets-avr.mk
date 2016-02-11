SKETCH_EEP = $(SKETCH:.ino=.eep)

eep: $(SKETCH_EEP)

$(SKETCH_EEP): $(SKETCH_ELF)
	$(OBJCOPY) -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 $< $@

PROGRAM_TOOL := avrdude
PROGRAM_FLAGS := -C $(TOOLS)/etc/avrdude.conf -P$(UPLOAD_PORT) -c avrisp -b 19200 -p ${U_${BUILD_MCU}} 
BOOTLOADER_LFUSE := $(shell sed -ne "s/$(BOARD).bootloader.low_fuses=\(.*\)/\1/p" $(BOARDS))
BOOTLOADER_EFUSE := $(shell sed -ne "s/$(BOARD).bootloader.extended_fuses=\(.*\)/\1/p" $(BOARDS))
BOOTLOADER_HFUSE := $(shell sed -ne "s/$(BOARD).bootloader.high_fuses=\(.*\)/\1/p" $(BOARDS))
BOOTLOADER_FILE := $(shell sed -ne "s/$(BOARD).bootloader.file=\(.*\)/\1/p" $(BOARDS))

download: read-flash

fuses: read-fuses

eeprom: read-eeprom

read-flash:
	$(PROGRAM_TOOL) $(PROGRAM_FLAGS) -U flash:r:$(SKETCH_BIN)

read-eeprom:
	$(PROGRAM_TOOL) $(PROGRAM_FLAGS) -U eeprom:r:$(SKETCH_EEP)

read-fuses:
	$(PROGRAM_TOOL) $(PROGRAM_FLAGS) -U lfuse:r:-:h -U hfuse:r:-:h -U efuse:r:-:h -q -q

write-flash: $(SKETCH_BIN)
	$(PROGRAM_TOOL) $(PROGRAM_FLAGS) -U flash:w:$(SKETCH_BIN)

write-eeprom: $(SKETCH_EEP)
	$(PROGRAM_TOOL) $(PROGRAM_FLAGS) -U eeprom:w:$(SKETCH_EEP)

write-fuses:
	$(PROGRAM_TOOL) $(PROGRAM_FLAGS) -U lfuse:w:$(BOOTLOADER_LFUSE):m -U hfuse:w:$(BOOTLOADER_HFUSE):m -U efuse:w:$(BOOTLOADER_EFUSE):m

bootloader: write-fuses
	$(PROGRAM_TOOL) $(PROGRAM_FLAGS) -U flash:w:$(BOOTLOADER_FILE)
