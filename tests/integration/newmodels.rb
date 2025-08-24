require 'minitest/autorun'
require_relative '../../lib/gemini'

class TestNewModels < Minitest::Test
  def setup
    # Load environment variables
    GeminiAI.load_env
    
    # Skip tests if no API key is available
    skip "GEMINI_API_KEY not set" unless ENV['GEMINI_API_KEY']
  end
  
  def test_gemini_2_5_pro
    client = GeminiAI::Client.new(model: :pro)
    response = client.generate_text('Say "2.5 Pro" in one phrase')
    
    refute_nil response
    refute_empty response.strip
    assert_instance_of String, response
    puts "Gemini 2.5 Pro response: #{response.strip}"
  end
  
  def test_gemini_2_5_flash
    client = GeminiAI::Client.new(model: :flash)
    response = client.generate_text('Say "2.5 Flash" in one phrase')
    
    refute_nil response
    refute_empty response.strip
    assert_instance_of String, response
    puts "Gemini 2.5 Flash response: #{response.strip}"
  end
  
  def test_gemini_2_0_flash
    client = GeminiAI::Client.new(model: :flash_2_0)
    response = client.generate_text('Say "2.0 Flash" in one phrase')
    
    refute_nil response
    refute_empty response.strip
    assert_instance_of String, response
    puts "Gemini 2.0 Flash response: #{response.strip}"
  end
  
  def test_gemini_1_5_pro
    client = GeminiAI::Client.new(model: :pro_1_5)
    response = client.generate_text('Say "1.5 Pro" in one phrase')
    
    refute_nil response
    refute_empty response.strip
    assert_instance_of String, response
    puts "Gemini 1.5 Pro response: #{response.strip}"
  end
  
  def test_model_comparison
    models_to_test = [:pro, :flash, :flash_2_0, :pro_1_5]
    prompt = "What is 2+2? Answer in one word."
    
    models_to_test.each do |model|
      client = GeminiAI::Client.new(model: model)
      response = client.generate_text(prompt)
      
      refute_nil response
      refute_empty response.strip
      puts "#{model}: #{response.strip}"
    end
  end
end