require "yaml"

module PiBender
  class Configuration
    attr_reader :parsed

    def initialize(file)
      load(file)
    end

    def load(file)
      @parsed = YAML.load(file)
    end

    def validate!
      raise PiBender::Configuration::NFSError.new(
        "A cluster may only contain one node with 'export', the rest should be 'mount'."
      ) unless nfs_valid?
    end

    def nfs_valid?
      nfs_settings = @parsed["hosts"].map { |_, settings| settings["nfs"] }.compact
      nfs_keys = nfs_settings.map { |nfs_settings| nfs_settings.keys.first }
      nfs_keys.group_by(&:itself)["export"].length <= 1
    end

    class NFSError < KeyError; end
  end
end
