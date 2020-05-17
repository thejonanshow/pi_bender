module PiBender
  class CLI
    include ::PiBender::ConsoleIO

    def initialize(config)
      @config = config
    end

    def start
      puts "Welcome to PiBender!"
      set_passwords
    end

    def set_passwords
      @config.hostnames.each do |host|
        prompt(message: "Enter password for #{host}:") do |response|
          response.empty?
        end
      end
    end

    def prompt(message:, attempts: 0, &response_validator)
      raise PromptError unless block_given?

      output message
      response = input

      if response_validator
        return response
      else
        puts "Invalid response."
        prompt(message: message, attempts: attempts + 1, &response_validator) unless attempts > 3
      end
    end

    class PromptError < ArgumentError; end
  end
end
