module PiBender
  module SpecHelpers
    module FakeClient
      def method_missing(name, *args, &block)
        message = "Method '#{name}' isn't defined."
        message << "\n- args: #{args.join(', ')}" if args.any?
        raise UnexpectedMethodError.new(message)
      end

      class UnexpectedMethodError < NotImplementedError; end
    end
  end
end
