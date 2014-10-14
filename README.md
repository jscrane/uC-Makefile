uC-Makefile
===========

A Makefile for popular Microcontrollers supporting Energia (all boards) 
and (in future) Arduino (all boards).

Configuration
-------------
Install the makefile fragments in _somedir_.

Create a Makefile in your sketch directory, such as this:

	PROCESSOR_FAMILY := msp430
	BOARD := lpmsp430g2553
	SKETCH = Blink.ino
	SOURCES = 

	include energia.mk

Invoke with:

	make -I somedir	

Note: installing the fragments in a directory on Gnu Make's [include 
path](https://www.gnu.org/software/make/manual/html_node/Include.html)
means you can invoke as simply:

	make

Credits
-------

- elpaso's [Makefile](https://github.com/elpaso/energia-makefile) for 
  msp430 provided inspiration.
