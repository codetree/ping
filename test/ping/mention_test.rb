require File.dirname(__FILE__) + '/../test_helper.rb'

class Ping::MentionTest < MiniTest::Test
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
