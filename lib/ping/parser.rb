require "ping/mention"
require "ping/issue"

module Ping
  class Parser
    attr_reader :text

    def initialize(text = nil)
      @text = text.to_s
    end

    def mentions
      Ping::Mention.extract(text)
    end

    def issues
      Ping::Issue.extract(text)
    end
  end
end
