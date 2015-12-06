---
layout: page
title: Konstantin Gredeskoul
disqus: disable
---

## What Have I Done Before?

### What is my skillset summary?

*Fluent, expert level*

 * Ruby
 * Ruby on Rails
 * CSS, JavaScript
 * RSpec, Sinatra, Capistrano, Devise, etc
 * Chef
 * Performance tuning code
 * Performance tuning PostgreSQL
 * Identifying bottlenecks in the system using USE method
 * Database schema design (for performance or scale)
 * Object oriented design, SOLID design
 * Java
 * SQL

*A bit dated, and possibly incomplete, but can catch up quickly:*
 
 * C/C++
 * Objective-C
 * Modern JavaScript libraries
 * React-based evented design

*Open source tools I can fluently use on any project:*

 * Redis, Nginx, Haproxy, pgBouncer, twemproxy
 * Solr, Memcached, RabbitMQ, Chef, Sidekiq, ElasticSearch
 * Linux, SmartOS, dTrace, statsd
 * NewRelic, Boundary
 
*Development Environment*

 * git, gitX, github
 * RubyMine, vim, Atom, TextMate
 * shiftIt
  
During the last nearly four years, I worked as a CTO at Wanelo.com. There, I had the honor of forming and then leading my "dream" engineering team, infused with the culture of positivity & optimism, desire to become masters of the craft, through collaboration, pair programming, best practices, and just being nice to each other. The engineering culture I helped create and the people at Wanelo ultimately cultivated work environment with a phenomenally high productivity, low defect rate, and a happy, self-managing team. 

Using an averaged comparison from several employees, who worked at many companies before, they estimated that Wanelo team moved at least 5X and up to 10X faster than any of their previous jobs.  What we've created ended up being a pretty tight ship, moving with a high velocity, confidence, and accuracy, not to mention 99.99% uptime.

Here is one testimonial (others available on my LinkedIn Profile):

Matt Camuto, Sr Software Engineer, says:  

> "I have worked with Konstantin and can say he is bar-none the most technically minded CTO and leader I have ever worked with. He has an amazing depth in system tuning, scaling architectures, Ruby programming, and database tuning. 
>
> His biggest contribution though was building a super well-oiled engineering team that is the dictionary definition of efficient, lean and driving a fully automated deployment infrastructure and enforcing best practices such as TDD in a pairing environment. 
> 
> Overall Konstantin is a super passionate and creative technologist and leader, and would be a great asset to any team that wants to build an amazing tech org. I would fully work with him again in a heartbeat."


But the team was not the only thing that makes me feel proud.  We navigated amongst various supporting technologies in such a way that a relatively small team, consisting of only 12 engineers working in pairs, was operating an enormously diverse stack. It consisted of an iOS & Android mobile apps, a ruby backend: single monorail + many micro-services, and a massive horizontally sharded PostgreSQL backend storing over 3B "saves" across 8K shards.  I often speak at conferences about incremental scaling that culminates in horizontal sharding. In the end, we scaled the backend to serve nearly *5,000–7,000 dynamic requests per second* from only eight app servers nodes. Our # of users to # of engineers ratio by far overtook Facebook's, even in the early days of the Internet giant. Our uptime was 99.99%. We had no security breaches. We did this all without Ops or QA teams, never "burning the midnight oil" or staying late at night. Anyone can build a web app, but that?... 

## What I can do for you.

At a somewhat high level, I am looking for consulting engagements with a high impact, constrained to maximum of 3 days a week. I see three possible directions, based on my level of comfort and previous experience:

  1. Senior Full-stack Ruby/Rails engineer, with extensive prior work in scalability, performance, database design and tuning, infrastructure automation, clean and adaptable software design, refactoring, design patterns, and TDD.
  2. Temporary or substitute Director of Engineering, VP of Engineering, Engineering Manager, or a CTO for a team of 0-30 developers.
  3. Systems Architect or Senior DevOps Engineer.

Couple of more specific points about each:

###  Ruby/Ruby on Rails Aficionado

