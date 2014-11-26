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

  context "#issues" do
    should "extract single issue references" do
      text = "See #43"
      parser = Ping::Parser.new(text)
      issue = parser.issues.first

      assert_equal nil, issue.qualifier
      assert_equal nil, issue.repository
      assert_equal "43", issue.number
    end

    should "extract single issue references followed by a period" do
      text = "See #43."
      parser = Ping::Parser.new(text)
      issue = parser.issues.first

      assert_equal nil, issue.qualifier
      assert_equal nil, issue.repository
      assert_equal "43", issue.number
    end

    should "extract close qualifiers" do
      %w{fix fixes fixed close closes closed resolve resolves resolved}.each do |q|
        text = "#{q} #55"
        parser = Ping::Parser.new(text)
        issue = parser.issues.first

        assert_equal q, issue.qualifier
        assert_equal nil, issue.repository
        assert_equal "55", issue.number
      end
    end

    should "extract dependency qualifiers" do
      %w{need needs needed require requires required}.each do |q|
        text = "#{q} #123"
        parser = Ping::Parser.new(text)
        issue = parser.issues.first

        assert_equal q, issue.qualifier
        assert_equal nil, issue.repository
        assert_equal "123", issue.number
      end
    end

    should "extract repository" do
      text = "codetree/codetree#43"
      parser = Ping::Parser.new(text)
      issue = parser.issues.first

      assert_equal nil, issue.qualifier
      assert_equal "codetree/codetree", issue.repository
      assert_equal "43", issue.number
    end

    should "extract repository with qualifier" do
      text = "Fixes codetree/codetree#43"
      parser = Ping::Parser.new(text)
      issue = parser.issues.first

      assert_equal "Fixes", issue.qualifier
      assert_equal "codetree/codetree", issue.repository
      assert_equal "43", issue.number
    end

    should "extract multiple references" do
      text = "You should look at #2 and #4 because #5 fixes codetree/codetree#6"
      parser = Ping::Parser.new(text)

      assert parser.issues.include?(2)
      assert parser.issues.include?(4)
      assert parser.issues.include?(5)
      assert parser.issues.include?(6)
    end

    should "not extract similar non-qualifiers" do
      text = "afixes #43"
      parser = Ping::Parser.new(text)
      issue = parser.issues.first

      assert_equal nil, issue.qualifier
      assert_equal nil, issue.repository
      assert_equal "43", issue.number
    end

    should "not choke on case" do
      text = "FIxEs #43"
      parser = Ping::Parser.new(text)
      issue = parser.issues.first

      assert_equal "FIxEs", issue.qualifier
      assert_equal nil, issue.repository
      assert_equal "43", issue.number
    end

    should "require one space between qualifier and issue" do
      text = "fixes   #43"
      parser = Ping::Parser.new(text)
      issue = parser.issues.first

      assert_equal nil, issue.qualifier
      assert_equal nil, issue.repository
      assert_equal "43", issue.number
    end
  end
end
