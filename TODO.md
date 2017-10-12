- use include path 
  (check http://blog.jgc.org/2007/01/what-makefile-am-i-in.html)
- read ~/{.arduino15, .energia15}/preferences.txt for defaults
- esp core: currently gets to link stage then bombs out:
    ld: WifiWeatherGuy.elf section `.text' will not fit in region `iram1_0_seg'
- handle multiple .ino files
