require File.dirname(__FILE__) + '/../test_helper.rb'

class Ping::IssueReferenceTest < MiniTest::Test
  context "#==" do
    should "compare with integers" do
      issue = Ping::IssueReference.new("fixes", "codetree/codetree", "123")
      assert issue == 123
    end

    should "compare with strings" do
      issue = Ping::IssueReference.new("fixes", "codetree/codetree", "123")
      assert issue == "123"
    end

    should "compare with issues" do
      issue = Ping::IssueReference.new("fixes", "codetree/codetree", "123")
      assert issue == Ping::IssueReference.new(nil, "codetree/codetree", "123")
    end
  end

  context "#to_s" do
    should "return the issue number" do
      issue = Ping::IssueReference.new("Fixes", "codetree/codetree", "123")
      assert_equal "123", issue.to_s
    end
  end

  context "#to_i" do
    should "return the integer issue number" do
      issue = Ping::IssueReference.new("Fixes", "codetree/codetree", "123")
      assert_equal 123, issue.to_i
    end
  end
end
