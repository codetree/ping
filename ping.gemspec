# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
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
  spec.required_ruby_version  = '>= 2.4'
  spec.require_paths          = ['lib']

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_development_dependency 'bundler', '~> 2.1', '>= 2.1.4'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'mocha', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 0.80.1'
  spec.add_development_dependency 'shoulda-context', '~> 1.2'
end
