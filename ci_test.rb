require_relative 'lib/gemini_ai'

# This is a simple test that doesn't require an API key
# It just verifies that the gem can be loaded and basic functionality exists

puts "Testing Friday Gemini AI gem..."

begin
  # Test that the Client class exists
  puts "Checking for Client class..."
  raise "Client class not found" unless defined?(GeminiAI::Client)
  puts "✓ Client class exists"

  # Test that the Error class exists
  puts "Checking for Error class..."
  raise "Error class not found" unless defined?(GeminiAI::Error)
  puts "✓ Error class exists"

  # Test that the VERSION constant exists
  puts "Checking for VERSION constant..."
  raise "VERSION constant not found" unless defined?(GeminiAI::VERSION)
  puts "✓ VERSION constant exists: #{GeminiAI::VERSION}"

  # Test that the Client class has the expected methods
  puts "Checking for required methods..."
  client_methods = GeminiAI::Client.instance_methods(false)
  required_methods = [:generate_text, :chat]

  missing_methods = required_methods - client_methods
  raise "Missing methods: #{missing_methods.join(', ')}" unless missing_methods.empty?
  puts "✓ All required methods exist"

  puts "\nAll basic tests passed!"
  puts "Friday Gemini AI gem version: #{GeminiAI::VERSION}"
rescue => e
  puts "❌ Test failed: #{e.message}"
  puts e.backtrace.join("\n")
  exit 1
end
