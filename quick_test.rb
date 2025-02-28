require_relative 'lib/gemini_ai'
require 'httparty'

# Ensure API key is set as an environment variable
api_key = ENV['GEMINI_API_KEY']
raise "GEMINI_API_KEY must be set" if api_key.nil?

begin
  # First, verify the available models
  models_url = "https://generativelanguage.googleapis.com/v1/models?key=#{api_key}"
  response = HTTParty.get(models_url)
  puts "Available Models:"
  puts response.body

  # Test different models
  models = {
    flash: GeminiAI::Client.new(api_key, model: :flash),
    flash_lite: GeminiAI::Client.new(api_key, model: :flash_lite)
  }

  models.each do |name, client|
    puts "\n=== #{name.to_s.upcase} Model Test ==="
    response = client.generate_text('Tell me a short joke about AI')
    puts "Response: #{response}"
  end

rescue GeminiAI::Error => e
  puts "Gemini AI Error: #{e.message}"
rescue StandardError => e
  puts "Unexpected Error: #{e.class}: #{e.message}"
  puts e.backtrace.join("\n")
end
