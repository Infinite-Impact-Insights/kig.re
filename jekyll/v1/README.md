### Installing

You need to start by having a working version of ruby 2.4+, either using rbenv, rvm, etc.

```bash
git clone https://github.com/kigster/kig.re
cd kig.re
gem install bundler --no-ri --no-rdoc
bundle
```

### Running Locally

After that, you can view the blog by serving with Jekyll directly:

```bash
rake
```

This calls default task `jekyll:preview`, which builds the site, and opens the browser, while keeping jekyll serving the requests.

This is a great mode to add new content.

### Deployment

To deploy to Joyent Cloud, run the script

```bash
./deploy
``` 

Requirements: SSH Keys into the Joyent Account.

### Rake Tasks

Complete list of rake tasks is below:

```bash
❯ rake -T
rake deploy             # Deploy the HEAD to production
rake docker:build       # Build Docker Image from a Dockerfile
rake docker:rm          # Remove Docker container
rake docker:run         # Run (and build) Docker image
rake docker:start       # Start Docker Container
rake docker:status      # Report on status of the Docker container
rake docker:stop        # Stop docker container
rake jekyll:build       # Generate all static pages into _site folder
rake jekyll:clean       # Remove _site folder
rake jekyll:new[title]  # Generate a new post with the title provided as an argument
rake jekyll:preview     # Starts Jekyll in serve --watch mode and opens the browser
```


## Docker 

The site can also be run inside a Docker container, based on an nginx.

First, you must [download and install Docker](https://docs.docker.com/docker-for-mac/install/).

Then,

```bash
rake docker:run
```

This will build an nginx-based Docker image, build all assets and push them into the image.
The image will then be running, and accessible via:

```bash
open http://localhost/
```

Or [this link](http://localhost/).

### Rake Docker:Run

Below is the example build of the container:

```bash
docker rm --force kigre-kigre
kigre-kigre
RUBYOPT="-W0" bundle exec jekyll build
Configuration file: /Users/kig/workspace/sites/kig.re/_config.yml
            Source: .
       Destination: ./_site
 Incremental build: disabled. Enable with --incremental
      Generating...
Generating Compass: /Users/kig/workspace/sites/kig.re/_compass => /Users/kig/workspace/sites/kig.re/_site/../public/css

      Generating...                     done in 0.841 seconds.
 Auto-regeneration: disabled. Use --watch to enable.
chmod -R 755 _site/
cp _docker/Dockerfile.nginx-full _site/Dockerfile
cp _docker/nginx* _site/
cd _site && docker build -t kigster/kigre .
Sending build context to Docker daemon 14.07 MB
Step 1/13 : FROM nginx:1.11.10
 ---> 6b914bbcb89e
Step 2/13 : MAINTAINER Konstantin Gredeskoul <kigster@gmail.com>
 ---> Using cache
 ---> 230d81f55068
Step 3/13 : LABEL Description "This image is used to run Konstantins Blog" Vendor "ReinventONE, Inc." Version "1.0"
 ---> Using cache
 ---> 50bc4fb1dc15
Step 4/13 : RUN apt-get update -qq && apt-get -y upgrade
 ---> Using cache
 ---> dd03359b49b6
Step 5/13 : RUN apt-get install -V -y nodejs software-properties-common curl git htop man unzip vim wget
 ---> Using cache
 ---> 5f6d89f3f9c6
Step 6/13 : RUN apt-get install -V -y net-tools
 ---> Using cache
 ---> ea27cbc4542d
Step 7/13 : RUN mkdir /app
 ---> Using cache
 ---> 8d2470bbfe49
Step 8/13 : ADD . /app
 ---> 886e00b8ed23
Removing intermediate container 2ebf0b8f84c5
Step 9/13 : COPY nginx.conf /etc/nginx/nginx.conf
 ---> 496c86c26d9f
Removing intermediate container 2a8227b9ce98
Step 10/13 : WORKDIR /app
 ---> 3e69f7ab4990
Removing intermediate container e3a689f2986f
Step 11/13 : RUN rm /app/nginx.conf
 ---> Running in 2ed1e697a607
 ---> fb984961925e
Removing intermediate container 2ed1e697a607
Step 12/13 : EXPOSE 8080
 ---> Running in 9c3202665f25
 ---> f1738f6ba96e
Removing intermediate container 9c3202665f25
Step 13/13 : CMD /usr/sbin/nginx
 ---> Running in 11bfaa4ff0bd
 ---> 25dddc9cccdb
Removing intermediate container 11bfaa4ff0bd
Successfully built 25dddc9cccdb
docker run --name kigre-kigre -d -p 80:8080 kigster/kigre
afe5d37582a8ef208e8f655a7be7d65ae36fa12c76261822ad57d4cb67735120
``` 
