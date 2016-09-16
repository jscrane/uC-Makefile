Top-level includes
------------------
- arduino-tiny.mk
- arduino15.mk
- energia.mk

Common include
--------------
- ucmk.mk

Platform includes
-----------------
- arduino.mk and targets-avr.mk
- msp430.mk
- lm4f.mk

Note:
- for Energia, specify PROCESSOR_FAMILY and BOARD
- for Arduino, specify only BOARD
- should include PROCESSOR_FAMILY in both cases
