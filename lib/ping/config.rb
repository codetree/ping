module Ping
  class << self
    attr_accessor :config

    def configure
      yield config
    end

    def config
      @config ||= Config.new
    end

    # Here we are implementing a reset method because
    # for global values like this, it’s best to clean up before/after
    # each spec to ensure the system is back to a default state.
    def reset
      @config = Config.new
    end
  end

  class Config
    attr_accessor :qualifiers

    DEFAULT_QUALIFIERS = [
      'close', 'closes', 'closed', 'fix', 'fixes', 'fixed', 'need', 'needs', 'needed',
      'require', 'requires', 'required', 'resolve', 'resolves', 'resolved'
    ]

    def initialize
      @qualifiers = DEFAULT_QUALIFIERS
    end
  end
end
