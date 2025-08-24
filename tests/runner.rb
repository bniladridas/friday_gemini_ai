#!/usr/bin/env ruby

# Test runner for the GeminiAI gem
require 'minitest/autorun'

# Load all test files
Dir[File.join(__dir__, '**', '*.rb')].reject { |f| f.include?('runner.rb') }.each { |file| require file }

puts "Running GeminiAI gem tests..."
puts "Ruby version: #{RUBY_VERSION}"
puts "Test files loaded: #{Dir[File.join(__dir__, '**', '*.rb')].reject { |f| f.include?('runner.rb') }.size}"