module PiBender
  class CLI
    config = PiBender::Configuration.new("config.yml")

    def prompt
      # { true || false }
      # reprompt if validation fails, reprompt with message
    end
  end
end
