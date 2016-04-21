---
layout: page
title: 'Docking with the Container Conf on Autopilot'
draft: true
---
I am writing this from the [ContainerCamp](http://container.camp) – a single day conference in San Francisco. Its happening inside of the gorgeous Bloomingdale shopping mall. Who knew that inside of the shopping mall is a shwanky co-working space? I didn't.

Anyway, I am here as a bit of an outsider, at least the way I see myself. I have been hearing about Docker, playing with it a bit, scratching my head quite a bit, and so I am certainly looking forward to some clarity today. I do strongly believe that if something is a challenge for me to fully "get", it's going to be a challenge also for other people, perhaps those who think like me. 

### Blood Behind

I come to this conference with over twenty years of commercial software experience. My early foreay into software started with Linux version 0. I was the guy with 80 floppy disks at the university computer center, installing it on one of the firmly attached computers in the lab. Of course I didn't have a permission, what sort of question is that?!

From my the first true software job that I landed in Melbourne circa 1995, I was deeply involved with Operations. I was hired to be a junior helper to the truly phenomenal Ops Group in charge of running everything, requred  for the  multi-million, multi-year project to rewrite  ancient management software for one of the largest private rail companies in Australia. From cargo tracking with live sensors, to routing of the (iron) containers, to ticketing, this was a major undertanding, and one that (predictably) got delayed by over a year.  

It was during that time that I got to appreciate the complexities and intoxicating power of making large distributed systems run continuously, withstanding hardware outages, network outages, train outages, human errors, and in general – tolerate anything at all that could possibly failed. I believe, that this was the experience that would make a lasting imprint on the way I think of building and running distributed software.

##  Ops Team and Dev vs Ops (Topica)

## DevOps Team, and Dev without Ops (Wanelo)

### Chef

### Joyent Zones

## Containers

## Conference Quotes::

"Containers are not a panacaea!" 
"Containers are not virtualization"
	 –– RedHeat

## Container Koolaid

Quote from [http://kubernetes.io/docs/whatisk8s/](http://kubernetes.io/docs/whatisk8s/):

> The __Old Way__ to deploy applications was to install the applications on a host using the operating system package manager. This had the disadvantage of entangling the applications’ executables, configuration, libraries, and lifecycles with each other and with the host OS. One could build immutable virtual-machine images in order to achieve predictable rollouts and rollbacks, but VMs are heavyweight and non-portable.

And then, of course, 

> The New Way is to deploy containers based on operating-system-level virtualization rather than hardware virtualization. These containers are isolated from each other and from the host: they have their own filesystems, they can’t see each others’ processes, and their computational resource usage can be bounded. They are easier to build than VMs, and because they are decoupled from the underlying infrastructure and from the host filesystem, they are portable across clouds and OS distributions.


## Things Worth Researching

* Kuberneties – deployment and orchestration tool for Docker?
* Deis – workflow for Kuberneties
* Flynn

