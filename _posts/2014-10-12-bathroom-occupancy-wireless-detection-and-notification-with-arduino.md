---
layout: default
title: Bathroom Occupancy Remote Awareness Technology with Arduino
---

My company, with all of it's 35 people, recently moved into a new office which was equipped with only two private bathrooms, separated by a floor.

A few times a day, when I'd really have to go, I would go to one of the bathrooms, find it's door locked, then run upstairs, find the other one locked too.. Damn! Come back down, only find someone that else just took the first bathroom, while I was upstairs knocking.

You can see how this can get pretty inefficient and frustrating once or twice, but now multiply this by every work day, and 35 employees, and you have a problem.

Given my foray into Arduino over the last few months, I knew I could probably come up with a solution. I got approved for a small budget of about $200, and started looking around.

### Formulating the Problem

The problem was very simple: people needed to know when each bathroom was occupied, or not.  Just like on the airplane you see bathroom light on/off, I wanted something like that for our two bathrooms. Something everyone could see.

#### Communicating Occupancy Status

<div class="full">
    <img src="https://raw.githubusercontent.com/kigster/Borat/master/images/real-life-examples/borat-at-wanelo.jpg"
        alt="Bathroom Occupancy Wireless Notification Arduino-based System" title="Live on the wall at work"/>
</div>
<br />

