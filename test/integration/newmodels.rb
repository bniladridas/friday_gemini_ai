# frozen_string_literal: true

require_relative '../test_helper'

class TestNewModels < Minitest::Test
  def setup
    # Stub the API key validation to always pass
    GeminiAI::Client.any_instance.stubs(:validate_api_key!).returns(true)

    # Stub sleep to speed up tests
    GeminiAI::Client.any_instance.stubs(:sleep)
  end

  def test_gemini_2_5_pro
    # Stub the request with specific model endpoint
    stub_gemini_request(
      model: 'gemini-2.5-pro',
      with_body: {
        'contents' => [{
          'parts' => [{ 'text' => 'Test prompt' }]
        }],
        'generationConfig' => {
          'temperature' => 0.7,
          'maxOutputTokens' => 1024,
          'topP' => 0.9,
          'topK' => 40
        }
      }
    )

    # Create client and make the request
    client = create_test_client(model: :pro)
    response = client.generate_text('Test prompt')

    # Verify the response
    refute_nil response
    refute_empty response.strip
    assert_instance_of String, response
    assert_equal 'Test response from Gemini AI', response

    # Verify the correct model was used
    assert_equal 'gemini-2.5-pro', client.instance_variable_get(:@model)
  end

  def test_gemini_2_5_flash
    # Stub the request with specific model endpoint
    stub_gemini_request(
      model: 'gemini-2.5-flash',
      with_body: {
        'contents' => [{
          'parts' => [{ 'text' => 'Test prompt' }]
        }],
        'generationConfig' => {
          'temperature' => 0.7,
          'maxOutputTokens' => 1024,
          'topP' => 0.9,
          'topK' => 40
        }
      }
    )

    # Create client and make the request
    client = create_test_client(model: :flash)
    response = client.generate_text('Test prompt')

    # Verify the response
    refute_nil response
    refute_empty response.strip
    assert_instance_of String, response
    assert_equal 'Test response from Gemini AI', response

    # Verify the correct model was used
    assert_equal 'gemini-2.5-flash', client.instance_variable_get(:@model)
  end

  def test_gemini_2_0_flash
    # Stub the request with specific model endpoint
    stub_gemini_request(
      model: 'gemini-2.0-flash',
      with_body: {
        'contents' => [{
          'parts' => [{ 'text' => 'Test prompt' }]
        }],
        'generationConfig' => {
          'temperature' => 0.7,
          'maxOutputTokens' => 1024,
          'topP' => 0.9,
          'topK' => 40
        }
      }
    )

    # Create client and make the request
    client = create_test_client(model: :flash_2_0)
    response = client.generate_text('Test prompt')

    # Verify the response
    refute_nil response
    refute_empty response.strip
    assert_instance_of String, response
    assert_equal 'Test response from Gemini AI', response

    # Verify the correct model was used
    assert_equal 'gemini-2.0-flash', client.instance_variable_get(:@model)
  end

  def test_gemini_1_5_flash
    # Stub the request with specific model endpoint
    stub_gemini_request(
      model: 'gemini-1.5-flash',
      with_body: {
        'contents' => [{
          'parts' => [{ 'text' => 'Test prompt' }]
        }],
        'generationConfig' => {
          'temperature' => 0.7,
          'maxOutputTokens' => 1024,
          'topP' => 0.9,
          'topK' => 40
        }
      }
    )

    # Create client and make the request
    client = create_test_client(model: :flash_1_5)
    response = client.generate_text('Test prompt')

    # Verify the response
    refute_nil response
    refute_empty response.strip
    assert_instance_of String, response
    assert_equal 'Test response from Gemini AI', response

    # Verify the correct model was used
    assert_equal 'gemini-1.5-flash', client.instance_variable_get(:@model)
  end

  def test_gemini_1_5_pro
    # Stub the request with specific model endpoint
    stub_gemini_request(
      model: 'gemini-1.5-pro',
      with_body: {
        'contents' => [{
          'parts' => [{ 'text' => 'Test prompt' }]
        }],
        'generationConfig' => {
          'temperature' => 0.7,
          'maxOutputTokens' => 1024,
          'topP' => 0.9,
          'topK' => 40
        }
      }
    )

    # Create client and make the request
    client = create_test_client(model: :pro_1_5)
    response = client.generate_text('Test prompt')

    # Verify the response
    refute_nil response
    refute_empty response.strip
    assert_instance_of String, response
    assert_equal 'Test response from Gemini AI', response

    # Verify the correct model was used
    assert_equal 'gemini-1.5-pro', client.instance_variable_get(:@model)
  end

  def test_model_comparison
    models_to_test = %i[pro flash flash_2_0 pro_1_5]
    responses = {}
    prompt = 'What is 2+2? Answer in one word.'

    # Stub the request for each model
    models_to_test.each do |model|
      # Create a unique response for each model
      response_text = "Response from model: #{model}"

      stub_request(:post, /generativelanguage.googleapis.com/)
        .to_return(
          status: 200,
          body: {
            'candidates' => [{
              'content' => {
                'parts' => [{
                  'text' => response_text
                }]
              }
            }]
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      # Create client and make the request
      client = GeminiAI::Client.new(@api_key, model:)
      responses[model] = client.generate_text(prompt)

      # Verify the correct model was used
      expected_model = case model
                       when :pro then 'gemini-2.5-pro'
                       when :flash then 'gemini-2.5-flash'
                       when :pro_1_5 then 'gemini-1.5-pro'
                       when :flash_2_0 then 'gemini-2.0-flash'
                       end

      assert_equal expected_model, client.instance_variable_get(:@model)
    end

    # Verify we got responses for all models
    assert_equal models_to_test.size, responses.size

    # Verify all responses are unique (they should be, as we set different responses for each model)
    assert_equal models_to_test.size, responses.values.uniq.size

    # Verify each response contains the expected model identifier
    models_to_test.each do |model|
      assert_includes responses[model], "Response from model: #{model}"
    end
  end
end
