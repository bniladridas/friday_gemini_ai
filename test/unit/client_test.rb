# frozen_string_literal: true

require_relative '../test_helper'
require 'minitest/autorun'
require 'webmock/minitest'
require 'mocha/minitest'

# Include the necessary assertion methods
module Minitest
  module Assertions
    def array_including(*expected)
      ->(actual) { (expected - actual).empty? }
    end

    def hash_including(expected)
      ->(actual) { compare_hashes(expected, actual, '') }
    end

    private

    def compare_hashes(expected, actual, _path = '')
      expected.all? { |k, v| compare_hash_values(k, v, actual) }
    end

    def compare_hash_values(key, expected_value, actual_hash, path = '')
      actual_value = actual_hash[key]
      current_path = path.empty? ? key.to_s : "#{path}.#{key}"

      if expected_value.is_a?(Hash) && actual_value.is_a?(Hash)
        compare_hashes(expected_value, actual_value, current_path)
      elsif expected_value.is_a?(Array) && actual_value.is_a?(Array)
        compare_arrays(expected_value, actual_value, current_path)
      else
        actual_value == expected_value
      end
    end

    def compare_arrays(expected_array, actual_array, path = '')
      expected_array.each_with_index.all? do |item, i|
        current_path = "#{path}[#{i}]"
        if item.is_a?(Hash) && actual_array[i].is_a?(Hash)
          compare_hashes(item, actual_array[i], current_path)
        else
          actual_array[i] == item
        end
      end
    end
  end
end

