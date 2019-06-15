# uC-Makefile

A Makefile for popular Microcontrollers supporting Energia (msp430 and 
tivac boards) and Arduino-1.8.x (avr, attiny, esp8266 and esp32 boards).

If:
- You'd prefer to be using vi or emacs to the Arduino IDE
- Your preferred source tree layout differs from Arduino's
- You want to program more than one type of board at the same time
- You want more control over the build process than it gives you (e.g., compiler optimisation levels)
- ... then this is for you!

## Configuration
Install the makefile fragments in _somedir_.

Create a Makefile in your sketch directory, such as this, for a [TI Launchpad](https://en.wikipedia.org/wiki/TI_MSP430):

	BOARD := MSP-EXP430FR5739LP
	include msp430.mk

For an [Arduino Uno](https://en.wikipedia.org/wiki/Arduino), the equivalent would be:

	BOARD := uno
	include avr.mk

Invoke with:

	make -I somedir

**Note**: installing the fragments in a directory on Gnu Make's [include 
path](https://www.gnu.org/software/make/manual/html_node/Include.html)
means you can simply do:

	make

## Common Variables and Targets

Variables are make macros which can be (optionally) set in the user Makefile. They are in uppercase, words separated by underscore. A colon separates the name of the variable from its default value. Parentheses indicate valid alternative values.

- BOARD: _mandatory_ see `boards.txt`
- SKETCH
- SKETCHBOOK: ~/sketchbook
- TERMINAL: minicom
- TERMINAL_FLAGS: -D $(SERIAL_PORT) -b $(TERMINAL_SPEED)
- LIBRARY_PATH
- LIBRARIES
- COMPILER_WARNINGS: default
- SERIAL_PORT: /dev/ttyUSB0

Targets are in lowercase.

- all: default target, compiles and links sketch
- upload
- clean
- size
- nm
- path
- term: starts terminal on SERIAL_PORT

### Platform-specific
- [avr and attiny](avr.md)
- [esp8266 and esp32](esp.md)
- [msp430 and tivac](msp.md)

## Credits

- elpaso's [Makefile](https://github.com/elpaso/energia-makefile) for msp430 provided inspiration.
- attiny support is largely due to SpenceKonde's [ATTinyCore](https://github.com/SpenceKonde/ATTinyCore)
