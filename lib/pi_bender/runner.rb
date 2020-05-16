require "yaml"
require "unix-crypt"
require "io/console"

validate!(config)

config["hosts"].each do |hostname, settings|
  ip = settings["ip"]

module PiBender
  class Runner
    def initialize(config)
      @config = config
    end

    def run_command(command)
      `ssh #{username}@#{ip_address} `
    end
  end
end

