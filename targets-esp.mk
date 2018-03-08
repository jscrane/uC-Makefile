
SPIFFS_SIZE := $(shell echo $$(( $(SPIFFS_END) - $(SPIFFS_START) )))
IMAGE := spiffs.img

fs:
	$(MKSPIFFS) --create $(SPIFFS_DIR) -s $(SPIFFS_SIZE) $(IMAGE)

upload-fs:
	esptool -cd $(UPLOAD_RESET) -cb $(UPLOAD_SPEED) -cp $(UPLOAD_PORT) -ca $(SPIFFS_START) -cf $(IMAGE)
