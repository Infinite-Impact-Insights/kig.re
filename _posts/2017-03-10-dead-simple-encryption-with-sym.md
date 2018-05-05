---
layout: page
title: 'Dead Simple Encryption with Sym'
draft: false
toc: true
---

<div class="large">
<strong>A story about how your mom can now protect her application secrets by using this simple and effective <a href="https://github.com/kigster/sym">symmetric encryption tool</a>.</strong>
</div>

## These Days If You Are Not Paranoid...

— You don't live in reality :) [ — anonymous]

<div class="large">
As I write this, security is on everyone's mind, and for a very good reason. The news is riddled with all sorts of high profile break-ins and backdoors. Just a few days ago WikiLeaks released findings that <a href="https://www.wired.com/2017/03/wikileaks-cia-hack-signal-encrypted-chat-apps/">CIA and NSA may have been hacking into your phone</a>, rendering encryption used by the secure messaging apps like <a href="https://itunes.apple.com/us/app/signal-private-messenger/id874139669?mt=8">Signal</a> and <a href="https://www.whatsapp.com/">WhatsApp</a> completely useless.
</div>

> **Are you impatient?** If so — I direct you to view a [4-minute long ASCII Cinema session](/2017/03/10/dead-simple-encryption-with-sym.html#ascii) I recorded that showcases **sym** in its beautiful CLI glory :)



{{site.data.macros.continue}}



While these are serious issues that we as a society should debate, I found myself in need of an easy-to-use encryption tool, required for a much simpler problem. I was building a deploy automation for a web app, and one of the major inconveniences with that application was that various secrets were sprinkled around the file system, their filenames added to the `.gitignore` file so that they don't get accidentally checked into the repo. It took a good amount of time to get a local environment fully setup with all the secrets, so that the app would function locally.

Now, keeping secrets outside of your repo may provide you with a false sense of security. After all, anyone who gains access to your hard drive can download all of your secrets. Think of a coffee shop, with a public WiFi, combined with a lack of recent security updates for your operating system — and you are instantly at high risk. Besides the fact that decrypted secrets are easily accessible on your file system, this `gitignore` method deprives us, developers, from a very useful ability to track historical revisions of any changes to secrets files, and to be able to rollback to a previously working versions. Not to mention having to sync secrets across all developers when they change!

> "There is gotta be a better way..."  —— I thought to myself.

So I went on a hunt — looking for a magical encryption tool, ideally written in ruby, that I could use to encrypt secrets, which would then enable us to check-in application secrets, encrypted, into the repo. Without the encryption key these files are useless. After looking around for some time, I came to the conclusion that a tool that was simple enough to use, was able to read the private key from many sources — such as a file, environment variable, or even Mac OS-X Keychain, and offered password-protection for the keys, and can cache passwords for 15 minutes so that we don't have to retype it ten times during the deploy, this tools — **it simply did not exist.**

<div class="large">
Well, technically it did not exist until now :)
</div>

### Encryption Methods

{% lightbox_image { "url" : "/images/security/datacenter.jpg",  "title": "Data Center", "group":"security", "class": "clear-image" } %}

So let's review some high-level encryption terms that we'll use further in this discussion.

The two most commonly encryption method are:

{% lightbox_image { "url" : "/images/security/symmetric.jpg",  "title": "Symmetric", "group":"security", "class": "lightbox-image" } %}

 * **Symmetric Encryption** — this is where the same key is used to encrypt and decrypt the data. Typically, a random "IV" vector is used to randomize the encryption and make it harder to "brute-force" the key. You need both the key and the "IV" vector to decrypt the data. Having said that, and having done some research, people typically store the IV vector right next to the data. So I am not entirely sure how much added security it provides, but I am not an encryption expert.

{% lightbox_image { "url" : "/images/security/asymmetric.gif",  "title": "Asymmetric", "group":"security", "class": "lightbox-image" } %}

 * **Asymmetric (Public/Private Key) Encryption** — uses two pieces: a public and a private key. An unpredictable (typically large and random) number is used to begin generation of an acceptable pair of keys suitable for use by an asymmetric key algorithm. In an asymmetric key encryption scheme, anyone can encrypt messages using the public key, but only the holder of the paired private key can decrypt.

