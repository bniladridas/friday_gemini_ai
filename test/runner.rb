#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'test_helper'

class TestRunner
  TEST_DIRS = [
    'test/unit/**/*_test.rb',
    'test/integration/**/*_test.rb'
  ].freeze

  def self.run
    load_test_files
    run_tests
    report_coverage
  end

  def self.load_test_files
    TEST_DIRS.each do |pattern|
      Dir[File.join(__dir__, '..', pattern)].each do |file|
        require file
      end
    end
  end

  def self.run_tests
    puts "\nRunning GeminiAI gem tests..."
    puts "Ruby version: #{RUBY_VERSION}"
    puts "Test directory: #{File.expand_path(File.join(__dir__, '..'))}"
    puts "Test files: #{Minitest::Runnable.runnables.size} test suites loaded"
    puts "Coverage threshold: #{SimpleCov.minimum_coverage}%"
    puts '-' * 50
  end

  def self.report_coverage
    Minitest.after_run do
      result = SimpleCov.result
      covered_percent = result.covered_percent.round(2)

      puts "\nTest coverage: #{covered_percent}%"

      if covered_percent < SimpleCov.minimum_coverage
        puts "\nWARNING: Test coverage is below the minimum threshold of #{SimpleCov.minimum_coverage}%"
      end

      underperforming = result.files.select { |f| f.covered_percent < 90 }

      unless underperforming.empty?
        puts "\nFiles with coverage below 90%:"
        underperforming.sort_by(&:covered_percent).each do |file|
          puts "  #{file.filename.gsub("#{Dir.pwd}/", '')} (#{file.covered_percent.round(2)}%)"
        end
      end

      puts '-' * 50
    end
  end
end

# Run the tests
TestRunner.run
