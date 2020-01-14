# Ping [![Circle CI](https://circleci.com/gh/codetree/ping.svg?style=svg)](https://circleci.com/gh/codetree/ping)

A little library for extracting GitHub @mentions and issue references.

## Installation

Add this line to your application's Gemfile:

    gem 'ping'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ping

## Basic Usage

Simply load a new parser object and extract issue references and mentions. Here are examples.

#### issue references

``` ruby
parser = Ping::Parser.new('closed codetree/ping#25')
parser.issue_references # => [#<Ping::IssueReference:0x000056099c3cf400 @number="25", @qualifier="closed", @repository='codetree/ping'>]
```

#### mentions

``` ruby
parser = Ping::Mention.new('Hey @djreimer, please look into the bug.')
parser.mentions # => [#<Ping::Mention:0x000055ad151f43d0 @username="djreimer">]
```

## Configuration

gem provided some default qualifiers to extract issue references

``` ruby
DEFAULT_QUALIFIERS = [
  'close', 'closes', 'closed', 'fix', 'fixes', 'fixed', 'need', 'needs', 'needed',
  'require', 'requires', 'required', 'resolve', 'resolves', 'resolved'
]
```

but you can also define your own qualifiers along with default qualifiers

``` ruby
## config/initializers/ping.rb

require 'ping'

Ping.configure do |config|
  config.qualifiers = Ping::DEFAULT_QUALIFIERS.push(*['epic' 'needed-by'])
end
```
** Note: qualifiers must be an array of qualifier words

## Contributing

1. Fork it ( https://github.com/codetree/ping/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Updating RubyGems
1. Create an annotated tag `git tag -a v0.1.0 -m "msg with the tag`
2. Push tag to Github `github push --tags`
