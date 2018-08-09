IMAGE ?= spiffs.img

$(IMAGE): $(wildcard $(SPIFFS_DIR)/*)
	mkspiffs -c $(SPIFFS_DIR) -b $(SPIFFS_BLOCKSIZE) -p $(SPIFFS_PAGESIZE) -s $(SPIFFS_SIZE) $(IMAGE)

.PHONY: fs upload-fs partitions

fs: $(IMAGE)

upload-fs: $(IMAGE)
	$(UPLOAD_TOOL) --chip esp32 --baud $(UPLOAD_SPEED) --port $(UPLOAD_PORT) --before default_reset --after hard_reset write_flash -z --flash_mode $(FLASH_MODE) --flash_freq $(FLASH_FREQ) --flash_size detect $(SPIFFS_START) $(IMAGE)

partitions:
	$(TOOL_DIR)/gen_esp32part.py -q $(PARTITIONS) $(SKETCH_PARTITIONS)
