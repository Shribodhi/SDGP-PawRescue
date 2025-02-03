// TEST OLED
//
// ONLY TO BE USED WITH OLED 0.96" 128X64 DISPLAY - SSD1306 (see below fr connections)
// http://www.ebay.com/itm/0-96-I2C-IIC-SPI-Serial-128X64-White-OLED-LCD-LED-Display-Module-for-arduino-/182124690243?hash=item2a677a3b43:g:FgQAAOSwVC1XMH0y

// (c) Copyright Robert Brown 2014-2016. All Rights Reserved.
// The schematic, code and ideas for myGPS are released into the public domain. Users are free to implement these but
// may NOT sell this project or projects based on this project for commercial gain without express written permission
// granted from the author. Schematics, Code, Firmware, Ideas, Applications, Layout are protected by Copyright Law.
// Permission is NOT granted to any person to redistribute, market, manufacture or sell for commercial gain the myGPS
// products, ideas, circuits, builds, variations and units described or discussed herein or on this site.
// Permission is granted for personal and Academic/Educational use only.

#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_GFX.h>           // needed for OLED
#include "IIC_without_ACK.h"        // the two files .h and .cpp must be in the same folder as this file
#include "oledfont.c"               // must be in same folder as this file

#define OLED_SDA A4 // connected to SDA pin on OLED
#define OLED_SCL A5 // connected to SCL pin on OLED
// and connect OLED VCC pin to 5V and OLED GND pin to GND

IIC_without_ACK myoled(OLED_SDA, OLED_SCL);    // create OLED called myoled

char ProgramName[] = "myGPS-OLED";
char ProgramVersion[] = "0.0.1";
char ProgramAuthor[] = "(c) R BROWN 2016";


// Setup
void setup()
{
  // Setup the OLED
  myoled.Initial();
}

// Main Loop
void loop()
{
  // print startup screen, x, y
  // The screen size is 128 x 64, so using characters at 6x8 this gives 21chars across and 8 lines down
  myoled.Fill_Screen(0x00);    // clrscr OLED
  myoled.Char_F6x8(0, 0, "Hello");
  myoled.Char_F6x8(0, 2, "Welcome one and all");
  myoled.Char_F6x8(0, 3, "OLED Works!");
  delay(5000);
  myoled.Fill_Screen(0x00);    // clrscr OLED
  myoled.Char_F6x8(0, 0, "Goodbye");
  myoled.Char_F6x8(0, 2, "Farewell");
  myoled.Char_F6x8(0, 3, "Time to go");
  delay(5000);
}

