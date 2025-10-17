# frozen_string_literal: true

# Main entry point for the GeminiAI gem
require_relative 'core/version'
require_relative 'core/errors'
require_relative 'core/client'
require_relative 'utils/loader'
require_relative 'utils/logger'

module GeminiAI
  # Convenience method to create a new client
  def self.new(api_key = nil, model: :pro)
    Client.new(api_key, model: model)
  end

  # Load environment variables
  def self.load_env(file_path = '.env')
    Utils::Loader.load(file_path)
  end

  # Validate required environment variables
  def self.validate_env(required_vars = ['GEMINI_API_KEY'])
    missing_vars = required_vars.select { |var| ENV[var].nil? || ENV[var].empty? }
    unless missing_vars.empty?
      warn "Warning: Missing required environment variables: #{missing_vars.join(', ')}"
      warn 'Please set them in your .env file or environment'
    end
    missing_vars
  end
end