If we are dealing with an encrypted file that needs to be read by the application in both cases you'd need to have a key lying around — either the private key (from the public/private pair), or, in case of symmetric encryption, — the key used to encrypt the data.

While public/private key has some advantages to symmetric encryption, for application secrets it appeared to be an overkill. Perhaps this is my personal judgement, and maybe some of you would disagree — in which case please do leave a comment down below.

<div class="large">
But it is for these reasons that I decided to build a simple wrapper around OpenSSL's symmetric cipher, and release it under the name `sym` — a ruby gem.
</div>

{% lightbox_image { "url" : "/images/security/banner-encryption-locks.jpg",  "title": "Encryption", "group":"security", "class": "lightbox-image" } %}

### Evaluating Threats

But before we jump into the gem, I would like to explore a couple of use-cases that exist when encryption/decryption of secrets is introduced into the deploy flow of any application.  

We start by assuming that you have an encrypted file in your source repo, on your laptop. Perhaps using `sym` or otherwise you are able to decrypt this file, by providing a key. Now we can outline a few common scenarios:<br />

 1. You can decrypt secrets locally in order to use your app. This is the simples method that a) keeps your repo free of unencrypted secrets, and b) is very simple to use, because you essentially dealing with an unencrypted file once decryption step is performed.
 2. You can split your secrets into, say, "development", "staging" and "production", and only decrypt the "development" locally. This is better than above as it does not expose production secrets locally.
 3. But now you need to deploy. So the question is: Do you decrypt production secrets locally, and push them to a remote host (or a docker container), or do you attempt to decrypt things on the remote host? And, in the case of the latter — do you decrypt them once and leave decrypted files lying around on a remote host, or do you make your application decrypt files on the fly?
    * If you are **decrypting things locally**, you must delete the decrypted secrets immediately after the deploy. You also get completely open secrets file on the remote host, so if someone has access to the file system of a remote host, they can steal your secrets.
    * If you are **decrypting things remotely**, that means you need to pass the private key to the remote host, at least temporarily. An advantage is that you don't need to worry about production secrets being open locally, or having to remove them after the deploy. But the disadvantage is that your private key has to (at least momentarily) be present on all remote hosts you are deploying to.
    * Finally, you can decide that you want to **keep secrets encrypted everywhere, including remote hosts**, and make your application automatically decrypt the secrets upon reading them. For this you would need to pass the private key to all remote hosts, perhaps as environment variable, and add some code to reading in your settings, that decrypts it on the fly. This method is *the most secure of the above*, because the decrypted secrets **only exist in RAM**, which means that merely having access to the disk of the server is not enough to compromise your app. <br /><br />An attacker has to have a full login access to your remote server, or a Docker container. And let's face it — if the attacker gains login access to your server, all bets are off at this point. They can probably fireup irb or a remote debugger, and connect to your app's ruby runtime to fetch the secrets. They can also quickly figure out how the app is getting its encryption key by examining the code and the environment variables. So we won't focus much on the case when the remote server is completely compromised, but focus on the cases where may just partial access — such as disk access — is available to the attacker. In these situation you really don't want to have unencrypted secrets lying around the filesystem.
    * Note that ability to load encrypted settings into memory is not yet available in `sym`, but [this issue](https://github.com/kigster/sym/issues/9) should address this.

Final point I would like to make here, is that — given that the private key is very high-risk piece of data, — it may be a good idea to encrypt the key itself, but perhaps with the password that you can remember. This adds a rather significant layer of security, because finding the encrypted key without a password proves just as futile as trying to brute force the encrypted file itself. It should not be surprising then, that `sym` library supports password encryption with additional flexibility around caching the passwords (or not), and if caching — letting you specify for how long.

And now, since we already understand various threat vectors and scenarios, without further ado, I would love to introduce you to the new kid on the block: **`sym` — symmetric encryption made easy.**

## Sym
### Encrypting & Decrypting with Style

<div class="large">
<strong>Sym</strong> is a ruby library (gem) that offers both the command line interface (CLI) and a set of rich Ruby APIs, which make it rather <em>trivial to add encryption and decryption of sensitive data</em> to your development flow. As a layer of additional security, <strong>sym</strong> supports encrypting of the private key itself with a password. Unlike many other existing encryption tools, <strong>sym</strong> focuses on usability and streamlined interface (in both CLI and Ruby API), with the goal of making encryption easy and transparent to the developer integrating the gem. <strong>sym</strong> uses <em>symmetric Encryption</em> with a 256-bit key and a random 'iv' vector, to encrypt and decrypt data.
</div>

Sym's been tested on **Mac OS-X and Linux**, and its 95% coverate test suite successfully builds on the following rubies:

 * 2.2.5
 * 2.3.3
 * 2.4.0
 * 2.5.0
 * jruby-9.1.7.0

<div>
<strong>Sym</strong> uses the <code>AES-256-CBC</code> cipher to encrypt the actual data, — this is the cipher used by the US Government, and <code>AES-128-CBC</code> cipher to encrypt the key with an optional password.<br /><br />

Finally, <strong>sym</strong> compresses the encrypted data with <code>zlib</code> and converts it to <code>base64</code> string. While compression can be disabled if needed, turning off <code>base64</code> encoding is not currently supported. Therefore both the keys and the encrypted data will always appear like a <code>base64</code>-encoded string.
</div>


### What's In The Box: No Assembly Required

Let's dive into the library! I promise this will be brief!

**Sym** library includes two primary components —

 1. [Rich command line interface CLI](https://github.com/kigster/sym#cli) with many features to streamline encryption/decryption.
 2. Ruby API, available via several entry points:
     * [Basic Encryption/Decryption API](https://github.com/kigster/sym#rubyapi) is activated by including `Sym` module in a ruby class, it adds easy to use `encr`/`decr`, and `encr_password/decr_password` methods.
     * [Application API](https://github.com/kigster/sym#rubyapi-app) is activated by instantiating `Sym::Application` class, passing it an arguments hash as if it came from the CLI, and then calling `execute` method on the instance.
     * [Sym::MagicFile API](https://github.com/kigster/sym#magic-file) is a convenience class allowing you to read encrypted files in your ruby code with a couple of lines of code.
     * [Sym::Configuration](https://github.com/kigster/sym#rubyapi-config) class for overriding default cipher, and many other parameters such as compression, cache location, Zlib compression, and more.

### Priceless Time Savers

So how does `sym` substantiate its claim that it *streamlines* the encryption process? I thought about it, and turns out there are quite a few reasons:

  * By using Mac OS-X Keychain (and only on a Mac), `sym` offers a simple yet secure way of storing the key on a local machine, much more secure then storing it on a file system.
  * By using a password cache (`-c`) via an in-memory provider such as `memcached` or `drb`, `sym` invocations take advantage of password cache, and only ask for a password once per a configurable period.
  * By using `SYM_ARGS` environment variable, where common flags can be saved.
  * By reading a key from the default key source file `~/.sym.key` which requires no flags at all.
  * By utilizing the `--negate` option to quickly encrypt a regular file, or decrypt an encrypted file with extension `.enc`.
  * By using the `-t` (edit) mode, that opens an encrypted file in your `$EDITOR`, and replaces the encrypted version upon save & exit.

As you can see, I tried to build a tool that provides real security for application secrets, including password-based encryption but does not annoyingly ask for a password every time. With `--edit` option, and `--negate` options you can treat encrypted files like regular files.

> If you are interested in a "step by step" walkthrough, please open this link — [Step By Step Walkthrough of the README](http://kig.re/2017/03/10/dead-simple-encryption-with-sym.html#step-by-step-walkthrough).

<a name="ascii"></a>

### ASCII Session with Sym

<script type="text/javascript" src="https://asciinema.org/a/26nytbf3oaofijuwwxawuseas.js" id="asciicast-26nytbf3oaofijuwwxawuseas" async></script>

## Thanks!

Thanks for reading, and I hope you find this tool useful! Please feel free to submit issues or requests on GitHub at [https://github.com/kigster/sym](https://github.com/kigster/sym).

`Sym`is &copy; 2016-2017 [Konstantin Gredeskoul](https://kig.re/)

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

The library is designed to be a layer on top of [`OpenSSL`](https://www.openssl.org/), distributed under the [Apache Style license](https://www.openssl.org/source/license.txt).
