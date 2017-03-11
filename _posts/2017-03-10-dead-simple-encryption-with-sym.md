---
layout: page
title: 'Dead Simple Secrets Encryption with Sym'
draft: false
toc: true
---

<div class="large">
<strong>Or, how you too can protect your application secrets by using a simple and effective <a href="https://github.com/kigster/sym">symmetric encryption tool</a>.</strong>
</div>

### Encrypt This!

<img style="margin: 0px 0px; width: 100%;" src="/images/security/xlock-long.jpg"/>

<div class="large">

Security is on everyone's mind today. And for a good reason — we keep hearing about all sorts of break-ins, backdoors, or that CIA and NSA have been hacking into secure apps like <a href="https://itunes.apple.com/us/app/signal-private-messenger/id874139669?mt=8">Signal</a> and <a href="https://www.whatsapp.com/">Whats Up</a>, which certainly makes me nervous.
</div>

But while these issues of today are quite important, I wanted to address a much simpler problem that kept arising from one application I was working on to another.

I wanted to address the needs of developers who manage one or more applications, where we always seem to have some sort of sensitive information, and people scream at the poor intern that accidentally checked in the application secrets into git, and pushed. OMG! What have you done!

Well, keeping your secrets outside git may give you a false sense of security, but it sure does detract the ability to keep track of revisions, and rollback to a previously working version. 

<div class="large">
So how can we have our cake and eat it too? How can we encrypt these application secrets, so that it might be OK to check them in?
</div>



{{site.data.macros.continue}}



{% lightbox_image { "url" : "/images/security/banner-encryption-locks.jpg",  "title": "Encryption", "group":"security", "class": "lightbox-image" } %}

