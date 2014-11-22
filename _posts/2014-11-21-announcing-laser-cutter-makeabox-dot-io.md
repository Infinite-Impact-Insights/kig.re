---
layout: default
title: Announcing LaserCutter ruby gem and MakeABox.IO web site!
---

<div class="small" style="float:right;">
<a href="/images/laser-cutter.jpg" data-lightbox="makeabox" data-title="laser-cutter via the command line">
	<img src="/images/laser-cutter.jpg"/>
</a>
</div>

I've been so damn busy with life, the universe, and everything (although mostly Work, The Wife, and The Cat), that I forgot to mention and properly introduce to the world [LaserCutter](https://github.com/kigster/laser-cutter) –– a ruby gem for generating notched box designs, saved as PDF, and meant to be used on a laser cutter.  The gem provides a command line tool that will generate a pretty PDFs based on your desired box dimensions.

In addition to the ruby gem, I put together a simple web front-end, called  [MakeABox.IO](http://makeabox.io/), which allows you and me to generate boxes without installing any gem, or running anything on the command line.  

*NOTE: The site may be a bit slow to load as it's running on a free tier on Heroku. If it gets good use, I'll throw in some extra dynos :)*

<div class="small" style="float:right;">
<a href="/images/makeabox.jpg" data-lightbox="makeabox" data-title="MakeABox.io">
	<img src="/images/makeabox.jpg"/>
</a>
</div>

If you've made any enclosures of your own, you probably used one of the existing / free tools out there. I did not find them all at once, but over the time the choice seemed to come down to:

* [Rahulbotics BoxMaker](https://github.com/rahulbot/boxmaker) –– Since I last checked, it seems it's been taken down, though the source code remains.  I used this tool to create about a dozen of my first laser-cut boxes ever.  Note that [Adam Phelps](https://github.com/aphelps) has a [sligtly better fork](https://github.com/aphelps/boxmaker).

* [MakerCase](http://www.makercase.com/) – Probably the most advanced online tool I've seen, even with visual preview, but I have not actually made any boxes using it.

* [Tabbed Box Maker – A plugin for InkScape](http://www.keppel.demon.co.uk/111000/111000.html) 

###  So, why a new library?
{{site.data.macros.continue}}



It came down to a simple fact that I was not at all happy with BoxMaker. It had lots of bugs; it's source code was difficult to read and modify, it produced non-symmetric designs –– including corner pieces that would sometimes be disconnected from the main shape –– and it had no automated tests!  

To top it off it was written in Java, which was the right choice back in 2001.. but we are not there anymore.

<div class="small" style="float:right;">
<a href="/images/makeabox-pdf.jpg" data-lightbox="makeabox" data-title="MakeABox.io">
	<img src="/images/makeabox-pdf.jpg"/>
</a>
</div>


So I embarked on writing my own, and as of a few weeks ago, is now feature complete as far as basic box making is concerned.  It's written in __ruby__, it has a __beautiful command line interface__, it's box cut out designs are __handsomly symmetric__, and all  of my recent boxes have been made using it. And yet, there is so much more that I want to do more with it in the future.

I will admit that the current incarnation of this library (version 1.0.3) contains a number of hacks. I am not particularly proud of the low Code Clime score, but I am planning a refactor before I do more with it.  The algorithmic part of this ended up being a bit tricky (surprise!), but the kinks are ironed out and the tests are there to prove it.

### Wait, you said "tests"? WTF!

Yes tests.  We, in the ruby world, can't take a shit without writing a test for it. Ruby is a dynamic language and makes test writing both fun and necessary. With tests, someone else can come and contribute to my library, because of the confidence tests provide that they won't break anything.  Well, *nearly* anything.  Not everything is as well tested as it should be, and I'll slap my own wrists sometime before bed. But some tests are infinitely better than none :)

### Tab (aka "notch") Geometry

<div class="small" style="float:right;">
<a href="/images/box-speakers.jpg" data-lightbox="makeabox" data-title="Speaker boxes made with MakeABox.io">
	<img src="/images/box-speakers.jpg"/>
</a>
</div>


One of the key components of laser cut boxes is the tabs that make two sides snap into each other, by using alternative in/out tabs on each side. The width of this tab has a lot to do with the way the box will ultimately look.  The default is to use 3 x material thickness, but feel free to experiment with other values. Note that notch width input field is treated as a guideline, and not a promised value. 

### Kerfing

When laser cuts the material it usually burns a small portion of it.  This creates a cut with a non-zero width, called __[kerf](http://www.cutlasercut.com/resources/tips-and-advice/what-is-laser-kerf)__. If your box design does not account for kerf, your box will fit loose.  The stronger the laser, the bigger the cut, the looser the fit.

To fix this issue, I added support for *kerf*. To my surprise it ended up a much larger project than I aniticipated. It was really hard to get Kerf work, because for tabs sticking out it has to add to them, but for the ones sticking in: substract. Long story short, this is now supported, and there is a default kerf value  that's applied to all boxes, unless overridden.

### Developing Enclosures

<div class="small" style="float:right;">
<a href="/images/omnipix-enclosure.jpg" data-lightbox="makeabox" data-title="OmniPix 32x32 LED Screen with SmartMatrix and Teensy, in a custom enclosure made using MakeABox.IO">
	<img src="/images/omnipix-enclosure.jpg"/>
</a>
</div>

My process typically revolves around the following steps:

1. Measure my components and decide on the internal box dimensions.
2. Generate the box using http://MakeABox.IO
3. Import the PDF into Adobe Illustrator
4. Add holes, joins, openings for switches, screens, knobs, power, etc. 
5. Sometimes I expand a two opposite facing sides to grow larger than the box in both dimensions, so that they end up "squeezing" the contents between them. The picture on the right is using this model: I build this enclosure for the [Adafruit 32x32 LED Matrix](https://www.adafruit.com/products/2026) powered by [SmartMatrix](http://docs.pixelmatix.com/SmartMatrix/) and [Teensy 3.1](https://www.pjrc.com/teensy/teensy31.html). 
6. Sometimes I make legs and a stand (you can see that on the speakers above – who likes to have speakers that can not aim in your direction? :) 

I've gotten pretty good at Illustrator, and these days it takes me anything from 10 minutes, to a couple of hours (for a complex project) to design an enclosure. Then of course I haul to Techshop and print it on their Epolog Laser Cutter, while swearing profusely. 

### Next Steps

I am planning on adding a few key features, namely:

* T-Slot joins support with a configurable screw size
* Oversized front/back panel that hide some of the notches (as on the picture above)
* Lids and support for hinges and locks
* Your great idea? :) 

### Open Source

My library, like most of the projects I am working on, are under MIT Open Source license.  I would love for you to fork it, fix it, add features to it, and submit a pull request!  I promise I will consider it in a timely fashion.

Let's make laser cutting enclosures fun for the whole family! (Or just for you :)

Please leave comments, suggestions, complaints and the answer to life, the universe, and everything.

–– KIG.
