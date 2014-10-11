---
layout: default
title: Bathroom Occupancy Remote Awareness Technology with Arduino
---

## Problem

My company, which has 35 people, recently moved into a new office which was equipped with only two private bathrooms, separated by a floor.  So you would have to go to one bathroom, find it locked, then go upstairs, find the other one locked too.. come back down, only find someone else just took the lower one.  You can see how this can get pretty inefficient and frustrating, especially since bathrooms are separated.

Given my foray into Arduino over the last few months, I knew there was a solution.

## Solution

Enter [BORAT: Bathroom Occupancy Remote Awareness Technology](https://github.com/kigster/borat). BORAT is an Arduino-based toilet occupancy notification system, that uses inexpensive wireless radios (nRF24L01+) to communicate occupancy status of one or more bathrooms, to the main display unit, which would be typically located in a common highly visible area.

Here is how it looks on our wall – the LED matrices are so bright you can see it from any part of the office.

<div style="width: 100%; text-align: center">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/real-life-examples/borat-at-wanelo.jpg" alt="Bathroom Occupancy Wireless Notification Arduino-based System" title="Live on the wall at work" style="border: 1px solid black; max-width: 500px; text-align: center;">
</div><br />

You may be asking – why in hell does the observer unit (which determines occupancy) need a sonar?  Well, if you are like me, you like to take your time when you are .. you know..  Perhaps I don't move very much, maybe I am reading my phone, and so the motion sensor would eventually give up and give green light.  This is where Sonar comes in.  Aimed directly at someone sitting on the toilet, Sonar will read a different distance with a person there, versus without.  You can configure the threshold after installing Observer, and vola!  Near 100% accuracy!  Is it creepy, to have a 2-eyed robot staring at you in the bathroom? I'll leave that to the reader :)

My company can't live without this technology now.  I took a unit home one night to fix it, and forgot to bring it back.. Ugh.  I won't do *that* again! :)

## Deep Dive

BORAT consists of two logical units:

1. __Observer Unit__, installed in each bathroom, is based on the set of three sensors, a knob and an LCD serial port for on-premises configuration of the unit, and a wireless nRF24L01+ radio card.  Up to 5 observer units are supported (this is a limitation of the radio).

2. The __Display Unit__, which uses LED Matrices to display status of each bathroom occupancy. This unit can be additionally (and optionally) equipped with an Ethernet shield, in which case a small HTTP web server is started, and reports occupancy status over a simple JSON API.

Here is a diagram that explains overall placement and concept.

<div style="width: 100%; text-align: center">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/concept/layout-diagram.png" alt="Concept Diagram" title="Concept Diagram" style="border: 1px solid black; max-width: 600px; text-align: center;">
</div><br />

### Sensor Logic of the Observers

How do Observers determine if the bathroom is occupied? Here's how.

1. If the light is off, bathroom is unoccupied
2. If the light is on, we look at the motion sensor - if it detected movement within the last 15 seconds, we consider bathroom occupied.
3. If the motion sensor did not pick up any activity in the last 15 seconds, we then look at Sonar reading. If Sonar (which is meant to be pointed at the toilet) is reading distance above a given threshold, that means nobody is sitting there, and so the bathroom is occupied. Otherwise it's available.

That's it!

All settings and thresholds, including timeouts, are meant to be tweaked individually for each bathroom. This is why Observer unit contains a rotary encoder knob, and a connector for external serial port, meant to be a Serial LCD Display used only to configure the device, but not after.

Below diagram shows components used in the Observer unit installed in each bathroom.

<div style="width: 100%; text-align: center">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/concept/observer-components.jpg" alt="Observer Components" title="Observer Components" style="border: 1px solid black; max-width: 600px; text-align: center;">
</div><br />


### Display Unit

<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-display/DisplayUnit-0.jpg" alt="" title=""
style="height: 250px; margin-left: 30px; float: right; border: 1px solid black;">

The _Display_ unit can be certainly implemented in a variety of ways. I chose to use 2 sets of 8x8 LED Matrices, each attached to a Rainbowduino, programmed with _DisplayLED_ sketch.  Additional Arduino Uno (which acts as the master for the Rainbowduinos) listens on the wireless network notifications, and based on this information sends one of three possible states to each of the Rainbowduino units (which are assigned to rooms).

#### Configuration

To make changes visible to the user of the Observer module, one must have a Serial LCD display to show the feedback and new values. I found Sparkfun LCD to be very easy to use and reliable, and I have been converting most of my Arduino projects to report status data on that serial port.  Very useful!

