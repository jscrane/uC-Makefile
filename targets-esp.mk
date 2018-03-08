
SPIFFS_MAX_SIZE = 0xfb000

fs:
	$(MKSPIFFS) --create $(SPIFFS_DIR) -s $(SPIFFS_MAX_SIZE) spiffs.img
