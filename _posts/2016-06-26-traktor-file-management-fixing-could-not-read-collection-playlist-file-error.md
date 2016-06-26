---
layout: page
title: 'Native Instruments Traktor — Fixing Dreaded "Could Not Read Collection/Playlist file" Error'
---

## "Not a Rant" Rant

I'll start by saying that I love Native Instruments, and software and hardware that they make. Not all of it is a hit, but overall the company is definitely one of the undisputed leaders in the Digital Audio space.  I own Komplete versions 2 to 10, Traktor S4, S5, F1, Kore2 and a few others.

I've [created albums using NI tools](https://soundcloud.com/polygroovers), [some of which are available on iTunes](https://itunes.apple.com/us/artist/polygroovers/id160976572),  and I've never pirated any of the NI software by principle – being a software engineer, I was able to appreciate the colossal effort they've put into each and every synth.

### Reality Strikes

That said, being a software developer I have also been __continually amazed at how abysmal the file management interface is in Traktor__, and in fact in all other NI plugins too. With the CoreAudio&trade; Plugins I can usually get around it, since I use Logic Pro X&reg; as a DAW.

> But nowhere is the file management disaster is more in-your-face-obvious, aggravating, and frustrating, than in their flagship DJ product – Traktor.


{{site.data.macros.continue}}

### It Should Have Been There 5 Years Ago

Traktor has been around for quite a few years now, and the same complaints I had five years ago, are still  valid. And what I want is really not rocket science, it's complete basics.

Hopefully someone from NI will read this blog post, and add these feature requests that should have been there from the beginning to their list. And if and when Traktor comes out with some of these features implemented, I promise to go back and update this post.

* Simple UNDO functionality when working with Playlists?
* Single key DELETE of a track from a playlist? If I did it wrong, I can always undo. Or can I?
* Key binding. How about map Cmd-D to delete from a collection + disk?
* How about copy a tree of playlists and then paste it elsewhere?
* Etc... etc... etc..

Instead of these basics, you are supposed to sit their with your mouse and organize your tracks by looking at a 15px tall line of text. Thank God for the Ctrl-Scroll feature on the Mac. Oh, that's right, they _did add this feature in the later versions of Traktor_ – and you can now indeed increase the text font size. But still, you can't hit Delete key to delete (without a stupid confirmation, and with a no-brainer Undo option) a track from a playlist! In 2016! I don't have enough exclamation points to emphasize this last one.

But that's not all. In addition to these basic things we've come to expect from a well designed (from UX-standpoint) modern software, there are just glaring bugs like the one I will try to address in this blog post.

It hit me earlier today, and feeling fed up with Traktor's misbehavior with file management for years, I decided to finally take it out here, and help fellow Traktorians, raped daily by this software in all so many nasty ways, heal maybe just some of their PTSD-related nightmares.

### Ok, it's a Rant

I mean, honestly, I could rant about how absolutely abysmal Traktor's file management is for a long time, but it would get boring fast. Instead of a rant, I'll just make a short allegorical side note that's barely visible on this blog, and not at all emphasized. Feel free to skip if you are in a hurry.

> Traktor. If you and are were to get married, I would parade you like a trophy wife. You look gorgeous. You are the envy of the town. Your ability to mix drinks is beyond imaginable. Your effects are from the future, and your style pushes the boundary of what's possible today.

> And so why, why is it that in the bedroom you are one lousy celibate prude? Why is it that you won't push the boundary of what's possible there too?  When I ask you to import a collection that you yourself,  just a few seconds ago saved to disk... Why!!! Do you give me the dreaded "_Could Not Read Collection/Playlist File_" error? Wasn't it you damn yourself who just created that file to begin with? Wasn't that you who used ugly caps to write nasty XML tags into the file that makes even the ugliest formats look pretty by comparison?

> So here I am, calling on you, Traktor-wife, to go and train with some kinky clan in San Francisco, and finally learn how to manage files easily, quickly, cleanly, repeatedly, consistently, how to automatically detect that the hard-drive's name has changed and just remap the top folder without invalidating the entire collection! How hard is that? Open source your file management software, and the community will fix it in a weekend. Who, am I kidding, in an __hour__.

