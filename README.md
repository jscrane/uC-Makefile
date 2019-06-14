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

## Variables and Targets

Variables are make macros which can be (optionally) set in the user Makefile. They are in uppercase, words separated by underscore. A colon separates the name of the variable from its default value. Parentheses indicate valid alternative values.

Targets are in lowercase. 

### Common

- SKETCH
- SKETCHBOOK: ~/sketchbook
- TERMINAL: minicom
- TERMINAL_FLAGS: -D $(SERIAL_PORT) -b $(TERMINAL_SPEED)
- LIBRARY_PATH
- COMPILER_WARNINGS: default
- SERIAL_PORT: /dev/ttyUSB0

targets:
- all: default target, compiles and links sketch
- upload
- clean
- size
- nm
- path
- term: starts terminal on SERIAL_PORT

### avr and attiny variables and targets

- program: writes sketch using a programmer
- erase
- bootloader

When the programmer is `avrdude` there are some extra targets:
- read-fuses
- read-flash
- read-eeprom
- write-fuses
- write-eeprom

### attiny-specific Variables:

These variables correspond to menu options in the IDE:
- BOARD_PINMAPPING: anew (old)
- UPLOAD_VERIFY: noverify
- UPLOAD_VERBOSE: quiet (verbose)
- PROGRAMMER: arduinoasisp (avrisp, avrispmkii, usbtinyisp, usbasp, parallel, arduinoasispatmega32u4, usbtinyisp2, dragon, ponyser, stk500)
- EESAVE: aenable (disable)
- BOD: 1v8 (2v7, 4v3)

### esp8266 variables and targets

These variables mostly correspond to menu options in the IDE:
- LWIP_OPTS: lm2f (hb2f, lm2n, hb2n, lm6f, hb6f, hb1)
- F_CPU: 80 (160)
- DEBUG_PORT: Disabled (Serial, Serial1)
- DEBUG_LEVEL: None____ (SSL, TLS_MEM, HTTP_CLIENT, HTTP_SERVER, ..., CORE, WIFI, UPDATER, OTA, OOM, ...)
- EXCEPTIONS: disabled (enabled)
- VTABLES: flash (heap, iram)
- SSL: all (basic)
- WIPE: none  (sdk, all)
- UPLOAD_SPEED: 921600 (9600, 57600, 115200, 230400, 460800, 512000)
- UPLOAD_VERBOSE: quiet
- SPIFFS_DIR: data
- SPIFFS_IMAGE: spiffs.img

targets:
- fs: creates $(SPIFFS_IMAGE)
- upload-fs: writes $(SPIFFS_IMAGE) to flash

### esp32 variables and targets

- UPLOAD_SPEED: 921600
- FLASH_FREQ: 80
- SPIFFS_DIR: data
- SPIFFS_IMAGE: spiffs.img

targets:
- fs
- upload-fs

### msp430 and tivac variables

- SKETCHBOOK: ~/Energia
- SERIAL_PORT: /dev/ttyACM0

## Credits

- elpaso's [Makefile](https://github.com/elpaso/energia-makefile) for msp430 provided inspiration.
- attiny support is largely due to SpenceKonde's [ATTinyCore](https://github.com/SpenceKonde/ATTinyCore)
