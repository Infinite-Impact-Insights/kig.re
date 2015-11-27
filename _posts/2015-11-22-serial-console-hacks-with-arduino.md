---
layout: page
title: Serial Console Hacks with Arduino
---

## Battling Console

I wanted to share a method that I use to connect to a Serial port of any Arduino I am using at any given moment.  This method has a caveat, in that if you have more than one Arduino connected, it will pick one of them at random.

### Motivation

I always hate Serial port windows.  They do not automatically reconnect, and if they try (Eclipse) they don't always work (Teensy). So I went searching for a reliable solution that will automatically reconnect after loosing a connection.

I found it! It's called minicom! 


{{site.data.macros.continue}}


### Minicom

* If you are command-line savvy, then install or use [HomeBrew](http://brew.sh/), then ```brew install minicom```
* Alternatively, [Download Minicom Here](http://mac.softpedia.com/get/Developer-Tools/Minicom.shtml#download)
* In Terminal (or iTerm2 if you are awesome) test running ```minicom --version```

This is what I get:

{% highlight bash linenos %}
minicom version 2.7 (compiled Oct 20 2014)
{% endhighlight %}

### BASH Magic

Now add the following [BASH function](http://tldp.org/LDP/abs/html/complexfunct.html) to your ```~/.bashrc``` or ```~/.bash_profile``` files:

{% highlight bash linenos %}
function console {
  modem=`ls -1 /dev/cu.* | grep -vi bluetooth | tail -1`
  baud=${1:-9600}
  if [ ! -z "$modem" ]; then
    minicom -D $modem  -b $baud
  else
    echo "No USB modem device found in /dev"
  fi
}
{% endhighlight %}

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
