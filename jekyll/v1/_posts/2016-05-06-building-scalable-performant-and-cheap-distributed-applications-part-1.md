---
layout: page
title: 'Distributed Applications That Avoid DevOOPS'
tags:
toc: true

---

## Are you practicing __DevOops?__

 - do you constantly struggle to keep production running smoothly?
 - do you get a ton of alerts that don't actually mean things are broken?
 - do you use Docker, but your deploy takes 20+ minutes?
 - do you use Docker, but manually configure Docker Hosts once the cloud provisions them?
 - does it take hours to bring a new server into the pool to help alleviate load?
 - have you never practiced failover to your database replica?
 - do you NOT know who owns your root DNS?
 - have you skipped that ticket about making an offsite backup, and now there isn't one?

If you answer *yes* to any of these questions, then you just might... The thing is — you are not alone. Thousands of organizations do not have the time and resources to fix this type of technical debt, and escape the world of DevOops, where things just don't run smoothly. That is despite using newest technologies (Docker), largest cloud in the world (AWS), and a great team of engineers.

> I'd like to help.



{{site.data.macros.continue}}

## "DevOps Conversations"

### Intentions and Audience

With this post, I'd like to start a series of __DevOps__-related conversations about building distributed applications (read: common web-apps). Folks running enterprise application use different technologies and are hosted across a range of cloud providers, and yet are often faced with very similar problems.

I regularly met engineers working for successful and profitable businesses, who admit to being confused and overwhelmed by the new tools coming out, seemingly every week.

Then there is another group — the "early adopters" – who truly believe to have found a panacea that solves all worlds problems, and preach it to everyone. Perhaps *"Docker"* comes to mind as a completely over-hyped technology enjoying a massive popularity bubble.

Finally, some engineers are just starting, but are already expected to put together infrastructure in production — and those can be the most overwhelmed bunch. And I can't blame them.

### How did we get here?

The world of web development had gone from tedious, but simple (think CGI + perl), to productive and magical (think Rails), to concurrent (think functional programming, Node, then Closure), to super available (think Erlang, Elixir — the latter attempting to combine productivity of Rails with concurrency and uptime of Erlang — successfully).

And this is just the backend — forget about the front-end and drop the operational aspect of the deploy, infrastructure configuration, automation, etc.

> We've created a maze! Some call it "Micro Services Hell™"

### Micro-Services (Hell? Or Paradise?)

So which group do I, Konstantin, personally belong? Funny you should ask. The thing is – I am a __skeptical outsider__, and always have been. I try things on, see if they fit, and use what I like. And I am also a bit overwhelmed, and very excited about what lies ahead. Humans are great at classifying a ton of complexity, and that is exactly what I plan on doing here. Because complete mayhem.

<a href="/images/haproxy/microservices-hell.png" data-lightbox="devoops1" data-title="Example Distributed Architecture Hell">
<div class="full"><img src="/images/haproxy/microservices-hell.png" class="clear-image"/></div></a>

As can be see from the (fictional), but multi-color diagram above, building todays application requires connecting things to other things in many different ways. This requires things to know about other things, to be able to talk to them, and listen. Just like people. We would be worthless without these basic properties.

### Cross-cutting Concerns

Too often when a new application is conceived, broken down to the features, stories, mockups, and then methodically implemented, we often forget to ask ourselves the fundamental questions about the requirements related to application *availability, survivability, scale and performance, security, auditability,* etc. We don't have to implement ANY of these dimensions in the beginning, but thinking about them ahead of time informs so many turn-key decisions, related to software design, systems architecture, vendor selection, infrastructure cost, and even technology stack.

I do not suggest that we invest a ton of effort into making a non-existant application highly-available. I just want to have a __having a conversation__ about what these requirements might look like in the future. I find this conversation to be very helpful.  

### Infrastructure and Innovation

When applications like Chef, Puppet and Ansible came to the rescue, when it comes to configuring servers, we finally reached a point of automating servers that were running our software (well, maybe not all of us, but some did).

