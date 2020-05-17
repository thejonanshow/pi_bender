require "faraday"

module PiBender
  module Clients
    class HTTP
      def initialize(core = ::Faraday)
        @core = core
      end

      def head(url)
        @core.head(url)
      end
    end
  end
end
