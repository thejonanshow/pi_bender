module PiBender
  class CLI
    include ::PiBender::ConsoleIO

    attr_reader :minions

    def initialize(config, http: nil)
      @config = config
      @minions = create_minions
      @http = http || PiBender::Clients::HTTP.new
    end

    def start
      output "Welcome to PiBender! ~π~"
      output "---"
      set_passwords
      set_authorized_keys
    end

    def create_minions
      @config.hostnames.map do |hostname|
        PiBender::Minion.new(hostname: hostname, settings: @config.settings_for_hostname(hostname))
      end
    end

    def set_passwords
      output "1) Set passwords for the Raspberry Pis\n---"
      @minions.each do |minion|
        message = "Enter password for #{minion.hostname}:"
        password = prompt(message: message, input_handler: method(:input_secure)) do |response|
          !response.empty?
        end
        message = message.gsub("Enter", "Confirm")
        password_confirmation = prompt(message: message, input_handler: method(:input_secure)) do |response|
          !response.empty?
        end

        if password == password_confirmation
          minion.set_password(password)
        else
          output "Passwords don't match."
          redo
        end
      end
    end

    def set_authorized_keys
      output "2) Pull ssh keys from GitHub\n---"
      username = prompt(message: "Enter your GitHub username:") do |response|
        response if username_valid?(response)
      end

      if keys = fetch_keys(username)
        set_keys_on_minions(keys)
      else
        output "Could not acquire keys, authorized_keys file will not be changed."
      end
    end

    def username_valid?(username)
      url = "https://github.com/#{username}.keys"
      http_status = @http.head(url).status

      if http_status == 200
        true
      else
        output "Couldn't reach GitHub, the request to #{url} returned '#{http_status}'."
        false
      end
    end

    def fetch_keys(username)
      url = "https://github.com/#{username}.keys"
      keys = @http.get(url).body.split("\n")
    end

    def set_keys_on_minions(keys)
      @minions.each do |minion|
        minion.set_keys(keys)
      end
    end

    def prompt(message:, attempts: 0, input_handler: method(:input), &response_validator)
      raise PromptError unless block_given?

      output message
      response = input_handler.call

      if response_validator.call(response)
        return response
      else
        output "Invalid response."
        prompt(message: message, attempts: attempts + 1, &response_validator) unless attempts > 3
      end

      nil
    end

    class PromptError < ArgumentError; end
  end
end
