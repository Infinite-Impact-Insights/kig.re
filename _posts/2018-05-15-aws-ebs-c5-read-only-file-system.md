---
layout: page
title: 'AWS/EBS/C5 class instance: cannot create file: Read-only file system'
draft: false
toc: true
author: Konstantin Gredeskoul
---

## Is AWS a sane choice of a Cloud for mission-critical infrastructure

<div class="large">
In this short post I describe the "read-only" problem that happened to one of our C5 hosts, offer a bit of a rant about how incompetent AWS support staff is, and how their forums are completely _useless_, and frankly, _infuriating_.

And as far as the question posted above I will let you make your own conclusion — so keep on reading.

Do you have the same problem on one of your C5 instances? Then read on. At least in our case the solution has been found. But not by AWS. By me.
</div>

## The Problem — read only file system on a C5 class instance.


{{site.data.macros.continue}}


So here is what happened earlier today.

One of our C5 instances suddenly became *read only*.

Since most services write to disk, the instance essentially became completely useless.

I desperately searched for answer on AWS forums... to no avail.

Despite finding [several](https://forums.aws.amazon.com/post!post.jspa?forumID=30&threadID=269150&messageID=818393&reply=true) [threads](https://forums.aws.amazon.com/thread.jspa?messageID=818393#818393) describing my exact problem, I quickly realized that NONE of the threads contained a solution!!!!! Now single customer who reported the problem said on the forum — "Yay!", it worked!

Because there were no suggestions besides increasing *nvme* *io_timeout* from 30 seconds to some arbitrary large number. I did that, rebooted the instance, and nothing changed. And the *io_timeout* was reset back to 30 seconds.

Well, that was a flop. Nice try AWS. Next time — try a bit harder, will you?

## The Solution

Now, if you are experiencing the same problem I suggest you run the following command:

```
$ mount -l | grep nvme
/dev/nvme0n1p1 on / type ext4 (ro,relatime,data=ordered) [cloudimg-rootfs]
```

What you see here is that the primary EBS volume was mounted as `ro` — meaning read only.

If you issue the same command on a healthy machine, you should see `rw`, instead of `ro`, meaning, of course, "read-write".

OK, so why would a file system on Linux become read-only? Could it be some data corruption? Bad blocks?

That's a possibility. Unlikely, since they are supposed to be using SSDs that are more reliable than HDDs. At least that's what SSD manufacturers want you to believe.

Anyway, from my early Linux days (I installed my first Linux in 1996, I think, from 80 floppy disks, really), I remember the über helpful `fsck` command. If you type `fsck<TAB><TAB>` you will see that there are a bunch of them:

```
$ fsck<TAB><TAB>
fsck          fsck.cramfs   fsck.ext3     fsck.ext4dev  fsck.minix    fsck.nfs      fsck.xfs      fsck.btrfs    fsck.ext2     fsck.ext4
fsck.fat      fsck.msdos    fsck.vfat
```  

OK, so we just need to figure out the file system — and then run it. Right above, where we did `mount -l` you will notice that the file system type is `ext4`. Alrighty then. We have our `fsck`!

Let's run it and see what options does it have:


```
fsck.ext4
Usage: fsck.ext4 [-panyrcdfvtDFV] [-b superblock] [-B blocksize]
		[-I inode_buffer_blocks] [-P process_inode_size]
		[-l|-L bad_blocks_file] [-C fd] [-j external_journal]
		[-E extended-options] device

Emergency help:
 -p                   Automatic repair (no questions)
 -n                   Make no changes to the filesystem
 -y                   Assume "yes" to all questions
 -c                   Check for bad blocks and add them to the badblock list
 -f                   Force checking even if filesystem is marked clean
 -v                   Be verbose
 -b superblock        Use alternative superblock
 -B blocksize         Force blocksize when looking for superblock
 -j external_journal  Set location of the external journal
 -l bad_blocks_file   Add to badblocks list
 -L bad_blocks_file   Set badblocks list
```

Alright — I love seeing something called "automatic repair". Since this machine is dead in the water, what am I going to loose?

Let's run this sucker.

```
$ fsck.ext4 -p /dev/nvme0n1p1
cloudimg-rootfs contains a file system with errors, check forced.
cloudimg-rootfs: Deleted inode 1567791 has zero dtime.  FIXED.
cloudimg-rootfs: ***** REBOOT LINUX *****
cloudimg-rootfs: 568214/5120000 files (0.1% non-contiguous), 3412081/10485499 blocks
```

### OMG!! Something got fixed?

This command run very quickly and found a bad inode, apparently with zero dtime, whatever that means. I am not about to go into the details of file systems, but this output looks promising to me.

So fuck it, let's reboot. See what happens.

I type:

```bash
sync; sync; reboot
```

> NOTE: this how I recommend you always reboot you instances. Double `sync`, then `reboot`. Why this is so is outside the scope of this post.

The box rebooted very quickily and some 30 seconds later I was able to SSH into the machine and vola!

**No more read-only root partition, all services boot, and everything is back to normal.** Whoohooo!

### How Not to Run Support Forums

Now, I think to myself, I can share this wisdom on AWS Forums! And other people can benefit from this!

Not so fast, says AWS (allegorically, not literaly) they spell out for me:

> Dear Konstantin, we are going to fuck you in a few more ways before you can be "helpful" to our customers. They really don't need your help, we got it covered. Really, fuck off.

What they actually said verbatim is this:

> Your account is not ready for posting messages yet. See the following article for details: [https://aws.amazon.com/premiumsupport/knowledge-center/error-forum-post/](https://aws.amazon.com/premiumsupport/knowledge-center/error-forum-post/).

So now I am sitting on a solution, but I can't even share it with other AWS customers, because apparently my account is not activated. It says something stupid like "you have to login to activate it". I am already logged in! OK, fine, I'll log out and log back in again. Nope, same problem.

This is infuriating beyond belief. Hence, I take it to my own blog to bitch about it, and in the process, perhaps help a few people.

## Conclusion

I personally think AWS is a behemoth not worth wasting your time on.

I believe in clouds that are flexible and do not lock you into their proprietary and expensive solutions.

I believe in a cloud that helps their customers and quickly resolves their problems.

I used to be on such a cloud, and it was a paradise. But my current employer was already on AWS, and so I deal with it.

Are you curious about what cloud does not screw with their customers, offers incredibly competitive pricing, and is the only cloud that can run Docker Containers natively on the bare metal?

It's [**Joyent**](https://www.joyent.com/) — now a subsidiary of Samsung, little known but the most amazing cloud I've worked with.

But even if I wasn't on Joyent, I would probably choose Google Cloud. I just trust Google a whole lot more than I trust Amazon after my experience.

You can decide what's best for you, but don't forget, AWS Forums are not very helpful it turns out.

Please leave a comment if you found the solution here, and not on AWS support site. I would really appreciate it!