The types of information that usually needs protecting falls into a few categories:

 * **username and password information** for external 3rd party services. And not all services are equil: for example, a login information into your NewRelic account that monitors your app is probably not as sensitive as something like your company's Stripe or BrainTree credentials. With those, any attacker can move money on behalf of your entire company. This is what I call "not great".<br /><br />
 * **application API tokens** into companies that your application integrates with. Perhaps these are shipping providers, or accounting applications, or analytics such as MixPanel, Looker and so on.<br /><br />
 * Probably one of the worst types of information to leak is your **cloud deployment SSH keys, API keys and secrets**, something that Amazon AWS, for example issues to the companies. Using these keys one can competely destroy your AWS accounts, including all of your backups (you are doing offsite backups to ANOTHER cloud provider, aren't you?). The result is very well documented in the saga about the [CodeSpaces going out of business]() after a hacker demanded a ransom, and subsequently killed their infrastructure.

So how do you deal with this information in a secure way?

#### Secrets? What Secrets?

We'll refer to the general concept of a sensitive information described in the previous section as — **secrets**. We absolutely need these secrets so that our application can function, or so that our deploy to the cloud can work. And yet, if you hesitated the check that YAML file into git repository that's shared across the organization, you can pat yourself on the back — you are absolutely right. Don't ever check that into your repo *unencrypted*.

So what options do you have *besides* encryption?  Let's explore.

##### 1. Keep Secrets Outside of the Main Repo

As one option, you can keep those files separate out of your git repo, add the filename to `.gitignore`, and distribute the secrets file somehow else. One company that I am familiar with, used to keep the secrest file up on the company's AWS S3 account, as a downloadable file.

While this is not the worst idea in the world, it does have some clear disadvantages. The most important one being that when you `git clone` your source code, you may be missing a vital piece of your codebase that prevents you from developing your code. You need to download some file to      get things working.

Second big downside, is that you loose revision control of the actual secrets file. And at this day and age, I hope I don't have to convince you that revision control for the source code is *kind of a necessity*.


##### 2. Keep Secrets in the AWS Host Configuration ZIP

AWS allows you to configure each host by uploading a manifest file, with a bunch of JSON configuration. I worked at another company that relied on this process to separate secrets out. However, these manifest files were not even version controlled.

So once again, we arrive at a problem that secrets live outside the codebase, and once again are not revision cotrolled.

##### 3. Environment Variables

Sites like Heroku require you to provide sensitive information in the environment variables. To be honest, Heroku does have options to encrypt environemnt variables, but if you are using this method outside of Heroku, then how are you ensuring these environment variables are set? Somehow the data must make it onto the server. Is it a shell file?

You can quickly see that just moving to environment variables does not solve anything.

### So Whats The Solution?

{% lightbox_image { "url" : "/images/security/datacenter.jpg",  "title": "Data Center", "group":"security", "class": "clear-image" } %}


So the solution, most obviously, is to encrypt your secrets. You can encrypt individual key-pair values, or the entire secrets file. This give you a nice advantage that the encrypted secrets file can be safely checked into the github repo, as long as the encryption key(s) are nowhere near your repo.

So let's review some basic encryption concepts that can help us feel safe about what we are doing with our secrets.

There are many types of encryption, but the two most commonly used methods are:

{% lightbox_image { "url" : "/images/security/symmetric.png",  "title": "Symmetric", "group":"security", "class": "lightbox-image" } %}

 1. **Symetric Encryption** — this is where the same key is used to encrypt and decrypt. Typically a random "IV" vector is used to randomize the encryption, and make it much more difficult to "brute-force" the key. The library completely hides `iv` generation from the user, and automatically generates a random `iv` per encryption.

{% lightbox_image { "url" : "/images/security/asymmetric.gif",  "title": "Asymmetric", "group":"security", "class": "lightbox-image" } %}

 2. **Public/Private Key Encryption** — where there are two pieces: a public and a private key.

In both cases, if there is an encrypted file, and you need to read it — you need to have a piece of data around — the key — in order to decrypt the data. 

Let's explore the new tool that I have released to public under the MIT License.

### Enter Sym — Encryption Made Easy

<div class="large">

<strong>sym</strong> is a command line utility and a Ruby API that makes it <em>trivial to encrypt and decrypt sensitive data</em>. Unlike many other existing encryption tools, <strong>sym</strong> focuses on usability and streamlined interface (CLI), with the goal of making encryption easy and transparent. The result? There is no longer any excuse for keeping your application secrets unencrypted or outside of your repo.
</div>

<div>
<strong>sym</strong> uses <em>symmetric Encryption</em> which simply means that you will be using the same 256-bit key to encrypt and decrypt data. In addition to the private key, the encryption uses an IV vector. The library completely hides `iv` generation from the user, and automatically generates a random `iv` per encryption. Finally, each key can be uniquely password-protected (encrypted) and stored in OS-X Keychain, environment variable or a file.

</div>

#### What's Included

This gem includes two primary components:

 * [Rich command line interface CLI](#cli) with many features to streamline encryption/decryption.
 * Ruby API:
     * [Basic Encryption/Decryption API](#rubyapi) is activated by including `Sym` module in a class, it adds easy to use `encr`/`decr` methods.
     * [Application API](#rubyapi-app) is activated by instantiating `Sym::Application`, and using the instance to drive sym's complete set of functionality, as if it was invoked from the CLI.
     * [Sym::Configuration](#rubyapi-config) class for overriding default cipher, and many other parameters such as compression, cache location, zlib compression, and more.


#### Massive Time Savers

So how does `sym` substantiate its claim that it *streamlines* the encryption process? I thought about it, and turns out there are quite a few reasons:
 
  * By using Mac OS-X Keychain, `sym` offers a simple yet secure way of storing the key on a local machine, much more secure then storing it on a file system.
  * By using a password cache (`-c`) via an in-memory provider such as `memcached` or `drb`, `sym` invocations take advantage of password cache, and only ask for a password once per a configurable time period.
  * By using `SYM_ARGS` environment variable, where common flags can be saved.
  * By reading a key from the default key source file `~/.sym.key` which requires no flags at all.
  * By utilizing the `--negate` option to quickly encrypt a regular file, or decrypt an encrypted file with extension `.enc`.
  * By using the `-t` (edit) mode, that opens an encrypted file in your `$EDITOR`, and replaces the encrypted version upon save & exit.

As you can see, we really tried to build a tool that provides good security for application secrets, including password-based encryption, but does not annoyingly ask for password every time. With `--edit` option, and `--negate` options you can treat encrypted files like regular files. 

> Encrypting application secrets had never been easier! –– Socrates [LOL, -ed.]


#### How It Works

  1. You generate a new encryption key, that will be used to both encrypt and decrypt the data. The key is 256 bits, or 32 bytes, or 45 bytes when base64-encoded, and can be generated with `sym -g`.
     * You can optionally password protect the key with `sym -gp`
     * You can save the key into a file with `sym -gpo key-file` 
     * Or you can save it into the OS-X Keychain, with `sym -gpx keychain-name`
     * You can also cache the password, with `sym -gpcx keychain-name`
     * Normally, `sym` will also print the resulting key to STDOUT.
     * You can prevent the key from being printed to STDOUT with `-q/--quiet`. 
  2. You then take a piece of sensitive __data__ that you want to encrypt. This can be a file or a string.
  3. You can then use the key to encrypt sensitive __data__, with `sym -e [key-spec] [data-spec]`, passing it the key in several accepted ways. Smart flag `-k` automatically interpretes the source of the key, by trying:
     * a file with a pathname.
     * or environment variable
     * or OS-X Keychain password entry
     * or you can paste the key interactively with `-i` 
  4. Input data can be read from a file with `-f file`, or read from STDIN, or a passed on the command line with `-s string`    
  4. Output is the encrypted data, which is printed to STDOUT by the default, or it can be saved to a file with `-o <file>`
  5. Encrypted file can be later decrypted with `sym -d [key-spec] [data-spec]`

#### ASCII Session with Sym

<script type="text/javascript" src="https://asciinema.org/a/26nytbf3oaofijuwwxawuseas.js" id="asciicast-26nytbf3oaofijuwwxawuseas" async></script>

### Thanks!

Thanks for reading, and I hope you find this tool useful! Please feel free to submit issues or requests on github at [https://github.com/kigster/sym](https://github.com/kigster/sym).

`Sym`is &copy; 2016-2017 [Konstantin Gredeskoul](https://kig.re/)

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

The library is designed to be a layer on top of [`OpenSSL`](https://www.openssl.org/), distributed under the [Apache Style license](https://www.openssl.org/source/license.txt).

