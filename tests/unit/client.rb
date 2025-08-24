require 'minitest/autorun'
require_relative '../../lib/gemini'

class TestClient < Minitest::Test
  def setup
    # Use a mock API key for testing
    @api_key = 'AIzaSyDummyTestKeyForUnitTests123456789'
    @client = GeminiAI::Client.new(@api_key)
  end
  
  def test_client_initialization
    assert_instance_of GeminiAI::Client, @client
  end
  
  def test_invalid_api_key
    assert_raises GeminiAI::Error do
      GeminiAI::Client.new('invalid_key')
    end
  end
  
  def test_empty_api_key
    assert_raises GeminiAI::Error do
      GeminiAI::Client.new('')
    end
  end
  
  def test_nil_api_key_without_env
    # Temporarily clear environment variable
    original_key = ENV['GEMINI_API_KEY']
    ENV['GEMINI_API_KEY'] = nil
    
    assert_raises GeminiAI::Error do
      GeminiAI::Client.new
    end
    
    # Restore environment variable
    ENV['GEMINI_API_KEY'] = original_key
  end
  
  def test_empty_prompt_validation
    assert_raises GeminiAI::Error do
      @client.generate_text('')
    end
  end
  
  def test_nil_prompt_validation
    assert_raises GeminiAI::Error do
      @client.generate_text(nil)
    end
  end
  
  def test_model_selection
    flash_client = GeminiAI::Client.new(@api_key, model: :flash)
    lite_client = GeminiAI::Client.new(@api_key, model: :flash_lite)
    
    assert_instance_of GeminiAI::Client, flash_client
    assert_instance_of GeminiAI::Client, lite_client
  end
  
  def test_invalid_model_defaults_to_pro
    # Should not raise error, should default to pro model
    client = GeminiAI::Client.new(@api_key, model: :invalid_model)
    assert_instance_of GeminiAI::Client, client
  end
end