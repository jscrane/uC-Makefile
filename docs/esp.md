### esp8266

menu options:
- XTAL: 80 (160)
- DBG: Disabled (Serial, Serial1)
- LVL: None____ (SSL, TLS_MEM, HTTP_CLIENT, HTTP_SERVER, ..., CORE, WIFI, UPDATER, OTA, OOM, ...)
- IP: lm2f (hb2f, lm2n, hb2n, lm6f, hb6f, hb1)
- WIPE: none (sdk, all)
- VT: flash (heap, iram)
- SSL: all (basic)
- EXCEPTIONS: disabled (enabled)
- MMU: 3232 (4816, 4816H, 3216, ext128k, ext8192k)

other variables:
- UPLOAD_SPEED: 921600 (9600, 57600, 115200, 230400, 460800, 512000)
- UPLOAD_VERBOSE: quiet
- FS_DIR: data
- SPIFFS_IMAGE: spiffs.img
- LITTLEFS_IMAGE: littlefs.img
- OTA_HOST: the hostname for OTA upload
- OTA_PORT: the OTA listening port
- OTA_PASSWORD: the auth password for OTA

targets:
- spiffs: creates $(SPIFFS_IMAGE)
- upload-spiffs: writes $(SPIFFS_IMAGE) to flash
- fs: creates $(LITTLEFS_IMAGE)
- upload-fs: writes $(FS_IMAGE) to flash
- ota

### esp32

menu options:
- FLASHFREQ: 80
- PARTITIONSCHEME: default

other variables:
- UPLOAD_SPEED: 921600
- SPIFFS_DIR: data
- SPIFFS_IMAGE: spiffs.img
- OTA_HOST
- OTA_PORT
- OTA_PASSWORD

targets:
- fs
- upload-fs
- ota

### examples

WeMos D1 Mini:
```
BOARD := d1_mini
UPLOAD_SPEED := 921600
TERMINAL_SPEED := 115200
FLASH_SIZE := 4M1M
F_CPU := 80
include esp8266.mk
```

Node32s:
```
BOARD := node32s
UPLOAD_SPEED := 921600
TERMINAL_SPEED := 115200
include esp32.mk
```
