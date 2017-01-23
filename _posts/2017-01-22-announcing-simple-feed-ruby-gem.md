---
layout: page
title: 'Announcing SimpleFeed — a scalable and easy to use pure ruby/redis solution for social feeds'
draft: true
---

## Activity Feeds — The Good, The Bad, and Slow

We see them everywhere: social networks such as FaceBook, Twitter, GitHub, LinkedIn — they all have them. A list of events, typically the newest at the top, about things we should "care about": such as content from people we follow, important events of our own, or even events from our geographic location — like on NextDoor.

It just makes sense: in addition to having a dynamic information based on your interests, modern sites can show you a highly personalized view into what is happening over time, and people love it.

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


