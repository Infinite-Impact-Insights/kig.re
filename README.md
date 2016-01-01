## In Development

 You need to start by having a working version of ruby 2.2+, either using rbenv, rvm, etc.

```bash
gem install bundler
bundle install
bundle exec jekyll serve --watch

# or alternatively use rake that has a lot of useful commands:
rake jekyll:preview
# or to build into _site
rake jekyll:build
```

Now, to package this up and run in a Docker:

```bash
brew cask install dockertoolbox docker-compose docker-machine socker-swarm kitematic
docker-machine create default --driver virtualbox
eval $(docker-machine env default)
```

Then you can do the following:

```bash
rake docker:run
```
This will build nginx-based Docker image, build all assets and push them into the image.
The image will then be running, and accessible via:

```bash
open "http://$(docker-machine ip default):8080"
```