I am very happy being a single senior contributor at the moment, because I love coding, have always remained an active coder, and have seen enough systems to be able to get up to speed quickly. My extensive software engineering background, from C/C++, Java, Perl, and Ruby give me the breadth of knowledge a lot of Ruby developers lack today. I can fix that – because I love mentoring more junior engineers, and have done a lot of mentoring in the past. If there are engineers that need to be "pulled up" in their skillset, I would be happy to pair with them. 

I love Ruby, as well as Rails, realizing fully what these two technologies did to the practice of web development and programming in general. I have been in love with Ruby since 2006, and it is my "go-to" language of choice. I have released several public libraries in Ruby that are in moderately wide use. 

I advocate for incremental but continuing investment in making software more adaptable, (i.e. easy to change and maintain), highly performant, and possible to scale horizontally across commodity hardware (or a cloud).  The concepts of micro-services architectures and DevOps have been my focus for quite some time, and across six different engineering teams.  

My strong preference would be to join an organization that already does pair-programming, or at least is willing to try it.

### Engineering Manager & a CTO

Perhaps you need someone to step into your engineering org, work in the trenches, increase efficiency, team happiness, establish better practices, resolve conflicts, provide feedback, suggest how the team can improve, and so on. Or maybe you need someone to represent engineering, report on engineering progress to the current management, founders or the Board. These are the exact types of challenges that I am quite familiar with and comfortable solving.

###  Systems Architect or Senior DevOps Engineer

This role typically involves looking at a system holistically, improving its uptime, performance, resilience, security, and scalability. I filled the role of systems architect, designing the production layout of our application components across 300+ cloud nodes, managing and optimizing resources, working with our cloud vendor on both technical issues and contract negotiation. 

I began building Wanelo's infrastructure using Chef from the very beginning, and the way it started it is still today. There are about 300 hosts managed using Chef, without the dedicated Ops team. 

While I realize that the word "architect," as it applies to software, has gotten quite a bit of bad taste within the last decade, born out of disdain for non-coding architects creating unworkable designs for others to implement. I get that. At the same time, large software projects require consistency in decision making, a "bird's eye view" oversight of the entire thing. Each and every engineer, at that point, can not possibly know and understand every other part of the system. Therefore on projects this large, architect's role is to work together with engineers, designing a database schema, or discussing pros and cons of introducing, say, RabbitMQ into the mix. Good architects still write code, but they are also responsible for keeping a pulse on commits and code reviews, so that whatever ends up getting built fits well into the rest of the systems assumptions, agreed upon conventions, and ideally is also reusable.

I love operational transparency in production, powered by full automation, comprehensive monitoring, and intelligent alerting that uses business metrics to decide if an alert is worth sending, thus resulting in just a few alerts a week. This approach enables small teams to manage large cloud deployments across any low-cost horizontally scalable infrastructure.

## Who am I, and how did I get here?

The following (extra long) section lazily tells my story, and is, perhaps, an optional read. 

Think of me as this alpha geek, who's geekiness was born out of desperation of how long it takes to do something new and interesting in mathematics. That impatience was one of the qualities that happen to be part of the three virtues of great programmers, where the other two are laziness and hubris. See threevirtues.com.

For four years, I studied mathematics, condensing the first two years into one. I graduated with honors, without taking a single computer science class. And yet, at the time, I was spending most of my free time hacking: installing early Linux from 84 diskettes, distributing my shareware for profit, starting an award winning website in 1996, gasping at the Mosaic browser's ugliness. I spent most of my time in the CS Lab, and I was there much longer than any of the CS people. They all knew me by name. It wasn't until I left college I realized that *this is what I want* to be doing full time, not mathematics. As one of the top graduates in my year, I was offered a prestigious position at a place equivalent to the famous AT&T Bell Research Labs. But I just couldn't do it. I jumped on an opportunity to join a small "outcast" company of hackers, UNIX system administrators, and Visual Basic developers, working as consultants on big and small projects, for other companies. I've had a blast with them, which pretty much established the direction of my career path for decades to come. The year was 1995, and the place was Australia.

