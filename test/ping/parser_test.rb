require File.dirname(__FILE__) + '/../test_helper.rb'

class Ping::ParserTest < MiniTest::Test
  context "#mentions" do
    should "extract @mentions" do
      text = "Hey there, @djreimer. How's @defunkt?"
      parser = Ping::Parser.new(text)
      assert parser.mentions.include?("djreimer")
      assert parser.mentions.include?("defunkt")
    end

    should "de-dup mentions" do
      text = "Hey there, @djreimer. How's @djreimer?"
      parser = Ping::Parser.new(text)
      assert_equal 1, parser.mentions.length
    end
  end
end
