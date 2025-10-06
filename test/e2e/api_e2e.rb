# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/gemini'

class TestAPIe2e < Minitest::Test
  def setup
    @api_key = ENV.fetch('GEMINI_API_KEY', nil)
    skip 'GEMINI_API_KEY not set, skipping e2e tests' unless @api_key

    @client = GeminiAI::Client.new(@api_key)
  end

  def test_basic_text_generation
    response = @client.generate_text('Say "Hello World" in one word')

    refute_nil response
    refute_empty response.strip
    assert_instance_of String, response
    assert_includes response.downcase, 'hello'
  rescue GeminiAI::Error => e
    if e.message.include?('Rate limit exceeded') || e.message.include?('RESOURCE_EXHAUSTED')
      skip "Rate limit exceeded: #{e.message}"
    end
    raise
  end

  def test_chat_functionality
    messages = [
      { role: 'user', content: 'What is 2+2?' },
      { role: 'model', content: '4' },
      { role: 'user', content: 'What is 3+3?' }
    ]

    response = @client.chat(messages)

    refute_nil response
    refute_empty response.strip
    assert_instance_of String, response
    assert_includes response, '6'
  rescue GeminiAI::Error => e
    if e.message.include?('Rate limit exceeded') || e.message.include?('RESOURCE_EXHAUSTED')
      skip "Rate limit exceeded: #{e.message}"
    end
    raise
  end

  def test_different_models
    # Test with flash model for speed
    client_flash = GeminiAI::Client.new(@api_key, model: :flash)
    response = client_flash.generate_text('What is the capital of France? Answer in one word.')

    refute_nil response
    refute_empty response.strip
    assert_includes response.downcase, 'paris'
  rescue GeminiAI::Error => e
    if e.message.include?('Rate limit exceeded') || e.message.include?('RESOURCE_EXHAUSTED')
      skip "Rate limit exceeded: #{e.message}"
    end
    raise
  end
end
