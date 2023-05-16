### msp430 and tivac

variables:
- SERIAL_PORT: /dev/ttyACM0

examples:

Launchpad:
```
BOARD := MSP-EXP430G2553LP
TERMINAL_SPEED := 9600
include msp430.mk
```

Fraunchpad:
```
BOARD := MSP-EXP430FR5739LP
TERMINAL_SPEED := 9600
include msp430.mk
```

Stellarpad:
```
BOARD := EK-LM4F120XL
TERMINAL_SPEED := 115200
include tivac.mk
```
