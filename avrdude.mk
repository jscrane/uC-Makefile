PROGRAMMER_FLAGS := -p$(build.mcu) -c$(program.protocol) $(program.extra_params)

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