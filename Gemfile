source 'https://rubygems.org'

# Specify your gem's dependencies in gemini.gemspec
gemspec

# Additional dependencies
gem 'bigdecimal', '~> 3.2'

# Development and test dependencies
group :development, :test do
  # Test coverage
  gem 'simplecov', '~> 0.21.0', require: false
  gem 'simplecov-lcov', '~> 0.8.0', require: false
  
  # Security and development tools
  gem 'bundler-audit', '~> 0.9', require: false
  gem 'rubocop', '~> 1.72.1', require: false
end

gem "minitest-reporters", "~> 1.7"

gem "mocha", "~> 2.7", :groups => [:development, :test]
gem "webmock", "~> 3.19", :groups => [:test]
