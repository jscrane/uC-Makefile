### avr and attiny

when the programmer is `avrdude` there are some extra targets:
- read-fuses
- read-flash
- read-eeprom
- write-fuses
- write-eeprom

### avr

menu options:
- CPU: the chip (and clock speed) of the cpu, if required by the chosen board

other variables and their defaults:
- UPLOAD_VERBOSE: `quiet` (`verbose`)
- UPLOAD_VERIFY: `verify`
- PROGRAM_VERBOSE: same as UPLOAD_VERBOSE
- PROGRAM_VERIFY: same as UPLOAD_VERIFY
- ERASE_VERBOSE: same as UPLOAD_VERBOSE
- BOOTLOADER_VERBOSE: same as UPLOAD_VERBOSE
- PROGRAMMER: arduinoasisp (avrisp, avrispmkii, usbtinyisp, usbasp, parallel, arduinoasispatmega32u4, usbtinyisp2, dragon, ponyser, stk500)

### attiny

menu options:
- CHIP: _mandatory_
- CLOCK: _mandatory_
- PINMAPPING: anew (old)
- LTO: enable (disable)
- BOD: 1v8 (2v7, 4v3)
- EESAVE: aenable (disable)
- MILLIS: enable (disable)
- NEOPIXELPORT: porta (portb)

other variables:
- UPLOAD_VERBOSE: `quiet` (`verbose`)
- UPLOAD_VERIFY: `verify`
- PROGRAM_VERBOSE: same as UPLOAD_VERBOSE
- PROGRAM_VERIFY: same as UPLOAD_VERIFY
- ERASE_VERBOSE: same as UPLOAD_VERBOSE
- BOOTLOADER_VERBOSE: same as UPLOAD_VERBOSE
- PROGRAMMER: arduinoasisp

### examples

Uno:
```
BOARD := uno
TERMINAL_SPEED := 115200
include avr.mk
```

Nano:
```
BOARD := nano
CPU := atmega168
include avr.mk
```

Pro/Pro Mini with 8MHz CPU:
```
BOARD := pro
CPU := 8MHzatmega328
TERMINAL_SPEED := 115200
include avr.mk
```

ATTiny84 with Optiboot and 8MHz internal clock:
```
BOARD := attinyx4opti
CHIP := 84
CLOCK := 8internal
TERMINAL_SPEED := 19200
include tiny.mk
```
