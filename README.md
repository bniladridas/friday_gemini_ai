# Friday Gemini AI Ruby Gem

[![Gem Version](https://badge.fury.io/rb/friday_gemini_ai.svg)](https://badge.fury.io/rb/friday_gemini_ai)

A Ruby gem for interacting with Google's Gemini AI models. Simple, intuitive, and powerful.

## Documentation

Full documentation is available at [https://bniladridas.github.io/friday_gemini_ai/](https://bniladridas.github.io/friday_gemini_ai/)

## Table of Contents
1. [Installation](#installation)
2. [Configuration](#configuration)
3. [Usage](#usage)
   - [Text Generation](#text-generation)
   - [Chat](#chat)
   - [Error Handling](#error-handling)
4. [Logging](#logging)
5. [Security](#security)
6. [Testing](#testing)
7. [Contributing](#contributing)

## Installation

### From RubyGems
```bash
gem install friday_gemini_ai
```

### Using Bundler
Add to your Gemfile:
```ruby
gem 'friday_gemini_ai'
```

## Configuration

Set your API key:
```bash
export GEMINI_API_KEY='your_api_key_here'
```

## Usage

### Text Generation
```ruby
require 'gemini_ai'

client = GeminiAI::Client.new
response = client.generate_text('Tell me a joke')
puts response
```

### Chat
```ruby
messages = [
  { role: 'user', content: 'Hello' },
  { role: 'model', content: 'Hi there!' },
  { role: 'user', content: 'How are you?' }
]

response = client.chat(messages)
puts response
```

### Error Handling
```ruby
begin
  client.generate_text('')
rescue GeminiAI::Error => e
  puts "Error: #{e.message}"
end
```

## Logging

### Configuration
```ruby
# Set logging level
GeminiAI::Client.logger.level = Logger::INFO

# Log to file
GeminiAI::Client.logger = Logger.new('logfile.log')
```

### Log Levels
- DEBUG: Detailed debug information
- INFO: General operational messages
- WARN: Warning conditions
- ERROR: Error conditions

## Security

### API Key Protection
- Never hardcode API keys
- Use environment variables
- Automatic key masking in logs

## Testing

Run the test suite:
```bash
bundle exec ruby test/gemini_ai_test.rb
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request
