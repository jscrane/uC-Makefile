$(SPIFFS_IMAGE): $(wildcard $(SPIFFS_DIR)/*)
	mkspiffs -c $(SPIFFS_DIR) -b $(SPIFFS_BLOCKSIZE) -p $(SPIFFS_PAGESIZE) -s $(SPIFFS_SIZE) $(SPIFFS_IMAGE)

fs: $(SPIFFS_IMAGE)

upload-fs: $(SPIFFS_IMAGE)
	esptool -cd $(UPLOAD_RESET) -cb $(UPLOAD_SPEED) -cp $(UPLOAD_PORT) -ca $(SPIFFS_START) -cf $(SPIFFS_IMAGE)

reset:
	esptool -cd $(UPLOAD_RESET) -cp $(UPLOAD_PORT) -cr
