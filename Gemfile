source 'https://rubygems.org'

# Specify your gem's dependencies in gemini.gemspec
gemspec

# Additional dependencies
gem 'bigdecimal', '~> 3.2'

# Development and test dependencies
group :development, :test do
  # Security and development tools
  gem 'bundler-audit', '~> 0.9', require: false
   # gem 'rubocop', '~> 1.72.1', require: false
end

gem "mocha", "~> 2.7", :groups => [:development, :test]
gem "minitest-reporters", "~> 1.6", :groups => [:development, :test]
gem "webmock", "~> 3.19", :groups => [:test]
