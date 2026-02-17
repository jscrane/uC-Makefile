### stm32

menu items:
- `pnum`: _mandatory_
- `xserial`: `generic` (`none`, `disabled`)
- `usb`: `CDCgen` (`none`, `CDC`, `HID`)
- `xusb`: `FS` (`HS`, `HSFS`)
- `virtio`: `disable` (`generic`, `enabled`)
- `opt`: `osstd` (`oslto`, `o1std`, `o1lto`, `o2std`, `o2lto`, `o3std`, `o3lto`, `ogstd`, `o0std`)
- `dbg`: `none` (`enable_sym`, `enable_log`, `enable_all`)
- `rtlib`: `nano` (`nanofp`, `nanofs`, `nanofps`, `full`)
- `upload_method`: `dfu2Method` (`swdMethod`, `dfuMethod`, `bmpMethod`, `hidMethod`, `serialMethod`, `dfuoMethod`)

other variables:
- SERIAL_PORT: `/dev/ttyACM0`
- STM_TOOLS: `/usr/local`

examples:

[HY-TINY](https://stm32duinoforum.com/forum/wiki_subdomain/index_title_HY-TinySTM103T.html):
```
BOARD := GenF1
pnum := HY_TINYSTM103TB
include stm32.mk

```
