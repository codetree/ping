require "ping/mention"
require "ping/issue_reference"

module Ping
  class Parser
    attr_reader :text

    def initialize(text = nil)
      @text = text.to_s
    end

    def mentions
      Ping::Mention.extract(text)
    end

    def issue_references
      Ping::IssueReference.extract(text)
    end

    def replace_issue_references(&block)
      Ping::IssueReference.replace(text, &block)
    end
  end
end
