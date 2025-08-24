require 'minitest/autorun'
require_relative '../../lib/gemini'

class TestAPI < Minitest::Test
  def setup
    # Load environment variables
    GeminiAI.load_env
    
    # Skip tests if no API key is available
    skip "GEMINI_API_KEY not set" unless ENV['GEMINI_API_KEY']
    
    @client = GeminiAI::Client.new
  end
  
  def test_basic_text_generation
    response = @client.generate_text('Say hello in one word')
    
    refute_nil response
    refute_empty response.strip
    assert_instance_of String, response
  end
  
  def test_chat_functionality
    messages = [
      { role: 'user', content: 'Hello' },
      { role: 'model', content: 'Hi there!' },
      { role: 'user', content: 'How are you?' }
    ]
    
    response = @client.chat(messages)
    
    refute_nil response
    refute_empty response.strip
    assert_instance_of String, response
  end
  
  def test_different_models
    flash_client = GeminiAI::Client.new(model: :flash)
    lite_client = GeminiAI::Client.new(model: :flash_lite)
    
    flash_response = flash_client.generate_text('Test')
    lite_response = lite_client.generate_text('Test')
    
    refute_nil flash_response
    refute_nil lite_response
    assert_instance_of String, flash_response
    assert_instance_of String, lite_response
  end
  
  def test_custom_parameters
    response = @client.generate_text(
      'Write one word',
      temperature: 0.1,
      max_tokens: 10
    )
    
    refute_nil response
    assert_instance_of String, response
  end
end