require 'gemini_ai'

# SECURE API KEY HANDLING EXAMPLE

# Ensure API key is set as an environment variable
api_key = ENV['GEMINI_API_KEY']
raise "GEMINI_API_KEY must be set" if api_key.nil?

begin
  # Generate text using default model
  client = GeminiAI::Client.new
  response = client.generate_text('Tell me a joke about AI security')
  puts "Flash Model Response: #{response}"

  # Use Flash Lite model
  client_lite = GeminiAI::Client.new(model: :flash_lite)
  response_lite = client_lite.generate_text('Explain cybersecurity in one sentence')
  puts "Flash Lite Model Response: #{response_lite}"

rescue GeminiAI::Error => e
  puts "Gemini AI Error: #{e.message}"
rescue StandardError => e
  puts "Unexpected Error: #{e.message}"
end
