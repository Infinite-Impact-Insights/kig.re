---
layout: page
title: 'SimpleFeed — a scalable and easy to use open source library for building social feeds'
draft: true
---

# Feeding Frenzy with ["Simple Feed"](https://github.com/kigster/simple-feed)
---
##### Or — how to enable a social feed on your (ruby-based) web application in fifteen minutes

---

### For the Impatient

In quick summary, in this post I am very excited to announce the official release of the open source ruby library called [Simple Feed](https://github.com/kigster/simple-feed), released as a [ruby gem](https://rubygems.org/gems/simple-feed). 

I was and still am the primary developer on this project, and my name is [Konstantin Gredeskoul](https://kig.re) — which you probably already knew. This library would not have been possible without the generosity and sponsorship of my current employer [Simbi.com](https://simbi.com). 

The software is running live in production, and is powering three separate social feeds on Simbi: the global feed, followers feed, and "own" feed — events related the feed owner's actions:

<img src="https://raw.githubusercontent.com/kigster/simple-feed/master/man/activity-feed-action.png" width="100%" border="1">

The software is distributed under the [MIT License](http://opensource.org/licenses/MIT) and is available today. It's written in [ruby](https://www.ruby-lang.org/en/), and does not depend on [Ruby on Rails](http://rubyonrails.org), therefore it can power applications running on Rack, Sinatra and using alternative web frameworks. Having said that, at Simbi we are using it with Rails, and I may release a small Rails adapter for SimpleFeed in the future.

It's short-list of features is:

 * You can define any number of feeds per Ruby VM
 * SimpleFeed stores pure strings associated with a floating point number (typically – time), and so does not assume any specific format of the data
 * The data is stored in pluggable backends, with `Redis` and `Hash` providers supplied.
    * New providers can be easily built and used with the same API.
    * Using [Twemproxy](https://github.com/twitter/twemproxy), the backend can be transparently sharded to support millions of users.
    * Redis provider is optimized for multi-user batch operations, such as posting an event to many users at once using Redis `pipeline`.
 * Rich API allowing both single-user (ie, for reading the feed) and multi-user (ie for writing to feed) batch operations
 * Powerful DSL
 * Near 100% test coverage :) 

For information on how to use, install and other technical details I refer you to [README](https://github.com/kigster/simple-feed) or to the more detailed discussion below.


{{site.data.macros.continue}}


### Feeds 101

The word "feed" has a bit of a mythical origin, but what it describes is rather well understood at this point.  A related term **[Data Feed](https://en.wikipedia.org/wiki/Data_feed)** is defined by the Wikipedia as a _... mechanism for users to receive updated data from data sources._

Wikipedia then goes into describing various types of feeds, such as the RSS or News feeds, Web feeds, and even Product Feeds — all of which I had to deal with extensively in my career.

This is why I feel that I have a particular responsibility to explain them to folks that may not fully get the concept, in a way that just makes sense. And there is no better place to start, than to clarify that....

> A feed is just a _list_. An ordered list of things, and typically — similar looking things.

— Really? — You might exclaim.

— Yup. It's a list of things, but it does have some special properties. 

You see, its meant to be consumed (or read, loaded, imported) by the computers, not humans. At least this is how the word "feed" entered into the technical gargon in late 90s. 

If I *scribble* you a shopping list on a piece of paper, — that's just a **shopping list**.

But if I enter this list into an Excel, or into a database, then suddenly this list turns into a form that an average modern day computer can read. It can then "*do some awesome stuff*" with this list. Like — in the case of a [product feed](https://www.shopify.com.au/resources/product-feed-management) — it could search for products on the Internet, and compare prices, or verify product availability, etc. In fact, I built an app that did just that. 

But what's true, is that only the web geeks like myself (and, perhaps, some very progressive teenagers) are going shopping with a [shopping feed](https://wanelo.co/trending). Most of us are still shopping with a simple list.

And so with the understanding that a **feed is just a list of things that is intended for a computer to ingest**, we can move forward, and talk about Social Feeds, which are, ironically, intended for humans.

In the world of World Wide Web, and in particular, in the world of the Social Web, when we mention the word "feed" when we talk about a time-ordered list of events that have occured. We might even call this an "Activity Feed". And it makes sense: you the see activity that matters to you and the connections you made on the social network. 

Importantly, *as the new activity occurrs on the site, it is "fed" to you via this feed*. You could say that we are all being fed information that comes through a feed(-ing tube?[ -ED.]).

### Feed This

We see these activity feeds everywhere these days: social networks such as FaceBook, Twitter, GitHub, LinkedIn — they all have them. 

It's a common sense — in addition to tailoring information to your interests, modern applications show you a highly personalized view into what is happening over time (including right now), and people love it. We all love it, and I love it too.

In fact, it really bothers me when I signup or register for a new application only to realize that I can't easily see what's going on: what are my friends doing, what I am doing, what else is going on? 

> It feels awefully quiet on a social site without an activity feed.

And the number of sites that don't offer an activity feed is still staggeringly large. 

And so why is that?

Perhaps the reason is that **it's not that easy to build this feature from scratch** — the activity feed is a moderately difficult software project. It is difficult, because:

 * The feed collects many different types of events from many users, and often has complex rules as to what is shown to the user, and when. 
 * The feed must be updated nearly in real time, so as new events happen, they should immediately show up in user's feeds. 
 * the feed must be shown to each user quickly, or people get bored and leave. How many times have you quit an app that was stuck "spinning its wheels"?
 
The last two requirements — being near real time, and being fast to render — are at a conflict with each other. This is why it took Twitter so long to get this right at a huge scale. The renown ["Bieber" problem](https://www.wired.com/2015/11/how-instagram-solved-its-justin-bieber-problem/) which occurs when Justin Bierber tweets to his tens of millions of followers, generates enormous activity on Twitter's backend.

Luckily, most social sites aren't Twitter.

### Feed Simple

So who do I know so much about these feeds, you might ask?

Well, funny you should ask. You see, I built more a few of them for various social networks I worked for, and they are *all still live and in production*!  

My previous employer — [Wanelo.com](https://wanelo.co) — uses activity feeds for both the "Magic" and "My Feed" features. In Wanelo's case, the feeds are populated with products, and the software powering these feeds did experience the "Bieber Problem", except not with Justin Bieber, but with the very popular store [Urban Outfitters](https://wanelo.co/urbanoutfitters), that amassed over 3M followers on that social network. Whenever the store would post a new product, three million followers must see that product in their feeds. That's no simple feat.

The company I work for now — [Simbi](https://simbi.com) — is a social network for symbiotic economy: where people can barter services with each other. Having social feed there was a natural fit, if not a real neccessity. 

And it was Simbi that kindely supported the development of the open source library called [Simple Feed](https://github.com/kigster/simple-feed), which, belatedly, and in this post, I am very very happy to announce to the world, even though it has already been mentioned on the Peter Cooper's [Ruby Weekly](http://rubyweekly.com/issues/336) (thanks Peter!).

**SimpleFeed** is a pure ruby library that uses [Redis](http://redis.io) as a storage mechanism, and deals with storing pure strings in the feed, associated with the timestamp (or to be precise, with any floating point number that defaults to time). 

> Because the library only stores string data type, it is left to the developer that integrates the library to decide how exactly to serialize their data in the feed. 

### Wow, I want one!

If you are a site owner, and you've always wanted to add a social feed, or a news feed to your site today — there are several pretty good options. 

A couple of them are written in Ruby. Unfortunately, many of the options are either Rails-specific, or they are rather extensive in what they offer and how much code and functionality they load into your ruby VM when used.

That's not to say these options aren't good, and perhaps if you were to consider building one, I'd recommend that you reviewed them all.

Here are the ones I found:

 * [GetStream.io](https://getstream.io/) is a commercial solution with clients in many languages, as well as the REST API. For someone with a very low site traffic this might be one of the best options, if you are OK relying on a 3rd party for uptime and reliability.
 * [activity_feed](https://github.com/agoragames/activity_feed) — is an open source ruby gem that's probably the closest one to *SimpleFeed*, but unfortunately it lacks some pretty basic features: for example, it assumes you want to define one and only one activity feed in your application: you configure your feed at the global level. In SimpleFeed you can configure as many specialized feeds as you like. Also, it offers some strong opinions about what is stored in the feed, ie the data structure of the feed item. SimpleFeed does no such thing, and stores pure strings, leaving it up to you to decide how to serialize your data.
 * [public_activity](https://github.com/chaps-io/public_activity) — is another open source ruby gem that's quite a bit out of date.

And so with the above options out of the way, I encourage you to give [SimpleFeed](https://github.com/kigster/simple-feed) a powerful test-drive, and perhaps it will fill the sweet spot of your needs, by being both _rich in functionality typically needed to implement a diverse activity feed_, and yet _simple enough_ that it would take little time and effort to integrate it and to enable social feeds on your site. 

What's more, it can easily scale to support millions of users with just a few small configuration changes, typically done by the dev-ops engineers. 




### References

 - ["How would you go about building an activity feed like Facebook?"](https://hashnode.com/post/architecture-how-would-you-go-about-building-an-activity-feed-like-facebook-cioe6ea7q017aru53phul68t1/answer/ciol0lbaa02q52s530vfqea0t) by [Lee Byron](https://hashnode.com/@leebyron).
 - ["Feeding Frenzy: Selectively Materializing Users’ Event Feeds"](http://jeffterrace.com/docs/feeding-frenzy-sigmod10-web.pdf) (Yahoo! Research paper).


