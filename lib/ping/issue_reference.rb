module Ping
  class IssueReference
    attr_accessor :qualifier, :repository, :number

    QUALIFIERS = /
      close|closes|closed|fix|fixes|fixed|resolve|resolves|resolved|
      need|needs|needed|require|requires|required
    /ix

    REPOSITORY_NAME = /[a-z0-9][a-z0-9\-]*\/[a-z0-9][a-z0-9\-_]*/ix

    # Match references of the form:
    #
    # - #123
    # - codetree/feedback#123
    # - GH-123
    # - needs #123
    # - etc...
    #
    # See http://rubular.com/r/evB7RlvUfI
    SHORT_PATTERN = /
      (?:^|\W)                    # beginning of string or non-word char
      (?:(#{QUALIFIERS})(?:\s))?  # qualifier (optional)
      (?:(#{REPOSITORY_NAME})?    # repository name (optional)
      \#|(?:GH\-))(\d+)           # issue number
      (?=
        \.+[ \t\W]|               # dots followed by space or non-word character
        \.+$|                     # dots at end of line
        [^0-9a-zA-Z_.]|           # non-word character except dot
        $                         # end of line
      )
    /ix

    # Match references of the form:
    #
    # - https://github.com/codetree/feedback/issues/123
    # - https://github.com/codetree/feedback/pulls/123
    # - needs https://github.com/codetree/feedback/issues/123
    # - etc...
    URL_PATTERN = /
      (?:^|\W)                    # beginning of string or non-word char
      (?:(#{QUALIFIERS})(?:\s))?  # qualifier (optional)
      https:\/\/github.com\/
      (#{REPOSITORY_NAME})        # repository name
      \/(?:issues|pulls)\/
      (\d+)                       # issue number
      (?=
        \.+[ \t\W]|               # dots followed by space or non-word character
        \.+$|                     # dots at end of line
        [^0-9a-zA-Z_.]|           # non-word character except dot
        $                         # end of line
      )
    /ix

    def initialize(qualifier, repository, number)
      @qualifier = qualifier
      @repository = repository
      @number = number
    end

    def self.extract(text)
      [SHORT_PATTERN, URL_PATTERN].inject([]) do |memo, pattern|
        memo.tap do |m|
          text.scan(pattern).each do |match|
            m << new(*match)
          end
        end
      end
    end

    def self.replace(text, &block)
      [SHORT_PATTERN, URL_PATTERN].each do |pattern|
        text = text.gsub(pattern) do |match|
          ref = new(*match.scan(pattern).first)
          replace_match(match, ref, &block)
        end
      end

      text
    end

    def self.replace_match(match, ref, &_block)
      replacement = yield(match, ref)
      return replacement unless replacement.is_a?(IssueReference)

      # Reformat the given issue reference replacement to match
      new_phrase = match[0] == ' ' ? ' ' : '' # fix leading space
      new_phrase << replacement.qualifier + ' ' if replacement.qualifier
      new_phrase << replacement.repository.to_s
      new_phrase << '#' + replacement.number.to_s
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
