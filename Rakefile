require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb', '*_test.rb']
  t.warning = false
end

task default: :test

desc 'Run a simple test to verify the gem is working'
task :quick_test do
  ruby 'quick_test.rb'
end

desc 'Run a CI-friendly test that does not require API keys'
task :ci_test do
  ruby 'ci_test.rb'
end
