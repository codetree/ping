module Ping
  class IssueReference
    attr_accessor :qualifier, :repository, :number

    Qualifiers = /
      close|closes|closed|fix|fixes|fixed|resolve|resolves|resolved|
      need|needs|needed|require|requires|required
    /ix

    RepositoryName = /[a-z0-9][a-z0-9-]*\/[a-z0-9][a-z0-9\-_]*/

    Pattern = /
      (?:^|\W)                    # beginning of string or non-word char
      (?:(#{Qualifiers})(?:\s))?  # qualifier (optional)
      (?:(#{RepositoryName})?     # repository name (optional)
      \#|(?:GH\-))(\d+)           # issue number
      (?=
        \.+[ \t\W]|               # dots followed by space or non-word character
        \.+$|                     # dots at end of line
        [^0-9a-zA-Z_.]|           # non-word character except dot
        $                         # end of line
      )
    /ix

    # See http://rubular.com/r/bb7Ks0JK9l now http://rubular.com/r/evB7RlvUfI

    def initialize(qualifier, repository, number)
      @qualifier = qualifier
      @repository = repository
      @number = number
    end

    def self.extract(text)
      text.scan(Pattern).map do |match|
        self.new(*match)
      end
    end

    def self.replace(text, &block)
      text.gsub(Pattern) do |phrase|
        replacement = yield(phrase, self.new(*phrase.scan(Pattern).first))

        if replacement.is_a?(IssueReference)
          new_phrase = phrase[0] == " " ? " " : "" # fix leading space
          new_phrase << replacement.qualifier + " " if replacement.qualifier
          new_phrase << replacement.repository.to_s
          new_phrase << "#" + replacement.number.to_s
        else
          replacement
        end
      end
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