By that time I was playing with a couple of [Rainbowduinos](http://www.amazon.com/Rainbowduino-LED-Driver-Platform-Atmega328/dp/B0068JYK0I?_encoding=UTF8&tag=kiguino-20),
which were driving one [8x8 LED Matrix displays](http://www.amazon.com/Super-Bright-RGB-LED-matrix/dp/B0068K01QE/?_encoding=UTF8&tag=kiguino-20), and I was pretty impressed with the results. I almost immediately knew I wanted to use these to indicate the status of occupancy. Initially I thought – green matrix means bathroom is available, red means occupied.  I pretty much went with this for the final version, although I added some
[lava-lamp like animations](https://github.com/kigster/Borat/blob/master/firmware/DisplayLED/DisplayLED.ino) to make things more interesting :)

#### Detecting Occupancy Status

This is where things got more tricky.

I brainstormed with a few folks many-o-options. We talked about:

* Detecting status of door lock – which would have been great, but required changing/munging door locks in a rented building, and possibly running electric wire to/from door handle. Possible fire danger, or electrocuting people while they grab handle, are just some of the undesired side-effects.
* I saw some projects online where people used magnetic strips to detect if the door is simply closed or open.  But this requires everyone to leave the door open when they leave – not realistic!
* Same is relying on the light sensor alone: easy/cheap – yes, reliable no!  Not only that, but our exhaust is connected to the light, so people often leave light on deliberately to keep the fan going.

It was clear to me that a combination system was needed: something that not only relied on light, or motion sensor, for example, but a combination of sensors.  Pretty soon, I settled on using just these three:

* Light sensor
* Motion sensor
* Sonar distance sensor

#### Communication

This part was easy – I picked up a few [nRF24L01+ radios](http://www.amazon.com/nRF24L01-Wireless-Transceiver-Arduino-Compatible/dp/B00E594ZX0/?_encoding=UTF8&tag=kiguino-20) for very cheap. An excellent [communications library](http://maniacbug.github.io/RF24/) was some of the best Arduino C++ code I've seen so far, and instilled confidence.

At this point I had my pieces and was ready to proceed with the implementation.

{{site.data.macros.continue}}
___


## Solution

<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-display/DisplayUnit-0.jpg" alt="" title=""
class="small-right">

Enter the project (all of which is open sourced under MIT License), that took good month over a few nights and weekends this summer: [BORAT: Bathroom Occupancy Remote Awareness Technology](https://github.com/kigster/borat). BORAT is an Arduino-based toilet occupancy notification system, that uses inexpensive wireless radios (nRF24L01+) to communicate occupancy status of one or more bathrooms, to the main display unit located in a highly visible area.

You may be asking – why in hell does the observer unit (which determines occupancy) need a sonar?  Well, if you are like me, you like to take your time when you are .. you know..  Perhaps I don't move very much, maybe I am reading my phone, and so the motion sensor would eventually give up and give green light.  This is where Sonar comes in.  Aimed directly at someone sitting on the toilet, Sonar will read a different distance with a person there, versus without.  You can configure the threshold after installing Observer, and vola!  Near 100% accuracy!  Is it creepy, to have a 2-eyed robot staring at you in the bathroom? I'll leave that to the reader :)

My company can't live without this technology now.  I took a unit home one night to fix it, and forgot to bring it back.. The next day everyone I'd bump into was asking "Where is BORAT?.. What happened?".  Hilarious, and amazing how quickly humans get used to things that are actually useful.

### Deep Dive

BORAT consists of two logical units:

1. Multiple __Observer Units__, installed in each bathroom, each is based on the set of three sensors, a knob and an LCD serial port for on-premises configuration of the unit, and a wireless nRF24L01+ radio card.  Up to 5 observer units are supported (this is a limitation of the radio).

2. The __Display Unit__, which uses LED Matrices to display status of each bathroom occupancy. This unit can be additionally (and optionally) equipped with an Ethernet shield, in which case a small HTTP web server is started, and reports occupancy status over a simple JSON API.

Here is a diagram that explains various placement options and overall concept.

<div class="full">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/concept/layout-diagram.png" alt="Concept Diagram" title="Concept Diagram">
</div>
<br />

Remember, communication is wireless.  These little cards are pretty damn impressive, they get through several walls, or pretty good distances (50-100feet) when used across line of sight.  I did have to move the display unit once, from a place that had 3 walls separating it from the Observers, to 2 walls, and now it's flawless. With 3 walls in between it was spotty.

## Observer Units

### Logic

Observers are responsible for communicating a binary status to the display unit: either __occupied__, or __available__.  Display unit also has third status: __disconnected__, for each observer unit. But Observers don't have that.

How do Observers determine if the bathroom is occupied? Based on the following logic:

1. If the light is off, the bathroom is available
2. If the light is on, we look at the motion sensor - if it detected movement within the last 15 seconds, we consider bathroom occupied
3. If the motion sensor did not pick up any activity in the last 15 seconds, we then look at Sonar reading.
  * If Sonar (which is meant to be pointed at the toilet) is reading distance above a given threshold, that means nobody is sitting there, and so the bathroom is occupied.
  * Otherwise it's available.

That's it!

All settings and thresholds, including timeouts, are meant to be tweaked individually for each bathroom. This is why Observer unit contains a [rotary encoder knob](http://www.amazon.com/Rotary-Encoder-Development-Arduino-Compatible/dp/B00HSWXMDK/?_encoding=UTF8&tag=kiguino-20), and a connector for external serial port, meant to be a Serial LCD Display used only to configure the device, but not after.

Below diagram shows components used in the Observer unit installed in each bathroom.

<div class="full">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/concept/observer-components.jpg" alt="Observer Components" title="Observer Components">
</div>
<br />

They are, for reference:

__Observer Unit__ (quantities per unit):

* 1 x [Arduino Nano](http://www.amazon.com/gp/product/B00761NDHI?ie=UTF8&camp=1789&creativeASIN=B00761NDHI&linkCode=xm2&tag=kiguino-20) (I chose older Nano because of the Nano IO Shield that saved me wiring up the RF24 radio, as well as had breakouts for sensors – very convenient)
* 1 x [Arduino Nano IO Shield](http://www.amazon.com/gp/product/B00BD6KEYC?ie=UTF8&camp=1789&creativeASIN=B00BD6KEYC&linkCode=xm2&tag=kiguino-20)
* 1 x [nRF24L01+ radio](http://www.amazon.com/nRF24L01-Wireless-Transceiver-Arduino-Compatible/dp/B00E594ZX0/?_encoding=UTF8&tag=kiguino-20)
* 1 x [Sonar HC-SR04 Distance Sensor](http://www.amazon.com/gp/product/B00E0NXTJW?ie=UTF8&camp=1789&creativeASIN=B00E0NXTJW&linkCode=xm2&tag=kiguino-20)
* 1 x [Photo Resistor](http://www.amazon.com/gp/product/B00AQVYWA2?ie=UTF8&camp=1789&creativeASIN=B00AQVYWA2&linkCode=xm2&tag=kiguino-20)
* 1 x [Infrared PIR Motion Sensors](http://www.amazon.com/gp/product/B008AESDSY?ie=UTF8&camp=1789&creativeASIN=B008AESDSY&linkCode=xm2&tag=kiguino-20)
* 1 x [Rotary Encoder Knob](http://www.amazon.com/Rotary-Encoder-Development-Arduino-Compatible/dp/B00HSWXMDK/?_encoding=UTF8&tag=kiguino-20)
* 1 x [RGB LEDs](http://www.amazon.com/gp/product/B005VMDROS?ie=UTF8&camp=1789&creativeASIN=B005VMDROS&linkCode=xm2&tag=kiguino-20) for status communication
* 1 x [Microtivity Prototyping Board, 5x7cm](http://www.amazon.com/gp/product/B007K7I8CI?ie=UTF8&camp=1789&creativeASIN=B007K7I8CI&linkCode=xm2&tag=kiguino-20)
* 1 x [Female port for JST 3-wire cable](http://www.amazon.com/gp/product/B007R9TUUS?ie=UTF8&camp=1789&creativeASIN=B007R9TUUS&linkCode=xm2&tag=kiguino-20)
* Many spacers, [# 4-40 nut](http://www.amazon.com/gp/product/B000FK9HH2?ie=UTF8&camp=1789&creativeASIN=B000FK9HH2&linkCode=xm2&tag=kiguino-20) and [#4-40 screws](http://www.amazon.com/dp/B00DD4AUE6/?ie=UTF8&camp=1789&creativeASIN=B000MN6RAM&linkCode=xm2&tag=kiguino-20), also [M2 sizes](http://www.amazon.com/gp/product/B000FN1XDA?ie=UTF8&camp=1789&creativeASIN=B000FN1XDA&linkCode=xm2&tag=kiguino-20)


### Configuring using LCD and Rotary Encoder Knob

To make changes visible to the user of the Observer module, one must have a Serial LCD display to show the feedback and new values. I found Sparkfun LCD to be very easy to use and reliable, and I have been converting most of my Arduino projects to report status data on that serial port.  Very useful!

Here is a picture of one of the observer units attached to a debugging console (16x2 LCD Display), which is communicated with via a Serial cable.  The LCD is optional and can be plugged in/out at any time.

<div class="small">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Configuration-via-SerialLCD.jpg" alt="Configuring a Sensor" title="">

<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Module-3-Knob.jpg" alt="Configuring a Sensor" title="">
<p style="clear:both;">
</div>

The settings that can be changed are (and are cycled through by pressing the button):

1. _Light sensitivity_ (between 0 and 1023): light reading below the threshold will be considered "dark" and will render the overall status as "unoccupied".
2. _IR Sensor Delay_: this is a delay in milliseconds that "blocks" any reading of the motion sensor after any change was detected (this is so that it does not flicker). Typically set to 5000ms it means that once motion is detected, motion sensor reading is considered as positive for this long regardless of what the sensor actually reports.
3. _Sonar Distance_ (in cm): distance threshold used to decide if Sonar is detecting someone or not.  Values less than threshold are positive (detect), large than threshold are negative (unoccupied).
4. _Exit Timout_ (in seconds): if the light was left on, and we detected occupancy, but no longer do – how long should we consider the room still occupied?  If you make this number too small, the overall status will flicker as various sensors are triggered, but then released. Setting this to 10-30 seconds is reasonable.  Remember, if bathroom user turns off the light, the timeout is not used.
5. _Save Settings?_ Defaults to NO, but if YES is chosen, we save parameters to EEPROM, so even if the unit reboots they persist and are used moving forward by that unit.
6. _Disable Radio?_ Sometimes it's convenient to configure the sensors alone, without the unit attempting to connect to the mothership – the display unit.  Set that to YES and radio will temporarily deactivate. This is not saved to EEPROM.

#### Observer Module Design and Enclosure

Over the last few months I built three separate Observer modules, the first two of them had Sonar built into the laser-cut enclosure, so to aim Sonar you would have to move the entire enclosure.

By the way, need to make some laser-cut boxes?  Check out [MakerBox.io](http://makerbox.io) – the tool I built after getting frustrated with the crowd favorite – BoxMaker. But that's another blog post.

Since it is not practical to be tilting or leaning the enclosure itself to aim at the toilet, I updated the design, and moved the Sonar sensor to the top of the box, using an arm I designed.  It's incredible what can be done in 2D, and then turned into a 3D object!

<img src="/images/laser-cut-johnny5.jpg" alt="" title="" class="small-right">

The new arm allows movement using three degrees of freedom. This design is clearly more flexible and can adapt to various locations much better then the previous ones.

The template files inside the enclosure folder of the project contain designs for the boxes, as well as the arm. Feel free to use them! By laser-cutting these parts you too can assemble BORAT boxes and the Sonar ARM.

In fact, I had a little fun and made this [Johnny Five](http://en.wikipedia.org/wiki/Short_Circuit) looking dude, but this has *absolutely nothing to do with this project* :)  It is cute though, you must agree. Helpless, but cute.

<div style="clear:both; margin-bottom: 30px;"></div>

#### Early Boxes with Fixed Sonar

<div class="small">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Final-SinglePCB-HandMade.jpg">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Final-Nano-Shield.jpg">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-WoodenPanel-Prototype.jpg" alt="Configuring a Sensor">
<p style="clear:both; margin-bottom: 20px;">
</div>

#### Flexible Arm Designs

<div class="small">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Module-3-Front.jpg">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Module-3.jpg">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Module-3-Side.jpg">
<p style="clear:both; margin-bottom: 20px;">
</div>

## Display Module

The _Display_ unit can be certainly implemented in a variety of ways. I chose to use:

* 2 x [8x8 LED Matrices](http://www.amazon.com/gp/product/B007ZK4I10?ie=UTF8&camp=1789&creativeASIN=B007ZK4I10&linkCode=xm2&tag=kiguino-20)
* 2 x [Rainbowduinos](http://www.amazon.com/gp/product/B0068JYK0I?ie=UTF8&camp=1789&creativeASIN=B0068JYK0I&linkCode=xm2&tag=kiguino-20), programmed with the _DisplayLED_ sketch
* 1 x [Primary Arduino Uno](http://www.amazon.com/gp/product/B006H06TVG?ie=UTF8&camp=1789&creativeASIN=B006H06TVG&linkCode=xm2&tag=kiguino-20) (which acts as the master for the Rainbowduinos) listens on the wireless network notifications, and based on this information sends one of three possible states to each of the Rainbowduino units (which are assigned to rooms)
* 1 x [Arduino Prototyping Shield](http://www.amazon.com/gp/product/B007QXTRNA?ie=UTF8&camp=1789&creativeASIN=B007QXTRNA&linkCode=xm2&tag=kiguino-20)
* 1 x [RGB LED](http://www.amazon.com/gp/product/B005VMDROS?ie=UTF8&camp=1789&creativeASIN=B005VMDROS&linkCode=xm2&tag=kiguino-20) for status
* 1 x [Ethernet Shield](http://www.amazon.com/gp/product/B006UT97FE?ie=UTF8&camp=1789&creativeASIN=B006UT97FE&linkCode=xm2&tag=kiguino-20) for JSON server
* Several patch cables
* Custom made laser-cut enclosure
* Spacers, #4-40 nuts and bolts

Primary way the display unit informs users is via two sets of LED Matrices, shown below.

<div class="small">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-display/DisplayUnit-1.jpg">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-display/DisplayUnit-2.jpg">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-display/DisplayUnit-3.jpg">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-display/DisplayUnit-4.jpg">
<img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-display/DisplayUnit-5.jpg">
<div style="clear:both; margin-bottom: 20px;"></div>
</div>

## Conclusion

What's the morale of the story?  Who am I kidding.

It sure is nice to know without getting up from your desk, if you can or can not use the restroom, when they are in limited supply.

Could have this been done cheaper?  Absolutely!  Smaller?  Definitely!

Want to help me design PCB board to make the next Observer Unit?  Please get in touch!  [Create an issue on GitHub](https://github.com/kigster/Borat/issues/new), and describe your idea, and I'll make sure to respond asap.

Also – please leave comments, feedback, suggestions.. All of those nice things.

<p>Thanks for reading,<br />
–– Konstantin.
</p>








