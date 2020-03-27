---
layout: post
title: 'Scaling Web Applications On Postgresql A Walkthrough Presentation'
date: '2015-11-28 00:00:00 +08:00'
post_image: /assets/images/posts/scaling-web-applications-on-postgresql.png
tags: [scaling, postgresql, web-apps]
categories: [programming]
author_id: 1
comments: true
toc: true
markdown_toc: true
excerpt: "In this exciting and informative talk, presented at PgConf Sillicon Valley 2015, Konstantin cut through the theory to deliver a clear set of practical solutions for scaling applications atop PostgreSQL, eventually supporting millions of active users, tens of thousands concurrently, and with the application stack that responds to requests with a 100ms average. He will share how his team solved one of the biggest challenges they faced: effectively storing and retrieving over 3B rows of 'saves' (a Wanelo equivalent of Instagram's 'like' or Pinterest's 'pin'), all in PostgreSQL, with highly concurrent random access."
---


 TOC
{:toc}

## 2015 Silicon Valley PostgreSQL Developer Conference

I was very happy to have my submission accepted at the recent pgConfSV conference (where SV is for Sillicon Valley). For various reasons I was unable to cover everything I wanted during the talk, which is a note to self for future public speaking engagements! Time your talk! :). Well, below is an updated version of that presentation, which shows an incremental and methodical path to scaling web applications to millions of users using PostgreSQL, all the while covering a very range of material.  

### Audience

In general, the ideal audience for this is operationally and architecturally minded full stack engineers, building web apps that either are already serving a ton of traffic, or will be soon.

But on the broader scale, I was intending for this presentation to be helpful to anyone trying to get a grasp on how to evolve their web application to where it's able to serve a rather high throughput of 5K-50K requests per second. This range is still far below what the internet 'giants' such as Facebook, Google, or Twitter get (if I had to guess, it would be in 1M/sec). But, it is also far from an early naive web application with just a few users.  

Turns out it *is* possible to achieve high scalability on the cheap, and using PostgreSQL, which is what we did at Wanelo, and it turned out great.

### Presentation

You can view the presentation here:

 * [From Obvious to Ingenius: Incrementally Scaling Web Apps on PostgreSQL](https://www.slideshare.net/kigster/from-obvious-to-ingenius-incrementally-scaling-web-apps-on-postgresql)

Thanks!