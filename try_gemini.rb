require_relative 'lib/friday_gemini_ai'

# Using the API key from your .env file
api_key = ENV['GEMINI_API_KEY']
if api_key.nil? || api_key.strip.empty?
  abort "Error: GEMINI_API_KEY environment variable is not set. Please set it to your Gemini API key."
end

# The module name in this gem is GeminiAI, and the method is generate_text
client = GeminiAI::Client.new(api_key, model: :flash)

begin
  puts "Sending request to Gemini..."
  response = client.generate_text('Hello, how are you?')
  puts "\nResponse:"
  puts response
rescue => e
  puts "\nAn error occurred: #{e.message}"
end
