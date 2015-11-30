---
layout: page
title: 'Scaling Web Applications on PostgreSQL pgConfSV 2015 presentation.'
---

## pgConf 2015 PostgreSQL Developer Conference in the Bay Area

I was very happy to have my submission accepted at the recent pgConfSV conference (where SV is for Sillicon Valley). For various reasons I did not cover everything I wanted, which is a note to self for any future public speaking engagement :).  Anyhow, below is an updated version of that presentation, which presents an incremental path to scaling multi-user concurrent web applications using PostgreSQL, while covering a very wide set of material.  

### Audience

I was intending for this prezo to be helpful for anyone trying to get a grasp on how to evolve a web application to where it's able to server 3-5K requests per second. This number is still far below what presumable the "giants" such as Facebook, Google, or Twitter get, but it is also far from a beginner application with just a few users.  Turns out it *is* possible to achieve high scalability on the cheap, and using PostgreSQL, which is what we did at Wanelo, and it turned out great.

### Presentation

<iframe src="//www.slideshare.net/slideshow/embed_code/key/yXKNCNdj1GNfE6" width="595" height="375" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong><a href="//www.slideshare.net/kigster/from-obvious-to-ingenius-incrementally-scaling-web-apps-on-postgresql" title="From Obvious to Ingenius: Incrementally Scaling Web Apps on PostgreSQL" target="_blank">From Obvious to Ingenius: Incrementally Scaling Web Apps on PostgreSQL</a> </strong> from <strong><a href="//www.slideshare.net/kigster" target="_blank">Konstantin Gredeskoul</a></strong> </div>

Thanks!