require "yaml"

module PiBender
  class Configuration
    def initialize(file)
      load(file)
      PiBender::Configuration.validate!(@parsed)
    end

    def self.validate!(config)
      raise MissingHostsError unless config["hosts"]

      raise PiBender::Configuration::NFSError.new(
        "A cluster may only contain one node with 'export', the rest should be 'mount'."
      ) unless nfs_valid?(config)
    end

    def self.nfs_valid?(config)
      nfs_settings = config["hosts"].map { |_, settings| settings["nfs"] }.compact
      return true if nfs_settings.empty?

      nfs_keys = nfs_settings.map { |nfs_settings| nfs_settings.keys.first }
      nfs_keys.group_by(&:itself)["export"].length <= 1
    end

    def hostnames
      @parsed["hosts"].keys
    end

    def settings_for_hostname(hostname)
      @parsed["hosts"][hostname]
    end

    def load(file)
      @parsed = YAML.load(file)
    end

    class NFSError < KeyError; end
    class MissingHostsError < ArgumentError; end
  end
end
