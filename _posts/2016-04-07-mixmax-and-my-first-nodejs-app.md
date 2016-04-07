---
layout: page
title: 'MixMax link resolvers, and my first node.js application'
---

## MixMax

<div class="small-right">
{% lightbox_image { "url" : "/images/mixmax/mixmax-slash-commands.png",  "title": "MixMax Slash Commands", "group":"mixmax" } %}
</div>

A few days ago I was blown away but what a (still) little-known startup called [MixMax](http://mixmax.com) is doing with email —
nothing short of revolutionizing it! If you haven't see it yet, do check it out, especially if you often find yourself scheduling
meetings or lunches over email, asking for feedback, conducting polls or sharing rich media with others.

MixMax "decorates" (a software term for "enhances") standard Gmail functionality with a lot of goodies, which are accessible from
both the GUI as well as via the "slash" commands, like is often seen in infamous [IRC](http://www.irc.org) clients (which, perhaps, pioneered this approach), or a more recent app [Slack](https://slack.com), or any multi-player online video game. Slashes are just the way of commanding the computer, and we are pretty used to that.


{{site.data.macros.continue}}


<div class="small-right">
{% lightbox_image { "url" : "/images/mixmax/calendar_drag_preview.gif",  "title": "MixMax Slash Commands", "group":"mixmax" } %}
</div>

So imagine my joy, when I realized that with a simple `/cal` I can now insert a few
available time slot options in my email, and request the recipient to choose one.
Once they do, the event is inserted into my calendar right away. This is magic!

## Extending MixMax

Of course, one of the first things I did was to see if the tool is extensible, and
to my delight, [it sure was!](http://sdk.mixmax.com/)  So, with a bit of free time
on my hands, and a long standing desire to get a bit more Node.JS under my belt,
I embarked on an adventure of building a simple link resolver for [Wanelo](https://wanelo.com) –
the fantastic product discovery site, and a social network where I worked until
pretty recently.

## Using an IDE

I will admit that I am a big sucker for [JetBrains](http://jetbrains.net) series
of IDEs. Having learned one (the Java IDE [JetBrains IDEA](https://www.jetbrains.com/idea/)
a very long time ago, I feel that I pretty much know them all now, because of
how many similarities are between each IDE. JetBrains did a fantastic job at
abstracting out functionality of an IDE away from a specific language or a framework,
and thus building us a series of best of breed IDEs on the market.

I love them so much that I recently purchased a two-year long [All Products Pack](https://www.jetbrains.com/store/?fromMenu#edition=personal) that gives me
all of their IDEs! It's actually a pretty damn amazing deal. And no, I do not
receive commissions from JetBrains, I am simply a very enthusiastic user.

### WebStorm

The IDE for building JavaScript and node applications is [WebStorm](https://www.jetbrains.com/webstorm/).

> If you like my environment below, I highly encourage you to [download and import my WebStorm Settings](/downloads/webstorm-2016.1-settings.jar), as you'll get bunch of goodies with this settings file.

If you have never used JetBrains IDE – just take a look at this screenshot, and
try to comprehend just how much is going on there on my screen, all within the
confines of my development environment.

{% lightbox_image { "url" : "/images/mixmax/webstorm-mixmax-resolver.png",  "title": "WebStorm IDE with MixMax project loaded", "group":"mixmax" } %}

## Project 'wanelo-mixmax-link-resolver'

To cut the long story pretty damn short, [I built a small project](https://github.com/kigster/wanelo-mixmax-link-resolver)
to resolve Wanelo product URLs into a small widget that looks like this:

{% lightbox_image { "url" : "/images/mixmax/mixmax-wanelo-preview.png",  "title": "Preview of the Widget I built", "group":"mixmax" } %}

Along the way I had to figure out how to

  * actually organize code in a Node.JS projec
  * how to add runtime and development dependencies
  * how to setup automated unit testing
  * and how to deploy it all on Heroku.

I will add all these details in a follow-up blog post, but for the time being,
[please checkout the GitHub Repo](https://github.com/kigster/wanelo-mixmax-link-resolver) – note that it contains instructions, should
you choose to install this resolver for yourself.


Thanks for reading!

/signoff
