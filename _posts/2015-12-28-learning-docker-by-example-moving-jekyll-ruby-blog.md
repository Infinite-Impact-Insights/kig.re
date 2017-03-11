---
layout: page
title: 'DevOps Guide to Docker: Why, How and Wow.'
draft: true
toc: true

---

---

## Preface

We are quickly approaching 2016, only a few days away. Docker has been the new hotness for several years, and our cloud hosting company [Joyent](http://joyent.com) had been ahead of the game: they had been running light-weight containers since nearly the company's inception sometime in 2006. This is because Joyent's host operating system (i.e. their software 'hypervisor') has always been [SmartOS](https://smartos.org/), which descended from Sun Microsystem's Solaris OS. SmartOS today is open source, and is a very modern OS. But unfortunately it is not nearly as popular as Linux platforms.  As a developer I've appreciated many features that SmartOS offered. This is a topic for a whole another post, but if you are curious, [here is a good (but slightly outdated) overview.](http://www.joyent.com/blog/bruning-questions-why-use-smartos).

But what's important to know about Joyent is that when SmartOS was used as a hypervisor, to run SmartOS virtual instances, these instances could be resized dynamically, shrunk or grown in terms of RAM, CPU or disk IO – all without needing to reboot! They also reboot in a just couple of seconds. When this flexibility was combined with a complete Chef automation, we (at [Wanelo.com](http://wanelo.com)) were quite happy with our DevOps situation.

> In fact, I presented on this very subject at RubyConf Australia early in 2015. Focusing on how Wanelo managed to run large infrastructure serving millions of users without hiring operations people. I also shared several high availability patterns. The talk is called ["DevOps without the Ops"](https://rubyconf.eventer.com/rubyconf-australia-2015-1223/devops-without-the-ops-a-fallacy-a-dream-or-both-by-konstantin-gredeskoul-1724).

At the time I was writing this, the top largest leading Cloud providers support Docker container-based virtual machines, as does Joyent. Believe it or not, I haven't had a chance to play with it yet, and so I decided to do a small project with Docker and AWS, and document my "a-ha!" moments about Docker and AWS, hoping that this guide might help someone else fast-track into Docker quicker.

Given my larger than your average developer experience with DevOps and Operations in general, I thought that my journey will likely be similar for many others with my background. And that happens to be a fantastic motivation for a blog post.

## Audience

I am going to make an effort to write in a pretty inclusive style, where you do not have to be a rockstar Rails programmer to understand what's going on.  But you should be familiar with UNIX OSes, with deploying web applications, with setting up the "stuff" that makes your web application work (such as nginx/apache, database, etc).  You may have dabbled in AWS, Docker or Chef, and they left you confused. This is what I am looking for. If you are confused – you've come to the right place, because at the beginning of the blog I am pretty confused too! This is why I m writing this :)

So let's get started!

## Project

This blog runs on [Jekyll](https://jekyllrb.com/) blogging generator. I call it generator because it simply generates static pages that are then served by a web server like nginx. As far as I know you can not add any dynamic functionality to Jekyll server-side (only client-side, with AJAX and JavaScript APIs).

We will migrate this simple blog from Github Pages to AWS/Docker, while discussing along the way, showing the code, and comparing our impressions :) If you are reading this blog on http://kig.re/ domain, then it's already been migrated.

The second phase, after we get it to run locally – is to deploy it to production. I would like to configure two EC2 instances, one in each of the two availability zones we'll pick, and put them behind an elastic load balancer, for maximum high availability. I will constrain myself to not add any more complexities, but typically fail at that 😜

## Goals

As a relative newcomer to the "Docker Scene", I am wearing hipster pants and twttr t-shirt. No, not really. But I am curious about this technology, and how it changes my "toolbox": the list of tried and true solutions to common problems that I have accumulated over two decades of commercial software development.

> Most importantly, I want to first __understand Docker__, it's architecture, and, specifically, it's __innovation__. What are the key pieces that makes Docker so popular? I would like to prepare, in a repeatable way, my laptop (or any future Mac OS-X computer) with the tools necessary to run Docker containers locally, on Mac OS-X El Capitan.
> What's the relationship between *Chef* and *Docker*. As a DevOps engineer, do I need them both? Or does Docker alone provide sufficient replacement for automating application development on both development, staging and production environments?

__So there, above, are my personal goals for this project.__

But what are the big challenges in front of DevOps engineers today? Well, distributed systems with often conflicting demands can be __very very difficult__ to manage, while satisfying orthogonal requirements. So simplifying anything in this area is a big win, especially for the businesses running software in the cloud.

To really break this down, and fast, let's pretend that we are now in the Land Of "Ops", and we are managing a large production infrastructure.

Each business is unique in that it prioritizes the below list of requirements in a unique way. For a financial tool, security may be paramount, but for a site that does not record any personal information – it might not. As a result, depending on the business we always have to juggle requirements and expectation across several orthogonal axis (and by othogonal I mean that they are mostly independent of each other – one cary vary drastically while the other is fixed, etc.)

From my experience, the top requirements that Engineering as a discipline at any organization must satisfy, is a combination of the following (in no particular order):

 1. Ability to __easily change__, deploy, and understand the software.
 2. The cost (and risk) of __breaking production__ with a deployed bug.
 3. The cost (and risk) of an __unplanned downtime__, and cost of being down per minute.
 4. Ability for the system to __automatically scale up and down__ with the incoming traffic.
 5. Predictability of the __operational cost__, for example $x per month, per 1K MAU.
 6. __Security posture__, risk factor, probability of a compromise. After-affects of a break-in.

Often these go at odds with each other: for example, increasing security posture means slowing down development, and increasing operational cost. And so on.

I really like to distill things down as much as possible, so when I do that with the list above, here is what I get:

> Today's enterprise software development requires a carefully measured balance of effort, spent on the abilities to grow, change and scale software and the service on one hand, and risks of a tumble, crash or a data leak on the other.

So with that, let's move along to see what Docker gets us, but before – I want to better understand the concept and the history of virtualization.

## Computing "Inception"

Virtualization is a concept that should be relatively easy to understand. For many years now it has been possible to run one operating system inside another.

With Mac OS-X growing popularity around early 2000s, this concept reached the "consumer". It was no longer a question of large enterprises, but developers, designers, and gamers. People wanted to run OS-X application side by side with Windows. And in the case a Mac, that was not even possible until Apple switched to the Intel processor family.

#### 2005 – Parallels

Most popular, and probably the very first one was [Parallels, Inc.](https://en.wikipedia.org/wiki/Parallels_(company)). It allowed Mac OS-X users to run Windows, next to their Mac Apps, and without having to reboot their computer.

Parallels created a software that emulated the hardware – a layer that pretends to be a collection of a familiar BIOS,  motherboard, RAM, CPU, and peripherals, USB, SATA disks, etc. I write software for living, and to me it feels like a pretty difficult task to accomplish, and Parallels definitely were the first to market, releasing their first version in 2005.

While Parallels did technically work, for many resource-intensive application running inside Parallels was simply not realistic. It was just too damn slow. Consumers quickly discovered that running games inside Parallels was pretty much a moot point.

#### 2006 - BootCamp

Steve Jobs must have liked what Parallels did, and decided to do it better, as he typically does. Well, maybe not better, but differently.  BootCamp allowed Mac users to run Windows at near native speed of their Mac, but the catch was that only one or the other was possible.  You could run other operating systems too, just like with Parallels.


#### 2007 - KVM
