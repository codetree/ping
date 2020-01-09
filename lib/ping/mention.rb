module Ping
  class Mention
    attr_accessor :username

    PATTERN = /
      (?:^|\W)                    # beginning of string or non-word char
      @((?>[a-z0-9][a-z0-9-]*))   # @username
      (?!\/)                      # without a trailing slash
      (?=
        \.+[ \t]|                 # dots followed by space or non-word character
        \.+$|                     # dots at end of line
        [^0-9a-zA-Z_.]|           # non-word character except dot
        $                         # end of line
      )
    /ix

    def initialize(username)
      @username = username
    end

    def self.extract(text)
      text.scan(PATTERN).flatten
          .map(&:downcase).uniq.map do |username|
            new(username)
          end
    end

    def ==(username)
      username == self.username
    end

    def to_s
      username
    end
  end
end
