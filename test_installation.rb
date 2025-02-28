require_relative 'lib/gemini_ai'

puts "Testing Friday Gemini AI Gem Installation..."

# Initialize client
client = GeminiAI::Client.new

# Test text generation
puts "\nTesting text generation..."
response = client.generate_text("What's your favorite programming language and why?")
puts "Response: #{response}"

# Test with flash_lite model
puts "\nTesting flash_lite model..."
client_lite = GeminiAI::Client.new(model: :flash_lite)
response = client_lite.generate_text("Write a short poem about coding")
puts "Response: #{response}"

puts "\nAll tests completed successfully!"
