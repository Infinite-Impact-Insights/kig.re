---
layout: page
title: 'Dead Simple Encryption with Sym'
draft: false
toc: true
---

<div class="large">
<strong>A story about how your mom can now protect her application secrets by using this simple and effective <a href="https://github.com/kigster/sym">symmetric encryption tool</a>.</strong>
</div>

<img style="margin: 10px 0; width: 100%; height: 100px;" src="/images/security/xlock-long.jpg"/>

## Encrypt This!


<div class="large">

Security is on everyone's mind and for a good reason. The news is riddled with all sorts of break-ins, backdoors, and headlines like the CIA and NSA have been hacking into secure apps like <a href="https://itunes.apple.com/us/app/signal-private-messenger/id874139669?mt=8">Signal</a> and <a href="https://www.whatsapp.com/">Whats Up</a>. I, for one, am certainly nervous.
</div>

But while these issues of today are quite important, I wanted to address a much simpler problem that kept arising from one application I was working on to another.

I wanted to respond to the needs of developers who manage one or more applications, where we always seem to have some sensitive information, and people scream at the poor intern that accidentally checked in the application secrets into git, and pushed. OMG! What have you done!

Keeping your secrets outside of git may do more than providing you a false sense of security, it may also derail the ability to track revisions, and rollback to a previously working version. 

<div class="large">
So how can we have our cake and eat it too? How can we encrypt these application secrets, so that it might be OK to keep them in the source repository?
</div>



{{site.data.macros.continue}}



{% lightbox_image { "url" : "/images/security/banner-encryption-locks.jpg",  "title": "Encryption", "group":"security", "class": "lightbox-image" } %}

