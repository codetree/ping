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

## Development
After checking out the repo, run `bundle install` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version:
1. Update the version number <ver> in `lib/html/pipeline/issue_references/version.rb`
2. Run `gem git tag -a <ver> -m 'some msg'`
3. Run `gem push --tags`

## Testing
Before beginning testing, be sure to run `bundle install && npm install`
Ruby unit tests can be run with `bundle exec rake test`.

## Contributing

Read the [Contributing Guidelines](CONTRIBUTING.md) and open a Pull Request!
