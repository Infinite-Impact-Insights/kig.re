---
layout: page
title: 'DevOps Guide to Docker: Why, How and Wow.'
sidebar: top
---

---

## Preface

We are quickly approaching 2016, only a few days away. Docker has been the new hotness for several years, but since our hosting company at the time – [Joyent](http://joyent.com) was much ahead of the game: they had been running light-weight containers since the company's inception sometime in 2006. This is because Joyent's host operating system (i.e. their software 'hypervisor') has always been [SmartOS](https://smartos.org/), which descended from Solaris. SmartOS is a very modern OS, however, and as a developer I've appreciated many features that it inherited from Solaris. This is a topic for a whole another post, but if you are curious, [here is a good (but outdated) overview.](http://www.joyent.com/blog/bruning-questions-why-use-smartos). But in a nutshell, on Joyent containers can ve be resized, shrunk and grown without a reboot.  They also reboot in a couple of seconds. Combine that with a full Chef automation, and we (at [Wanelo.com](http://wanelo.com)) were quite happy with the DevOps situation.

> I even presented at RubyConf Australia early in 2015, speaking about how Wanelo managed to run large infrastructure serving millions of users without hiring operations people. It's called ["DevOps without the Ops"](https://rubyconf.eventer.com/rubyconf-australia-2015-1223/devops-without-the-ops-a-fallacy-a-dream-or-both-by-konstantin-gredeskoul-1724).

Now majority of the leading Cloud providers, including Joyent, support Docker container-based virtual machines. So I decided to do a small project with Docker and AWS, and document my "a-ha!" moments about Docker and AWS, hoping that this guide might help someone else fast-track into Docker quicker.

## Audience

In this blog post I assume that you are familiar with UNIX OSes, and understand basic client-server architecture of web applications.  You do not need to know anything about Jekyll – you can think of it as a simple command line tool that generates a bunch of HTML that we will serve as a website.

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

To really break this down, and fast, let's pretend that we are now in the "Ops" land of application development, because we are managing the production infrastructure. We always have to juggle requirements and expectation across several axis:

 1. Software must be easy to deploy, configure and change
 2. Overall service must be highly available
 3. As well as automatically scalable up and down
 4. It should not cost more than X$/month to run.
 5. It should be secure
 6. And how about – easy to understand?

---


So that's a pretty serious list of questions, so let's get to work.

## What Docker is NOT.

### Hi! I am BIOS.

Before we get to Docker, there is a concept that should be mentally recalled: for many years now it has been possible to run one operating system inside another.  Most popular, and probably the very first one was [Parallels, Inc.](https://en.wikipedia.org/wiki/Parallels_(company)). It allowed Mac OS-X users to run Windows, next to their Mac Apps, and without having to reboot their computer.

#### 2005 – Parallels

Parallels created a software that emulated the hardware – a layer that pretends to be a collection of a familiar BIOS,  motherboard, RAM, CPU, and peripherals, USB, SATA disks, etc. I write software for living, and to me it feels like a pretty difficult task to accomplish, and Parallels definitely were the first to market, releasing their first version in 2005.

Parallels did its job, and there are millions of happy customers. But, one thing was clear: the speed was the huge sacrifice. Most people knew that running, i.e. World of Warcraft inside Parallels is pretty much idiotic. But possible.

Issues at the time: very slow (barely usable on older laptops), poor graphics, long boot time, very long install.

#### 2006 - BootCamp

Steve Jobs must have liked what Parallels did, and decided to do it better, as he typically does. Well, maybe not better, but differently.  BootCamp allowed Mac users to run Windows at near native speed of their Mac, but the catch was that only one or the other was possible.  You could run other operating systems too, just like with Parallels.


#### 2007 - KVM
