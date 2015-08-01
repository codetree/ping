require File.dirname(__FILE__) + '/../test_helper.rb'

class Ping::ParserTest < MiniTest::Test
  context '#size' do
    should 'extract the last point value' do
      text = 'Is this size:12 or size:14?'
      parser = Ping::Parser.new(text)
      assert_equal 14, parser.size.points
    end

    should 'be indifferent to keyword casing' do
      text = 'SiZe:12'
      parser = Ping::Parser.new(text)
      assert_equal 12, parser.size.points
    end

    should 'return nil if there is no size' do
      text = 'No size here'
      parser = Ping::Parser.new(text)
      assert_nil parser.size.points
    end
  end
end
