### stm32

menu items:
- PNUM: _mandatory_
- XSERIAL: ```generic``` (```none```, ```disabled```)
- USB: ```CDCgen``` (```none```, ```CDC```, ```HID```)
- XUSB: ```FS``` (```HS```, ```HSFS```)
- OPT: ```osstd``` (```oslto```, ```o1std```, ```o1lto```, ```o2std```, ```o2lto```, ```o3std```, ```o3lto```, ```ogstd```, ```o0std```)
- DBG: ```none``` (```enable_sym```, ```enable_log```, ```enable_all```)
- RTLIB: ```nano``` (```nanofp```, ```nanofs```, ```nanofps```, ```full```)
- UPLOAD_METHOD: ```dfu2Method``` (```swdMethod```, ```dfuMethod```, ```bmpMethod```, ```hidMethod```, ```serialMethod```, ```dfuoMethod```)

other variables:
- SERIAL_PORT: ```/dev/ttyACM0```
- STM_TOOLS: ```/usr/local```

examples:

[HY-TINY](https://stm32duinoforum.com/forum/wiki_subdomain/index_title_HY-TinySTM103T.html):
```
BOARD := GenF1
PNUM := HY_TINYSTM103TB
include stm32.mk

```
