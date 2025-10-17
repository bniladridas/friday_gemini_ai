# frozen_string_literal: true

# Environment configuration for GeminiAI gem
require_relative '../lib/gemini'

# Load environment variables from .env file
GeminiAI.load_env

# Configure logging level based on environment
GeminiAI::Utils::Logger.instance.level = case ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
                                         when 'production'
                                           Logger::ERROR
                                         when 'test'
                                           Logger::WARN
                                         else
                                           Logger::DEBUG
                                         end

# Validate required environment variables
GeminiAI.validate_env
