# frozen_string_literal: true

require_relative '../test_helper'

class ClientEdgeCasesTest < Minitest::Test
  def setup
    @client = GeminiAI::Client.new('AIzaSyDummyTestKeyForUnitTests123456789')
    @test_image = Base64.strict_encode64(File.binread('test/fixtures/test_image.jpg'))
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  def test_generate_text_with_long_prompt
    long_prompt = 'a' * 9000
    stub_gemini_request(response: test_response, status: 200)

    error = assert_raises(GeminiAI::Error) do
      @client.generate_text(long_prompt)
    end

    assert_equal 'Prompt too long (max 8192 tokens)', error.message
  end

  def test_generate_image_text_with_empty_image
    error = assert_raises(GeminiAI::Error) do
      @client.generate_image_text('', 'test prompt')
    end

    assert_equal 'Image is required', error.message
  end

  def test_chat_with_system_instruction
    expected_system_instruction = 'You are a helpful assistant'
    
    stub_request(:post, /generativelanguage/)
      .with(body: hash_including({
        contents: [
          { role: 'user', parts: [{ text: 'Hello' }] },
          { role: 'assistant', parts: [{ text: 'Hi there!' }] },
          { role: 'user', parts: [{ text: 'Tell me a joke' }] }
        ],
        systemInstruction: {
          parts: [
            { text: expected_system_instruction }
          ]
        }
      }))
      .to_return(
        status: 200,
        body: test_response,
        headers: { 'Content-Type': 'application/json' }
      )

    messages = [
      { role: 'user', content: 'Hello' },
      { role: 'assistant', content: 'Hi there!' },
      { role: 'user', content: 'Tell me a joke' }
    ]

    @client.chat(messages, system_instruction: expected_system_instruction)
  end

  def test_rate_limiting
    stub_gemini_request(response: test_response, status: 200).times(2)

    start_time = Time.now
    @client.generate_text('test')
    @client.generate_text('test')
    end_time = Time.now

    # Should take at least 1 second between requests (min_request_interval)
    assert_operator (end_time - start_time), :>=, 1.0
  end

  def test_api_key_masking
    # mask_api_key keeps first 4 and last 4 characters, replaces middle with asterisks
    assert_equal 'AIza*******************************6789',
                 @client.send(:mask_api_key, 'AIzaSyDummyTestKeyForUnitTests123456789')
    assert_equal 'test', @client.send(:mask_api_key, 'test')
    assert_equal '[REDACTED]', @client.send(:mask_api_key, nil)
  end

  private

  def test_response(text = 'Test response from Gemini AI')
    {
      candidates: [
        {
          content: {
            parts: [
              { text: }
            ]
          }
        }
      ]
    }.to_json
  end

  def stub_gemini_request(response: test_response, status: 200)
    stub_request(:post, /generativelanguage/)
      .to_return(
        status:,
        body: response,
        headers: { 'Content-Type': 'application/json' }
      )
  end
end
