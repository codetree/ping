require File.dirname(__FILE__) + '/../test_helper.rb'

class Ping::IssueReferenceTest < MiniTest::Test
  def extract(text)
    Ping::IssueReference.extract(text)
  end

  def extract_first(text)
    Ping::IssueReference.extract(text).first
  end

  context '.extract with standard syntax' do
    should 'extract single issue references' do
      text = 'See #43'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal nil, issue.repository
      assert_equal '43', issue.number
    end

    should 'extract single issue references followed by a period' do
      text = 'See #43.'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal nil, issue.repository
      assert_equal '43', issue.number
    end

    should 'extract close qualifiers' do
      %w(fix fixes fixed close closes closed resolve resolves resolved).each do |q|
        text = "#{q} #55"
        issue = extract_first(text)

        assert_equal q, issue.qualifier
        assert_equal nil, issue.repository
        assert_equal '55', issue.number
      end
    end

    should 'extract dependency qualifiers' do
      %w(need needs needed require requires required needed-by).each do |q|
        text = "#{q} #123"
        issue = extract_first(text)

        assert_equal q, issue.qualifier
        assert_equal nil, issue.repository
        assert_equal '123', issue.number
      end
    end

    should 'extract repository' do
      text = 'codetree/codetree#43'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal 'codetree/codetree', issue.repository
      assert_equal '43', issue.number
    end

    should 'extract repository with qualifier' do
      text = 'Fixes codetree/codetree#43'
      issue = extract_first(text)

      assert_equal 'Fixes', issue.qualifier
      assert_equal 'codetree/codetree', issue.repository
      assert_equal '43', issue.number
    end

    should 'handle odd repository names' do
      text = 'giant-sequoia-123/scaling_octokitten#43'
      issue = extract_first(text)

      assert_equal 'giant-sequoia-123/scaling_octokitten', issue.repository
      assert_equal '43', issue.number
    end

    should 'extract multiple references' do
      text = 'You should look at #2 and #4 because #5 fixes codetree/codetree#6'
      refs = extract(text)

      assert refs.include?(2)
      assert refs.include?(4)
      assert refs.include?(5)
      assert refs.include?(6)
    end

    should 'not extract similar non-qualifiers' do
      text = 'afixes #43'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal nil, issue.repository
      assert_equal '43', issue.number
    end

    should 'not choke on case' do
      text = 'FIxEs #43'
      issue = extract_first(text)

      assert_equal 'FIxEs', issue.qualifier
      assert_equal nil, issue.repository
      assert_equal '43', issue.number
    end

    should 'require one space between qualifier and issue' do
      text = 'fixes   #43'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal nil, issue.repository
      assert_equal '43', issue.number
    end

    should 'handle variable casing in repo names' do
      text = 'needs Liquid-Labs/rf-app-admin-web-app#2'
      issue = extract_first(text)

      assert_equal 'needs', issue.qualifier
      assert_equal 'Liquid-Labs/rf-app-admin-web-app', issue.repository
      assert_equal '2', issue.number
    end
  end

  context '.extract with GH-XXX syntax' do
    should 'extract single issue references' do
      text = 'See GH-43'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal nil, issue.repository
      assert_equal '43', issue.number
    end

    should 'extract lower case issue references' do
      text = 'See gh-43'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal nil, issue.repository
      assert_equal '43', issue.number
    end

    should 'extract single issue references followed by a period' do
      text = 'See GH-43.'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal nil, issue.repository
      assert_equal '43', issue.number
    end

    should 'extract close qualifiers' do
      %w(fix fixes fixed close closes closed resolve resolves resolved).each do |q|
        text = "#{q} GH-55"
        issue = extract_first(text)

        assert_equal q, issue.qualifier
        assert_equal nil, issue.repository
        assert_equal '55', issue.number
      end
    end

    should 'extract dependency qualifiers' do
      %w(need needs needed require requires required).each do |q|
        text = "#{q} GH-123"
        issue = extract_first(text)

        assert_equal q, issue.qualifier
        assert_equal nil, issue.repository
        assert_equal '123', issue.number
      end
    end

    should 'extract multiple references' do
      text = 'You should look at GH-2 and GH-4 because GH-5 fixes codetree/codetree#6'
      refs = extract(text)

      assert refs.include?(2)
      assert refs.include?(4)
      assert refs.include?(5)
      assert refs.include?(6)
    end

    should 'not extract similar non-qualifiers' do
      text = 'afixes GH-43'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal nil, issue.repository
      assert_equal '43', issue.number
    end

    should 'not choke on case' do
      text = 'FIxEs GH-43'
      issue = extract_first(text)

      assert_equal 'FIxEs', issue.qualifier
      assert_equal nil, issue.repository
      assert_equal '43', issue.number
    end

    should 'require only one space between qualifier and issue' do
      text = 'fixes   GH-43'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal nil, issue.repository
      assert_equal '43', issue.number
    end

    should 'require at least one space before GH' do
      text = 'fixes codetree/codetreeGH-99 and fixes GH-43'
      issue = extract_first(text)

      assert_equal 'fixes', issue.qualifier
      assert_equal nil, issue.repository
      assert_equal '43', issue.number
    end
  end

  context '#issue_references with URL syntax' do
    should 'extract single issue references' do
      text = 'See https://github.com/codetree/feedback/issues/43'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal 'codetree/feedback', issue.repository
      assert_equal '43', issue.number
    end

    should 'extract single pull requests references' do
      text = 'See https://github.com/codetree/feedback/pulls/43'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal 'codetree/feedback', issue.repository
      assert_equal '43', issue.number
    end

    should 'extract single issue references followed by a period' do
      text = 'See https://github.com/codetree/feedback/issues/43.'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal 'codetree/feedback', issue.repository
      assert_equal '43', issue.number
    end

    should 'extract close qualifiers' do
      %w(fix fixes fixed close closes closed resolve resolves resolved).each do |q|
        text = "#{q} https://github.com/codetree/feedback/issues/55"
        issue = extract_first(text)

        assert_equal q, issue.qualifier
        assert_equal 'codetree/feedback', issue.repository
        assert_equal '55', issue.number
      end
    end

    should 'extract dependency qualifiers' do
      %w(need needs needed require requires required).each do |q|
        text = "#{q} https://github.com/codetree/feedback/issues/123"
        issue = extract_first(text)

        assert_equal q, issue.qualifier
        assert_equal 'codetree/feedback', issue.repository
        assert_equal '123', issue.number
      end
    end

    should 'extract multiple references' do
      text = 'You should look at https://github.com/codetree/feedback/issues/2 ' \
        'and https://github.com/codetree/feedback/issues/4 because ' \
        'https://github.com/codetree/feedback/issues/5 fixes codetree/codetree#6'

      refs = extract(text)

      assert refs.include?(2)
      assert refs.include?(4)
      assert refs.include?(5)
      assert refs.include?(6)
    end

    should 'not extract similar non-qualifiers' do
      text = 'afixes https://github.com/codetree/feedback/issues/43'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal 'codetree/feedback', issue.repository
      assert_equal '43', issue.number
    end

    should 'not choke on case' do
      text = 'FIxEs https://github.com/codetree/feedback/issues/43'
      issue = extract_first(text)

      assert_equal 'FIxEs', issue.qualifier
      assert_equal 'codetree/feedback', issue.repository
      assert_equal '43', issue.number
    end

    should 'require only one space between qualifier and issue' do
      text = 'fixes   https://github.com/codetree/feedback/issues/43'
      issue = extract_first(text)

      assert_equal nil, issue.qualifier
      assert_equal 'codetree/feedback', issue.repository
      assert_equal '43', issue.number
    end
  end

  context '.replace' do
    should 'yield the phrase and parsed reference' do
      text = 'Fixes codetree/codetree#123   needs codetree/feedback#456'

      expected = [
        'Fixes codetree/codetree#123',
        ' needs codetree/feedback#456'
      ]

      Ping::IssueReference.replace(text) do |phrase, reference|
        expected_phrase = expected.shift
        expected_reference = Ping::IssueReference.extract(expected_phrase).first

        assert_equal expected_phrase, phrase
        assert_equal expected_reference, reference
      end
    end

    context 'given a IssueReference replacement' do
      should 'handle qualifier + repo + number' do
        text = 'Fixes a/b#123  fixes #456'

        result = Ping::IssueReference.replace(text) do |_phrase, reference|
          reference.tap do |r|
            r.repository = 'codetree/feedback' unless r.repository
          end
        end

        assert_equal 'Fixes a/b#123  fixes codetree/feedback#456', result
      end

      should 'handle qualifier + number' do
        text = 'Fixes #123  fixes #456'

        result = Ping::IssueReference.replace(text) do |_phrase, reference|
          reference.tap do |r|
            r.qualifier = 'needs'
            r.repository = 'a/b'
          end
        end

        assert_equal 'needs a/b#123  needs a/b#456', result
      end

      should 'handle repo + number' do
        text = 'a/b#123  b/c#456'

        result = Ping::IssueReference.replace(text) do |_phrase, reference|
          reference.tap do |r|
            r.qualifier = 'needs'
            r.repository = 'd/e'
          end
        end

        assert_equal 'needs d/e#123  needs d/e#456', result
      end

      should 'handle number only' do
        text = '#123 #456'

        result = Ping::IssueReference.replace(text) do |_phrase, reference|
          reference.tap do |r|
            r.repository = 'd/e'
          end
        end

        assert_equal 'd/e#123 d/e#456', result
      end
    end

    context 'given a string replacement' do
      should 'replace references' do
        text = 'Fixes a/b#123  fixes #456'

        result = Ping::IssueReference.replace(text) do |phrase, _reference|
          phrase + ' bar'
        end

        assert_equal 'Fixes a/b#123 bar  fixes #456 bar', result
      end
    end
  end

  context '#==' do
    should 'compare with integers' do
      issue = Ping::IssueReference.new('fixes', 'codetree/codetree', '123')
      assert issue == 123
    end

    should 'compare with strings' do
      issue = Ping::IssueReference.new('fixes', 'codetree/codetree', '123')
      assert issue == '123'
    end

    should 'compare with issues' do
      issue = Ping::IssueReference.new('fixes', 'codetree/codetree', '123')
      assert issue == Ping::IssueReference.new(nil, 'codetree/codetree', '123')
    end
  end

  context '#to_s' do
    should 'return the issue number' do
      issue = Ping::IssueReference.new('Fixes', 'codetree/codetree', '123')
      assert_equal '123', issue.to_s
    end
  end

  context '#to_i' do
    should 'return the integer issue number' do
      issue = Ping::IssueReference.new('Fixes', 'codetree/codetree', '123')
      assert_equal 123, issue.to_i
    end
  end
end
