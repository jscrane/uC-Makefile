### avr and attiny

targets:
- program: writes sketch using a programmer
- erase
- bootloader

when the programmer is `avrdude` there are some extra targets:
- read-fuses
- read-flash
- read-eeprom
- write-fuses
- write-eeprom

### avr variables

- BOARD_CPU: the clock speed of the cpu, if required
- UPLOAD_VERIFY: -V
- UPLOAD_VERBOSE: quiet
- PROGRAM_VERBOSE
- ERASE_VERBOSE
- BOOTLOADER_VERBOSE
- PROGRAMMER: arduinoasisp (avrisp, avrispmkii, usbtinyisp, usbasp, parallel, arduinoasispatmega32u4, usbtinyisp2, dragon, ponyser, stk500)

### attiny variables

these correspond to menu options in the IDE:
- BOARD_CHIP: _mandatory_
- BOARD_CLOCK: _mandatory_
- BOARD_PINMAPPING: anew (old)
- UPLOAD_VERIFY: noverify
- UPLOAD_VERBOSE: quiet (verbose)
- PROGRAMMER: arduinoasisp
- EESAVE: aenable (disable)
- BOD: 1v8 (2v7, 4v3)

### examples

Uno:
```
BOARD := uno
TERMINAL_SPEED := 115200
include avr.mk
```

Pro/Pro Mini with 8MHz CPU:
```
BOARD := pro
BOARD_CPU := 8MHzatmega328
TERMINAL_SPEED := 115200
include avr.mk
```

ATTiny84 with Optiboot and 8MHz internal clock:
```
BOARD := attinyx4opti
BOARD_CHIP := 84
BOARD_CLOCK := 8internal
TERMINAL_SPEED := 19200
include tiny.mk
```
