## Common Variables and Targets

Variables are make macros which can be (optionally) set in the user Makefile. They are in uppercase, words separated by underscore. 
A colon separates the name of the variable from its default value. Parentheses indicate valid alternative values.

- BOARD: _mandatory_ (see `boards.txt`)
- SKETCH
- SKETCHBOOK: `~/Arduino`
- TERMINAL: `minicom`
- TERMINAL_FLAGS: `-D $(SERIAL_PORT) -b $(TERMINAL_SPEED)`
- LOCAL_LIBRARY_PATH
- LIBRARIES
- COMPILER_WARNINGS: `default`
- SERIAL_PORT: `/dev/ttyUSB0`
- CLEAN: per-sketch `clean` target

Targets are in lowercase.

- all: default target, compiles and links sketch
- upload
- clean
- path
- term: starts terminal on `SERIAL_PORT`

### Platform-specific
- [avr and attiny](avr.md)
- [esp8266 and esp32](esp.md)
- [msp430 and tivac](msp.md)
- [stm32](stm32.md)