class TestClient < Minitest::Test
  def default_safety_settings
    [
      {
        category: 'HARM_CATEGORY_HARASSMENT',
        threshold: 'BLOCK_MEDIUM_AND_ABOVE'
      },
      {
        category: 'HARM_CATEGORY_HATE_SPEECH',
        threshold: 'BLOCK_MEDIUM_AND_ABOVE'
      },
      {
        category: 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
        threshold: 'BLOCK_MEDIUM_AND_ABOVE'
      },
      {
        category: 'HARM_CATEGORY_DANGEROUS_CONTENT',
        threshold: 'BLOCK_MEDIUM_AND_ABOVE'
      }
    ]
  end

  def setup
    # Use a valid API key format that will pass the regex validation
    @api_key = "AIzaSyD#{'a' * 35}" # 39 characters total, starting with AIzaSyD

    # Stub the API key validation to always pass
    GeminiAI::Client.any_instance.stubs(:validate_api_key!).returns(true)

    # Stub sleep to speed up tests
    GeminiAI::Client.any_instance.stubs(:sleep)

    # Create client after stubs are set up
    @client = GeminiAI::Client.new(@api_key)

    # Mock successful response
    @success_response = {
      candidates: [{
        content: {
          parts: [{
            text: 'Test response from Gemini AI'
          }]
        }
      }]
    }

    # Mock error response
    @error_response = {
      error: {
        message: 'Test error',
        code: 400,
        status: 'INVALID_ARGUMENT'
      }
    }
  end

  def test_initialization_with_api_key
    assert_equal @api_key, @client.instance_variable_get(:@api_key)
    assert_equal 'gemini-2.5-pro', @client.instance_variable_get(:@model)
  end

  def test_api_key_masking_in_logs
    # Create a StringIO to capture logs
    log_output = StringIO.new
    logger = Logger.new(log_output)
    logger.formatter = proc do |severity, datetime, _progname, msg|
      "#{datetime}: #{severity} -- #{msg}\n"
    end

    # Stub the logger to capture logs
    GeminiAI::Client.stubs(:logger).returns(logger)

    # Create a client with a test API key
    test_api_key = 'AIzaSyDtestkey1234567890123456789012345678'
    client = GeminiAI::Client.new(test_api_key)

    # Stub the HTTP request to avoid making real API calls
    stub_request(:post, /generativelanguage\.googleapis\.com/)
      .to_return(
        status: 200,
        body: { candidates: [{ content: { parts: [{ text: 'Test response' }] } }] }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    # Make a request that will be logged
    client.generate_text('Test prompt')

    # Check the logs
    log_output.rewind
    logs = log_output.read

    # The API key should be masked in the logs
    assert_includes logs, 'AIza**********************************5678', 'API key should be masked in logs'
    refute_includes logs, test_api_key, 'Raw API key should not appear in logs'
  end

  def test_initialization_with_env_var
    ENV['GEMINI_API_KEY'] = 'env_api_key_12345678901234567890123456789012'
    client = GeminiAI::Client.new

    assert_equal ENV.fetch('GEMINI_API_KEY', nil), client.instance_variable_get(:@api_key)
    ENV.delete('GEMINI_API_KEY')
  end

  def setup_rate_limiting_test
    # Stub for both v1 and v1beta API versions since the client might use either
    @stub_v1 = stub_request(:post, "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-pro:generateContent?key=#{@api_key}")
               .to_return(
                 status: 200,
                 body: { candidates: [{ content: { parts: [{ text: 'Test response' }] } }] }.to_json,
                 headers: { 'Content-Type' => 'application/json' }
               )

    @stub_v1beta = stub_request(:post, "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent?key=#{@api_key}")
                   .to_return(
                     status: 200,
                     body: { candidates: [{ content: { parts: [{ text: 'Test response' }] } }] }.to_json,
                     headers: { 'Content-Type' => 'application/json' }
                   )
  end

  def test_rate_limiting_non_ci_environment
    setup_rate_limiting_test

    # Clear CI environment variables
    ENV['CI'] = nil
    ENV['GITHUB_ACTIONS'] = nil

    # Initialize the client and override the min_request_interval to 0 for testing
    client = GeminiAI::Client.new(@api_key)
    client.instance_variable_set(:@min_request_interval, 0)

    # Mock Kernel.sleep to track calls
    sleep_calls = []
    Kernel.stub(:sleep, ->(seconds) { sleep_calls << seconds }) do
      # Make the test requests
      start_time = Time.now
      3.times { client.generate_text('test') }
      elapsed = Time.now - start_time

      # In non-CI with min_request_interval=0, requests should execute immediately
      assert_operator elapsed, :<, 0.1, 'Requests should execute immediately with min_request_interval=0'
      assert_empty sleep_calls, 'Should not sleep between requests with min_request_interval=0'
    end

    # Verify the requests were made (checking v1 endpoint)
    assert_requested(
      :post,
      "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-pro:generateContent?key=#{@api_key}",
      times: 3
    )
  end

  def test_rate_limiting_ci_environment
    # Set up environment for CI
    ENV['CI'] = 'true'
    ENV['GITHUB_ACTIONS'] = 'true'

    # Stub the HTTP request for generate_text with the correct endpoint
    stub_request(:post, "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-pro:generateContent?key=#{@api_key}")
      .to_return(
        status: 200,
        body: { candidates: [{ content: { parts: [{ text: 'Test response' }] } }] }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    client = GeminiAI::Client.new(@api_key)

    # Mock sleep to track calls
    sleep_calls = []
    client.define_singleton_method(:sleep) do |seconds|
      sleep_calls << seconds
    end

    # Make the test requests
    3.times { client.generate_text('test') }

    # Verify sleep was called between requests
    assert_equal 2, sleep_calls.size, 'Should sleep between each request in CI'
    sleep_calls.each { |delay| assert_in_delta 3.0, delay, 0.1, 'Should sleep 3.0s between requests in CI' }

    # Verify the requests were made
    assert_requested(
      :post,
      "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-pro:generateContent?key=#{@api_key}",
      times: 3
    )
  ensure
    # Clean up
    ENV['CI'] = nil
    ENV['GITHUB_ACTIONS'] = nil
  end

  def test_initialization_with_different_model
    client = GeminiAI::Client.new(@api_key, model: :flash)

    assert_equal 'gemini-2.5-flash', client.instance_variable_get(:@model)
  end

  def setup_invalid_api_key_tests
    @original_api_key = ENV.fetch('GEMINI_API_KEY', nil)
    GeminiAI::Client.any_instance.unstub(:validate_api_key!)
  end

  def teardown_invalid_api_key_tests
    if @original_api_key
      ENV['GEMINI_API_KEY'] = @original_api_key
    else
      ENV.delete('GEMINI_API_KEY')
    end
  end

  def test_initialization_with_nil_key
    setup_invalid_api_key_tests
    ENV.delete('GEMINI_API_KEY')

    error = assert_raises(GeminiAI::Error) { GeminiAI::Client.new(nil) }

    assert_match(/API key is required/, error.message)
  ensure
    teardown_invalid_api_key_tests
  end

  def test_initialization_with_empty_key
    setup_invalid_api_key_tests

    error = assert_raises(GeminiAI::Error) { GeminiAI::Client.new('') }

    assert_match(/API key is required/, error.message)
  ensure
    teardown_invalid_api_key_tests
  end

  def test_initialization_with_invalid_format_key
    setup_invalid_api_key_tests

    error = assert_raises(GeminiAI::Error) { GeminiAI::Client.new('invalid-key') }

    assert_match(/Invalid API key format/, error.message)
  ensure
    teardown_invalid_api_key_tests
  end

  def test_initialization_with_short_but_valid_prefix_key
    setup_invalid_api_key_tests

    error = assert_raises(GeminiAI::Error) { GeminiAI::Client.new('AIza123') }

    assert_match(/Invalid API key format/, error.message)
  ensure
    teardown_invalid_api_key_tests
  end

  def test_initialization_with_nil_key_in_env
    setup_invalid_api_key_tests
    ENV.delete('GEMINI_API_KEY')

    error = assert_raises(GeminiAI::Error) { GeminiAI::Client.new }

    assert_match(/API key is required/, error.message)
  ensure
    teardown_invalid_api_key_tests
  end

  def test_initialization_with_empty_key_in_env
    setup_invalid_api_key_tests
    ENV['GEMINI_API_KEY'] = ''

    error = assert_raises(GeminiAI::Error) { GeminiAI::Client.new }

    assert_match(/API key is required/, error.message)
  ensure
    teardown_invalid_api_key_tests
  end

  def test_initialization_with_invalid_format_key_in_env
    setup_invalid_api_key_tests
    ENV['GEMINI_API_KEY'] = 'invalid-key'

    error = assert_raises(GeminiAI::Error) { GeminiAI::Client.new }

    assert_match(/Invalid API key format/, error.message)
  ensure
    teardown_invalid_api_key_tests
  end

  def test_initialization_with_short_key_in_env
    setup_invalid_api_key_tests
    ENV['GEMINI_API_KEY'] = 'AIza123'

    error = assert_raises(GeminiAI::Error) { GeminiAI::Client.new }

    assert_match(/Invalid API key format/, error.message)
  ensure
    teardown_invalid_api_key_tests
  end

  def test_generate_content_success
    stub_request(:post, /generativelanguage\.googleapis\.com/)
      .to_return(
        status: 200,
        body: @success_response.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    response = @client.generate_text('Hello, Gemini!')

    assert_equal 'Test response from Gemini AI', response
  end

  def test_generate_image_text_with_empty_image
    assert_raises(GeminiAI::Error) do
      @client.generate_image_text('', 'Describe this image')
    end
  end

  def test_generate_image_text
    image_data = test_helper_image_data

    # Set up the stub with the expected request body
    stub = stub_image_text_request(image_data)

    # Make the actual request with the prompt that matches the stub
    response = @client.generate_image_text(image_data, 'Test prompt')

    # Assert the response
    assert_requested stub
    assert_equal 'A test image description', response
  end

  def test_helper_image_data
    # Base64 encoded 1x1 transparent PNG
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=='
  end

  def expected_image_text_request_body(image_data)
    {
      contents: [
        {
          parts: [
            { text: 'Describe this image' },
            {
              inline_data: {
                mime_type: 'image/png',
                data: image_data
              }
            }
          ]
        }
      ],
      generationConfig: {
        temperature: 0.4,
        topK: 32,
        topP: 1.0,
        maxOutputTokens: 2048,
        stopSequences: []
      }
    }
  end

  def stub_image_text_request(image_data)
    # Use the same API key that's used in the test client
    api_key = @client.instance_variable_get('@api_key')

    stub_request(:post, "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key=#{api_key}")
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Ruby',
          'X-Goog-Api-Client' => %r{gemini_ai_ruby_gem/\d+\.\d+\.\d+}
        },
        body: {
          contents: [{
            parts: [
              { inline_data: { mime_type: 'image/jpeg', data: image_data } },
              { text: 'Test prompt' }
            ]
          }],
          generationConfig: {
            temperature: 0.7,
            maxOutputTokens: 1024,
            topP: 0.9,
            topK: 40
          }
        }
      )
      .to_return(
        status: 200,
        body: {
          candidates: [
            {
              content: {
                parts: [
                  { text: 'A test image description' }
                ]
              }
            }
          ]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  def test_expected_image_text_request_body
    image_data = 'base64_encoded_image_data'

    result = expected_image_text_request_body(image_data)

    assert_equal 'Describe this image', result[:contents].first[:parts].first[:text]
    assert_equal 'image/png', result[:contents].first[:parts].last[:inline_data][:mime_type]
    assert_equal image_data, result[:contents].first[:parts].last[:inline_data][:data]
    assert_in_delta 0.4, result[:generationConfig][:temperature], 0.001
    assert_equal 2048, result[:generationConfig][:maxOutputTokens]
    assert_in_delta 1.0, result[:generationConfig][:topP], 0.001
    assert_equal 32, result[:generationConfig][:topK]
  end

  def test_image_text_response
    {
      status: 200,
      body: { 'candidates' => [{ 'content' => { 'parts' => [{ 'text' => 'A test image description' }] } }] }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    }
  end

  def test_setup_generate_content_with_options
    @request_body = nil
    @stub = stub_request(:post, %r{generativelanguage\.googleapis\.com/v1/models/gemini-2\.5-pro:generateContent\?key=.*})
            .with do |request|
      @request_body = JSON.parse(request.body)
      true
    end
            .to_return(
              status: 200,
              body: @success_response.to_json,
              headers: { 'Content-Type' => 'application/json' }
            )
  end

  def test_generate_content_with_temperature
    test_setup_generate_content_with_options

    response = @client.generate_text('Hello, Gemini!', temperature: 0.7)

    assert_requested(@stub, times: 1)
    assert_in_delta(0.7, @request_body.dig('generationConfig', 'temperature'))
    assert_equal 'Test response from Gemini AI', response
  end

  def test_generate_content_with_top_p
    test_setup_generate_content_with_options

    response = @client.generate_text('Hello, Gemini!', top_p: 0.9)

    assert_requested(@stub, times: 1)
    assert_in_delta(0.9, @request_body.dig('generationConfig', 'topP'))
    assert_equal 'Test response from Gemini AI', response
  end

  def test_generate_content_with_top_k
    test_setup_generate_content_with_options

    response = @client.generate_text('Hello, Gemini!', top_k: 40)

    assert_requested(@stub, times: 1)
    assert_equal 40, @request_body.dig('generationConfig', 'topK')
    assert_equal 'Test response from Gemini AI', response
  end

  def test_generate_content_with_max_tokens
    test_setup_generate_content_with_options

    response = @client.generate_text('Hello, Gemini!', max_tokens: 2048)

    assert_requested(@stub, times: 1)
    assert_equal 2048, @request_body.dig('generationConfig', 'maxOutputTokens')
    assert_equal 'Test response from Gemini AI', response
  end

  def test_generate_content_with_multiple_options
    test_setup_generate_content_with_options

    response = @client.generate_text(
      'Hello, Gemini!',
      temperature: 0.7,
      top_p: 0.9,
      top_k: 40,
      max_tokens: 2048
    )

    assert_requested(@stub, times: 1)
    config = @request_body['generationConfig']

    assert_in_delta(0.7, config['temperature'])
    assert_in_delta(0.9, config['topP'])
    assert_equal 40, config['topK']
    assert_equal 2048, config['maxOutputTokens']
    assert_equal 'Test response from Gemini AI', response
  end

  def test_generate_content_with_system_instruction
    response = make_test_chat_request

    assert_equal 'Test response from Gemini AI', response
  end

  def test_stub_system_instruction_request
    stub_request(:post, %r{generativelanguage\.googleapis\.com/v1/models/gemini-2\.5-pro:generateContent\?key=.*})
      .with(
        body: hash_including({
                               contents: [{
                                 role: 'user',
                                 parts: [{
                                   text: 'Hello, Gemini!'
                                 }]
                               }],
                               systemInstruction: {
                                 parts: [{
                                   text: 'You are a helpful assistant.'
                                 }]
                               },
                               generationConfig: {
                                 temperature: 0.7,
                                 maxOutputTokens: 1024,
                                 topP: 0.9,
                                 topK: 40
                               }
                             })
      )
      .to_return(
        status: 200,
        body: {
          candidates: [{
            content: {
              parts: [{
                text: 'Test response from Gemini AI'
              }]
            }
          }]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  def make_test_chat_request
    # Stub the request with the expected parameters
    stub_request(:post, "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-pro:generateContent?key=#{@api_key}")
      .with(
        body: {
          contents: [
            { role: 'user', parts: [{ text: 'Hello, Gemini!' }] }
          ],
          generationConfig: {
            temperature: 0.7,
            maxOutputTokens: 1024,
            topP: 0.9,
            topK: 40
          },
          systemInstruction: {
            parts: [{ text: 'You are a helpful assistant.' }]
          }
        }.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => '*/*',
          'User-Agent' => 'Ruby',
          'X-Goog-Api-Client' => %r{gemini_ai_ruby_gem/\d+\.\d+\.\d+}
        }
      )
      .to_return(
        status: 200,
        body: {
          candidates: [{
            content: {
              parts: [{
                text: 'Test response from Gemini AI'
              }]
            }
          }]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    # Make the chat request and return the response
    @client.chat(
      [
        { role: 'user', content: 'Hello, Gemini!' }
      ],
      system_instruction: 'You are a helpful assistant.'
    )
  end

  def test_make_chat_request
    response = make_test_chat_request

    assert_equal 'Test response from Gemini AI', response
  end

  def test_generate_content_with_safety_settings
    safety_settings = default_safety_settings

    stub_request(:post, %r{generativelanguage\.googleapis\.com/v1/models/gemini-2\.5-pro:generateContent\?key=.*})
      .with(
        body: {
          'contents' => [
            { 'parts' => [{ 'text' => 'Test prompt' }] }
          ],
          'generationConfig' => {
            'temperature' => 0.7,
            'maxOutputTokens' => 1024,
            'topP' => 0.9,
            'topK' => 40
          },
          'safetySettings' => safety_settings.map { |s| { 'category' => s[:category], 'threshold' => s[:threshold] } }
        },
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby',
          'X-Goog-Api-Client' => %r{gemini_ai_ruby_gem/\d+\.\d+\.\d+}
        }
      )
      .to_return(
        status: 200,
        body: {
          'candidates' => [{
            'content' => {
              'parts' => [{
                'text' => 'Test response from Gemini AI'
              }]
            }
          }]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    response = @client.generate_text(
      'Test prompt',
      safety_settings:
    )

    assert_requested :post, %r{generativelanguage\.googleapis\.com/v1/models/gemini-2\.5-pro:generateContent\?key=.*}
    assert_equal 'Test response from Gemini AI', response
  end

  def test_default_safety_settings
    [{
      category: 'HARM_CATEGORY_DANGEROUS_CONTENT',
      threshold: 'BLOCK_NONE'
    }, {
      category: 'HARM_CATEGORY_HARASSMENT',
      threshold: 'BLOCK_NONE'
    }, {
      category: 'HARM_CATEGORY_HATE_SPEECH',
      threshold: 'BLOCK_NONE'
    }, {
      category: 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
      threshold: 'BLOCK_NONE'
    }]
  end

  def test_stub_safety_settings_request
    safety_settings = default_safety_settings
    stub_request(:post, "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-pro:generateContent?key=#{@api_key}")
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Ruby',
          'X-Goog-Api-Client' => 'gemini_ai_ruby_gem/0.1.0'
        },
        body: {
          contents: [
            { parts: [{ text: 'Test prompt' }] }
          ],
          generationConfig: {
            temperature: 0.7,
            maxOutputTokens: 1024,
            topP: 0.9,
            topK: 40
          },
          safetySettings: safety_settings.map { |s| { category: s[:category], threshold: s[:threshold] } }
        }.to_json
      )
      .to_return(
        status: 200,
        body: @success_response.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  def valid_safety_settings_request?(request, safety_settings)
    body = JSON.parse(request.body)

    valid_contents?(body) &&
      valid_safety_settings?(body, safety_settings) &&
      valid_generation_config?(body)
  end

  def valid_contents?(body)
    body['contents'].is_a?(Array) &&
      body['contents'].first['parts'].is_a?(Array) &&
      body['contents'].first['parts'].first['text'] == 'Hello, Gemini!'
  end

  def valid_safety_settings?(body, safety_settings)
    body['safetySettings'].is_a?(Array) &&
      body['safetySettings'].first['category'] == safety_settings.first[:category] &&
      body['safetySettings'].first['threshold'] == safety_settings.first[:threshold]
  end

  def valid_generation_config?(body)
    body['generationConfig'].is_a?(Hash) &&
      body['generationConfig'].key?('temperature') &&
      (body['generationConfig']['temperature'] - 0.7).abs < Float::EPSILON
  end

  def assert_safety_settings_request_made
    assert_requested(
      :post,
      %r{generativelanguage\.googleapis\.com/v1/models/gemini-2\.5-pro:generateContent\?key=.*},
      times: 1
    )
  end

  def test_generate_text_with_safety_settings
    safety_settings = default_safety_settings
    stub_text_safety_settings_request(safety_settings)

    response = @client.generate_text('Hello, Gemini!', safety_settings:)

    assert_text_safety_settings_request_made
    assert_equal 'Test response from Gemini AI', response
  end

  def stub_text_safety_settings_request(safety_settings)
    expected_body = {
      contents: [
        { parts: [{ text: 'Hello, Gemini!' }] }
      ],
      generationConfig: {
        temperature: 0.7,
        maxOutputTokens: 1024,
        topP: 0.9,
        topK: 40
      },
      safetySettings: safety_settings.map { |s| { category: s[:category], threshold: s[:threshold] } }
    }

    stub_request(:post, "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-pro:generateContent?key=#{@api_key}")
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Ruby',
          'X-Goog-Api-Client' => 'gemini_ai_ruby_gem/0.1.0'
        },
        body: expected_body.to_json
      )
      .to_return(
        status: 200,
        body: @success_response.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  def valid_text_safety_request?(request_body, safety_settings)
    # This method is no longer needed as we're using exact matching
  end

  def valid_text_contents?(body)
    # This method is no longer needed as we're using exact matching
  end

  def assert_text_safety_settings_request_made
    assert_requested(
      :post,
      "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-pro:generateContent?key=#{@api_key}",
      times: 1
    )
  end

  def test_mask_api_key
    # Test with a typical API key
    assert_equal 'AIza**************************************abcd',
                 @client.send(:mask_api_key, 'AIza12345678901234567890123456789012345678abcd')

    # Test with a short key (less than 8 characters)
    assert_equal 'short', @client.send(:mask_api_key, 'short')

    # Test with exactly 8 characters
    assert_equal '12345678', @client.send(:mask_api_key, '12345678')

    # Test with nil
    assert_equal '[REDACTED]', @client.send(:mask_api_key, nil)
  end

  def test_generate_content_api_error
    stub_request(:post, /generativelanguage\.googleapis\.com/)
      .to_return(
        status: 400,
        body: @error_response.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    error = assert_raises(GeminiAI::Error) do
      @client.generate_text('Test prompt')
    end

    assert_match(/API Error: Test error/, error.message)
  end

  def test_generate_content_network_error
    stub_request(:post, /generativelanguage\.googleapis\.com/)
      .to_raise(HTTParty::Error.new('Network error'))

    error = assert_raises(GeminiAI::Error) do
      @client.generate_text('Test prompt')
    end

    assert_match(/API request failed: Network error/, error.message)
  end

  def test_rate_limiting
    # Create a new client with a shorter interval for testing
    client = GeminiAI::Client.new(@api_key)
    client.instance_variable_set(:@min_request_interval, 0.1)

    # Track sleep calls
    sleep_times = []

    # Stub the sleep method to track calls
    client.define_singleton_method(:sleep) do |time|
      sleep_times << time
      # Don't actually sleep during tests
    end

    # Stub the API request
    stub_request(:post, /generativelanguage\.googleapis\.com/)
      .to_return(
        status: 200,
        body: @success_response.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    # First request - should not trigger sleep
    client.generate_text('First request')

    assert_empty sleep_times, 'First request should not trigger sleep'

    # Set last_request_time to now to force rate limiting on next request
    client.instance_variable_set(:@last_request_time, Time.now)

    # Second request - should trigger rate limiting sleep
    client.generate_text('Second request')

    # Verify sleep was called with a value close to 0.1 seconds
    assert_equal 1, sleep_times.size, 'Expected sleep to be called exactly once'
    assert_in_delta 0.1, sleep_times.first, 0.01, 'Expected sleep to be called with approximately 0.1 seconds'
  end

  def test_models_constant
    assert_kind_of Hash, GeminiAI::Client::MODELS
    assert GeminiAI::Client::MODELS.key?(:pro)
    assert GeminiAI::Client::MODELS.key?(:flash)
  end

  def test_logger
    assert_respond_to GeminiAI::Client, :logger
    assert_kind_of Logger, GeminiAI::Client.logger
  end

  def test_redacts_api_key_in_logs
    # Create a new client with a known API key
    api_key = 'AIza12345678901234567890123456789012345678'
    client = GeminiAI::Client.new(api_key)

    # Capture log output
    log_output = StringIO.new
    logger = Logger.new(log_output)
    logger.formatter = proc do |severity, _datetime, _progname, msg|
      "#{severity} -- #{msg}\n"
    end

    # Stub the logger
    GeminiAI::Client.stubs(:logger).returns(logger)

    # Setup the API response
    stub_request(:post, /generativelanguage\.googleapis\.com/)
      .to_return(
        status: 200,
        body: @success_response.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    # Make the API call
    client.generate_text('Test logging')

    # Get the log output
    log_output.rewind
    logs = log_output.read

    # Verify the API key is not in the logs
    refute_includes logs, api_key, 'API key was not redacted in logs'

    # Verify the redacted version is in the logs
    assert_match(/AIza\*{32}/, logs, 'Redacted API key pattern not found in logs')
  end
end
