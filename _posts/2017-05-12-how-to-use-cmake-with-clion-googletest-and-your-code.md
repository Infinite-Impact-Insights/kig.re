---
layout: page
title: 'C++ Newbie Tour: How to Use CMake with CLion, GoogleTest and Your Code'
draft: true
toc: true
---

# C++ Newbie Tour

First things first, let's start with terminology. You see, I started learning C++ somewhat recently, which may be puzzling if you know me — I've been building my career in programming for over twenty five years. Well, despite programming professionally in C, Perl, BASH, Java, and Ruby, I have somehow skipped C++.  But then, when I decided to play with hardware like Arduino, of course I wanted to take advantage of Object Oriented techniques and design patterns that I've acquired over the years to my Arduino library code! Ha! By that time I was very surprised to find most existing Arduino projects and libraries written, badly, in C. There are some exceptions, like the RF24 library, but majority of the libs are not even written by professional programmers, and can be a bit, ... hairy.

But, it turns out that you can have your cake and eat it too.

You can absolutely build an Arduino library in C++, as long is does not need to link with large static libraries (or, if they do — you have plenty of flash on your chip — thanks Teensy!). And that's how I got into learning how to structure my C code in a C++ way. Cause that's what's C++ programming is all about, no?

So with this I kick off an official "C++ Newbie Tour" set of blog posts, with which I hope to share some of the important things I've been learning as I am going through this process, and in particular figure out something that those of us who've been using Rails for too many goddamn years :) are used to having nicely laid out projects, with clearly named folders for where things should go, and a magical dependency loader.

# What We'll Need...

While I am on a Mac with Mac OS-X Sierra, and Xcode Developer tools, I much prefer to use JetBrains IDEs for programming in almost any language. I tend to resort to Atom for when I want to peek at a project, and open it quickly, but for actual development I am a big IDE fan. Using RubyMine I can out-code (in ruby) and out-refactor almost any VI user out there :) Feel free to challenge me!

So the components I will be using in my C++ learning quest are:

 * [JetBrains CLion IDE](https://www.jetbrains.com/clion/) is the IDE I will use for writing C++ code.
 * [GoogleTest C++ Unit Test Library](https://github.com/google/googletest) is a fantastic library we'll rely on
 * Because Clion supports only two build systems, we will use one of them — [CMake](https://cmake.org/). CMake is meant to be a much simpler Makefile generator, and is clearly gaining traction in the community.
 * We'll also use `gcc` compiler, of which I have two versions installed: one comes from [HomeBrew](http://brew.sh), and one comes built in by Apple.

 In my BASH init files, I set `/usr/local/bin` to be placed before the standard system paths such as `/usr/bin`, `bin`, etc. Since Apple does not allow `/usr/bin` to be writeable, that's the only option when you want to override the older system binary.

 ```bash
 # given that my PATH is "/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin" etc.
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

Now, if you do not have the Brew GCC installed, you should probably rectify this situation as quickly as possible. You see, the built-in compiler, on a 2017 machine with the latest OS-X, still does not appear to full C++11 and C++14 feature support.

How do I know this? Let's find out.

## C++ vs C++11 vs C++14

Many things have changed in C++ since it was, just C++. So it's kind of important to know what your compiler supports before using a feature that will require rewrite if you are stuck on the older compiler.

Our test file will be called `c++ver.cpp`, and it's contents will look like this below. It simply uses a macro `__cplusplus` to determine the version, and prints it out:

```c++
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

```tcl
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

```tcl
$ ls -al *c++*
-rwxr-x---  1 kig  staff  15788 May 12 17:59 default-c++compiler
-rwxr-x---  1 kig  staff   9180 May 12 17:59 gcc6-c++compiler
```

The newer compiler produced a binary of half the size!

And what if we add `-O3` to optimize it?

```tcl
$ ls -al *c++*
-rwxr-x---  1 kig  staff  10676 May 12 18:13 default-c++compiler
-rwxr-x---  1 kig  staff   9056 May 12 18:13 gcc6-c++compiler
```

Huh, so the build-in compiler got squashed quite a bit! While gcc6 pretty much stayed at nearly the same tiny byte size.

As a fun experiment, if we replace `std::cout` with `printf`, and instead of importing `<iostream>` — a C++ library, we could import a C library `<stdio>`?

The code now looks like this:

```c++
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

Compiles the same way, and hey!

```tcl
-rwxr-x---  1 kig  staff  8432 May 12 18:17 default-c++compiler
-rwxr-x---  1 kig  staff  8432 May 12 18:17 gcc6-c++compiler
```

The files are IDENTICAL sized (but not actually identical, I checked).

Anyway, now that we had this brief detour about C++ versions and how to use a compiler, we are going to take a look at what type of things we may be creating with our C++ project?

## Targets

So targets are what you actually wanna build with your code. It can be one of three things:

  1. an executable binary
  2. a static library
  3. a shared library


### Compiler Can Be Your Friend, But You Are Cooler

The output of the G++ compiler is typically an object file. In C they just had a `.o` extension, in C++ they made it something else, I can't remember. The point is that the overall process is quite similar between C and C++ going from source to object file:

 * C/C++ pre-processor runs
 * compiler parses the file for syntax errors
 * compiler searches for all the headers included in your file
 * and once all symbols have been found, it spits out an object file.

### Linker Can Ruin Your Life. Or Reincarnate You.

Next step is the Linker. The Linker comes in, all super-duper cool, and says — "Hey, y'all! You are all a bunch of boring compiled objects, and I am going to assemble you into something interesting, meaningful, otherwise you are just bunch of lonely algorithms at your own damn funeral."! He's a bit of an emotional wreck, that linker.

So the *Linker* then combines one or more object files, links it with existing libraries, and turns the result into into either an **executable binary** that you can typically run as `./a.out` unless you specified it's name with `-o badass-tool`. But it can also result in a **static or shared library** that other programmers can import and use.

In fact, in the first example, we used the function `std::cout << "value"` to print to STDOUT. That function is pre-compiled for us, and lives in the standard C++ library. Similarly, `printf` lives in `libc`! The basic standard C library that exists on every UNIX system because literally everything with a tiny exception of  uses functions from standard library. And therefore must be linked with it.

So, in a nutshell, compiler turns our little C++ classes and declarations into object files with symbol tables, while linker joins them all up, in the right order, to have a single binary where all all the symbols (like method calls) are resolved. When you execute a binary, and you are missing a dependency, you will get an appropriate error.

# GoogleTest

Next on our agenda is the fantastic testing library from Google — `googletest`.
