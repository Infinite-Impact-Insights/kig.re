# frozen_string_literal: true
# vim: ft=ruby
require_relative '../task_helper'
require 'childprocess'

extend(TaskHelper)
Rake.extend(TaskHelper)

def ruby_environment
  env = {}
  env['RUBYOPT'] = /^2\.7/.match?(RUBY_VERSION) ?
      '-W:no-deprecated -W:no-experimental -W0' :
      'W0'
  env
end

namespace :jekyll do
  desc 'Setup dependencies: NodeJS & Gulp'

  task :deps do
    install_nodejs_dependencies
  end

  desc 'Generate a new post with the title provided as an argument'
  task :new, [:title] do |_t, args|
    generate_new_post(args)
  end

  desc 'Remove _site folder'
  task :clean do
    sh 'rm -rf _site'
  end

  desc 'Generate all static pages into _site folder'
  task :generate do
    threads = []
    threads << Thread.new do
      install_nodejs_dependencies
    end

    threads << Thread.new do
      TaskHelper::Executable.new('bundle exec jekyll build', **ruby_environment).start
    end

    threads.map(&:join)

    sh 'chmod -R 755 _site/'
  end

  desc 'Prettify HTML'
  task :prettify do
    sh %\
        for file in $(find _site -name '*.html'); do
          echo "${file}";
          sed -i'' -e  's#<p><div id="preamble">#<div id="preamble">#g; s#^</div></p>$#</div>#g' ${file};
        done
        \
    sh 'cd _site && prettier --html-whitespace-sensitivity=css --end-of-line=lf --print-width=150 --prose-wrap=never --parser=html --write "**/*.html" || true'
  end

  task production: %w(jekyll:generate jekyll:prettify)

  desc 'Serve while live updating Jekyll and SASS content'
  task :watch do
    TaskHelper.watch
  end

  task serve: %i(clean deps watch)

  task :browser do
    spawn 'sleep 20 && open http://0.0.0.0:4000'
  end

  desc 'Starts Jekyll in serve --watch mode and opens the browser'
  task preview: %i(browser serve)
end
