Top-level includes
------------------
- arduino-tiny.mk
- arduino15.mk
- energia.mk
- arduino-esp.mk
- arduino-esp32.mk

Common include
--------------
- ucmk.mk

Platform includes
-----------------
- arduino.mk and targets-avr.mk
- msp430.mk
- lm4f.mk
- esp8266.mk
- esp32.mk

Note:
-----
- for Arduino, specify BOARD
- for Energia, specify BOARD _and _ PROCESSOR_FAMILY
