## In Development

 You need to start by having a working version of ruby 2.2+, either using rbenv, rvm, etc.

```bash
gem install bundler
bundle install
bundle exec jekyll serve --watch
```

Now, to package this up and run in a Docker:

```bash
brew cask install dockertoolbox docker-compose docker-machine socker-swarm kitematic
docker-machine create default --driver virtualbox
eval $(docker-machine env default)
```
