source 'https://rubygems.org'

# Specify your gem's dependencies in gemini.gemspec
gemspec

# Additional dependencies
gem 'bigdecimal', '~> 4.0'

# Development and test dependencies
group :development, :test do
  # Security and development tools
  gem 'bundler-audit', '~> 0.9', require: false
  gem 'base64', require: false
   # gem 'rubocop', '~> 1.72.1', require: false
end

gem "mocha", "~> 2.7", groups: [:development, :test]
gem 'httparty', '>= 0.21', '< 0.24', groups: [:development, :test]
# gem "minitest-reporters", "1.5.0", :groups => [:development, :test]
# gem "webmock", "~> 3.19", :groups => [:test]