### Ukraine (...– 1991)

But even before that, I was born in the Ukraine, where I grew up spending time in schools with advanced physics and mathematics programs. During the breaks or after school I would go to my mother's office – a physics department at a local university, where at 13 I was the only person who knew how to operate a lonely IBM 286 computer that the department procured.  I also competed at Olympiads, reaching national level twice, once in physics, and once in mathematics. 

### Australia (1992-1998)

My family moved from the Ukraine to Australia when I was doing my first year of college maths, and so I continued and completed my degree there for another three years. I then worked for another three years doing one-year contracts with various technology companies. My personal life was not working out at the time, and my best friend was finishing EECS degree at Berkeley, so in 1998 I arrived in the Bay Area to stay in his dorm, at the I-House. 

### US, Bay Area (1998 - now)

San Francisco was my second immigration, this time without my family. It was an era of the Internet boom, and I got hired in an instant. For the next seven years, I worked at an email company called Topica, where, as a founding engineer, and later, systems architect, I helped build one of the largest and fastest email delivery systems in the world. It was sending massive 200M messages a day, nearly 1% of all daily Internet email at that time (2000). It was not spam, but groups. Eventually, Yahoo bought our competitor, which then became Yahoo Groups, and which spelled the eventual end of Topica. The system we've built there, however, was highly available, fault tolerant, highly concurrent distributed transactional system, with horizontally partitioned dataset, and built atop of ORACLE database, and a powerful proprietary middleware called TUXEDO. It was quite far ahead of its time, based on its technology, but very much behind in business and sales.

Between Topica and now, I worked for a security company (RedSeal), a book publishing company (Blurb), premium mobile messaging SMS/MMS platform (DropInMedia, which I co-founded). After that I "accidently" ended up at three e-commerce companies in a row: a user generated modernist decals shop (Infectious), women's clothing shop (ModCloth), and the digital mall of the future (Wanelo). That said, I am not too keen on staying within e-commerce domain, and am ready to try something new.

## Thinking Outside the Box

Today, I see myself an almost obsessive "creator" as opposed to a "consumer."  It takes an effort for me to step away from the *creative process* (i.e. writing code, fixing something, building a hardware gadget) to *absorption* (i.e. reading books, watching talks, for example). I am normally able to focus on work with a fierce sense of focus, and when I am in the flow, I tend to be incredibly productive. But I have also learned to step outside my flow, when needed, and listen. I do that more and more now, as I appreciate both. 

Speaking of creating, when I was a kid I learned to play piano, and it always followed me everywhere. I was in the school jazz band, later becoming an electronic music producer and a DJ. I performed at various music events throughout Bay Area and far beyond since 1997. But my obsession with music didn't stop there: together with my wife, we created "PolyGroovers" – an electronic music duo, whose three albums are available on iTunes and SoundCloud (the latter for free). I still receive emails from people who love it, and that is extremely gratifying to me. I still improvise on my piano at home almost daily.  

Other things I've been doing in my life are white-water kayaking, 15 years of Burning Man, backpacking in Europe. More recently I got into Arduino, hardware, IoT, laser-cutting, enclosures, electronics, which makes me, I guess, a "maker." I built a "Bathroom Occupancy Remote Awareness Technology" (abbr: "BORAT") which I installed at Wanelo's office, and where it worked flawlessly for 13 months, becoming the irreplaceable part of the culture. You can find some other creations on my Google+ profile at https://plus.google.com/+KonstantinGredeskoul

I love learning new things, and I do so continuously, subscribing to a lifelong learning, so to speak. Be that Cisco firewall configuration language, gaming algorithms, hardware and electronics, plastic enclosure design, modeling and production, new programming language, or a piano piece. Most recently I signed up for an Electronic and Digital Circuits course from MIT, due in May. It is all fascinating to me, and I just wish that we had more hours in a day. 

*TL;DR:* This diversity of skills, a constant stream of creativity, as well as continuous learning, facilitate an "outside the box" type of thinking. It is what makes me a very strong player on an engineering team: I can fill many shoes pretty well, and a select few – *really well*. I can raise above any level of detail, and create abstractions necessary to break the problem down so that it can be understood and solved. All while mentoring the willing on how they too can do this exercise next time.

