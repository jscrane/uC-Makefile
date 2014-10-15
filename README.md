uC-Makefile
===========

A Makefile for popular Microcontrollers supporting Energia (all boards) 
and Arduino-1.0 (all boards).

Configuration
-------------
Install the makefile fragments in _somedir_.

Create a Makefile in your sketch directory, such as this:

	PROCESSOR_FAMILY := msp430
	BOARD := lpmsp430g2553
	SKETCH = Blink.ino
	SOURCES = 

	include energia.mk

For Arduino 1.0, replace the last line with:

	include arduino10.mk

Invoke with:

	make -I somedir

Note: installing the fragments in a directory on Gnu Make's [include 
path](https://www.gnu.org/software/make/manual/html_node/Include.html)
means you can simply do:

	make

Other Settings
--------------

Some settings it might be necessary to override, and their defaults are:

- IDE_HOME (/usr/local/energia or /usr/local/arduino)
- SKETCHBOOK (~/energia/sketchbook or ~/sketchbook)
- UPLOAD_PORT (/dev/ttyUSB0)

Credits
-------

- elpaso's [Makefile](https://github.com/elpaso/energia-makefile) for 
  msp430 provided inspiration.
