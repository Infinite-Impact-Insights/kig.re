---
layout: page
title: 'Service Discovery, High Availability, and Fault Tolerance – This Afternoon'
draft: true
---

Maybe you are running one or more distributed multi-part, a.k.a. micro-services applications in production. Good for you!

<img src="/images/haproxy/microservices-hell.png" class="clear-image"/>

Perhaps you are struggling with _high availability_, such as tolerating hardware outages, maybe when your cloud provider is  rebooting servers, etc.

Perhaps you may be seeing an error known as __"too many clients"__, or __"max connections reached"__, or __"what, you think you really need another one!!??"__ – coming from one or more of your services (or your coffee shop barista)...

Or maybe, within your micro-services architecture, you are struggling with service discoverability, ie. how does your app know the IPs of your:

* search cluster
* your backend service(s)
* your redis cluster
* your databases with their replicas
* your memcaches
* your message bus
* cat feeder


### You and Me

We have a lot in common.

I too wanted a solution to all of the above, but I wanted the solution _yesterday_ – because I am impatient, and I needed it to be _cheap_ – because startup, _simple to understand and manage_  – because tiny team, _reliable_  – because sleep!

Also, together the above problems can be summed up quite simply. We sincerely want to improve the state of:

1. _hardware (or server) failure tolerance_, such as, for example – instances bouncing up and down
2. _too many clients problem_ – when the share number of connections overwhelm the underlying service
3. _service discovery_, i.e. – how do we move routing information (read: every single IP address) __out of our application configuration__?

