require 'httparty'
require 'json'
require 'base64'
require 'logger'

module GeminiAI
  VERSION = '0.1.5'
  class Error < StandardError; end

  class Client
    BASE_URL = 'https://generativelanguage.googleapis.com/v1/models'
    MODELS = {
      pro: 'gemini-2.0-flash',
      flash: 'gemini-2.0-flash',
      flash_lite: 'gemini-2.0-flash-lite'
    }

    # Configure logging
    def self.logger
      @logger ||= Logger.new(STDOUT).tap do |log|
        log.level = Logger::DEBUG  # Changed to DEBUG for more information
        log.formatter = proc do |severity, datetime, progname, msg|
          # Mask any potential API key in logs
          masked_msg = msg.to_s.gsub(/AIza[a-zA-Z0-9_-]{35,}/, '[REDACTED]')
          "#{datetime}: #{severity} -- #{masked_msg}\n"
        end
      end
    end

    def initialize(api_key = nil, model: :pro)
      # Prioritize passed API key, then environment variable
      @api_key = api_key || ENV['GEMINI_API_KEY']
      
      # Extensive logging for debugging
      self.class.logger.debug("Initializing Client")
      self.class.logger.debug("API Key present: #{!@api_key.nil?}")
      self.class.logger.debug("API Key length: #{@api_key&.length}")
      
      # Validate API key
      validate_api_key!
      
      @model = MODELS.fetch(model) { 
        self.class.logger.warn("Invalid model: #{model}, defaulting to pro")
        MODELS[:pro] 
      }
      
      self.class.logger.debug("Selected model: #{@model}")
    end

    def generate_text(prompt, options = {})
      validate_prompt!(prompt)

      request_body = {
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: build_generation_config(options)
      }

      send_request(request_body)
    end

    def generate_image_text(image_base64, prompt, options = {})
      raise Error, "Image is required" if image_base64.nil? || image_base64.empty?
      
      request_body = {
        contents: [
          { parts: [
            { inline_data: { mime_type: 'image/jpeg', data: image_base64 } },
            { text: prompt }
          ]}
        ],
        generationConfig: build_generation_config(options)
      }

      send_request(request_body, model: :pro_vision)
    end

    def chat(messages, options = {})
      request_body = {
        contents: messages.map { |msg| { role: msg[:role], parts: [{ text: msg[:content] }] } },
        generationConfig: build_generation_config(options)
      }

      send_request(request_body)
    end

    private

    def validate_api_key!
      if @api_key.nil? || @api_key.strip.empty?
        self.class.logger.error("API key is missing")
        raise Error, "API key is required. Set GEMINI_API_KEY environment variable or pass key directly."
      end

      # Optional: Add basic API key format validation
      unless valid_api_key_format?(@api_key)
        self.class.logger.error("Invalid API key format")
        raise Error, "Invalid API key format. Please check your key."
      end

      # Optional: Check key length and complexity
      if @api_key.length < 40
        self.class.logger.warn("Potentially weak API key detected")
      end
    end

    def valid_api_key_format?(key)
      # Strict format check: starts with 'AIza', reasonable length
      key =~ /^AIza[a-zA-Z0-9_-]{35,}$/
    end

    def validate_prompt!(prompt)
      if prompt.nil? || prompt.strip.empty?
        self.class.logger.error("Empty prompt provided")
        raise Error, "Prompt cannot be empty"
      end

      if prompt.length > 8192
        self.class.logger.error("Prompt exceeds maximum length")
        raise Error, "Prompt too long (max 8192 tokens)"
      end
    end

    def build_generation_config(options)
      {
        temperature: options[:temperature] || 0.7,
        maxOutputTokens: options[:max_tokens] || 1024,
        topP: options[:top_p] || 0.9,
        topK: options[:top_k] || 40
      }
    end

    def send_request(body, model: nil)
      current_model = model ? MODELS.fetch(model) { MODELS[:pro] } : @model
      url = "#{BASE_URL}/#{current_model}:generateContent?key=#{@api_key}"

      # Log URL with masked API key for security
      masked_url = "#{BASE_URL}/#{current_model}:generateContent?key=#{mask_api_key(@api_key)}"
      self.class.logger.debug("Request URL: #{masked_url}")
      self.class.logger.debug("Request Body: #{body.to_json}")

      begin
        response = HTTParty.post(
          url, 
          body: body.to_json,
          headers: { 
            'Content-Type' => 'application/json',
            'x-goog-api-client' => 'gemini_ai_ruby_gem/0.1.0'
          },
          # Add timeout to prevent hanging
          timeout: 30
        )

        self.class.logger.debug("Response Code: #{response.code}")
        self.class.logger.debug("Response Body: #{response.body}")

        parse_response(response)
      rescue HTTParty::Error, Net::OpenTimeout => e
        self.class.logger.error("API request failed: #{e.message}")
        raise Error, "API request failed: #{e.message}"
      end
    end

    def parse_response(response)
      case response.code
      when 200
        text = response.parsed_response
               .dig('candidates', 0, 'content', 'parts', 0, 'text')
        text || 'No response generated'
      else
        error_message = response.parsed_response['error']&.dig('message') || response.body
        self.class.logger.error("API Error: #{error_message}")
        raise Error, "API Error: #{error_message}"
      end
    end

    # Mask API key for logging and error reporting
    def mask_api_key(key)
      return '[REDACTED]' if key.nil?
      
      # Keep first 4 and last 4 characters, replace middle with asterisks
      return key if key.length <= 8
      
      "#{key[0,4]}#{'*' * (key.length - 8)}#{key[-4,4]}"
    end
  end
end
