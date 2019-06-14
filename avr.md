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

### attiny-specific

these variables correspond to menu options in the IDE:
- BOARD_PINMAPPING: anew (old)
- UPLOAD_VERIFY: noverify
- UPLOAD_VERBOSE: quiet (verbose)
- PROGRAMMER: arduinoasisp (avrisp, avrispmkii, usbtinyisp, usbasp, parallel, arduinoasispatmega32u4, usbtinyisp2, dragon, ponyser, stk500)
- EESAVE: aenable (disable)
- BOD: 1v8 (2v7, 4v3)

