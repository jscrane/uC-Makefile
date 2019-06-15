### esp8266

these variables mostly correspond to menu options in the IDE:
- LWIP_OPTS: lm2f (hb2f, lm2n, hb2n, lm6f, hb6f, hb1)
- F_CPU: 80 (160)
- DEBUG_PORT: Disabled (Serial, Serial1)
- DEBUG_LEVEL: None____ (SSL, TLS_MEM, HTTP_CLIENT, HTTP_SERVER, ..., CORE, WIFI, UPDATER, OTA, OOM, ...)
- EXCEPTIONS: disabled (enabled)
- VTABLES: flash (heap, iram)
- SSL: all (basic)
- WIPE: none  (sdk, all)
- UPLOAD_SPEED: 921600 (9600, 57600, 115200, 230400, 460800, 512000)
- UPLOAD_VERBOSE: quiet
- SPIFFS_DIR: data
- SPIFFS_IMAGE: spiffs.img
- OTA_HOST: the hostname for OTA upload
- OTA_PORT: the OTA listening port
- OTA_PASSWORD: the auth password for OTA

targets:
- fs: creates $(SPIFFS_IMAGE)
- upload-fs: writes $(SPIFFS_IMAGE) to flash
- ota

### esp32

variables:
- UPLOAD_SPEED: 921600
- FLASH_FREQ: 80
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