> What if I move a folder? Rename my hard disk? Move to another computer? Oh God, no no no, all of that breaks Traktor! Rename back, quick! Oh wait, but the collection file is already saved and overwritten, and all my playlists are goooooone! Fuuuuuuuuuck!  

<div class="pull-right">
— last day in the life of one Traktor User, minutes before suicide, Oils and Blood,  "Anonymous".
</div>
<div style="clear: right; margin-bottom: 20px;"></div>

Anyway, you get the point. I guess that was a bit of a rant.

##  Problem: "Could Not Read Collection/Playlist file"

This shows up very briefly in red when you open Traktor and voila – the playlists are empty.

### Diagnosis

The problem, in my case, and as I have suspected, was that the XML file `collections.nml` was not a properly formed XML file.

{% lightbox_image { "url": "/images/traktor/traktor--badxml.png", "title": "Traktor Bad XML", "group": "traktor", "class": "clear-image" } %}

In my case it contained illegal (possibly UTF8) characters that came from a bogus filename of one of the imported files. Presence of this data in the XML file rendered it unreadable for most XML parsers, including the one Traktor uses internally.

> __RANT WARNING__. Good software would have captured the error from the XML parser, which often includes the exact line and column where the error occurs, and often even the data. It would have printed this error on the screen, so that I could go and manually try to fix this. Instead Traktor swallowed this error, not printing it anywhere, — _even in its own log file!_ — and proceeded to boot with a blank set. Because that's what you've asked, right?'

> Not to mention the fact it was Traktor in the first place that __create this file__!

### So, Why Did This Happen?

This may happen after you:

 * Restarted a Traktor post importing a large collection of new or creating new playlists or folders
 * Tried to import a collection from a backup, or someone else's file
 * Some other way ended up adding a new file that contained bad characters, that Traktor failed to filter out.

### What's Going On?

The file where Traktor stores its data is called `collection.nml`. It usually lives in Traktor's home folder (which you can change via it's Settings > File Management). The same folder may also have a file called `collection_backup_invalid.nml` or `collection_backup_outdated.nml`.

The first thing you'd want to do is to figure out which of these files contains the collections you would like to become "active" collection, and once you do – please make a copy/backup of that file.

