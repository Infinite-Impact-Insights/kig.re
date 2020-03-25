# frozen_string_literal: true

require 'colored2'
require 'childprocess'
module TaskHelper
  def rake_output_message(message)
    STDERR.puts("\n❯ " + message.bold.yellow)
  end

  def sh(*args)
    super(*args, verbose: true)
  end

  def background_sh(*commands)
    processes = []
    commands.each do |command|
      process = ChildProcess.build(*command)
      processes << process
      # inherit stdout/stderr from parent...
      process.io.inherit!
      process.environment['RUBYOPT'] = '-W0'
    end

    processes.each(&:start)

    loop do
      processes.each do |process|
        # check process status
        break if process.exited?
      end
      sleep 1
    end

    processes.each(&:stop)
    exit 0
  end

  def header(title)
    puts "\n#{title.upcase.yellow.bold}\n"
  end

  def image(config)
    "#{config.docker.image.user}/#{config.docker.image.name}"
  end

  def container(config)
    "#{config.docker.container.name}-#{config.docker.image.name}"
  end
end
