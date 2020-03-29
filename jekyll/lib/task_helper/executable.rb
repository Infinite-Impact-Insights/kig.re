require_relative '../ui_widgets'
require 'json'
module TaskHelper
  RUBY_COMMANDS = %w(bundle rake jekyll).freeze

  class Executable
    include UIWidgets
    extend Forwardable

    def_delegators :env, :[], :[]=

    attr_accessor :command, :env, :process, :process_thread

    def initialize(command, env = {})
      self.command = command.is_a?(Array) ? command : command.split(' ')
      # add 'ruby -S ' if the command starts with the bundler
      if RUBY_COMMANDS.include?(self.command.first)
        self.command.unshift('-S')
        self.command.unshift('ruby')
      end
      self.env = env
    end

    def start(async: true, verbose: true)
      self.process = ChildProcess.build(*command)

      process.io.inherit!
      process.environment ||= {}

      cmd = command.join(' ')

      env&.each_pair do |var, value|
        process.environment[var] = value
      end

      text = ["Launching    ➡ " + cmd.bold.green]
      text += ["Environment  ➡ " + process.environment.map { |k, v| "export #{k}=#{v}".bold.cyan }.join("\n")]

      self.process_thread = Thread.new do
        process.start
        text += ["Process      ➡ #{process.pid.to_s.bold.yellow}"]
        text_box text: text if verbose
        process.wait
        process.exit_code
      end

      join unless async
    end

    def join
      process_thread.join if process_thread&.alive?
    end

    def exit_code
      process_thread&.value
    end
  end


  JEKYLL_BUILD_COMMAND = Executable.new(
    'bundle exec jekyll build --trace', { RUBYOPT: '-W0' }
  ).freeze

  JEKYLL_WATCH_COMMAND = Executable.new(
    'bundle exec jekyll serve -H 0.0.0.0 --watch --drafts --trace', { RUBYOPT: '-W0' }
  ).freeze

  GULP_WATCH_COMMAND = Executable.new('gulp watch').freeze

  NEW_BLOG_TEMPLATE = ->() { ERB.new(File.read('_templates/post.md.erb')) }
end
