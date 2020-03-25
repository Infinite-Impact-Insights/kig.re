---
layout: post
title: "Scaling Web Applications On Postgresql A Walkthrough Presentation"
date: "2015-11-28 00:00:00 +08:00"
post_image: /assets/images/posts/scaling-web-applications-on-postgresql.png
tags: [scaling, postgresql, web-apps]
categories: [programming]
author_id: 1
comments: true
excerpt: "TODO"
---


## pgConf 2015 PostgreSQL Developer Conference in the Bay Area

I was very happy to have my submission accepted at the recent pgConfSV conference (where SV is for Sillicon Valley). For various reasons I was unable to cover everything I wanted during the talk, which is a note to self for future public speaking engagements! Time your talk! :). Well, below is an updated version of that presentation, which shows an incremental and methodical path to scaling web applications to millions of users using PostgreSQL, all the while covering a very range of material.  

### Audience

In general, the ideal audience for this is operationally and architecturally minded full stack engineers, building web apps that either are already serving a ton of traffic, or will be soon.

But on the broader scale, I was intending for this presentation to be helpful to anyone trying to get a grasp on how to evolve their web application to where it's able to serve a rather high throughput of 5K-50K requests per second. This range is still far below what the internet "giants" such as Facebook, Google, or Twitter get (if I had to guess, it would be in 1M/sec). But, it is also far from an early naive web application with just a few users.  

Turns out it *is* possible to achieve high scalability on the cheap, and using PostgreSQL, which is what we did at Wanelo, and it turned out great.

### Presentation

<iframe src="//www.slideshare.net/slideshow/embed_code/key/yXKNCNdj1GNfE6" width="595" height="375" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong><a href="//www.slideshare.net/kigster/from-obvious-to-ingenius-incrementally-scaling-web-apps-on-postgresql" title="From Obvious to Ingenius: Incrementally Scaling Web Apps on PostgreSQL" target="_blank">From Obvious to Ingenius: Incrementally Scaling Web Apps on PostgreSQL</a> </strong> from <strong><a href="//www.slideshare.net/kigster" target="_blank">Konstantin Gredeskoul</a></strong> </div>

Thanks!