The issue of failing hardware, especially in a large cloud deployment, is so ubiquitous that Netflix even wrote a tool to simulate it. The __Netflix Mantra__ encourages us to expect and anticipate failures at every level, and to practice swift recovery. See [ChaosMonkey](https://en.wikipedia.org/wiki/Chaos_Monkey), aka [Simian Army](https://github.com/Netflix/SimianArmy).

Whether this is your motivation, or if you, like me, feel that any self-respecting SRE (site reliability engineer) should take care of their (mental) health first, and that means – zero alerts at night, most of the time, all the time.

# So, how do we get there?

But before we discuss the solution, I'd like to pose it to you that there are three important questions that need to be formulated for any of this to make sense:

 1. What is a _real problem_ worth waking up for at night, and how is it different from a problem that can wait until the morning?
 2. How do I get alerted (at night) only about the "real problem", but not be spammed by the other less important ones?
 3. Is there such as thing, as an "ignorable problem"?

Below, I offer to you my answers. As with everything, your mileage may vary. Very.

## Defining the Real Problem

In my mind

> The _real problem_ can almost always be defined as a rapid change (often downward) in at least one critical business metric.

#### What business metric?

On any application with an uptime requirement I would want to track, in real time, key business metrics that represent the "heartbeat" of the business: such as a the rate of sales per second, rate of new user registrations, rate of saving a product (Wanelo) or pinning a pin (Pinterest), or tweeting a tweat (Twitter) or submitting a post (Tumblr), or committing the code (Github), the list goes on.

Give me a company name I am familiar with, and I can guarantee you that both you and I can instantly write down 2-3 definitive metrics, that _if the metrics stay at the expected value_ chances are the underlying software is functioning __good enough__ to support these critical functions.

A good way to think about the primary critical metrics for your business is in terms of some of the most valuable __write__ operation – in computer terms –  that users perform on your site/app/platform.  Why? Most businesses are defined by data they collect.  Take away that data and the business may need to start from scratch or fold. Read operations don't seem to have the same critical impact on the business, although they sure affect the end users.

Ultimately, both read and write metrics are important, but what is most important is that they are tracked in near-real time, shown on the dashboards.

> But what's most important, is that your Severity 1 Alerts are based on the critical metrics rapidly changing for the worse, and nothing else.

### Detecting the Real Problem

In order to detect our real problem, we need to first start monitoring our business metrics, but not just anyhow, but __live__: with no more than a 1-3 second delay.

#### Events

If you are not sure how you could add this functionality, I would point you in the direction of the [Observer](https://en.wikipedia.org/wiki/Observer_pattern) design pattern.

If you've been building websites with Rails, it is very likely that you have __not__ seen this pattern closely in action, and may not realize why you even need it.

In fact, what is true is that every web application is necessarily an [Event Based System](https://en.wikipedia.org/wiki/Event_(computing) that generates and consumes events, including the critical  business metrics that we care about. It is just that events are not universally implemented [as they ought to be in software](http://www.martinfowler.com/eaaDev/EventSourcing.html).

But doing so offers great many benefits. When we started building the new [Wanelo](https://wanelo.com), I knew early on that I had to buckle down and create the basis for our future eventing model before much of the business logic had been written in an __eventless__ manner.  The result of that effort is the open source ruby library [Ventable](https://github.com/kigster/ventable), and a related [blog post](/2013/08/05/detangling-business-logic-in-rails-apps-with-poro-events-and-observers.html).

This can be typically very easily implemented into an application by do as can be measured by detecting that a *derivative* function of said metric is a negative constant. Value lower than -3 or -4 represents a __very steep decline__ in the business metric. In summary:

> Real time data collection of critical business metrics is easier in systems that natively implement and handle events, and dispatch them to the interested parties, including real-time data collection and monitoring systems.

One such third-party software that I really like using is [Circonus](https://circonus.com/).

# The Solution

If you are thinking "Docker" because that's what everyone is saying, I would like to politely remind you what people were saying in early 2008 – namely that Lehman Brothers can not fail. Any time you have mass mania, it is bound to have an explosive ending.

In fact, Docker only makes this problem worse: we have MORE virtual hosts, which are all running services, databases and caches in containers, because everything is now containerized, and can run side by side another container just like those "lego blocks" on the cargo train. Or at least that's the dream :)

__I really shouldn't be beating on Docker,__ – it's a good technology. I just have a strong allergy to mass manias and obsessions. But I digress.

What I am talking about, is something I, as a developer, did not have in very high regard for a longest time, but something that grew on rapidly me during my days at [ModCloth](https://modcloth.com) and [Wanelo](https://wanelo.com), and now I can not live without it.

It is a simple thing, known as .... (drumroll....)....

### The answer to life, universe and everything....

> A Proxy

Yes, the panacea is an old friend from the old days. Except it's younger than ever.

So how can I claim that a simple proxy can solve all of the above?

Let's start with the actual software: _HAProxy is a HTTP/HTTPS/TCP proxy and connection pooling_ software that is built on top of `libevent`, typically runs in a single process and is incredibly efficient. It is also some of the best software ever written in C. Seriously!

At the RubyConf Australia conference I [recommended that you put `haproxy` in front of your MOM](https://rubyconf.eventer.com/rubyconf-australia-2015-1223/devops-without-the-ops-a-fallacy-a-dream-or-both-by-konstantin-gredeskoul-1724). Let me clarify this point – it was mainly so that your MOM can failover to another you (or your sibling) in case you are too busy :)  It's not so that you have two moms. Or is it?

`haproxy` Does the following:

 * automatic failover, stops sending traffic to a dead node, or while it's rebooting, in-memory queue size, failure actions, etc.

 * automatically add more backend servers if traffic increases

 * use in HTTP mode, or TCP mode – to failover redis, memcached, postgresql, etc.

`pgBouncer`

 * This one is a specialized proxy, meant to be used with PostgreSQL database, and this thing rocks!
 * We chose _transaction_ mode, and were able to reduce the number of connections from our application by a factor of 10 without any noticeable latency added.

`Twemproxy`

 * Redis / Memcached connection pooling proxy with automatic key-based sharding implemented.
 * We sharded our redis cluster into 256 redis nodes, and application talked to it through haproxy first, then six twemproxy servers, talking to the actual redis servers.
 * Need to failover to another Redis? Haproxy does that – switches to another twemproxy cluster or port.


So how do we solve each problem we listed upfront?



## High availability

<img src="/images/haproxy/haproxy-frontend.png" class="clear-image"/>

## Fault Tolerance

<img src="/images/haproxy/haproxy-backend.png" class="clear-image"/>

## Service Discovery or Routing Encapsulation

<img src="/images/haproxy/haproxy-router.png" class="clear-image"/>

## Conclusion

My strong recommendation is to invest into building haproxy into your application stay, to serve as a "glue" or as a high-availability router. If you are using PostgreSQL you will do yourself a favor if you start using pgBouncer running on your application servers, so that you can collapse the crazy number of database connections that Rails likes to create into a much more reasonable set. Similarly, with Twemproxy – it's a fantastic piece of software that, in addition, will allow you to shard your redis or memcached backend by key.
