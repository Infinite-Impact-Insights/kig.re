# frozen_string_literal: true

require_relative '../task_helper'
extend(TaskHelper)
Rake.extend(TaskHelper)

namespace :jekyll do
  desc 'Setup dependencies: NodeJS & Gulp'

  task :deps do
    sh 'command -V node 2>/dev/null || brew install node'
    sh '[[ $(node --version) == "v13.11.0" ]] || brew upgrade node'
    sh 'command -V gulp 2>/dev/null || npm install --global gulp-cli'
    sh 'npm install'
    sh 'gulp build'
  end

  desc 'Generate a new post with the title provided as an argument'
  task :new, [:title] do |_t, args|
    title = args[:title]
    if title.nil?
      err = 'Error: ' + 'title is required.'.red + "\n" \
            'Usage: ' + 'rake \'jekyll:new[My Fancy New Title]\''.bold.green
      raise err
    end

    file_title = title.gsub(/ /, '_').gsub(/[^a-zA-Z0-9\-_]/, '').downcase
    filename   = "_posts/#{Time.now.strftime('%Y-%m-%d')}-#{file_title}.md"

    b = binding

    header "Creating a new blog post!\n"

    puts 'Filename: ' + filename.to_s.bold.green
    puts 'Title:    ' + "'#{title}'".bold.green

    File.open(filename.to_s, 'w') do |f|
      f.puts(ERB.new(File.read('_templates/post.md.erb')).result(b))
    end
  end

  desc 'Remove _site folder'
  task :clean do
    sh 'rm -rf _site'
  end

  desc 'Generate all static pages into _site folder'
  task generate: %i(deps) do
    sh 'RUBYOPT="-W0" bundle exec jekyll build'
    sh 'chmod -R 755 _site/'
  end

  task :server do
    sh 'RUBYOPT="-W0" bundle exec jekyll serve -H 0.0.0.0 --watch --trace'
  end

  task serve: %i(deps server)

  task :browser do
    spawn 'sleep 10 && open http://0.0.0.0:4000'
  end

  desc 'Starts Jekyll in serve --watch mode and opens the browser'
  task preview: %i(browser serve)
end
