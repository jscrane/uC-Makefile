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

See the [documentation](docs/README.md).

## Credits

- elpaso's [Makefile](https://github.com/elpaso/energia-makefile) for msp430 provided inspiration.
- attiny support is largely due to SpenceKonde's [ATTinyCore](https://github.com/SpenceKonde/ATTinyCore)
