require "unix_crypt"

module PiBender
  class Minion
    attr_reader :hostname, :hashed_password

    def initialize(hostname:, settings:)
      @hostname = hostname
      @settings = settings
    end

    def set_password(password)
      raise PasswordError.new(
        "Passwords can not be empty."
      ) if password.empty?

      @hashed_password = UnixCrypt::SHA256.build(password)
    end

    class PasswordError < ArgumentError; end
  end
end
