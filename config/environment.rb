# Environment configuration for GeminiAI gem
require_relative '../lib/gemini'

# Load environment variables from .env file
GeminiAI.load_env

# Configure logging level based on environment
case ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
when 'production'
  GeminiAI::Utils::Logger.instance.level = Logger::ERROR
when 'test'
  GeminiAI::Utils::Logger.instance.level = Logger::WARN
else
  GeminiAI::Utils::Logger.instance.level = Logger::DEBUG
end

# Validate required environment variables
required_vars = ['GEMINI_API_KEY']
missing_vars = required_vars.select { |var| ENV[var].nil? || ENV[var].empty? }

unless missing_vars.empty?
  puts "Warning: Missing required environment variables: #{missing_vars.join(', ')}"
  puts "Please set them in your .env file or environment"
end