Let's say you started Traktor with a blank set (so the initial`collections.nml` file is very small), and then added a ton of files and samples, organized playlists, etc. It's not until you normally exit Traktor that it will save your most recent changes to a file. (By the way, do not Force-Quit Traktor after making many changes to your play lists, or your changes won't be saved). So if we list the files in Finder using the list view (see image below) we should be able to tell which of them is a tiny file, and which of them is a larger file with the real tracks.

{% lightbox_image { "url": "/images/traktor/traktor-file-error--finder-view.png", "title": "Traktor Root Folder", "group": "traktor", "class": "clear-image" } %}

Let's say you determine that it is the "invalid" file that contains your actual data:

```
cp collection_backup_invalid.nml collection-my-backup.nml
```

Now we have a backup file of your full collection, so we can proceed to munge the invalid file until it's valid.

### Detecting XML Errors

I detected the error using the `xmllint` tool that's installed  on Mac OS-X by default. If you don't have one, you can install it with Homebrew:

```
brew install libxml2
xmllint --version
```

The above commands (as well as subsequent commands) are meant to run inside Terminal (or do yourself a favor, and install [iTerm2](https://www.iterm2.com/) please).

You need to `cd` into the Traktor's Root directory (I explain in the next section how to find your root folder, but this section is for the _impatient_).

```bash
cd ~/Documents/Native\ Instruments/Traktor\ 2.10.2
```

Now run the following command (assuming that your old collection is in the file `collection_backup_invalid.nml` — this happens when Traktor boots up, it will move your old one into this file, while regular `collection.nml` will be a tiny valid but blank as a dead fish's stare.)

```bash
xmllint --noout collection_backup_invalid.nml 2>&1 | head -10
```

On my machine I saw the following:

```
collection_backup_invalid.nml:14195: parser error: invalid character in attribute value
MzMzMzMzIjMiIjIzIQ==" TITLE="MidBass3°%/
                                        ^
collection_backup_invalid.nml:14195: parser error: attributes construct error
MzMzMzMzIjMiIjIzIQ==" TITLE="MidBass3°%/
                                        ^
```

From this you can deduce that the character following MidBass3 in the title of that track is something that trips XML parser. What we want is to see no output at all when we run `xmllint --noout` – this would indicate that the XML parsed successfully.

### How to fix this XML corruption?

This is largely up to you. But it revolves around these steps:

1. __Quit Traktor!__ This is the most important step :)
2. Run `xmllint` to find errors as shown above
3. Use your favorite editor to remove the errors
   * You can remove entire lines from the file but then you risk having other parts of the file reference something that doesn't exist. So I think it's much safer to...
   * Use find/replace to "fix" bad filenames or bad titles, or any other bad string in the XML file.
   * Your editor's capabilities will determine how exactly you'll proceed.
4. Save & repeat until no more errors are found.

In my case, I used regular expressions and `vim` editor to replace the offending file names. My steps were:

1. Open the file`collection_backup_invalid.nml` in an editor capable of doing global find/replace with regular expressions, for example `vim collection_backup_invalid.nml`
2. Run the following replacement command in "Vim": `:% s#MidBass\(\d\)\?[^"a-zA-Z0-9._ ]\+.\?\*"#MidBass\1-bad"#g` and press ENTER. See below for regex explanation if you care.
3. Save the file (vim: `:w` and ENTER).
4. Run `xmllint` again. Find more errors and repeat for all occurrences of errors until no more errors are printed.

In the above fix we have likely messed up the actual file entry for MidBass[1,2,3,etc], and won't be able to open that particular file (or files), but the gain is that if the XML file is now, hopefully, valid, we should be able to copy it into `collection.nml` and boot Traktor again.

### Once XML is Clean

__WARNING__: command below assumes that your `collection.nml` is a tiny file that's been overwritten by Traktor, and that `collection_backup_invalid.nml` contains the "fixed up" content we want.

Let's copy our fixed file over the one that Traktor will use during it's boot:

```
cp collection_backup_invalid.nml collection.nml
```

And now lets try to start Traktor again.  If you are as lucky as I was – your Traktor will now boot, and all your old playlists will still be there :)

## Longer Explanation with Screenshots

### Finding Traktor's Root Folder

The first thing you will need to figure out is your Traktor's "Root" folder. Go to "Settings, File Management" and it will be the first folder in the list, as shown below.

{% lightbox_image { "url": "/images/traktor/traktor--prefs.png", "title": "Traktor Preferences", "group": "traktor", "class": "clear-image" } %}

Next, let's open that folder in Finder.


### Finding Traktor's Log File

First of all – notice the `Logs` folder there. Inside of it is the `Traktor.log` file. Double-click this file, and the __Console__ Application should pop up on Mac OS-X.

While you are debugging Traktor it's a good idea to keep Console open, as it will automatically show any new messages printed to the log file at the bottom. Which will be helpful, because the actual error message shown during Traktor's boot time does not stick for very long:

`WARNING: Could not read collection/playlist file:Macintosh HD:Users:boo:Documents:Native Instruments:Traktor 2.10.2:collection.nml`

{% lightbox_image { "url": "/images/traktor/traktor--console.png", "title": "Traktor Log File", "group": "traktor", "class": "clear-image" } %}

I recommend to keep this window open while we perform any operations below, and in the future — if you ever experience issues with Traktor — this should be the first place you look.

### Replacing Things in VIM

As you may remember, I used the following regex to "fix" my file:

```vim
:% s#MidBass\(\d\)\?[^"a-zA-Z0-9._ ]\+.\?\*"#MidBass\1-bad"#g
```

Basically, % means all file, 's' means replace, # becomes a delimiter of what I am replacing with what is the replacement.

My search is "MidBass", followed by an optional digit which I am capturing (and using later as "\1). The optional digit must be followed by a character NOT from the classes described, meaning it should be a non-text, non-digit, etc. character (meaning – a baddie daddy lamata ). It can then optionally be followed by any other character until a double quote, but "\?" makes it non-greedy and stops at the first match (instead of matching all the way till the end of the string).

## Conclusion

I hope this helped some of the Traktor users out there with the head scratching problem.

In the meantime, I hope that NI will fix these issues and update their File Management interface to be more modern, robust, flexible and consistent. Because it's already about 10 years late to the party.

~ Konstantin / (aka [DJ LeftCtrl](https://soundcloud.com/leftctrl).
