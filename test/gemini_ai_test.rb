require 'minitest/autorun'
require_relative '../lib/gemini_ai'

class GeminiAITest < Minitest::Test
  def setup
    @api_key = ENV['GEMINI_API_KEY']
    @client = GeminiAI::Client.new(@api_key)
  end

  def test_generate_text
    response = @client.generate_text('Tell me a short joke')
    refute_nil response
    assert response.length > 0
  end

  def test_generate_text_with_options
    response = @client.generate_text('Explain machine learning',
      temperature: 0.5,
      max_tokens: 200
    )
    refute_nil response
    assert response.length > 0
  end

  def test_chat
    messages = [
      { role: 'user', content: 'Hello' },
      { role: 'model', content: 'Hi there!' },
      { role: 'user', content: 'How are you?' }
    ]

    response = @client.chat(messages)
    refute_nil response
    assert response.length > 0
  end

  def test_invalid_api_key
    assert_raises(GeminiAI::Error) do
      GeminiAI::Client.new('')
    end
  end

  def test_empty_prompt
    assert_raises(GeminiAI::Error) do
      @client.generate_text('')
    end
  end
end
