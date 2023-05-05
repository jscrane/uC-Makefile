### stm32

variables:
- MENU_XSERIAL: generic
- MENU_USB: none
- MENU_XUSB: FS
- MENU_OPT: osstd
- MENU_DBG: none
- MENU_RTLIB: nano
- MENU_UPLOAD_METHOD: serialMethod
- MENU_SERIAL_PORT: $(SERIAL_PORT) or /dev/ttyUSB0
- STM_TOOLS: /usr/local

examples:

[HY-TINY](https://stm32duinoforum.com/forum/wiki_subdomain/index_title_HY-TinySTM103T.html):
```
BOARD := GenF1.menu.pnum.HY_TINYSTM103TB
include stm32.mk

```
