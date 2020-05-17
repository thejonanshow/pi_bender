require "io/console"

module PiBender
  module ConsoleIO
    def output(message)
      return if @io_disabled
      puts message
    end

    def input
      return "" if @io_disabled
      gets.chomp
    end

    def input_secure
      return "" if @io_disabled
      STDIN.noecho(&:gets).chomp
    end

    def disable_io
      @io_disabled = true
      self
    end

    def enable_io
      @io_enabled = false
      self
    end
  end
end
