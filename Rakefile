# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

desc 'Run tests'
task default: :test
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

# append to the default rake task
RuboCop::RakeTask.new

Rake::Task['test'].enhance ['rubocop']
