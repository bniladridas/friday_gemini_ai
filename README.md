# Friday Gemini AI Ruby Gem

## Overview
A powerful Ruby gem for interacting with Google's Gemini AI models, providing easy text generation capabilities.

## Features
- Support for multiple Gemini AI models
- Flexible text generation
- Comprehensive error handling
- Configurable generation parameters
- Advanced security and logging

## Security

### 🔒 API Key Protection

#### Key Management
1. **Never Hardcode API Keys**
   - Do NOT include your API key directly in your code
   - Use environment variables or secure key management systems

2. **Environment Variable Setup**
   ```bash
   # Set in your shell profile (.bashrc, .zshrc, etc.)
   export GEMINI_API_KEY='your_actual_api_key'
   ```

3. **Secure Key Passing**
   ```ruby
   # Recommended: Use environment variable
   client = GeminiAI::Client.new

   # Alternative: Pass key securely
   client = GeminiAI::Client.new(ENV['GEMINI_API_KEY'])
   ```

#### Advanced Security Features
- API key format validation
- Automatic key masking in logs
- Strict input validation
- Request timeout protection

### 🕵️ Logging and Monitoring

#### Logging Configuration
```ruby
# Configure logging level
GeminiAI::Client.logger.level = Logger::WARN  # Default
GeminiAI::Client.logger.level = Logger::DEBUG  # More verbose
```

#### Log Masking
- API keys are automatically masked in logs
- Sensitive information is redacted
- Prevents accidental key exposure

### 🛡️ Best Practices
- Restrict API key permissions
- Use the principle of least privilege
- Keep your API key confidential
- Monitor API usage and set up alerts
- Implement rate limiting
- Regularly rotate API keys

## Installation

### Local Installation
1. Clone the repository
```bash
git clone https://github.com/bniladridas/gemini_ai.git
cd gemini_ai
```

2. Build the gem
```bash
gem build gemini_ai.gemspec
```

3. Install the gem locally
```bash
gem install gemini_ai-0.1.0.gem
```

### Using Bundler
Add to your Gemfile:
```ruby
gem 'gemini_ai', path: '/path/to/gemini_ai'
```

### From RubyGems
```bash
gem install friday_gemini_ai
```

Or add to your Gemfile:
```ruby
gem 'friday_gemini_ai', '~> 0.1.0'
```

## Quick Start

1. Get your API key from [Google AI Studio](https://aistudio.google.com/app/apikey)

2. Set your API key:
```bash
export GEMINI_API_KEY='your_api_key_here'
```

3. Start using the gem:
```ruby
require 'gemini_ai'

# Initialize client
client = GeminiAI::Client.new

# Generate text
response = client.generate_text('Tell me a joke')
puts response

# Use different model
client_lite = GeminiAI::Client.new(model: :flash_lite)
response = client_lite.generate_text('What is AI?')
puts response

# Use custom parameters
response = client.generate_text('Write a haiku', 
  temperature: 0.3,
  max_tokens: 30,
  top_p: 0.8,
  top_k: 20
)
puts response
```

## Configuration

## Testing and Verification

### Running the Test Suite
To run the comprehensive test suite:
```bash
ruby comprehensive_test.rb
```

### Quick Verification
First, ensure your API key is set:
```bash
export GEMINI_API_KEY='your_api_key_here'
```

Then run the verification script:
```bash
ruby verify_api.rb
```

This will run a series of quick tests:
- Basic text generation with the default model
- Text generation with the flash_lite model
- Text generation with custom parameters

## Usage

### Basic Text Generation
```ruby
require 'gemini_ai'

# Initialize client with default model
client = GeminiAI::Client.new(ENV['GEMINI_API_KEY'])

# Generate text
response = client.generate_text('Tell me a joke about programming')
puts response
```

### Specifying a Model
```ruby
# Use Flash Lite model
client_lite = GeminiAI::Client.new(ENV['GEMINI_API_KEY'], model: :flash_lite)
response = client_lite.generate_text('Explain AI in simple terms')
```

### Custom Generation Options
```ruby
options = {
  temperature: 0.7,
  max_tokens: 100,
  top_p: 0.9,
  top_k: 40
}

response = client.generate_text('Write a short story', options)
```

## Error Handling
The gem provides robust error handling:
```ruby
begin
  client.generate_text('')  # Raises an error
rescue GeminiAI::Error => e
  puts "An error occurred: #{e.message}"
end
```

## Contributing
1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License
MIT License

## Support
For issues, please file a GitHub issue in the repository.
