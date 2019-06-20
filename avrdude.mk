PROGRAMMER_FLAGS := -p$(build.mcu) -c$(program.protocol) $(program.extra_params)

read-fuses read-flash read-eeprom write-fuses write-eeprom: path = $(runtime.tools.$(upload.tool).path)
read-fuses read-flash read-eeprom write-fuses write-eeprom: cmd.path = $(tools.$(upload.tool).cmd.path)

read-fuses:
	$(cmd.path) -C $(tools.$(upload.tool).config.path) $(PROGRAMMER_FLAGS) -U lfuse:r:-:h -U hfuse:r:-:h -U efuse:r:-:h -q -q

read-flash:
	$(cmd.path) -C $(tools.$(upload.tool).config.path) $(PROGRAMMER_FLAGS) -U flash:r:$(SKETCH_BIN)

read-eeprom:
	$(cmd.path) -C $(tools.$(upload.tool).config.path) $(PROGRAMMER_FLAGS) -U eeprom:r:$(SKETCH_EEP)

write-fuses:
	$(cmd.path) -C $(tools.$(upload.tool).config.path) $(PROGRAMMER_FLAGS) -U lfuse:w:$(bootloader.low_fuses):m -U hfuse:w:$(bootloader.high_fuses):m -U efuse:w:$(bootloader.extended_fuses):m

write-eeprom:
	$(cmd.path) -C $(tools.$(upload.tool).config.path) $(PROGRAMMER_FLAGS) -U eeprom:w:$(SKETCH_EEP)
