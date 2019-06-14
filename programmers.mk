-include $(runtime.platform.path)/programmers.txt

program.protocol := $($(PROGRAMMER).program.protocol)
program.speed := $($(PROGRAMMER).program.speed)
$(eval program.extra_params := $(subst {,$${,$($(PROGRAMMER).program.extra_params)))

upload program erase bootloader: path = $(runtime.tools.$(UPLOAD_TOOL).path)
upload program erase bootloader: cmd.path = $(tools.$(UPLOAD_TOOL).cmd.path)
upload program erase bootloader: config.path = $(tools.$(UPLOAD_TOOL).config.path)
upload: $(SKETCH_BIN)
	$(tools.$(UPLOAD_TOOL).upload.pattern)

program erase bootloader: protocol = $(program.protocol)
program: $(SKETCH_BIN)
	$(tools.$(UPLOAD_TOOL).program.pattern)

erase:
	$(tools.$(UPLOAD_TOOL).erase.pattern)

bootloader:
	$(tools.$(UPLOAD_TOOL).bootloader.pattern)