In this case, the types of information that need protecting fall into a few categories:

 * **username and password information**, such as logins into external 3rd party services. Such services have various levels of threat: for example, your NewRelic account that monitors your app is probably not as sensitive as your Stripe or Braintree payment processing credentials.<br /><br />
 * **application API tokens** into applications you integrate with. Perhaps these are shipping providers, or accounting applications, or analytics such as MixPanel, Looker and so on.<br /><br />
 * Probably one of the worst types of information to leak is your **cloud deployment SSH keys, API keys and secrets**, something that Amazon AWS, for example, issues to the companies. Using these keys one can completely destroy your AWS accounts, including all of your backups (you are doing offsite backups to ANOTHER cloud provider, aren't you?). The result is very well documented in the saga about the [CodeSpaces going out of business]() after a hacker demanded a ransom, and subsequently killed their infrastructure.

So how do you deal with this information in a secure way?

### I Can Haz Secrets?

We'll refer to the general concept of a sensitive information described in the previous section as — **secrets**. We need these secrets so that our application can function, or so that our deploy to the cloud can work. And yet, if you hesitated the check that YAML file into git repository that's shared across the organization, you can pat yourself on the back — you are right. Don't ever check that into your repo *unencrypted*.

So what options do you have *besides* encryption?  Let's explore.

#### Secrets Outside of the Repo

As one option, you can keep those files separate out of your git repo, add the filename to `.gitignore`, and distribute the secrets file somehow else. One company that I am familiar with used to keep the application secrets up on the company's AWS S3 account, as a downloadable file.

While this is not the worst idea in the world, it does have some clear disadvantages. The primary one being that when you `git clone` your source code, you may be missing a vital piece of your codebase that prevents you from developing your code. You need to download some file to get things working.

The second big downside is that you loose revision control of the secrets file. I hope I don't have to convince you that source revision control is *kind of a necessity*.


#### Secrets in AWS Host Config

AWS allows you to configure each host by uploading a manifest file, with a bunch of JSON configuration. I worked at another company that relied on this process to separate secrets out. However, these manifest files were not even version controlled.

So once again, we arrive at a problem that secrets live outside the codebase, and once again are not revision controlled.

#### Secrets in Environment Variables

Sites like Heroku require you to provide sensitive information in the environment variables. To be honest, Heroku does have options to encrypt environment variables, but if you are using this method outside of Heroku, then how are you ensuring these environment variables are set? Somehow the data must make it onto the server. Is it a shell file?

You can quickly see that just moving to environment variables does not solve anything.

### Cracking the Nut

{% lightbox_image { "url" : "/images/security/datacenter.jpg",  "title": "Data Center", "group":"security", "class": "clear-image" } %}


So the solution, most obviously, is to encrypt your secrets. You can encrypt individual key-pair values or the entire secrets file. This gives you an excellent advantage that the encrypted secrets file can be safely checked into the GitHub repo, as long as the encryption key(s) are nowhere near your repo.

So let's review some basic encryption concepts that can help us feel safe about what we are doing with our secrets.

There are many types of encryption, but the two most commonly used methods are:

{% lightbox_image { "url" : "/images/security/symmetric.png",  "title": "Symmetric", "group":"security", "class": "lightbox-image" } %}

 * **Symmetric Encryption** — this is where the same key is used to encrypt and decrypt. Typically a random "IV" vector is used to randomize the encryption and make it harder to "brute-force" the key. The library completely hides `iv` generation from the user and automatically generates a random `iv` per encryption.

{% lightbox_image { "url" : "/images/security/asymmetric.gif",  "title": "Asymmetric", "group":"security", "class": "lightbox-image" } %}

 * **Public/Private Key Encryption** — where there are two pieces: a public and a private key.

If we are dealing with an encrypted file that needs to be read — then in order to decrypt it, in both cases you'd need to have a key lying around — either the private key (from the public/private pair), or the private key used to encrypt the data, in case of symmetric encryption.

While public/private key has many advantages, for some situations it may be an overkill. It is for those situations that I decided to develop a simple wrapper around OpenSSL's symmetric cipher, and release it under the name `sym` — a ruby gem.

### Enter Sym — Encryption Made Easy

<div class="large">

<strong>sym</strong> is a command line utility and a Ruby API that makes it <em>trivial to encrypt and decrypt sensitive data</em>. Unlike many other existing encryption tools, <strong>sym</strong> focuses on usability and streamlined interface (CLI), with the goal of making encryption easy and transparent. The result? There is no longer any excuse for keeping your application secrets unencrypted or outside of your repo.
</div>

<div>
<strong>sym</strong> uses <em>symmetric Encryption</em> which simply means that you will be using the same 256-bit key to encrypt and decrypt data. In addition to the private key, the encryption uses an IV vector. The library completely hides `iv` generation from the user and automatically generates a random `iv` per encryption. Finally, each key can be uniquely password-protected (encrypted) and stored in OS-X Keychain, environment variable or a file.

</div>

#### What's Included

This gem includes two primary components:

 * [Rich command line interface CLI](https://github.com/kigster/sym#cli) with many features to streamline encryption/decryption.
 * Ruby API:
     * [Basic Encryption/Decryption API](https://github.com/kigster/sym#rubyapi) is activated by including `Sym` module in a ruby class, it adds easy to use `encr`/`decr` methods.
     * [Application API](https://github.com/kigster/sym#rubyapi-app) is activated by instantiating `Sym::Application`, and using the instance to drive sym's complete set of functionality as if it is invoked from the CLI.
     * [Sym::Configuration](https://github.com/kigster/sym#rubyapi-config) class for overriding default cipher, and many other parameters such as compression, cache location, Zlib compression, and more.

#### Time Saving Features

So how does `sym` substantiate its claim that it *streamlines* the encryption process? I thought about it, and turns out there are quite a few reasons:
 
  * By using Mac OS-X Keychain, `sym` offers a simple yet secure way of storing the key on a local machine, much more secure then storing it on a file system.
  * By using a password cache (`-c`) via an in-memory provider such as `Memcached` or `drb`, `sym` invocations take advantage of password cache, and only ask for a password once per a configurable period.
  * By using `SYM_ARGS` environment variable, where common flags can be saved.
  * By reading a key from the default key source file `~/.sym.key` which requires no flags at all.
  * By utilizing the `--negate` option to quickly encrypt a regular file, or decrypt an encrypted file with extension `.enc`.
  * By using the `-t` (edit) mode, that opens an encrypted file in your `$EDITOR`, and replaces the encrypted version upon save & exit.

As you can see, I tried to build a tool that provides real security for application secrets, including password-based encryption but does not annoyingly ask for a password every time. With `--edit` option, and `--negate` options you can treat encrypted files like regular files. 

> Encrypting application secrets had never been easier! –– Socrates [LOL, -ed.]

#### Step By Step

  1. You generate a new encryption key, that will be used to both encrypt and decrypt the data. The key is 256 bits, or 32 bytes, or 45 bytes when base64-encoded, and can be generated with `sym -g`.
     * You can optionally password protect the key with `sym -gp`
     * You can save the key into a file with `sym -gpo key-file` 
     * Or you can save it into the OS-X Keychain, with `sym -gpx keychain-name`
     * You can also cache the password, with `sym -gpcx keychain-name`
     * Normally, `sym` will also print the resulting key to STDOUT.
     * You can prevent the key from being printed to STDOUT with `-q/--quiet`. 
  2. You then take a piece of sensitive __data__ that you want to encrypt. This can be a file or a string.
  3. You can then use the key to encrypt sensitive __data__, with `sym -e [key-spec] [data-spec]`, passing it the key in several accepted ways. Smart flag `-k` automatically interprets the source of the key, by trying:
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

Thanks for reading, and I hope you find this tool useful! Please feel free to submit issues or requests on GitHub at [https://github.com/kigster/sym](https://github.com/kigster/sym).

`Sym`is &copy; 2016-2017 [Konstantin Gredeskoul](https://kig.re/)

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

The library is designed to be a layer on top of [`OpenSSL`](https://www.openssl.org/), distributed under the [Apache Style license](https://www.openssl.org/source/license.txt).
