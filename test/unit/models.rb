# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/gemini'

class TestModels < Minitest::Test
  def setup
    # Use a mock API key for testing
    @api_key = 'AIzaSyDummyTestKeyForUnitTests123456789'
  end

  def test_gemini_pro_model
    client = GeminiAI::Client.new(@api_key, model: :pro)

    assert_instance_of GeminiAI::Client, client
    assert_equal 'gemini-pro', client.instance_variable_get(:@model)
  end

  def test_gemini_1_5_flash_model
    client = GeminiAI::Client.new(@api_key, model: :flash)

    assert_instance_of GeminiAI::Client, client
    assert_equal 'gemini-1.5-flash', client.instance_variable_get(:@model)
  end

  def test_gemini_1_5_models
    pro_1_5_client = GeminiAI::Client.new(@api_key, model: :pro_1_5)
    flash_1_5_client = GeminiAI::Client.new(@api_key, model: :flash_1_5)
    flash_8b_client = GeminiAI::Client.new(@api_key, model: :flash_8b)

    assert_instance_of GeminiAI::Client, pro_1_5_client
    assert_instance_of GeminiAI::Client, flash_1_5_client
    assert_instance_of GeminiAI::Client, flash_8b_client

    assert_equal 'gemini-1.5-pro', pro_1_5_client.instance_variable_get(:@model)
    assert_equal 'gemini-1.5-flash', flash_1_5_client.instance_variable_get(:@model)
    assert_equal 'gemini-1.5-flash-8b', flash_8b_client.instance_variable_get(:@model)
  end

  def test_gemini_1_5_models
    pro_1_5_client = GeminiAI::Client.new(@api_key, model: :pro_1_5)
    flash_1_5_client = GeminiAI::Client.new(@api_key, model: :flash_1_5)
    flash_8b_client = GeminiAI::Client.new(@api_key, model: :flash_8b)

    assert_instance_of GeminiAI::Client, pro_1_5_client
    assert_instance_of GeminiAI::Client, flash_1_5_client
    assert_instance_of GeminiAI::Client, flash_8b_client
  end

  def test_all_supported_models
    GeminiAI::Client::MODELS.each do |model_key, model_id|
      client = GeminiAI::Client.new(@api_key, model: model_key)

      assert_instance_of GeminiAI::Client, client, "Failed to create client for model: #{model_key} (#{model_id})"
    end
  end

  def test_invalid_model_defaults_to_pro
    # Should not raise error, should default to pro model (gemini-pro)
    client = GeminiAI::Client.new(@api_key, model: :invalid_model)

    assert_instance_of GeminiAI::Client, client
    assert_equal 'gemini-pro', client.instance_variable_get(:@model)
  end
end
