# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'
require 'webmock/minitest'

# Configure SimpleCov
SimpleCov::Formatter::LcovFormatter.config do |c|
  c.report_with_single_file = true
  c.single_report_path = 'coverage/lcov.info'
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::HTMLFormatter,
                                                                 SimpleCov::Formatter::LcovFormatter
                                                               ])

SimpleCov.start do
  # Filters
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/vendor/'
  add_filter '/spec/'
  add_filter 'gems/'

  # Groups
  add_group 'Lib', 'lib'
  add_group 'Tests', 'test'

  # Tracked files
  track_files 'lib/**/*.rb'
  track_files 'test/**/*.rb'

  # Coverage settings
  minimum_coverage 90
  maximum_coverage_drop 5

  # Ignore untestable code
  add_filter do |src_file|
    src_file.filename.include?('version.rb') ||
      src_file.filename.include?('_test.rb') ||
      src_file.filename.include?('test_helper')
  end
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'gemini'
require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/minitest'
require 'stringio'

# Configure Minitest
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Add helper methods to Minitest::Test
module Minitest
  class Test
    # Helper method to create a test API key
    def test_api_key
      "AIzaSyD#{'a' * 35}" # 39 characters total, starting with AIzaSyD
    end

    # Helper method to create a test image
    def test_image
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=='
    end

    # Helper method to create a test response
    def test_response(text = 'Test response from Gemini AI')
      {
        'candidates' => [{
          'content' => {
            'parts' => [{
              'text' => text
            }]
          }
        }]
      }
    end

    # Helper method to stub API requests
    def stub_gemini_request(model: 'gemini-2.5-pro', response: test_response, status: 200, with_body: nil)
      url = "https://generativelanguage.googleapis.com/v1/models/#{model}:generateContent?key=#{test_api_key}"

      stub = stub_request(:post, url)

      stub = stub.with(body: with_body) if with_body

      stub.to_return(
        status:,
        body: response.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    # Helper method to create a test client
    def create_test_client(model: :pro, **)
      GeminiAI::Client.new(test_api_key, model:, **)
    end
  end
end

# Configure WebMock
WebMock.disable_net_connect!(allow_localhost: true)

# Use spec-style reporting
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]
