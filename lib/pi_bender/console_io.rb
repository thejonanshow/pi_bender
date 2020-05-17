module PiBender
  module ConsoleIO
    def output(message)
      return if @io_disabled
      puts message
    end

    def input
      return if @disable_io
      gets.chomp
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