Thanks for taking the time to read all the way down to here! 


## Work at Wanelo

### What Wanelo Does 

Wanelo (“wah-nee-lo,” from Want, Need, Love) is a social store curated by the community. Wanelo's mission – is to create an open and connected market for all of the world's goods. You can buy almost everything you see on Wanelo, and the vast majority of products are posted by its members. Today Wanelo has grown to encompass 550K stores, 30 million products, and these products were saved by the users over 3B times. And as of 2015, Wanelo now directly integrates with thousands of stores hosted on the Shopify platform, sending orders made on Wanelo straight to seller's fulfillment interface on Shopify. And all consumers need to do to purchase, is to tap just twice: first on "Buy", and then on "Place Order" buttons.

### How did Wanelo Begin? 

I joined Wanelo right after Deena's (CEO, and a Founder) initial seed round, almost exactly four years ago. Working two jobs for a couple of weeks, I jumped into fixing site's continuous outages, which were the result of its popularity, and the unpreparedness of the early team of developers who worked on the first Wanelo "prototype".

After applying sufficient amount of "duck tape" gave the company a few months of breathing room, I focused on establishing a high-performance engineering practice within the newly formed team. Closely following the Pivotal Process, my team agreed to try full-time pair-programming, in addition to more familiar practices of continuous integration, daily deployments, and TDD. In just under two months that followed, with the team of six, we replaced the old Java app – 90K lines of code, no tests – with a compact Rails app – 10K lines of code, and half of them are in automated tests. We then brought the new application live, while also migrating the data from MySQL to PostgreSQL, AND swapped Cloud vendors all at the same time, – with only one hour of downtime. During which we greeted our visitors with a live kitten cam. Full story: http://bit.ly/ONeXPb

In August 2012, Wanelo launched iOS app that climbed to #1 in the Free Lifestyle Category on iTunes store within weeks, and with 60,000+ near 5-star ratings the app has been hovering around top 100. To keep up with the user growth, we scaled horizontally, which allowed us to support 10x traffic growth within seven months.

### What did I do at Wanelo? 

I was in a full hiring mode for quote some time, and I was particularly successful with identifying junior super-powers. I was able to hire a 17-year-old programmer from Texas, who ended up being one of the best engineers I've ever worked with, plus another young female, who also quickly became instrumental to our success.

One of my biggest goals, as a CTO (who also manages the team) is to enable the team to their full potential, identify any social issues, support our culture of collaboration, authenticity, and maturity in social interactions. I think the team very much appreciated having that as a core value.

From the very beginning our cloud infrastructure was completely automated with Chef (enterprise), and most of the software is covered by the automated tests. These two practices, introduced from the beginning enabled the company to avoid having to hire a dedicated Operations or QA teams. Cloud and CDN resources are now provisioned and configured by the developers, across a range of technologies and vendors. See the following presentation at RubyConf Australia 2015: http://www.slideshare.net/kigster/dev-ops-without-the-ops

My contribution to code, design, automation during early days remains integral, and still operational within the Wanelo system, which is now a thousand times more complex than when we started.

With a few senior developers, I was able to start incrementally scaling our infrastructure to support rising user growth. When application reached 200K RPMs, we knew we had to scale out horizontally. I spoke on this subject at a recent pgConfSV 2015 conference, which is a conference for PostgreSQL users and developers. My talk presentation is here http://sw.im/scale-wanelo – an 110-page recipe book for scaling web applications.

The combination of successful team building, as well as reaching horizontal scaling problems, and then solving them together with my team, were the two main reasons I have been very happy during my tenure.

## Links

My blog probably has the most information about my recent projects:

http://kiguino.moos.io/ ## LinkedIn

<script src="//platform.linkedin.com/in.js" type="text/javascript"></script>
<script type="IN/MemberProfile" data-id="https://www.linkedin.com/in/kigster" data-format="inline" data-related="false"></script>
