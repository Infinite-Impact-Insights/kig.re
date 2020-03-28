---
layout: post
title: 'C5 class instance on EC2: cannot create file: Read-only file system'
post_image: /assets/images/posts/aws/nvme-disks.jpg
tags: [aws, ec2, ubuntu]
categories: [devops]
author_id: 1
comments: true
toc: true
excerpt: "In this short post I describe the read-only file system issue that happened to one of our C5 hosts, and how we fixed it."
---

## Summary

<div class="post-summary">

This post describes how I was able to fix the "read-only filesystem" issue on one of my C5 instances in AWS EC2.

For impatient, I was able to run <code>fsck.ext4 -p</code> to fix an inode issue, and then the machine rebooted with read/write.

Read on for more details.

</div>

## Is AWS really a sane choice of a Cloud for mission-critical infrastructure?

This is a rhetorical question.

Still, — in this short post I describe the "read-only" problem that happened to one of our C5 hosts, offer a bit of a rant about how incompetent AWS support staff is, and how their forums are completely _useless_, and frankly, _infuriating_.

And as far as the question posted above I will let you make your own conclusion — so keep on reading.

Do you have this problem on one of your EC2 instances? Then read on. At least in our case the solution has been found. But not by AWS.

## The Problem — read only file system on a C5 class instance.

So here is what happened earlier today.

**One of our C5 instances suddenly became *read only***.

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

The command which assumes your instance uses SSD local drives, which are typically provided by the NVME (Non-Volatile Memory Express) drives.

> Note: NVMe (Non-Volatile Memory Express) is a communications interface and driver that defines a command set and feature set for PCIe-based SSDs with the goals of increased and efficient performance and interoperability on a broad range of enterprise and client systems. NVMe was designed for SSD.

What you see here is that the primary EBS volume was mounted as `ro` — meaning read only.

If you issue the same command on a healthy machine, you should see `rw`, instead of `ro`, meaning, of course, "read-write".

OK, so why would a file system on Linux become read-only? Could it be some data corruption? Bad blocks?

That's a possibility. Unlikely, since they are supposed to be using SSDs that are more reliable than HDDs. At least that's what SSD manufacturers want you to believe.

Anyway, from my early Linux days (I installed my first Linux in 1996, I think, from 80 floppy disks, really), I remember the über helpful `fsck` command. If you type `fsck<TAB><TAB>` you will see that there are a bunch of them:

```
$ fsck<TAB><TAB>
fsck
fsck.cramfs
fsck.ext3
fsck.ext4dev
fsck.minix
fsck.nfs
fsck.fat
fsck.msdos
fsck.vfat
fsck.xfs
fsck.btrfs
fsck.ext2
fsck.ext4
```

OK, so we just need to figure out which file system we are running, and then run the appropriate `fsck` utility.

Right above, where we did `mount -l`, you may have noticed that the file system type is `ext4`. Alrighty then. Now we know which `fsck` to run!

Let's run it and see what options does it have:

```bash
$ fsck.ext4
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

```bash
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


### Result

The box rebooted very quickly, and some 30 seconds later I was able to SSH into the machine. Viola!

No more read-only root partition, all services boot, and everything is back to normal.

Fantastic.

### How Not to Run Support Forums

I could vent a lot about how horrible AWS forums are, but I'll just say that there were relevant questions, with no answers. Not only that, but I couldn't even register for the forums and post the question right away.

Perhaps some time has passed now and they've fixed that. But let's just say it left me infuriated and without any useful info whatsoever.

