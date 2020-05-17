module PiBender
  class Minion
    attr_reader :hostname

    def initialize(hostname:, settings:)
      @hostname = hostname
      @settings = settings
    end
  end
end
