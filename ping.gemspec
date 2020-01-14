# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ping/version'

Gem::Specification.new do |spec|
  spec.name                   = 'ping'
  spec.version                = Ping::VERSION
  spec.authors                = ['Codetree', 'Derrick Reimer']
  spec.email                  = ['support@codetree.com', 'derrickreimer@gmail.com']
  spec.summary                = 'Parse @mentions and issue references'
  spec.description            = 'A little library for parsing GitHub @mentions and issue references'
  spec.homepage               = 'https://github.com/codetree/ping'
  spec.license                = 'MIT'
  spec.required_ruby_version  = '>= 2.2.2'
  spec.files                  = `git ls-files -z`.split("\x0")
  spec.executables            = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files             = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths          = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'shoulda-context', '~> 1.2'
  spec.add_development_dependency 'mocha', '~> 1.0'
  spec.add_development_dependency 'rubocop'
end
