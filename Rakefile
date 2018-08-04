# frozen_string_literal: true

require 'rake/testtask'

task :cop do
  system 'bundle exec rubocop'
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task default: %i[cop test]
