require File.dirname(__FILE__) + '/../test_helper.rb'

class Ping::IssueTest < MiniTest::Test
  context "#==" do
    should "compare with integers" do
      issue = Ping::Issue.new("fixes", "codetree/codetree", "123")
      assert issue == 123
    end

    should "compare with strings" do
      issue = Ping::Issue.new("fixes", "codetree/codetree", "123")
      assert issue == "123"
    end

    should "compare with issues" do
      issue = Ping::Issue.new("fixes", "codetree/codetree", "123")
      assert issue == Ping::Issue.new(nil, "codetree/codetree", "123")
    end
  end

  context "#to_s" do
    should "return the issue number" do
      issue = Ping::Issue.new("Fixes", "codetree/codetree", "123")
      assert_equal "123", issue.to_s
    end
  end

  context "#to_i" do
    should "return the integer issue number" do
      issue = Ping::Issue.new("Fixes", "codetree/codetree", "123")
      assert_equal 123, issue.to_i
    end
  end
end
