---
layout: post
title: 'C++ Newbie Tour: Getting Started with C++ on Mac OSX'
post_image: /assets/images/posts/cpp/c-cpp.jpg
tags: [c/c++, build-systems, coding, learning]
categories: [programming]
author_id: 1
comments: true
toc: true
excerpt: "In this post we'll explore some of the things that a beginner C++ programmers (but not general beginner programmers) might find useful in getting quickly up to speed."
---

## C++ — A Newbie Tour

First I'll start with a confession: I started learning C++ somewhat recently, which may be puzzling if you know me well because I've been building my career in software engineering for well over twenty five years.

Well, despite having hands-on skils in C, Java, Ruby, Perl, even BASH, — I have somehow skipped C++.  But then, as soon as I decided to play with hardware like Arduino it became clear that I wanted to take advantage of the Object Oriented techniques and Design Patterns that I acquired over the years and apply them to my Arduino code!

By that time I was very surprised to find that the vast majority of the existing Arduino projects and libraries were written rather badly, in C. The best ones are written in a mixture of C++ and Assembly. But, it turns out that you can have your cake and eat it too — meaning, you can apply OO principles to Arduino programming.

> In this post we'll explore some of the things that a beginner C++ programmers (but not general beginner programmers) might find useful in getting quickly up to speed. We will look at which compilers support newer C++ standards C++11 and C++14 and the difference between linker and compiler, as well as dynamic vs static library. Finally, we'll offer a C++ project template you can use in your own projects.


{{site.data.macros.continue}}


For the record, you absolutely **can** build an Arduino library or a sketch using C++, as long is does not need to link with any standard C++ libraries (or, if they do — you have plenty of flash on your chip — thanks Teensy!).

So with this I kick off an official "C++ Newbie Tour" set of blog posts, with which I hope to share some of the important things I've been learning as I am going through this process, and in particular figure out something that those of us who've been using Rails for too many goddamn years :) are used to having nicely laid out projects, with clearly named folders for where things should go, and a magical dependency loader.

## Getting Started with C++ on a Mac OSX

While I am on a Mac with Mac OS-X Sierra, and Xcode Developer tools, I much prefer to use JetBrains IDEs for programming in almost any language. I tend to resort to Atom for when I want to peek at a project, and open it quickly, but for actual development I am a big IDE fan. Using RubyMine I can out-code (in ruby) and out-refactor almost any VI user out there :) Feel free to challenge me!

