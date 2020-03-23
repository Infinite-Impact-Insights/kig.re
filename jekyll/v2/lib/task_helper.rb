# frozen_string_literal: true

require 'colored2'

module TaskHelper
  def rake_output_message(message)
    STDERR.puts("\n❯ " + message.bold.yellow)
  end

  def sh(*args)
    super(*args, verbose: true)
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
