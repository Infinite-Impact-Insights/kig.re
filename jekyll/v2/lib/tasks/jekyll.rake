# frozen_string_literal: true

require_relative '../task_helper'
require 'childprocess'

extend(TaskHelper)
Rake.extend(TaskHelper)


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
      TaskHelper::Executable.new('RUBYOPT="-W0" bundle exec jekyll build').start
    end

    threads.map(&:join)

    sh 'chmod -R 755 _site/'
  end

  desc 'Serve while live updating Jekyll and SASS content'
  task :watch do
    TaskHelper.watch
  end

  task serve: %i(deps watch)

  task :browser do
    spawn 'sleep 20 && open http://0.0.0.0:4000'
  end

  desc 'Starts Jekyll in serve --watch mode and opens the browser'
  task preview: %i(browser serve)
end
