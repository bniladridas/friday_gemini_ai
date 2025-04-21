require_relative 'lib/gemini_ai'

# This is a simple test that doesn't require an API key
# It just verifies that the gem can be loaded and basic functionality exists

puts "Testing Friday Gemini AI gem..."

# Test that the Client class exists
raise "Client class not found" unless defined?(GeminiAI::Client)

# Test that the Error class exists
raise "Error class not found" unless defined?(GeminiAI::Error)

# Test that the VERSION constant exists
raise "VERSION constant not found" unless defined?(GeminiAI::VERSION)

# Test that the Client class has the expected methods
client_methods = GeminiAI::Client.instance_methods(false)
required_methods = [:generate_text, :chat]

missing_methods = required_methods - client_methods
raise "Missing methods: #{missing_methods.join(', ')}" unless missing_methods.empty?

puts "All basic tests passed!"
puts "Friday Gemini AI gem version: #{GeminiAI::VERSION}"
