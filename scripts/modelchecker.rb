#!/usr/bin/env ruby
# frozen_string_literal: true

require 'httparty'
require 'json'
require_relative '../lib/gemini'

# Load environment variables
GeminiAI.load_env

class ModelChecker
  BASE_URL = 'https://generativelanguage.googleapis.com/v1/models'

  # New Gemini 2.5 models from the image
  NEW_MODELS = {
    'gemini-2.5-pro' => 'Gemini 2.5 Pro',
    'gemini-2.5-flash' => 'Gemini 2.5 Flash',
    'gemini-2.5-flash-lite' => 'Gemini 2.5 Flash-Lite'
  }.freeze

  def initialize(api_key = nil)
    @api_key = api_key || ENV.fetch('GEMINI_API_KEY', nil)

    return unless @api_key.nil? || @api_key.strip.empty?

    puts 'ERROR: API key is required. Set GEMINI_API_KEY environment variable or pass key directly.'
    exit 1
  end

  def check_all_models
    puts 'Checking Gemini model availability...'
    puts '=' * 50

    available_models = fetch_available_models

    if available_models.nil?
      puts 'ERROR: Failed to fetch model list from API'
      return
    end

    puts 'Available models from API:'
    available_models.each { |model| puts "  * #{model}" }
    puts

    puts 'Checking new Gemini 2.5 models:'
    NEW_MODELS.each do |model_id, model_name|
      if available_models.include?(model_id)
        puts "  [AVAILABLE] #{model_name} (#{model_id})"
        test_model(model_id, model_name)
      else
        puts "  [NOT AVAILABLE] #{model_name} (#{model_id})"
      end
    end

    puts
    puts 'Current client supported models:'
    GeminiAI::Client::MODELS.each do |key, model_id|
      status = available_models.include?(model_id) ? '[OK]' : '[ERROR]'
      puts "  #{status} #{key}: #{model_id}"
    end
  end

  private

  def fetch_available_models
    url = "#{BASE_URL}?key=#{@api_key}"

    begin
      response = HTTParty.get(url, timeout: 10)

      if response.code == 200
        models = response.parsed_response['models'] || []
        models.map { |model| model['name']&.split('/')&.last }.compact
      else
        puts "ERROR: API Error: #{response.code} - #{response.body}"
        nil
      end
    rescue StandardError => e
      puts "ERROR: Request failed: #{e.message}"
      nil
    end
  end

  def test_model(model_id, model_name)
    puts "    Testing #{model_name}..."

    url = "#{BASE_URL}/#{model_id}:generateContent?key=#{@api_key}"
    body = {
      contents: [{ parts: [{ text: "Say 'Hello' in one word" }] }],
      generationConfig: { temperature: 0.1, maxOutputTokens: 10 }
    }

    begin
      response = HTTParty.post(
        url,
        body: body.to_json,
        headers: { 'Content-Type' => 'application/json' },
        timeout: 15
      )

      if response.code == 200
        text = response.parsed_response.dig('candidates', 0, 'content', 'parts', 0, 'text')
        puts "    [SUCCESS] Test successful: #{text&.strip}"
      else
        puts "    [FAILED] Test failed: #{response.code} - #{response.parsed_response['error']&.dig('message')}"
      end
    rescue StandardError => e
      puts "    [ERROR] Test error: #{e.message}"
    end
  end
end

# Run the checker
if __FILE__ == $PROGRAM_NAME
  api_key = ARGV[0]
  checker = ModelChecker.new(api_key)
  checker.check_all_models
end
