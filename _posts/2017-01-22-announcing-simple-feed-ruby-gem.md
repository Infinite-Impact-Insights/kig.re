---
layout: page
title: 'SimpleFeed — a scalable and easy to use open source library for building social feeds'
draft: true
---

# Social Feeds — The Good, The Bad, and the (not so) Slow

The word "feed" has a bit of a mythical origin, but what it describes is rather well understood at this point. 

**[Data Feed](https://en.wikipedia.org/wiki/Data_feed)** is defined by the Wikipedia as a 

> ... mechanism for users to receive updated data from data sources.

It then goes into describing types of feeds such as the RSS or News Feeds, Web Feeds, and even Product Feeds — all of which I had to deal with extensively in my career.

This is why I have a particular responsibility to explain them to everyday folks, in a way that makes sense. And so to do that, I am going to make a, what will most definitely become, a very controversial statement on the Internet.

---

__This is because some people feel very uncomfortable with the admission that a Feed is just a List!__  A dumb, ordered list, consisting of stuff. 

---

Really! 

> *Actually, no, not realy. I don't think anyone's really pissed off about this, but only the web geeks are going shopping with a shopping feed. Most of us are still shopping with the list*.

Ok so maybe the "stuff" in this feed is a bit special — you see, its meant for computers. Let me explain.

If I *scribble* you a shopping list on a piece of paper, — that's just a shopping list. But if I enter this list into an Excel, or into a database, then suddenly this list turns into a form that an average modern day computer can "consume". It can then "*do stuff*" with this list. Like — in the case of a product feed — it can search and compare prices. 

And so *feed is just a list of things that is intended for a computer to ingest*, with the goal of doing some post-processing, or perhaps just spewing it out back at people, but in a different format. This is what the RSS, or News Feeds essentially are: content in a format that various computer programs can easily understand and reformat for reader's consumption.

In the world of the world wide web, and in particular, the world of the Social Web, feeds are commonly just lists of various events that have already occured. Such a feed is often referred to as an "Activity Feed". And it just makes sense: you the see activity that matters to you, and — even more importantly — *as the new activity occurrs, it is "fed" to you via this feed*. We are all being fed with information, that comes through a feed(-ing tube?[ -ED.]).

> In the 20th century, we've been trying to feed everybody, but in the 21st century feed for everyone. — Socrates.

I know, it's horrible, horrible, pun. Let's just pretend it didn't happen. Thanks, I really appreciate it. No, really, Socrates never said that. 

...

---

Activity This
=============

We see these activity feeds everywhere these days: social networks such as FaceBook, Twitter, GitHub, LinkedIn — they all have them. 

It starts off as a mere list of events, typically the newest at the top, and carries content that is, in general, relevant to us — such as the activity or content posted by the people we follow, or important events from our friends and family, or events from our geographic location, or — even — our own events. In this sense, you could probably say that Snapchat has a 24-hour feed (with its Stories feature), while other networks have a much longer (if not — forever) long feeds.

And it just makes sense: in addition to having a dynamic information based on your interests, modern sites can show you a highly personalized view into what is happening over time, and people love it. We love it. 

I love it too! In fact, it bothers me when I come to a web site, or an application that fails to show me a time-ordered list of interesting events that I should care about. Why not? 

Perhaps the reason is this — it's not that easy to build this feature from scratch — this elusive activity feed, that collects so many different types of events from all sorts of users, and is able to render the feed (ie, serve you a web page, or show you an app screen) quickly. 

How do I know this? 

Well, funny you should ask. You see, I built more than of those things for various social networks I worked for, and they are all still live and in production. 

My previous employer — Wanelo.com — uses activity feeds for both the "Magic" and "My Feed" features. In Wanelo's case, the feeds are populated with products.

The company I work for now — Simbi.com — is a social network for symbiotic economy: where people can barter services with each other. 

And it was Simbi that kindely supported the development of the open source library called [Simple Feed](https://github.com/kigster/simple-feed), which I am very happy to announce to the world, even though it has already been mentioned on the Peter Cooper's [Ruby Weekly](http://rubyweekly.com/issues/336).

SimpleFeed is a pure ruby library that uses [Redis](http://redis.io) as a storage mechanism, and deals with storing pure strings in the feed, associated with the timestamp. Because the library simple stores strings, it is left to the developer that uses then library to decide how exactly to serialize their data in the feed. 


### Wow, I want one!

If you wanted to add a social feed, or a news feed to your site today —
there are several pretty good options. A couple of them are written in Ruby. Unfortunately, many of the options are either Rails-specific, or they are rather extensive in what they offer and how much code and functionality they load into your ruby VM when used.

Well, perhaps [the new library I am announcing today](https://github.com/kigster/simple-feed), called [**simple-feed**](https://github.com/kigster/simple-feed) may help fill the sweet spot by being both _rich in typical  functionality needed to implement an activity feed_, and yet _simple enough_ that it would take very little time and effort to integrate it and enable social feeds on any site. 

What's more, it can easily scale to support millions of users with just a few small configuration changes, typically done by the dev-ops engineers. But we are getting a bit ahead of ourselves.


{{site.data.macros.continue}}


### What is an Activity Feed?

Activity feed is a visual representation of a time-ordered, reverse chronological list of events which can be:


 * personalized for a given user or a group, or global
 * aggregated across several actors for a similar event type, eg. "John, ary, etc.. followed George"
 * filtered by a certain characteristic, such as:
   * the actor producing an event — i.e. people you follow on a social network, or "yourself" for your own activity
   * the type of an event (i.e. posts, likes, comments, stories, etc)
   * the target of an event (commonly a user, but can also be a thing you are interested in, e.g. a github repo you are watching)

Here is an example of a real feed powered by this library, and which is very common on today's social media sites:

<img src="https://raw.githubusercontent.com/kigster/simple-feed/master/man/activity-feed-action.png" width="100%" border="1">

What you publish into your feed — i.e. _stories_ or _events_, will depend entirely on your application. SimpleFeed should be able to power the most demanding *write-time* feeds.

## Typical Implementation Challenges of Social Feeds

Building a personalized activity feed tends to be a challenging task, due to the diversity of event types that it often includes, the personalization requirement, and the need for it to often scale to very large numbers of concurrent users.  Therefore common implementations tend to focus on either:

 * optimizing the read time performance by pre-computing the feed for each user ahead of time
 * OR optimizing the various ranking algorithms by computing the feed at read time, with complex forms of caching addressing the performance requirements.
 
The first type of feed is much simpler to implement on a large scale (up to a point), and it scales well if the data is stored in a light-weight in-memory storage such as Redis. This is exactly the approach this library takes.

For more information about various types of feed, and the typical architectures that power them — please read:

 - ["How would you go about building an activity feed like Facebook?"](https://hashnode.com/post/architecture-how-would-you-go-about-building-an-activity-feed-like-facebook-cioe6ea7q017aru53phul68t1/answer/ciol0lbaa02q52s530vfqea0t) by [Lee Byron](https://hashnode.com/@leebyron).
 - ["Feeding Frenzy: Selectively Materializing Users’ Event Feeds"](http://jeffterrace.com/docs/feeding-frenzy-sigmod10-web.pdf) (Yahoo! Research paper).


