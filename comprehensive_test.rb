require 'dotenv/load'
require_relative 'lib/gemini_ai'
require 'minitest/autorun'

class GeminiAITest < Minitest::Test
  def setup
    # IMPORTANT: Replace this with your ACTUAL API key from Google AI Studio
    @api_key = ENV['GEMINI_API_KEY'] || 'REPLACE_WITH_YOUR_ACTUAL_API_KEY'
    
    # Diagnostic logging
    puts "\nDiagnostic Info:"
    puts "API Key: #{@api_key}"
    puts "Key Length: #{@api_key&.length}"
    puts "Key Starts with AIza: #{@api_key&.start_with?('AIza')}"
    puts "Key is not empty: #{!@api_key.nil? && @api_key.strip != ''}"
    
    raise "GEMINI_API_KEY must be set. Please go to https://aistudio.google.com/app/apikey and create a new API key." if @api_key == 'REPLACE_WITH_YOUR_ACTUAL_API_KEY'
    
    # Temporarily set environment variable
    ENV['GEMINI_API_KEY'] = @api_key
    
    @client_flash = GeminiAI::Client.new
    @client_flash_lite = GeminiAI::Client.new(model: :flash_lite)
  end

  def test_generate_text_success
    # Test text generation with different models
    [
      [@client_flash, 'Tell me a short joke about programming'],
      [@client_flash_lite, 'Explain quantum computing in simple terms']
    ].each do |client, prompt|
      response = client.generate_text(prompt)
      
      # Assertions
      refute_nil response, "Response should not be nil for #{client.instance_variable_get(:@model)}"
      assert response.is_a?(String), "Response should be a string for #{client.instance_variable_get(:@model)}"
      assert response.length > 0, "Response should not be empty for #{client.instance_variable_get(:@model)}"
    end
  end

  def test_generate_text_with_options
    # Test generation with custom generation config
    options = {
      temperature: 0.5,
      max_tokens: 50,
      top_p: 0.8,
      top_k: 30
    }

    response = @client_flash.generate_text('Write a haiku about technology', options)
    
    # Assertions
    refute_nil response, "Response should not be nil"
    assert response.is_a?(String), "Response should be a string"
    assert response.length > 0, "Response should not be empty"
  end

  def test_error_handling
    # Test empty prompt
    assert_raises(GeminiAI::Error, "Should raise error for empty prompt") do
      @client_flash.generate_text('')
    end

    # Test nil prompt
    assert_raises(GeminiAI::Error, "Should raise error for nil prompt") do
      @client_flash.generate_text(nil)
    end

    # Test extremely long prompt
    long_prompt = 'x' * 10000
    assert_raises(GeminiAI::Error, "Should raise error for extremely long prompt") do
      @client_flash.generate_text(long_prompt)
    end
  end

  def test_model_switching
    # Verify model switching works
    models = [:flash, :flash_lite]
    
    models.each do |model|
      client = GeminiAI::Client.new(model: model)
      response = client.generate_text('What model am I using?')
      
      # Assertions
      refute_nil response, "Response should not be nil for #{model}"
      assert response.is_a?(String), "Response should be a string for #{model}"
      assert response.length > 0, "Response should not be empty for #{model}"
    end
  end

  def test_response_diversity
    # Test that multiple generations produce different responses
    prompts = [
      'Tell me something interesting about space',
      'Describe a creative solution to a global problem'
    ]

    prompts.each do |prompt|
      responses = [
        @client_flash.generate_text(prompt),
        @client_flash.generate_text(prompt)
      ]

      # Responses might occasionally be the same, but it's unlikely
      refute_equal responses[0], responses[1], "Responses should have some variation"
    end
  end
end
