---
layout: page
title: How to use cheap Chinese Arduinos that come with with CH340G / CH341G Serial/USB chip
---
_Updated Nov 22, 2015 with the new signed driver for OS-X El Capitan and Yosemite_

My golden rule is that if something took me longer than 15 minutes to figure out, then it's worth documenting in a tiny blog post so that it would save time to others, just like many other similar posts saved me million hours by providing simple clear instructions.

# Why This Exists?

<div class="small-right">
<a href="/images/nano-ch340g-bottom.jpg" data-lightbox="kiguino" data-title="Bottom of the Arduino Nano clone with the CH340G chip">
	<img src="/images/nano-ch340g-bottom.jpg"/>
</a>
</div>

Recent versions of Chinese cheap [clones of Arduino boards](http://www.ebay.com/itm/381019048475) have been coming with a different USB/Serial chip, which replaces the usual FTDI. I read somewhere that licensing costs of FTDI make it prohibitive to companies selling boards for as little as $3, so I assume this is the main motivation. To be honest, as long as I can talk to my Arduino and buy it for $3 a piece, who cares? :)

# New Driver! 

Many instructions farther down below were written for the old driver, which was not signed, and therefore was not working out of the box on OS-X Yosemite and El Capitan. The latest driver appears to be signed, and should work out the box. The new driver is here: [CH34x_Install.zip (111Kb)](/downloads/CH34x_Install.zip).

<div style="font-size: 8pt; margin: 20px; padding: 20px; border: 1px solid black; font-decorations: italic;">Acknowledgements: thanks to <a href="[http://blog.sengotta.net/signed-mac-os-driver-for-winchiphead-ch340-serial-bridge/" target="_blank">Björn's Techblog</a> for posting the driver.</div>

Inside the driver is a brief README with the following instructions:


{{site.data.macros.continue}}


#### README

    CH34X USB-SERIAL DRIVER INSTALLATION INSTRUCTIONS
    Version: V1.0 Copyright (C) Jiangsu Qinheng Co., Ltd.
    Support System: OSX 10.9 and above

    Installation Process:
    - Extract the contents of the zip file to a local installation directory
    - Double-click CH34x_Install.pkg
    - Install according to the installation on procedure
    - Restart after finishing installing

    After the installation is completed, you will find serial device in the device
    list(/dev/tty.wchusbserial*), and you can access it by serial tools.

    If you can’t find the serial port then you can follow the steps below:
      1. Open terminal and type ‘ls /dev/tty*’ ande see is there device like tty.wchusbserial;
      2. Open ‘System Report’->Hardware->USB, on the right side “USB Device Tree” there will
         be device named “Vendor-Specific Device” and check if the Current is normal.
         If the steps upper don’t work at all, please try to install the package again.

    Note: Please enter System Preferences ➜ Security & Privacy ➜ General, below the
    title "Allow apps downloaded from:" you should choose the choice 2 ➜ "Mac App Store and
    identified developers" so that our driver will work normally.

<hr/>

# The Older Version of the Driver

This older version requires some hacking in order to get it to work.  I am leaving instructions just in case someone needs it, or the new driver does not work for someone.


### Download the driver

There are two main sites that people mention in the discussions about the driver:

* Chinese company that developed it: http://www.wch.cn/downloads.php?name=pro&proid=178
  * This driver appears newer than on the second link, and is from Dec 2013.
  * Note: for me that site took a long long time to load, and then it took forever to download this tiny driver, so I put up a copy here [CH341SER_MAC.ZIP (256Kb)](/downloads/CH341SER_MAC.ZIP), so that you don't have to wait. Hopefully they won't go after me for mirroring their driver :) 
* Second site is the Russian company that sells the USB programmer based on this chip: http://www.5v.ru/ch340g.htm but this site only has an older version of the driver, from 2012, so I do not recommend downloading it.

<div class="small-right">
<a href="/images/nano-ch340g-top.jpg" data-lightbox="kiguino" data-title="Top of the Arduino Nano">
	<img src="/images/nano-ch340g-top.jpg"/>
</a>
</div>


### Pre-Installation

Note: the following pre-installation steps are only required on the two most recent versions of OS-X Yosemite and El Capitan. It is because the driver is not signed properly from Apple's perspective. We are waiting on the developer to update the driver so that these pre-installation steps are no longer needed.

#### OS-X El Capitan Steps

* Reboot and press **⌘-R** immediately after the chime to enter Recovery Mode
* Open Terminal from the recovery mode
* run the command ```csrutil enable --without kext```
* Reboot.

<div style="font-size: 8pt; margin: 20px; padding: 20px; border: 1px solid black; font-decorations: italic;">Acknowledgements: thanks to <a href="http://tzapu.com/2015/09/24/making-ch340-ch341-serial-adapters-work-under-el-capitan-os-x/" target="_blank">this post</a> for these instructions.</div>

#### OS-X Yosemite Steps

* Open Terminal Application (it's located in /Application/Utilities) and type this command once you see a prompt: 
* ```sudo nvram boot-args="kext-dev-mode=1"```
* Reboot.

<div style="font-size: 8pt; margin: 20px; padding: 20px; border: 1px solid black; font-decorations: italic;">
Acknowledgements: see <a href="http://www.cindori.org/enabling-trim-on-os-x-yosemite/" target="_blank">this post</a> if you 
wish to know more details.</div>

### Installation

* Download the driver from here: [CH341SER_MAC.ZIP (256Kb)](/downloads/CH341SER_MAC.ZIP)
* Double click the ZIP file do unzip it
* Open the folder ~/Downloads/CH341SER_MAC
* Run installer found in that folder
* Restart when asked.

### Usage

If the driver properly loaded, you should see the device in you /dev folder (this is for advanced command-line users of OSX only).  On my machine it was called ```/dev/cu.wchusbserial1441140```

This port is showing up correctly in Arduino 1.0.6 and Arduino 1.5.8.

However, if you are using the Eclipse Plugin, it is not smart enough to list this port in the list of available serial ports (either in project properties, or in the serial monitor).  You will have to type the entire thing yourself: ```/dev/cu.wchusbserial1441140``` and then Eclipse can upload your sketch.

That's it! You should be ready to use the drivers and the board.

## References

* [Arduino Forums](http://forum.arduino.cc/index.php?topic=261375.0)
* [http://www.5v.ru/ch340g.htm](http://www.5v.ru/ch340g.htm)
* [http://www.wch.cn/downloads.php?name=pro&proid=178](http://www.wch.cn/downloads.php?name=pro&proid=178)
* [http://www.cindori.org/enabling-trim-on-os-x-yosemite/](http://www.cindori.org/enabling-trim-on-os-x-yosemite/)
