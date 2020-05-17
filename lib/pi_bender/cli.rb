module PiBender
  class CLI
    def initialize
      @config = PiBender::Configuration.new("pi_bender_config.yml")
    end

    def start
      puts "Welcome to PiBender!"
      set_passwords
    end

    def set_passwords
    end

    def prompt
      raise PromptError unless block_given?

      puts message
      response = gets.chomp

      if yield(response)
        return response
      else
        prompt(&block)
      end
    end

    class PromptError < ArgumentError; end
  end
end
