SPIFFS_SIZE := $(shell echo $$(( $(SPIFFS_END) - $(SPIFFS_START) )))
IMAGE ?= spiffs.img

$(IMAGE):
	mkspiffs -c $(SPIFFS_DIR) -b $(SPIFFS_BLOCKSIZE) -p $(SPIFFS_PAGESIZE) -s $(SPIFFS_SIZE) $(IMAGE)

fs: $(IMAGE)

upload-fs: $(IMAGE)
	esptool -cd $(UPLOAD_RESET) -cb $(UPLOAD_SPEED) -cp $(UPLOAD_PORT) -ca $(SPIFFS_START) -cf $(IMAGE)

reset:
	esptool -cd $(UPLOAD_RESET) -cp $(UPLOAD_PORT) -cr
