# Jekyll kig.re Site v2

## Usage:

### Generating the Static Site Manually:

```bash
$ npm install
$ gulp build
$ bundle install 
$ bundle exec jekyll build
```

Serve from `_site` folder.

### Automated Way via `rake`

We've put together a bunch of useful Rake tasks for all of your needs.

#### Static Site Generation

```bash
$ bundle install
$ bundle exec rake jekyll:generate
```

#### Live Editing

```bash
$ bundle install && bundle exec rake 
```

The task being executed by the default is `jekyll:preview`, which runs `jekyll:serve` and `jekyll:browser`. The later one opens the browser after the assets are compiled, but it's not an exact science.

The main Rake task `jekyll:serve` starts two long-running child processes:

 1. `gulp watch`
 2. `bundle exec jekyll serve --watch --trace`

This will live-recompile all static assets, so that you can see what you get.

You can Ctrl-C to shut it down.

Enjoy!


