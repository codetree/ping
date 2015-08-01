module Ping
  class Size
    attr_accessor :points

    PATTERN = /
      (?:^|\W)             # beginning of string or non-word char
      (?:size|points):     # keyword
      (\d+)                # point value
      (?=
        \.+[ \t\W]|        # dots followed by space or non-word character
        \.+$|              # dots at end of line
        [^0-9a-zA-Z_.]|    # non-word character except dot
        $                  # end of line
      )
    /ix

    # See http://rubular.com/r/7u67dIwXuk

    def self.extract(text)
      matches = text.scan(PATTERN)
      matches.any? ? self.new(matches.last.first.to_i) : self.new(nil)
    end

    def initialize(points)
      @points = points
    end

    def ==(other)
      other.to_i == to_i
    end

    def to_i
      points.to_i
    end

    def to_s
      points.to_s
    end
  end
end