Here is a picture of one of the observer units attached to a debugging console (16x2 LCD Display), which is communicated with via a Serial cable.  The LCD is optional and can be plugged in/out at any time.

<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Configuration-via-SerialLCD.jpg" alt="Configuring a Sensor" title=""
style="width: 370px; float: left; border: 1px solid black;">

<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Module-3-Knob.jpg" alt="Configuring a Sensor" title=""
style="width: 370px; float: right; border: 1px solid black;">
<p style="clear:both;">

The settings that can be changed are (and are cycled through by pressing the button):

1. _Light sensitivity_ (between 0 and 1023): light reading below the threshold will be considered "dark" and will render the overall status as "unoccupied".
2. _IR Sensor Delay_: this is a delay in milliseconds that "blocks" any reading of the motion sensor after any change was detected (this is so that it does not flicker). Typically set to 5000ms it means that once motion is detected, motion sensor reading is considered as positive for this long regardless of what the sensor actually reports.
3. _Sonar Distance_ (in cm): distance threshold used to decide if Sonar is detecting someone or not.  Values less than threshold are positive (detect), large than threshold are negative (unoccupied).
4. _Exit Timout_ (in seconds): if the light was left on, and we detected occupancy, but no longer do – how long should we consider the room still occupied?  If you make this number too small, the overall status will flicker as various sensors are triggered, but then released. Setting this to 10-30 seconds is reasonable.  Remember, if bathroom user turns off the light, the timeout is not used.
5. _Save Settings?_ Defaults to NO, but if YES is chosen, we save parameters to EEPROM, so even if the unit reboots they persist and are used moving forward by that unit.
6. _Disable Radio?_ Sometimes it's convenient to configure the sensors alone, without the unit attempting to connect to the mothership – the display unit.  Set that to YES and radio will temporarily deactivate. This is not saved to EEPROM.

#### Observer Module Design and Enclosure

Over the last few months I built three separate Observer modules, the first two of them had Sonar built into the laser-cut enclosure, so to aim Sonar you would have to move the entire enclosure.

Since it is not practical to be tilting or leaning the enclosure itself to aim at the toilet, I updated the design, and moved the Sonar sensor to the top of the box, using an arm I designed.  It's incredible what can be done in 2D, and then turned into a 3D object!

<img src="/images/laser-cut-johnny5.jpg" alt="" title=""
style="height: 400px; margin-left: 40px; float: right;">

The new arm allows movement using three degrees of freedom. This design is clearly more flexible and can adapt to various locations much better then the previous ones.

The template files inside the enclosure folder of the project contain designs for the boxes, as well as the arm. Feel free to use them! By laser-cutting these parts you too can assemble BORAT boxes and the Sonar ARM.

In fact, I had a little fun and made this [Johnny Five](http://en.wikipedia.org/wiki/Short_Circuit) looking dude :)

<p style="clear:both; margin-bottom: 30px;">

#### Early Boxes with Fixed Sonar

<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Final-SinglePCB-HandMade.jpg" alt="" title=""
style="height: 200px; margin-right: 20px; float: left;">

<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Final-Nano-Shield.jpg" alt="" title=""
style="height: 200px; margin-right: 20px; float: left;">

<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-WoodenPanel-Prototype.jpg" alt="Configuring a Sensor" title=""
style="height: 200px; margin-right: 20px; float: left;">
<p style="clear:both; margin-bottom: 30px;">

#### Flexible Arm Designs

<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Module-3-Front.jpg" alt="" title=""
style="height: 200px; margin-right: 20px; float: left;">

<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Module-3.jpg" alt="" title=""
style="height: 200px; margin-right: 20px; float: left;">

<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Module-3-Side.jpg" alt="" title=""
style="height: 200px; margin-right: 20px; float: left;">

<p style="clear:both;">


## Display Module

Primary way the display unit informs users is via two sets of LED Matrices, shown below.

<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-display/DisplayUnit-1.jpg" alt="" title=""
style="height: 170px; margin-right: 20px; float: left;">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-display/DisplayUnit-2.jpg" alt="" title=""
style="height: 170px; margin-right: 20px; float: left;">

<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-display/DisplayUnit-3.jpg" alt="" title=""
style="height: 170px; margin-right: 20px; float: left;">

<p style="clear:both; margin-bottom: 40px;">

<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-display/DisplayUnit-4.jpg" alt="" title=""
style="height: 170px; margin-right: 20px; float: left;">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-display/DisplayUnit-5.jpg" alt="" title=""
style="height: 170px; margin-right: 20px; float: left;">
<p style="clear:both; margin-bottom: 40px;">

