# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

desc 'Run rubocop to help find Ruby style violations'
task :cop do
  system 'bundle exec rubocop'
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

desc 'Run rubocop and all unit tests'
task default: %i[cop test]
