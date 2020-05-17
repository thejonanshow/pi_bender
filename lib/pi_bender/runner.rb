module PiBender
  class Runner
    include ::PiBender::ConsoleIO

    def initialize(config, dry_run = false)
      @config = config
      @dry_run = dry_run
    end

    def run(command:)
      if @dry_run
        output "Executing: #{command}"
        return
      end

      execute(command)
    end

    def execute(command)
      check_caller!
      `#{command}`
    end

    def check_caller!
      if caller.join.match /_spec/
        raise CallerError.new(
          "Runner#execute called from spec, set 'dry_run: true' when initializing Runner."
        )
      end
    end

    class CallerError < StandardError; end
  end
end

