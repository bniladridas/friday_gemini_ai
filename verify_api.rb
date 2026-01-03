require_relative 'lib/gemini_ai'

# Check if API key is set
if ENV['GEMINI_API_KEY'].nil? || ENV['GEMINI_API_KEY'].strip.empty?
  puts "Error: GEMINI_API_KEY environment variable is not set."
  puts "Please set it first:"
  puts "  export GEMINI_API_KEY='your_api_key_here'"
  exit 1
end

# Initialize client (uses GEMINI_API_KEY environment variable)
client = GeminiAI::Client.new

# Test basic text generation
puts "\nTesting basic text generation..."
response = client.generate_text("What is the capital of France?")
puts "Response: #{response}"

# Test with different model
puts "\nTesting with flash_lite model..."
client_lite = GeminiAI::Client.new(model: :flash_lite)
response = client_lite.generate_text("Tell me a short joke")
puts "Response: #{response}"

# Test with custom parameters
puts "\nTesting with custom parameters..."
response = client.generate_text("Write a haiku about programming",
  temperature: 0.3,
  max_tokens: 30,
  top_p: 0.8,
  top_k: 20
)
puts "Response: #{response}"
