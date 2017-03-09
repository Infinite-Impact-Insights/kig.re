---
layout: page
title: 'Dead Simple Secrets Encryption for Humans with Sym'
draft: false
---

## Dead Simple Secrets Encryption for Humans with [Sym](https://github.com/kigster/sym)

### Encrypt This

Security is on everyone's mind today. And for a good reason — we keep hearing about all sorts of break-ins, backdoors, or that CIA and NSA have been hacking into secure apps like [Signal]() and [WhatsUp](). 

But coming down to the clouds, I want to address the needs of everyday developers. We typially have a very common problem on our hands. Whether the application we are talking about is a Rails app, or a NodeJS app, we always have some sort of sensitive information that is required for the app to function properly.

For examples, the types of sensitive data I am talking about is the stuff that you should feel uneasy checking into git/github in clear text. 

Things like: 

 * **username and password information** for external 3rd party services. And not all services are equil: for example, a login information into your NewRelic account that monitors your app is probably not as sensitive as something like your company's Stripe or BrainTree credentials. With those, any attacker can move money on behalf of your entire company. This is what I call "not great".
 * **application API tokens** into companies that your application integrates with. Perhaps these are shipping providers, or accounting applications, or analytics such as MixPanel, Looker and so on. 
 * Probably one of the worst types of information to leak is your **cloud deployment SSH keys, API keys and secrets**, something that Amazon AWS, for example issues to the companies. Using these keys one can competely destroy your AWS accounts, including all of your backups (you are doing offsite backups to ANOTHER cloud provider, aren't you?). The result is very well documented in the saga about the [CodeSpaces going out of business]() after a hacker demanded a ransom, and subsequently killed their infrastructure.

So how do you deal with this information in a secure way?

### Homegrown Security — "Schmecurity Obscurity"

We'll refer to the general concept of a sensitive information described in the previous section as — **secrets**. We absolutely need these secrets so that our application can function, or so that our deploy to the cloud can work. And yet, if you hesitated the check that YAML file into git repository that's shared across the organization, you can pat yourself on the back — you are absolutely right. Don't ever check that into your repo *unencrypted*. 

So what options do you have *besides* encryption?  Let's explore.

##### 1. Keep Secrets Outside of the Main Repo 

As one option, you can keep those files separate out of your git repo, add the filename to `.gitignore`, and distribute the secrets file somehow else. One company that I am familiar with, used to keep the secrest file up on the company's AWS S3 account, as a downloadable file. 

While this is not the worst idea in the world, it does have some clear disadvantages. The most important one being that when you `git clone` your source code, you may be missing a vital piece of your codebase that prevents you from developing your code. You need to download some file to      get things working. 

Second big downside, is that you loose revision control of the actual secrets file. And at this day and age, I hope I don't have to convince you that revision control systems for the source code are not a bad thing.

##### 2. Keep Secrets in the AWS Host Configuration ZIP

AWS allows you to configure each host by uploading a manifest file, with a bunch of JSON configuration. I worked at another company that relied on this process to separate secrets out. However, these manifest files were not even version controlled. 

So once again, we arrive at a problem that secrets live outside the codebase, and once again are not revision cotrolled.

##### 3. Environment Variables

Sites like Heroku require you to provide sensitive information in the environment variables. To be honest, Heroku does have options to encrypt environemnt variables, but if you are using this method outside of Heroku, then how are you ensuring these environment variables are set? Somehow the data must make it onto the server. Is it a shell file? 

You can quickly see that just moving to environment variables does not solve anything.

### What Can Save Us All? Encryption.

So the solution, most obviously, is to encrypt your secrets. You can encrypt individual key-pair values, or the entire secrets file. This give you a nice advantage that the encrypted secrets file can be safely checked into the github repo, as long as the encryption key(s) are nowhere near your repo.

So let's review some basic encryption concepts that can help us feel safe about what we are doing with our secrets.

There are many types of encryption, but the two most commonly used methods are:

 1. Symetric encryption — this is where the same key is used to encrypt and decrypt.
 2. 
