# frozen_string_literal: true

require 'colored2'
require 'childprocess'
require 'forwardable'

require_relative 'task_helper/executable'
require_relative 'task_helper/runner'
require_relative 'ui_widgets'
require_relative 'logger_colors'

module TaskHelper
  include UIWidgets

  DEFAULT_NODE_VERSION = "v13.11.0"

  logger       = Logger.new(STDOUT)
  logger.level = Logger::INFO

  ChildProcess.logger = logger

  class << self
    def watch
      Runner.new(
        JEKYLL_WATCH_COMMAND.dup,
        GULP_WATCH_COMMAND.dup,
      ).parallel
    end
  end

  def install_nodejs_dependencies(node_version: DEFAULT_NODE_VERSION)
    brew = `which brew`.chomp
    if brew.nil? || !brew.end_with?('brew')
      raise "This task requires HomeBrew to be installed. 'which brew' returned #{brew}"
    end

    sh 'command -V node 2>/dev/null 1>&2 || brew install node'
    sh "[[ $(node --version) == '#{node_version}' ]] || brew upgrade node"
    sh 'command -V gulp 2>/dev/null 1>&2 || npm install --global gulp-cli'
    sh 'bash -c "set +e; npm ls >/dev/null || npm install"'
    sh 'gulp build'
  end

  def generate_new_post(args)
    title = args[:title]
    if title.nil?
      err = "Error: #{'title is required.'.red}\n" \
            "Usage: #{'rake \'jekyll:new[My Fancy New Title]\''.bold.green}"
      raise err
    end
    file_title = title.gsub(/ /, '_').gsub(/[^a-zA-Z0-9\-_]/, '').downcase
    filename   = "_posts/#{Time.now.strftime('%Y-%m-%d')}-#{file_title}.md"
    b          = binding
    h1 "Generating your new blog post!\n"
    puts 'Filename: ' + filename.to_s.bold.green
    puts 'Title:    ' + "'#{title}'".bold.green
    File.open(filename.to_s, 'w') do |f|
      f.puts(NEW_BLOG_TEMPLATE[].result(b))
    end
  end

  def rake_output_message(message)
    info("\n❯ " + message.bold.yellow)
  end

  def sh(*args)
    super(*args, verbose: true)
  end

  def header(title)
    info(title)
  end

  def image(config)
    "#{config.docker.image.user}/#{config.docker.image.name}"
  end

  def container(config)
    "#{config.docker.container.name}-#{config.docker.image.name}"
  end

end
