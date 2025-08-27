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
      ->(actual) { expected.all? { |k, v| actual[k] == v } }
    end
  end
end

class TestClient < Minitest::Test
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
      'candidates' => [{
        'content' => {
          'parts' => [{
            'text' => 'Test response from Gemini AI'
          }]
        }
      }]
    }

    # Mock error response
    @error_response = {
      'error' => {
        'message' => 'Test error',
        'code' => 400,
        'status' => 'INVALID_ARGUMENT'
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
        body: { 'candidates' => [{ 'content' => { 'parts' => [{ 'text' => 'Test response' }] } }] }.to_json,
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

  def test_rate_limiting
    # Stub the HTTP request
    stub_request(:post, "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent?key=#{@api_key}")
      .to_return(status: 200, body: { 'candidates' => [{}] }.to_json, headers: { 'Content-Type' => 'application/json' })

    # Test rate limiting in non-CI environment
    ENV['CI'] = nil
    ENV['GITHUB_ACTIONS'] = nil
    client = GeminiAI::Client.new(@api_key)

    start_time = Time.now
    3.times { client.generate_text('test') } # Should execute immediately
    elapsed = Time.now - start_time

    assert_operator elapsed, :<, 0.1, 'First 3 requests should execute immediately'

    # Test rate limiting in CI environment
    ENV['CI'] = 'true'
    ENV['GITHUB_ACTIONS'] = 'true'
    client = GeminiAI::Client.new(@api_key)

    start_time = Time.now
    3.times { client.generate_text('test') } # Should take at least 1.5 seconds (3 requests * 0.5s delay)
    elapsed = Time.now - start_time

    assert_operator elapsed, :>=, 1.5, 'In CI, requests should be rate limited with 0.5s delay'

    # Cleanup
    ENV['CI'] = nil
    ENV['GITHUB_ACTIONS'] = nil
  end

  def test_initialization_with_different_model
    client = GeminiAI::Client.new(@api_key, model: :flash)

    assert_equal 'gemini-2.5-flash', client.instance_variable_get(:@model)
  end

  def test_initialization_with_invalid_api_key
    # Save the original API key
    original_api_key = ENV.fetch('GEMINI_API_KEY', nil)

    begin
      # Remove the stub for this specific test
      GeminiAI::Client.any_instance.unstub(:validate_api_key!)

      # Test with a nil key passed directly - should raise error
      ENV.delete('GEMINI_API_KEY')
      puts 'Testing with nil key...'
      puts "ENV['GEMINI_API_KEY']: #{ENV['GEMINI_API_KEY'].inspect}"
      error = assert_raises(GeminiAI::Error) do
        client = GeminiAI::Client.new(nil)
        puts "Client initialized with nil key: #{client.inspect}"
      end
      puts "Error raised: #{error.inspect}"

      assert_match(/API key is required/, error.message)

      # Test with an empty string key passed directly - should raise error
      error = assert_raises(GeminiAI::Error) do
        GeminiAI::Client.new('')
      end

      assert_match(/API key is required/, error.message)

      # Test with a key that doesn't start with AIza - should raise error
      error = assert_raises(GeminiAI::Error) do
        GeminiAI::Client.new('invalid-key')
      end

      assert_match(/Invalid API key format/, error.message)

      # Test with a key that's too short but starts with AIza - should raise error
      error = assert_raises(GeminiAI::Error) do
        GeminiAI::Client.new('AIza123') # Too short but starts with AIza
      end

      assert_match(/Invalid API key format/, error.message)

      # Test with nil key in environment variable - should raise error
      ENV.delete('GEMINI_API_KEY')
      error = assert_raises(GeminiAI::Error) do
        GeminiAI::Client.new
      end

      assert_match(/API key is required/, error.message)

      # Test with empty key in environment variable - should raise error
      ENV['GEMINI_API_KEY'] = ''
      error = assert_raises(GeminiAI::Error) do
        GeminiAI::Client.new
      end

      assert_match(/API key is required/, error.message)

      # Test with invalid format key in environment variable - should raise error
      ENV['GEMINI_API_KEY'] = 'invalid-key'
      error = assert_raises(GeminiAI::Error) do
        GeminiAI::Client.new
      end

      assert_match(/Invalid API key format/, error.message)

      # Test with valid format but short key in environment variable - should raise error
      ENV['GEMINI_API_KEY'] = 'AIza123'
      error = assert_raises(GeminiAI::Error) do
        GeminiAI::Client.new
      end

      assert_match(/Invalid API key format/, error.message)
    ensure
      # Restore the original API key
      if original_api_key
        ENV['GEMINI_API_KEY'] = original_api_key
      else
        ENV.delete('GEMINI_API_KEY')
      end
    end
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

  def test_generate_image_text
    # Base64 encoded 1x1 transparent PNG
    test_image = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=='

    stub_request(:post, /generativelanguage\.googleapis\.com/)
      .with(
        body: hash_including({
                               contents: [{
                                 parts: [
                                   { inline_data: { mime_type: 'image/jpeg', data: test_image } },
                                   { text: 'Describe this image' }
                                 ]
                               }]
                             })
      )
      .to_return(
        status: 200,
        body: { 'candidates' => [{ 'content' => { 'parts' => [{ 'text' => 'A test image description' }] } }] }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    response = @client.generate_image_text(test_image, 'Describe this image')

    assert_equal 'A test image description', response
  end

  def test_generate_image_text_with_empty_image
    assert_raises(GeminiAI::Error) do
      @client.generate_image_text('', 'Describe this image')
    end
  end

  def test_generate_content_with_options
    stub_request(:post, %r{generativelanguage\.googleapis\.com/v1/models/gemini-2\.5-pro:generateContent\?key=.*})
      .with do |request|
        body = JSON.parse(request.body)
        body['contents'].is_a?(Array) &&
          body['contents'].first['parts'].is_a?(Array) &&
          body['contents'].first['parts'].first['text'] == 'Hello, Gemini!' &&
          body['generationConfig'].is_a?(Hash) &&
          body['generationConfig']['temperature'] == 0.7 &&
          body['generationConfig']['topP'] == 0.9 &&
          body['generationConfig']['topK'] == 40 &&
          body['generationConfig']['maxOutputTokens'] == 2048
      end
      .to_return(
        status: 200,
        body: @success_response.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    response = @client.generate_text(
      'Hello, Gemini!',
      temperature: 0.7,
      top_p: 0.9,
      top_k: 40,
      max_tokens: 2048
    )

    assert_requested(:post, %r{generativelanguage\.googleapis\.com/v1/models/gemini-2\.5-pro:generateContent\?key=.*},
                     times: 1)
    assert_equal 'Test response from Gemini AI', response
  end

  def test_generate_content_with_system_instruction
    # Stub the request with the full URL including the API key
    stub_request(:post, %r{generativelanguage\.googleapis\.com/v1/models/gemini-2\.5-pro:generateContent\?key=.*})
      .with(
        body: {
          'contents' => [{
            'role' => 'user',
            'parts' => [{ 'text' => 'Hello, Gemini!' }]
          }],
          'generationConfig' => {
            'temperature' => 0.7,
            'maxOutputTokens' => 1024,
            'topP' => 0.9,
            'topK' => 40
          },
          'systemInstruction' => {
            'parts' => [{
              'text' => 'You are a helpful assistant.'
            }]
          }
        }
      )
      .to_return(
        status: 200,
        body: @success_response.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    # For system instruction, we need to use the chat method with system_instruction parameter
    response = @client.chat(
      [
        { role: 'user', content: 'Hello, Gemini!' }
      ],
      system_instruction: 'You are a helpful assistant.'
    )

    assert_equal 'Test response from Gemini AI', response
  end

  def test_generate_content_with_safety_settings
    # Define safety settings with symbol keys as the client expects
    safety_settings = [{
      category: 'HARM_CATEGORY_DANGEROUS_CONTENT',
      threshold: 'BLOCK_NONE'
    }]

    # Stub the request with flexible matching for the body
    stub_request(:post, %r{generativelanguage\.googleapis\.com/v1/models/gemini-2\.5-pro:generateContent\?key=.*})
      .with do |request|
        body = JSON.parse(request.body)

        # Check the basic structure
        body['contents'].is_a?(Array) &&
          body['contents'].first['parts'].is_a?(Array) &&
          body['contents'].first['parts'].first['text'] == 'Hello, Gemini!' &&

          # Check safety settings
          body['safetySettings'].is_a?(Array) &&
          body['safetySettings'].first['category'] == 'HARM_CATEGORY_DANGEROUS_CONTENT' &&
          body['safetySettings'].first['threshold'] == 'BLOCK_NONE' &&

          # Check generation config
          body['generationConfig'].is_a?(Hash) &&
          body['generationConfig']['temperature'] == 0.7
      end
      .to_return(
        status: 200,
        body: @success_response.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    response = @client.generate_text(
      'Hello, Gemini!',
      safety_settings:
    )

    assert_requested(:post, %r{generativelanguage\.googleapis\.com/v1/models/gemini-2\.5-pro:generateContent\?key=.*},
                     times: 1)
    assert_equal 'Test response from Gemini AI', response
  end

  def test_generate_text_with_safety_settings
    safety_settings = [{
      category: 'HARM_CATEGORY_DANGEROUS_CONTENT',
      threshold: 'BLOCK_NONE'
    }]

    stub_request(:post, /generativelanguage\.googleapis\.com/)
      .with do |request|
        body = JSON.parse(request.body)
        body['contents'].is_a?(Array) &&
          body['contents'].first['parts'].is_a?(Array) &&
          body['contents'].first['parts'].first['text'] == 'Hello, Gemini!' &&
          body['safetySettings'].is_a?(Array) &&
          body['safetySettings'].first['category'] == 'HARM_CATEGORY_DANGEROUS_CONTENT' &&
          body['safetySettings'].first['threshold'] == 'BLOCK_NONE' &&
          body['generationConfig'].is_a?(Hash) &&
          body['generationConfig']['temperature'] == 0.7
      end
      .to_return(
        status: 200,
        body: @success_response.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    response = @client.generate_text(
      'Hello, Gemini!',
      safety_settings:
    )

    assert_requested(:post, /generativelanguage\.googleapis\.com/, times: 1)
    assert_equal 'Test response from Gemini AI', response
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
    stub_request(:post, /generativelanguage.googleapis.com/)
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
    stub_request(:post, /generativelanguage.googleapis.com/)
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
    stub_request(:post, /generativelanguage.googleapis.com/)
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

  def test_generate_image_text
    # Mock image data
    image_data = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=='

    # Stub the API request with the correct endpoint and parameters for pro_1_5 model
    model_name = GeminiAI::Client::MODELS[:pro_1_5]
    stub_request(:post, "https://generativelanguage.googleapis.com/v1/models/#{model_name}:generateContent?key=#{@api_key}")
      .with(
        body: {
          'contents' => [
            {
              'parts' => [
                {
                  'inline_data' => {
                    'mime_type' => 'image/jpeg',
                    'data' => image_data
                  }
                },
                { 'text' => 'Describe this image' }
              ]
            }
          ],
          'generationConfig' => {
            'temperature' => 0.7,
            'maxOutputTokens' => 1024,
            'topP' => 0.9,
            'topK' => 40
          }
        }
      )
      .to_return(
        status: 200,
        body: {
          'candidates' => [{
            'content' => {
              'parts' => [{
                'text' => 'This is a test image description.'
              }]
            }
          }]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    # Call the method with image data
    response = @client.generate_image_text(
      image_data,
      'Describe this image'
    )

    # Verify the request was made with the correct model
    model_name = GeminiAI::Client::MODELS[:pro_1_5]

    assert_requested :post, "https://generativelanguage.googleapis.com/v1/models/#{model_name}:generateContent?key=#{@api_key}",
                     times: 1

    # Check the request body separately
    assert_requested(:post,
                     "https://generativelanguage.googleapis.com/v1/models/#{model_name}:generateContent?key=#{@api_key}", times: 1) do |req|
      body = JSON.parse(req.body)
      contents = body['contents']
      parts = contents.first['parts']

      # Check that the parts array contains both the image and text
      has_image = parts.any? do |part|
        part['inline_data'] &&
          part['inline_data']['mime_type'] == 'image/jpeg' &&
          part['inline_data']['data'] == image_data
      end

      has_text = parts.any? { |part| part['text'] == 'Describe this image' }

      has_image && has_text
    end

    assert_equal 'This is a test image description.', response
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
    stub_request(:post, /generativelanguage.googleapis.com/)
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
