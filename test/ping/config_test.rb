# frozen_string_literal: true

require File.dirname(__FILE__) + '/../test_helper.rb'

class Ping::ConfigTest < MiniTest::Test
  def setup
    Ping.reset
  end

  context '#default qualifiers' do
    should 'have default qualifiers' do
      default_qualifiers = Ping::Config::DEFAULT_QUALIFIERS

      Ping.config.qualifiers.each do |q|
        assert default_qualifiers.include?(q)
      end
    end
  end

  context '#with custom configuration' do
    setup do
      @custom_qualifiers = %w[fix epic needed-by close]

      Ping.configure do |config|
        config.qualifiers = @custom_qualifiers
      end
    end

    should 'include custom qualifiers' do
      Ping.config.qualifiers.each do |q|
        assert @custom_qualifiers.include?(q)
      end
    end

    should 'not include unknown qualifiers' do
      unknown_qualifiers = %w[resolve require done]

      unknown_qualifiers.each do |q|
        assert !Ping.config.qualifiers.include?(q)
      end
    end
  end
end
