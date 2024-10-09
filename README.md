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

A minimal Makefile must specify a BOARD and include only one core. See the [documentation](docs/README.md) for core-specific options.

Invoke with:

	make -I somedir

**Note**: installing the fragments in a directory on Gnu Make's [include 
path](https://www.gnu.org/software/make/manual/html_node/Include.html)
means you can simply do:

	make

See the [documentation](docs/README.md).

## Supported Cores

 - [avr](https://github.com/arduino/ArduinoCore-avr), 1.8.6
 - [attiny](https://github.com/SpenceKonde/ATTinyCore), 1.5.2
 - Arduino [esp8266](https://github.com/esp8266/Arduino), 3.1.2
 - Arduino [esp32](https://github.com/espressif/arduino-esp32), 2.0.17
 - Energia [tivac](https://github.com/energia/tivac-core), 1.0.4 (requires editing SD.h for Stellarpad)
 - Energia [msp430](https://github.com/energia/msp430-lg-core), 1.0.7
 - [stm32](https://github.com/stm32duino/Arduino_Core_STM32), 2.5.0
 - [rp2040](https://github.com/earlephilhower/arduino-pico), 4.1.1 (new!)

Note: Energia is no longer developed. Its cores are now integrated with Arduino via
[this repository](https://github.com/Andy4495/TI_Platform_Cores_For_Arduino).

## Credits

- elpaso's [Makefile](https://github.com/elpaso/energia-makefile) for msp430 provided inspiration.
- attiny support is largely due to SpenceKonde's [ATTinyCore](https://github.com/SpenceKonde/ATTinyCore)
