### esp8266

menu options:
- XTAL: 80 (160)
- VT: flash (heap, iram)
- EXCEPTION: disabled (enabled)
- STACKSMASH: disabled (enabled)
- SSL: all (basic)
- MMU: 3232 (4816, 4816H, 3216, ext128k, ext8192k)
- NON32XFER: fast (safe)
- RESETMETHOD: nodemcu (ck, nodtr_nosync)
- CRYSTALFREQ: 26 (40)
- FLASHFREQ: 40 (80, 20, 26)
- FLASHMODE: dout (dio, quot, qio)
- EESZ: _mandatory_ (1M64, 1M128, 1M144, 1M160, 1M192, 1M256, 1M512, 1M, 2M64, 2M128, 2M256, 2M512, 2M1M, 2M, 4M2M, 4M3M, 4M1M, 4M, 
			8M6M, 8M7M, 8M, 16M14M, 16M15M, 16M, 512K32, 512K64, 512K128, 512K)
- LED: 2 (0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
- SDK: nonosdk_190703 (nonosdk_191122, nonosdk_191105, nonosdk_191024, nonosdk_190313, nonosdk221, nonosdk305)
- IP: lm2f (hb2f, lm2n, hb2n, lm6f, hb6f, hb1)
- DBG: Disabled (Serial, Serial1)
- LVL: None____ (SSL, TLS_MEM, HTTP_CLIENT, HTTP_SERVER, SSLTLS_MEM, SSLHTTP_CLIENT, SSLHTTP_SERVER, TLS_MEMHTTP_CLIENT, TLS_MEMHTTP_SERVER, HTTP_CLIENTHTTP_SERVER, 
			SSLTLS_MEMHTTP_CLIENT, SSLTLS_MEMHTTP_SERVER, SSLHTTP_CLIENTHTTP_SERVER, TLS_MEMHTTP_CLIENTHTTP_SERVER, SSLTLS_MEMHTTP_CLIENTHTTP_SERVER, HTTP_UPDATE, 
			CORE, WIFI, UPDATER, OTA, OOM, MDNS, HWDT, COREWIFIHTTP_UPDATEUPDATEROTAOOMMDNS, COREWIFIHTTP_UPDATEUPDATEROTAOOMMDNSHWDT, 
			COREWIFIHTTP_UPDATEUPDATEROTAOOMMDNSHWDT_NOEXTRA4K, SSLTLS_MEMHTTP_CLIENTHTTP_SERVERCOREWIFIHTTP_UPDATEUPDATEROTAOOMMDNS, 
			SLTLS_MEMHTTP_CLIENTHTTP_SERVERCOREWIFIHTTP_UPDATEUPDATEROTAOOMMDNSHWDT, SSLTLS_MEMHTTP_CLIENTHTTP_SERVERCOREWIFIHTTP_UPDATEUPDATEROTAOOMMDNSHWDT_NOEXTRA4K, 
			NoAssert-NDEBUG)
- WIPE: none (sdk, all)
- BAUD: 115200 (57600, 230400, 256000, 460800, 512000, 921600, 3000000)

other variables:
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
- JTAGADAPTER: default (external, bridge)
- PSRAM: disabled (enabled)
- PARTITIONSCHEME: default (minimal, no_ota, noota_3g, noota_ffat, noota_3gffat, huge_app, min_spiffs, fatflash, app3M_fat9M_16MB, rainmaker)
- CPUFREQ: 240 (160, 80, 40, 26, 20, 13, 10)
- FLASHMODE: qio (dio, qout, dout)
- FLASHFREQ: 80 (40)
- FLASHSIZE: 4M (8M, 2M, 16M)
- UPLOADSPEED: 921600 (115200, 256000, 230400, 460800, 512000)
- LOOPCORE: 1 (0)
- EVENTSCORE: 1 (0)
- DEBUGLEVEL: none (error, warn, info, debug, verbose)
- ERASEFLASH: none (all)

other variables:
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
TERMINAL_SPEED := 115200
EESZ := 4M1M
XTAL := 80
include esp8266.mk
```

Node32s:
```
BOARD := node32s
TERMINAL_SPEED := 115200
include esp32.mk
```
