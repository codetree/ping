module Ping
  class IssueReference
    attr_accessor :qualifier, :repository, :number

    REPOSITORY_NAME = /[a-z0-9][a-z0-9\-]*\/[a-z0-9][a-z0-9\-_]*/ix

    class << self
      def qualifier_regex
        /#{Ping.config.qualifiers.join('|')}/ix
      end

      # Match references of the form:
      #
      # - #123
      # - codetree/feedback#123
      # - GH-123
      # - needs #123
      # - etc...
      #
      # See http://rubular.com/r/evB7RlvUfI
      def short_pattern
        /
          (?:^|\W)                         # beginning of string or non-word char
          (?:(#{qualifier_regex})(?:\s))?  # qualifier (optional)
          (?:(#{REPOSITORY_NAME})?         # repository name (optional)
          \#|(?:GH\-))(\d+)                # issue number
          (?=
            \.+[ \t]|                      # dots followed by space or non-word character
            \.+$|                          # dots at end of line
            [^0-9a-zA-Z_.]|                # non-word character except dot
            $                              # end of line
          )
        /ix
      end

      # Match references of the form:
      #
      # - https://github.com/codetree/feedback/issues/123
      # - https://github.com/codetree/feedback/pulls/123
      # - needs https://github.com/codetree/feedback/issues/123
      # - etc...
      def url_pattern
        /
          (?:^|\W)                         # beginning of string or non-word char
          (?:(#{qualifier_regex})(?:\s))?  # qualifier (optional)
          https:\/\/github.com\/
          (#{REPOSITORY_NAME})             # repository name
          \/(?:issues|pulls)\/
          (\d+)                            # issue number
          (?=
            \.+[ \t]|                      # dots followed by space or non-word character
            \.+$|                          # dots at end of line
            [^0-9a-zA-Z_.]|                # non-word character except dot
            $                              # end of line
          )
        /ix
      end

      def extract(text)
        [short_pattern, url_pattern].inject([]) do |memo, pattern|
          memo.tap do |m|
            text.scan(pattern).each do |match|
              m << new(*match)
            end
          end
        end
      end

      def replace(text, &block)
        [short_pattern, url_pattern].each do |pattern|
          text = text.gsub(pattern) do |match|
            ref = new(*match.scan(pattern).first)
            replace_match(match, ref, &block)
          end
        end

        text
      end

      def replace_match(match, ref, &_block)
        replacement = yield(match, ref)
        return replacement unless replacement.is_a?(IssueReference)

        # Reformat the given issue reference replacement to match
        new_phrase = match[0] == ' ' ? ' ' : '' # fix leading space
        new_phrase << replacement.qualifier + ' ' if replacement.qualifier
        new_phrase << replacement.repository.to_s
        new_phrase << '#' + replacement.number.to_s
      end
    end

    def initialize(qualifier, repository, number)
      @qualifier = qualifier
      @repository = repository
      @number = number
    end

    def ==(other)
      other.to_i == to_i
    end

    def to_i
      number.to_i
    end

    def to_s
      number.to_s
    end
  end
end
