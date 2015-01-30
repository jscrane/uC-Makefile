uC-Makefile
===========

A Makefile for popular Microcontrollers supporting Energia (all boards) 
and Arduino-1.x (all boards).

If:
- You'd prefer to be using vi or emacs to the Arduino IDE
- Your preferred source tree layout differs from Arduino's
- You want to program more than one type of board at the same time
- You want more control over the build process than it gives you (e.g., compiler optimisation levels)
- ... then this is for you!

Configuration
-------------
Install the makefile fragments in _somedir_.

Create a Makefile in your sketch directory, such as this, for a [TI Launchpad](https://en.wikipedia.org/wiki/TI_MSP430):

	PROCESSOR_FAMILY := msp430
	BOARD := lpmsp430g2553
	include energia.mk

For an [Arduino Uno](https://en.wikipedia.org/wiki/Arduino), the equivalent would be:

	BOARD := uno
	include arduino10.mk

Invoke with:

	make -I somedir

**Note**: installing the fragments in a directory on Gnu Make's [include 
path](https://www.gnu.org/software/make/manual/html_node/Include.html)
means you can simply do:

	make

Other Settings
--------------

Some settings it might be necessary to override, and their defaults are:

- IDE_HOME (/usr/local/energia or /usr/local/arduino)
- SKETCHBOOK (~/energia/sketchbook or ~/sketchbook)
- UPLOAD_PORT (/dev/ttyUSB0)
- SKETCH (e.g., Blink.ino)
- SOURCES (e.g., foo.cpp bar.c)
- LOCAL_CPPFLAGS (e.g., local #defines)
- PROCESSOR_FAMILY (required for Launchpads, defaults to avr for Arduino)

Credits
-------

- elpaso's [Makefile](https://github.com/elpaso/energia-makefile) for msp430 provided inspiration.
