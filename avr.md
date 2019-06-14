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

- UPLOAD_VERIFY: -V
- UPLOAD_VERBOSE: quiet
- PROGRAM_VERBOSE
- ERASE_VERBOSE
- BOOTLOADER_VERBOSE
- PROGRAMMER: arduinoasisp (avrisp, avrispmkii, usbtinyisp, usbasp, parallel, arduinoasispatmega32u4, usbtinyisp2, dragon, ponyser, stk500)

### attiny variables

these variables correspond to menu options in the IDE:
- BOARD_PINMAPPING: anew (old)
- UPLOAD_VERIFY: noverify
- UPLOAD_VERBOSE: quiet (verbose)
- PROGRAMMER: arduinoasisp
- EESAVE: aenable (disable)
- BOD: 1v8 (2v7, 4v3)

