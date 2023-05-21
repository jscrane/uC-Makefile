$(call define-prefix-variables,$(PROGRAMMER))

upload program erase bootloader: path = $(tools.$(upload.tool).path)
upload program erase bootloader: cmd.path = $(tools.$(upload.tool).cmd.path)
upload program erase bootloader: config.path = $(tools.$(upload.tool).config.path)

program erase bootloader: protocol = $(program.protocol)
