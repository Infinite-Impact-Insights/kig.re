# frozen_string_literal: true

require_relative 'executable'
require_relative '../ui_widgets'

module TaskHelper
  class Runner
    include UIWidgets

    class UserInterruptedError < StandardError; end

    attr_accessor :executables, :commands, :options

    def initialize(*commands, **options)
      self.commands    = commands
      self.options     = options
      self.executables = []

      commands.each do |command|
        executables << make_executable(command)
      end
    end

    def parallel
      # Signal.trap('INT') { raise UserInterruptedError, 'Ctrl-C was pressed!' }

      executables.map { |e| e.start(options) }
      executables.map(&:join)

      loop do
        executables.each do |exec|
          break if exec.process.exited?
        end
        sleep 1
      end

      executables.each(&:stop)

      # return sum of all exit codes; for total success it should be zero
      executables.map(&:exit_code).sum
    rescue ChildProcess::Error => e
      warn e.message
      puts e.backtrace.reverse.join("\n")
    rescue UserInterruptedError => e
      warn e.message
    rescue StandardError => e
      warn e.message, 'Attempting to abort running children...'
    ensure
      shutdown!
    end

    private

    def shutdown!
      executables.each do |e|
        e.process.poll_for_exit(10) if e&.process&.alive?
      end
    rescue ChildProcess::TimeoutError
      executables.each do |e|
        e.process.stop if e&.process&.alive?
      end
    end

    def make_executable(command)
      return command if command.is_a?(Executable)

      Executable.new(
        command.is_a?(String) ? command.split(' ') : command
      )
    end
  end
end
