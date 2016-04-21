---
layout: page
title: 'Reach discoverability and high availability this afternoon despite your containers trying to bring you down...'
---

#### (aka. the lightning talk I did NOT give at the ContainerCamp)

> 5 minutes read.

This is an extended version of the talk I wanted to give as a Lightning Talk here at ContainerCamp SF, but unfortunately the rules by which this game was played precluded me from doing so in favor of a yet another PaaS software pitch. So here I present you the "what would have been a much shorter talk" as a short length blog post.

{{site.data.macros.continue}}


###  Me:

 * I am a software developer, deployer, and an operator of large distributed web-ish applications (20+yrs).

 * Recent hardware hobbyist, and an arduinoist (or, "dunist" not to be confused with it's anagram)

 * An architect, thought leader, CTO – most recently at Wanelo.com: ruby stack, traffic peaking at 10K reqs/sec, hosted on Joyent/SmartOS, automated with Chef, 99.98% uptime over 3.5 years.

 * A founder of a hardware startup [ReinventONE](http://reinvent.one), hoping to help you save time during your bathroom breaks.

	* blog: [kig.re](http://kig.re)
	* company: [reinvent.one/pitch/](http://reinvent.one/pitch/)
	* [@kig](http://twitter.com/kig) on Twitter, user id 338
	* [@kigster](http://github.com/kigster) on Github
	* [@kigster](http://linked.com/in/kigster) on LinkedIn

### You:

Maybe you are running one or more distributed multi-part (micro-services) applications in production.

Perhaps you are struggling with _high availability_, such as tolerating hardware outages, rebooting servers, etc.

Perhaps you may be seeing an error known as __"too many clients"__, or __"max connections reached"__, or __"what, you think you really need another one!!??"__ – coming from one or more of your services (or your coffee shop barista)...

Or maybe, within your micro-services architecture, you are struggling with service discoverability, ie. how does your app know the IPs of your:

* search cluster
* your backend service(s)
* your redis cluster
* your databases with their replicas
* your memcaches
* your message bus
* cat feeder

### Together

We have a lot in common.

I too wanted a solution to all of the above, but I wanted the solution _yesterday_ – because I am impatient, and I needed it to be _cheap_ – because startup, _simple to understand and manager_  – because small team, _reliable_  –because what is the worth of a reliability tool that's unreliable itself? Would that be like a snake eating it's own head? Yeeeck!

Also, together the above problems can be summed up quite simply. We are concerned and want to improve the state of:

1. hardware (or server) failure tolerance
2. too many clients problem
3. service discovery problem, ie – every component must know about the other.

The issue of failing hardware, especially in a large cloud deployment, is so ubiquitous that Netflix even popularized it. The __Netflix Mantra__ encourages us to expect and anticipate failures at every level, and to practice recovery. See [ChaosMonkey](https://en.wikipedia.org/wiki/Chaos_Monkey), aka [Simian Army](https://github.com/Netflix/SimianArmy).

It's nearly the same as, 

> The __Konstantin's Model__: Which states that any SRE of any kind is completely justified to ignore all alerts between 1am and 7am in the morning because sleep is just too important for your health.

Ok, fine, don't get me wrong, I do care about the application, and of course I will get up at night when there is a real problem requiring my attention. But this last sentence, is where things can get complex.

There are three questions that need to be defined for any of this to make sense:

 1. What is a "real problem" and how is it different from an "ignorable problem"?'
 2. How do I discover in real time about the "real problem", but not be bugged about the others?
 3. How can there be an "ignorable problem"?

Below, I offer to you my answers. As with everything, your answers may differ.

### Defining the Real Problem

In my mind the **real problem** can almost always be defined as a _rapid change in one or more critical business metrics_.  What business metrics?

On any application with an uptime requirement I would want to track, in real time, bunsiness metrics such as a rate of sales per second, rate of new user registrations, commenting, etc. If I was building another __Twitter__, it would be the rate of tweets coming in, __Wanelo__ – saves, __Pinterest__ - pins.  A good way to think about primary critical metrics for your business is in terms of some of the most valuable __write__ operation (on your datastore) that users perform on your site/app/platform.

### Detecting the Real Problem

In order to detect our real problem, we need to first start monitoring our business metrics, but not just anyhow, but __live__: with no more than a 1-3 second delay.

#### Events

If you are not sure how you could add this functionality, I would point you in the direction of the [Observer](https://en.wikipedia.org/wiki/Observer_pattern) design pattern.

If you've been building websites with Rails, it is very likely that you have __not__ seen this pattern closely in action, and may not realize why you even need it.

In fact, what is true is that every web application is necessarily an [Event Based System](https://en.wikipedia.org/wiki/Event_(computing) that generates and consumes events, including the critical  business metrics that we care about. It is just that events are not universally implemented as such in software.

But doing so offers great many benefits. When we just started building the new [Wanelo](https://wanelo.com), I knew early on that I had to buckle down and create a basis for our future eventing model before much of the business logic had been written in an _eventless_ manner.  The result of that effort is the open source ruby library [Ventable](https://github.com/kigster/ventable), and a related [blog post](http://building.wanelo.com/2013/08/05/detangling-business-logic-in-rails-apps-with-poro-events-and-observers.html).

This can be typically very easily implemented into an application by do

as can be measured by detecting that a *derivative* function of said metric is a negative constant. Value lower than -3 or -4 represents a __very steep decline__ in the business metric.


##  The Answer.

If you are thinking "Docker", without offending anyone, I'd like to compare Docker with the financial products of early 2008 – namely, real eastate securities. What could possibly go wrong with these shiny new products that everyone is buying?

In fact, Docker only makes this problem worse: we have MORE hosts, except now they are virtual hosts, which are all runnin services and data stores in containers, because everything is now containerized, and can run side by side another container just like those "lego blocks" on the cargo train. Or at least that's the dream :)

But – __I really shouldn't be beating on Docker,__ – it's a good technology. I just have a strong allergy to mass obsessions. But I digress.

#### How did I arrive at this answer?

There are likely many answers to this problem, some new and some just up and coming, some older and more mature, some proprietary, and some open source.  But what I am talking about it something I, as a developer, did not have in very high regard for a long time, but something that grew on me during my days at [ModCloth](https://modcloth.com) and [Wanelo](https://wanelo.com), and now I can not live without it.

It is a simple thing, known as .... (drumroll....)....

# The answer to life, universe and everything – Proxy.

In case you were wondering, it's – the boring old chap – proxy.

> "...Proxy husband, proxy wife, proxy father, proxy life. " –– IT Folk Song.

Proxies are easy, reliable, easy to setup and run, and they solve all of the above! Holy sh... mokes, REALLY!??!

#### HAPROXY

HAProxy is a HTTP/HTTPS/TCP proxy and connection pooling software that is built on top of `libevent`, typically runs in a single process and is incredibly efficient.

It is also some of the best software ever written in C. Seriously! At the RubyConf Australia conference I recommended that you put haproxy in front of your MOM. Let me clarify this point – it was mainly so that your MOM can failover to another you in case you are too busy :)

`haproxy` Does the following:

 * automatic failover, stops sending traffic to a dead node, or while it's rebooting, in-memory queue size, failure actions, etc.

 * automatically add more backend servers if traffic increases

 * use in HTTP mode, or TCP mode – to failover redis, memcached, postgresql, etc.


#### pgBouncer

This thing rocks! We chose `transaction` mode, and were able to reduce # of connections from our application by a factor of x10 without any noticeable latency added.

#### Twemproxy

Redis / Memcached connection pooling proxy with automatic key-based sharding implemented. We sharded our redis cluster into 256 redis nodes, and application talked to it through haproxy first, then six twemproxy servers, , behind 6 twemproxy "balancers",

### Some Examples

```bash
app server ⇢ haproxy ──── twemproxy ──── redis-server

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

app server ⇢ haproxy ──── twemproxy ────    memcached

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

app server ⇢ haproxy ─────────────────── micro-service

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

nginx ⇢ haproxy  ────────────────────────   app server

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

app server ⇢ haproxy  ────────── search 1 | provider 2

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

app server ⇢ pgBouncer  ─────────────────── postgresql

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

app server ⇢ pgBouncer  ────── pgBouncer ⇢ postgresql

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

app server ⇢ haproxy ────────  pgBouncer ⇢ postgresql
```

## Conclusion

My strong recommendation is to invest into building haproxy into your application stay, to serve as a "glue" or as a high-availability router.