So the components I will be using in my C++ learning quest are:

 * [JetBrains CLion IDE](https://www.jetbrains.com/clion/) is the IDE I will use for writing C++ code.
 * [GoogleTest C++ Unit Test Library](https://github.com/google/googletest) is a fantastic library we'll rely on
 * Because Clion supports only two build systems, we will use one of them — [CMake](https://cmake.org/). CMake is meant to be a much simpler Makefile generator, and is clearly gaining traction in the community.
 * We'll also use `gcc` compiler, of which I have two versions installed: one comes from [HomeBrew](http://brew.sh), and one comes built in by Apple.

### A Shortcut To Get Started Quickly

Before we go too far, I would like to bring your attention on the Github Project I maintain called [cmake-project-template](https://github.com/kigster/cmake-project-template) – this is a great starting point for any bare-bones C/C++ project that builds:

 * A static library
 * A binary that links with that library
 * And a test binary that runs the tests using Google Test framework.

So if you need a good starting point for your projects, head over there, fork it, rename it, and off you go.

### Exploring C++ Compilers on a Mac

Let's assume you ran `brew install gcc` and it worked. It most likely installed `gcc` into `/usr/local/bin` because other `/usr` folders are not writeable since some version of OS-X.

In my BASH init files, while defining the `PATH` variable, I place `/usr/local/bin` before the standard system paths such as `/usr/bin`, `bin`, etc. Since Apple does not allow `/usr/bin` to be writeable, that's the only option when you want to override the older system binary.

Given that my PATH is `"/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"` etc, I can install GCC using HomeBrew, and default to it anytime I type `gcc`:

```bash
❯ gcc --version
gcc (Homebrew GCC 6.3.0_1) 6.3.0
Copyright (C) 2016 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

That was the HomeBrew version.

And here is Apple's:

```bash
❯ /usr/bin/gcc --version
Configured with: --prefix=/Applications/Xcode.app/Contents/Developer/usr --with-gxx-include-dir=/usr/include/c++/4.2.1
Apple LLVM version 8.1.0 (clang-802.0.42)
Target: x86_64-apple-darwin16.5.0
Thread model: posix
InstalledDir: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
```

Now, if you do not have the Brew GCC installed, you should probably rectify this situation as quickly as possible. You see, the built-in compiler, on a 2017 machine with the latest OS-X, still does not appear to fully support C++11 and C++14 feature set.

How do I know this? Let's find out.

### C++ vs C++11 vs C++14

Many things have changed in C++ since it was, just C++. So it's kind of important to know what your compiler supports before using a feature that will require rewrite if you are stuck on the older compiler.

Our test file will be called `c++ver.cpp`, and it's contents will look like this below. It simply uses a macro `__cplusplus` to determine the version, and prints it out:

```clike
#include <iostream>
int main(){
  #if __cplusplus == 201402L
    std::cout << "C++14" << std::endl;
  #elif __cplusplus==201103L
    std::cout << "C++11" << std::endl;
  #else
    std::cout << "C++" << std::endl;
  #endif
  return 0;
}
```

Now, let's compile it and run it using both:

```bash
# First, let's use the default Apple's compiler installed with Dev Tools:
$ /usr/bin/g++ c++ver.cpp -o default-c++compiler
$ ./default-c++compiler
C++

# Now, let's use gcc-6 compiler installed with Brew.
$ /usr/local/bin/g++-6 c++ver.cpp -o gcc6-c++compiler
$ ./gcc6-c++compiler
C++14
```

OK, so we know know what each supports. But, what about the size of the binary generated?

```bash
$ ls -al *c++*
-rwxr-x---  1 kig  staff  15788 May 12 17:59 default-c++compiler
-rwxr-x---  1 kig  staff   9180 May 12 17:59 gcc6-c++compiler
```

The newer compiler produced a binary of half the size!

And what if we add `-O3` to optimize it?

```bash
$ ls -al *c++*
-rwxr-x---  1 kig  staff  10676 May 12 18:13 default-c++compiler
-rwxr-x---  1 kig  staff   9056 May 12 18:13 gcc6-c++compiler
```

Huh, so the build-in compiler got squashed quite a bit! While gcc6 pretty much stayed at nearly the same tiny byte size.

As a fun experiment, if we replace `std::cout` with `printf`, and instead of importing `<iostream>` — a C++ library, we could import a C library `<stdio>`?

The code now looks like this:

```clike
#include <stdio.h>
int main(){
#if __cplusplus==201402L
  printf("C++14\n");
#elif __cplusplus==201103L
  printf("C++11\n");
#else
  printf("C++\n");
#endif
  return 0;
}
```

Compiles the same way, and hey - look at that!

```bash
-rwxr-x---  1 kig  staff  8432 May 12 18:17 default-c++compiler
-rwxr-x---  1 kig  staff  8432 May 12 18:17 gcc6-c++compiler
```

The files are now IDENTICAL sized (but they are not actually binary-identical, I checked).

### Conclusion

What we learned here is that Apple's built-in `gcc` does not seem to support C++11 and C++14 standards, although it's possible I would need to pass some flags to it to enable it — not sure.

But if you install `gcc` with HomeBrew - you can use latest C++ features, and not only that, but your resulting binary will be smaller.

Not to mention, why make project OS-X specific when it can be platform independent right?

## Build Targets

So targets are what you actually wanna build with your code. It can be one of three things:

  1. an executable binary
  2. a static library
  3. a shared library

### Compiling Things...

The output of the G++ compiler is typically an object file. In C they just had a `.o` extension, in C++ they made it something else, I can't remember. The point is that the overall process is quite similar between C and C++ going from source to object file:

 * C/C++ pre-processor runs
 * compiler parses the file for syntax errors
 * compiler searches for all the headers included in your file
 * and once all symbols have been found, it spits out an object file.

### Linking Things...

Next step is the Linker. The Linker comes in, all super-duper cool, and says — "Hey, y'all! You are all a bunch of boring compiled objects, and I am going to assemble you into something interesting, meaningful, otherwise you are just bunch of lonely algorithms at your own goddamn funeral"!

He's a bit of an emotional wreck, that linker.

So the *Linker* then combines one or more object files, links it with existing libraries, and turns the result into either an **executable binary** that you can typically run as `./a.out` unless you specified it's name with `-o badass-tool`. But it can also produce a **static or dynamic library** that other programmers can import and use.

#### Static vs Dynamic (Shared) Libraries

 * Static libraries are literally embedded into the final binary, and so the binary will work whether or not the system has that library installed. That's a nice advantage, but the downside is that the binary will be much larger.

 * Dynamic libraries (also called "shared libraries") are not embedded into the final binary - instead a reference to an external file is embedded. When you run that binary, the shared linkage code embedded into it by the linker will search `LD_LIBRARY_PATH` for each shared library mentioned, and will fail if one or more are not found. The upside is having a small binary, but the downside is — the binary won't work unless dynamic library was found when the binary is run.


In fact, in the first example, we used the function `std::cout << "value"` to print to STDOUT. That function is pre-compiled for us, and lives in the standard C++ library. Similarly, `printf` lives in `libc`! The basic standard C library that exists on every UNIX system because literally everything with a tiny exception of  uses functions from standard library. And therefore must be linked with it.

### Summary of Compiler / Linker Difference

So, in a nutshell, compiler turns our little C++ classes and declarations into object files with symbol tables, while linker joins them all up, in the right order, to have a single binary where all all the symbols (like method calls) are resolved. When you execute a binary, and you are missing a dependency, you will get an appropriate error.

## What's Next?

In the subsequent series of posts we'll go through the next steps:

 * Header files versus source files
 * Build systems based on `make`
 * Leveraging `cmake` to help with `make`
 * Using GoogleTest Library for unit tests
 * And putting it all together in a project.

Thanks for reading!

---

And once again, I suggest you check out **[cmake-project-template](https://github.com/kigster/cmake-project-template)** – it's great starting point for any bare-bones C/C++ project.

And, if you got here because you want to build Arduino software in C++, I suggest you check out **[Arli](https://github.com/kigster/arli) — the Arduino library manager and project generator. To get started with it — run this:

```bash
$ gem install arli
$ arli -h
$ arli generate TimeMachine
```
