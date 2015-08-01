require File.dirname(__FILE__) + '/../test_helper.rb'

class Ping::MentionTest < MiniTest::Test
  def extract(text)
    Ping::Mention.extract(text)
  end

  def extract_first(text)
    Ping::Mention.extract(text).first
  end

  context ".extract" do
    should "extract @mentions" do
      text = "Hey there, @djreimer. How's @defunkt?"
      result = extract(text)
      assert result.include?("djreimer")
      assert result.include?("defunkt")
    end

    should "de-dup mentions" do
      text = "Hey there, @djreimer. How's @djreimer?"
      result = extract(text)
      assert_equal 1, result.length
    end
  end

  context "#==" do
    should "compare with strings" do
      mention = Ping::Mention.new("djreimer")
      assert mention == "djreimer"
    end

    should "compare with mentions" do
      mention = Ping::Mention.new("djreimer")
      assert mention == Ping::Mention.new("djreimer")
    end
  end

  context "#to_s" do
    should "return the username" do
      mention = Ping::Mention.new("djreimer")
      assert_equal "djreimer", mention.to_s
    end
  end
end
