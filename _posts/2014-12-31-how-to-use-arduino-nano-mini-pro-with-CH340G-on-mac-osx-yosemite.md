---
layout: default
title: How to use cheap Chinese Arduinos that come with with CH340G / CH341G Serial/USB chip
---

My golden rule is that if something took me longer than 15 minutes to figure out, then it's worth documenting in a tiny blog post so that it would save time to others, just like many other similar posts saved me million hours by providing simple clear instructions.

## To the point

<div class="small-right">
<a href="/images/nano-ch340g-bottom.jpg" data-lightbox="kiguino" data-title="Bottom of the Arduino Nano clone with the CH340G chip">
	<img src="/images/nano-ch340g-bottom.jpg"/>
</a>
</div>

Recent versions of Chinese cheap [clones of Arduino boards](http://www.ebay.com/itm/381019048475) have been coming with a different USB/Serial chip, which replaces the usual FTDI. I read somewhere that licensing costs of FTDI make it prohibitive to companies selling boards for as little as $3, so I assume this is the main motivation. To be honest, as long as I can talk to my Arduino and buy it for $3 a piece, who cares? :)

## Download the driver


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

## Install it


* Download the driver (see above)
* Double click the ZIP file do unzip it
* Open the folder ~/Downloads/CH341SER_MAC
* Run installer found in that folder
* If asked to restart, do not restart just yet.
* This next step is only needed if you are on OS-X Yosemite. For older versions of OS-X you do not need it:
  * Open Terminal Application (it's located in /Application/Utilities) and type this command once you see a prompt: 
  * ```sudo nvram boot-args="kext-dev-mode=1"```
  * See [this post](http://www.cindori.org/enabling-trim-on-os-x-yosemite/) if you 
    wish to know why we need to run this command.  I believe you need to do this because the driver is not signed properly, or is simply too old for Yosemite. Hopefully newer versions won't require this step and will automatically become enabled.
* Now restart your Mac

## Usage

If the driver properly loaded, you should see the device in you /dev folder (this is for advanced command-line users of OSX only).  On my machine it was called ```/dev/cu.wchusbserial1441140```

This port is showing up correctly in Arduino 1.0.6 and Arduino 1.5.8.

However, if you are using the Eclipse Plugin, it is not smart enough to list this port in the list of available serial ports (either in project properties, or in the serial monitor).  You will have to type the entire thing yourself: ```/dev/cu.wchusbserial1441140``` and then Eclipse can upload your sketch.

That's it! You should be ready to use the drivers and the board.


## Some Time Savers

Now, this is technically not related to the Chinese USB driver, I wanted to share a method that I use to connect to a Serial port of any Arduino I am using at any given moment.  This method has a caveat, in that if you have more than one Arduino connected, it will pick one of them at random.

### Motivation

I always hate Serial port windows.  They do not automatically reconnect, and if they try (Eclipse) they don't always work (Teensy). So I went searching for a reliable solution that will automatically reconnect after loosing a connection.

I found it! It's called minicom! 

* If you are command-line savvy, then install or use [HomeBrew](http://brew.sh/), then ```brew install minicom```
* Alternatively, [Download Minicom Here](http://mac.softpedia.com/get/Developer-Tools/Minicom.shtml#download)
* In Terminal (or iTerm2 if you are awesome) test running ```minicom --version```

This is what I get:

```bash
minicom version 2.7 (compiled Oct 20 2014)
```

Now add the following [BASH function](http://tldp.org/LDP/abs/html/complexfunct.html) to your ```~/.bashrc``` or ```~/.bash_profile``` files:

```bash
function console {
  modem=`ls -1 /dev/cu.* | grep -vi bluetooth | tail -1`
  baud=${1:-9600}
  if [ ! -z "$modem" ]; then
    minicom -D $modem  -b $baud
  else
    echo "No USB modem device found in /dev"
  fi
}
```

Then you can use it as follows – in Terminal type:

```bash
console
```

Or if using baud rate other than 9600:

```bash
console 115200
```

The function will find a serial device and connect MiniCom to it, which then automatically reconnects upon restart of your Arduino board.  Neat, eh? 

To stop this monitor, close the Terminal Window.

Enjoy!

## References

* [Arduino Forums](http://forum.arduino.cc/index.php?topic=261375.0)
* [http://www.5v.ru/ch340g.htm](http://www.5v.ru/ch340g.htm)
* [http://www.wch.cn/downloads.php?name=pro&proid=178](http://www.wch.cn/downloads.php?name=pro&proid=178)
* [http://www.cindori.org/enabling-trim-on-os-x-yosemite/](http://www.cindori.org/enabling-trim-on-os-x-yosemite/)