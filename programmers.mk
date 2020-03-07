-include programmers.txt.mk

program.protocol := $($(PROGRAMMER).program.protocol)
program.speed := $($(PROGRAMMER).program.speed)
program.extra_params := $($(PROGRAMMER).program.extra_params)

upload program erase bootloader: path = $(runtime.tools.$(upload.tool).path)
upload program erase bootloader: cmd.path = $(tools.$(upload.tool).cmd.path)
upload program erase bootloader: config.path = $(tools.$(upload.tool).config.path)
upload: $(SKETCH_BIN)
	$(tools.$(upload.tool).upload.pattern)

program erase bootloader: protocol = $(program.protocol)
program: $(SKETCH_BIN)
	$(tools.$(upload.tool).program.pattern)

erase:
	$(tools.$(upload.tool).erase.pattern)

bootloader:
	$(tools.$(upload.tool).bootloader.pattern)

.PHONY: upload program erase bootloader
