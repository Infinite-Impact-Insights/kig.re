---
layout: page
title: 'How to Bash Your Terminal, and Bash-It Good...'
draft: true
toc: true

---

Those of us who work on building software inevitably spend a portion of our time typing various commands on the command line.

And, unlike twenty years ago, when our terminal was a non-graphical ASCII terminal, today's terminals are very feature rich and able to express things like millions of colors, fantastic new fonts, not to mention community shortcuts and goodies that are packaged in convenient libraries such as __[Bash-It](https://github.com/Bash-it/bash-it)__, or __[Oh My ZSH](https://github.com/robbyrussell/oh-my-zsh)__.

## Some History

<div class="small-right">
{% lightbox_image { "url" : "/images/bash-it/msdos.gif",  "title": "MS DOS", "group":"prompts", "class": "command-line" } %}
</div>

A very long time ago, some day back in 1999, I switched to the Mac OS-X as soon as it was released for one and only one main reason: __the glorious Free-BSD-like command line__. Believe it or not, but until that, our choices of operating systems were pretty much limited to _Microsoft Windows_, with it's horrendous _[MSDOS](https://en.wikipedia.org/wiki/MS-DOS)_ command prompt mode, _[MacOS9](https://en.wikipedia.org/wiki/Mac_OS_9)_, which did not have a command prompt AFAIK, and of course the early versions of _[Linux](https://en.wikipedia.org/wiki/Linux)_, which at the time often required installation from about 80 floppy disks.

<div class="small-right">
{% lightbox_image { "url" : "/images/bash-it/macos9.jpg",  "title": "Mac OS9", "group":"prompts" } %}
</div>

I was a huge fan of the UNIX command line, and it's ability to __pipe__ commands to each other, and construct complex and very powerful means of processing text, filtering, replacing or counting anything that vaguely resembled a parseable text file.

But until then, we had to deal with something like this:

* quick intro into the project
* why run bash-it?
* powerline fonts and prompts
* reinvent1 prompt
* extending bash-it

{% lightbox_image { "url" : "/images/bash-it/bash-it-installing.png",       "title": "Bash-It: Installing it", "class": "command-line" } %}
{% lightbox_image { "url" : "/images/bash-it/bash-it-powerline-1.png",      "title": "Bash-It Theme: Powerline Multiline", "class": "command-line" } %}
{% lightbox_image { "url" : "/images/bash-it/bash-it-powerline-1.png",      "title": "Bash-It Theme: Powerline Multiline", "class": "command-line" } %}
{% lightbox_image { "url" : "/images/bash-it/bash-it-reinvent1-prompt.png", "title": "Bash-It Theme: Reinvent1", "class": "command-line" } %}
{% lightbox_image { "url" : "/images/bash-it/bash-it-running-tests.png",    "title": "Running Tests in Bash-It", "class": "command-line" } %}