And now Docker and light-weight containers are offering something different, and when coupled with the [ability to run on bare metal](https://www.joyent.com/blog/how-to-dockerize-a-complete-application) – very exciting indeed.

But all of this is changing so rapidly. What to use? What to apply? What are the best practices?

Oh, these are already __yesterday's best practices?__

Well, who has the ones that will still be *best* tomorrow?

____

## Who am I to speak on the subject?

Good question. I start with a bit of a personal history.

### Distributing Application Down Under

I started building distributed applications in 1996 when I was placed as a junior contractor in the operations group managing a very large-scale project. The goal was to rebuild the entire messaging and cargo tracking software for the Australian Railway Corporation named aptly [National Rail Corporation](https://en.wikipedia.org/wiki/National_Rail_Corporation).  Back then, we used this fascinating commercial software called [Tuxedo](https://en.wikipedia.org/wiki/Tuxedo_(software))  as middleware, transaction manager, a queueing system, and so much more. Tuxedo has a fascinating history – which could be a subject of an entirely separate post, but suffice it to say that it was developed by AT&T in the late 1970s, in a practically the same lab as UNIX itself! At some point in the 80s, it was then sold to Novell, then to BEA – which eventually used it to build it's flagship product [WebLogic](http://www.oracle.com/technetwork/middleware/weblogic/overview/index-085209.html) that now belongs to Oracle. I was told that there was a time where British Airways used Tuxedo to network over 20,000 stations together.

This is where I learned how to build distributed applications – with tenets such as *high availability, fault tolerance, load balancing, transactional queueing, distributed transactions* spanning several databases, plus several queues. Oh my gosh, if it sounds complicated — it' because it was! But once you get the main concepts behind how Tuxedo was constructed: each node had a server process that communicated with other nodes, and managed a local pool of services – it sounds very reasonable. I stayed on this project for about a year and a half, long enough that all of the most senior people who understood the messaging component had left, leaving me – 23-year-old junior programmer, the only person understanding the architecture and operational aspect of that system. That part of the waterfall was not predicted by their project managers ☺.  

Imagine being flown on a corporate helicopter across the gorgeous city of Sydney, just to attend the meeting with people five levels senior to explain how the multi-million dollar messaging infrastructure works :)  That was a good day.

<a href="/images/sydney-skyline.jpg" data-lightbox="devoops1" data-title="Sydney Skyline">
<div class="full"><img src="/images/sydney-skyline.jpg" class="clear-image"/></div></a>

### Distributing Email in San Francisco

I took my knowledge of distributed systems to the US, where I was hired to build Topica, a hot new startup in San Francisco creating a new generation of listservs, or email groups (aka. mailing lists). The year was 1998, and there sure wasn't any open source distributed networking software that gave us the incredible reliability and versatility that the middleware like Tuxedo provided, so we bought a license. Whether this was the right choice for the company as at time is not for me to judge. But the system we built ended up using Tuxedo (ANSI C with Tuxedo SDK), Perl (with native bindings for C), and horizontally distributed Oracle databases. This beast ended up being so damn scalable that at a point in time someone mentioned Topica as a source of more than 1% of __all daily internet__ at that time! And sure enough, we were sending several hundred million messages per day.  

And here is a kicker: if you open [https://app.topica.com/](https://app.topica.com/) you will see the login screen from the app we built – it's functionality is most similar to that of [Constant Contact](http://www.constantcontact.com/). The Topica app has been running untouched, seemingly unmodified, since 2004! – Twelve years! They stopped developing the app shortly after I left in 2004, mostly for business reasons. But the software endured. And it's still running, 12 years later.  It was built to be reliable. It was scalable. It was transactional. What it wasn't – is simple.

This second experience with Tuxedo forever changed the way I approach distributed application development.

### Back into the Future: Let's Start a new Company!

This part is hypothetical.

Say we are building a brand new web application that will do *this and that * in a very *particularly special way*, and the investors are flocking, giving us money, and so we get funded.  W00T!

> If I am an early engineer, or even a CTO, on this new project, *I would not be doing my job if I am not asking the founders a lot of questions that affect hugely the ways we are going to build the software supporting the business. And how soon.*

So I pull the founder into a quiet room, hide their cell phone from them, and unload onto them with questions for an hour.

The *best hour spent in the history of this startup*. Promise.

_______

## Six Questions to ask Every Founder

1. How reliable should this application be? What is the cost of one hour of downtime? What's the cost of one-hour downtime now, six months from now, a year from now? What is the cost of many small downtimes?  What about nightly maintenance?
2. How likely is it that we'll get a spike of traffic that will be very important or even critical for the app to withstand? Perhaps we were mentioned on TV.  Or someone twitted about us. How truly bad for our business will it be, if the app goes down during this type of event because it just can't handle the traffic? And even if the spike of death happens, how important it is that the team can scale the service right up with traffic within a reasonable amount of time?  What *is* a reasonable amount of time?
3. How important is it that the application interactions are fast? Or that the users don't have to wait three seconds for each page to load? How important is it that the application performance is not just "good" (say, 300ms average server latency), but outstanding (say, 50ms server average latency)?
4. How important it the core application data is to the survival of the business? For example, a financial startup that deals with people's money, data integrity is paramount.  For a social network that's merely collecting bookmarks, it's only vaguely significant. Large data losses are never fun, but a social network might recover, while a financial service will not.
5. How important it is that the application is secure? This question should be viewed from the point of view of being hacked into – once you are hacked, can you recover? If the answer is "no", you better not get hacked. Right?
6. The last bucket will deal with the engineering effort. Things like **cost,  productivity, ability to release often, hire and grow the team easily**, etc. What's the cost of maintenance, how big is the Ops team, how big and how senior must be the development team?

###  Oh, I hear you say the word: "**catastrophic**"

Now, how bad is it for your business, if, say, [you are hosted on AWS, and a greedy hacker takes over your account and demands ransom?](https://threatpost.com/hacker-puts-hosting-service-code-spaces-out-of-business/106761/) Well, if you did not think about the implications of building a 'mono-cloud' service, and even your "offsite" backups are performed in your one and only AWS account, then the answer is – once again – **catastrophic.**  Your business is terminated.

But then, in between "oh, it hurts, but it's ok" and "we are finished" there lies a whole other category of: "our users are pissed", "we lost 20% MOU", "[everyone is switching to another social network](https://www.technologyreview.com/s/511846/an-autopsy-of-a-dead-social-network/)", "did you hear so and so got broken into and got their user data stolen? They've asked for my social security number, and I am furious!..."  

> This may not be The Catastrophy just yet, but your technology is either not scaling, not reliable, or not secure. The Catastrophy may be right around the corner.

Given that I've been building almost exclusively applications that most certainly did not want to die because of scalability, reliability or security concerns, I've applied the same patterns over and over again, and results speak for themselves. I don't like bragging, and I wouldn't say this – but for those of you still skeptical – [I refer you to the uptime and scalability numbers mentioned in this presentation](https://rubyconf.eventer.com/rubyconf-australia-2015-1223/devops-without-the-ops-a-fallacy-a-dream-or-both-by-konstantin-gredeskoul-1724).

Which brings me to the conclusion of this blog post.

## Six Critical Tenets of Modern Apps

The topics and scenarios above, distill down to the following principles the apply to the vast majority of applications built today.

> As a simple exercise, feel free to write down – for your company, or application – how important, on a scale from 0 (not important), to 10 (critical/catastrophic if happens), are the following:

1. __High Availability__. Solutions to this are comprised of fault tolerance, multi-datacenter architecture, offsite backups, redundancy at every level, replicas, hosting/cloud vendor-independence, monitoring and a team on call.
2. __Scalability__.  Scalability is the ability to handle a massive concurrent load, perhaps hundreds of thousands of actively logged in users interacting with the system; that might spike to (say) 1M or more. It is also the ability to dynamically raise and lower application resources to match the demand and save on hosting.
3. __Performance.__ What's the average application latency (the time it takes the servers to respond to a user request – like a page load)? What's the 99% and 95% percentile? This is all application performance. Good performance helps scalability tremendously but does not warrant scalability in of itself. Well-performing applications simply need a lot fewer resources to scale, and are both the pleasure to use by your customers, and cheap to scale up. So performance truly does matter.
4. __Data Integrity.__  This is about not losing your data. Accidentally. Or maliciously. Usually, some data can be OK to lose. While another set of data is the lifeblood of your business. What if a trustworthy employee, thinking that they are connected to a development database, accidentally drops a critical table, and only then realizes that they did that on production? Can you recover from this user error?
5. __Security.__ This one is a no-brainer. The bigger the payoff for the hackers (or disgruntled employees) the more you want to focus on securing your digital assets, inventions, etc.  Not only preventing them from being copied and stolen but from being erased altogether. Always have at least the last day's backup of your database securely downloaded somewhere into an undisclosed location and encrypted with a passphrase.
6. __Productivity__. How quickly do we need to move? How unproven is the idea? Is it better to be down often, but move with a super-sonic speed, or be slower, but more reliable?  

These types of trade-offs I would like to discuss in the next installment of the DevOops Series.

## Coming Up Next

In the next blog post, I will discuss specific solutions to:

* _High Availability_
  * _Fault tolerance_
    * Redundancy
    * Recovery
    * Replication
* _Scalability_
    * How to scale transparently to more traffic
    * And scale down as needed
* _Service Discovery_
    * How does the app know where is everyone?
* _Monitoring and Alerting_
    * How to put your entire dev team on call
    * How to alerts on what's important
* How to do this all at a fraction of a cost that it used to be just a few years ago...
* How to stay vendor independent and why would you want to.

Thanks for reading!
