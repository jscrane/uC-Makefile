### stm32

variables:
- SERIAL_PORT: ```/dev/ttyACM0```
- MENU_XSERIAL: ```generic``` (```none```, ```disabled```)
- MENU_USB: ```CDCgen``` (```none```, ```CDC```, ```HID```)
- MENU_XUSB: ```FS``` (```HS```, ```HSFS```)
- MENU_OPT: ```osstd``` (```oslto```, ```o1std```, ```o1lto```, ```o2std```, ```o2lto```, ```o3std```, ```o3lto```, ```ogstd```, ```o0std```)
- MENU_DBG: ```none``` (```enable_sym```, ```enable_log```, ```enable_all```)
- MENU_RTLIB: ```nano``` (```nanofp```, ```nanofs```, ```nanofps```, ```full```)
- MENU_UPLOAD_METHOD: ```dfu2Method``` (```swdMethod```, ```dfuMethod```, ```bmpMethod```, ```hidMethod```, ```serialMethod```, ```dfuoMethod```)
- MENU_SERIAL_PORT: $(SERIAL_PORT) or ```/dev/ttyUSB0```
- STM_TOOLS: ```/usr/local```

examples:

[HY-TINY](https://stm32duinoforum.com/forum/wiki_subdomain/index_title_HY-TinySTM103T.html):
```
BOARD := GenF1.menu.pnum.HY_TINYSTM103TB
include stm32.mk

```
