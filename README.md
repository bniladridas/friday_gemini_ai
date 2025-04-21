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
4. [Real-World Examples](#real-world-examples)
5. [Logging](#logging)
6. [Security](#security)
7. [Testing](#testing)
8. [Contributing](#contributing)

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

## Real-World Examples

Here are some examples of the gem in action with real responses from the Gemini AI models:

### Creative Writing

**Prompt:**
```ruby
client.generate_text('Write a haiku about Ruby programming')
```

**Response:**
```
Gems sparkle bright red,
Code flows with elegant ease,
Joy in every line.
```

### Technical Information

**Prompt:**
```ruby
messages = [
  { role: 'user', content: 'Hello, can you tell me what Ruby is?' },
  { role: 'model', content: 'Ruby is a dynamic, object-oriented programming language known for its simplicity and productivity.' },
  { role: 'user', content: 'What are some popular Ruby frameworks?' }
]

client.chat(messages)
```

**Response:**
```
Here are some popular Ruby frameworks, categorized for clarity:

**Web Frameworks (The most common use of Ruby frameworks):**

*   **Ruby on Rails (Rails):**  By far the most popular and widely used.  It's a full-stack framework, meaning it provides tools and conventions for building everything from the front-end (views) to the back-end (database interactions, server logic).  It emphasizes convention over configuration, making it faster to develop applications.  Ideal for building web applications of all sizes, from simple blogs to complex e-commerce platforms.

*   **Sinatra:**  A lightweight and flexible framework.  It's considered a Domain Specific Language (DSL) for quickly creating web applications with minimal effort.  It's great for smaller projects, APIs, and prototyping.  It gives you more control over the structure of your application compared to Rails.

... (abbreviated for brevity)
```

### Customizing Parameters

**Prompt:**
```ruby
client.generate_text('Explain what an API is in one sentence', temperature: 0.3, max_tokens: 50)
```

**Response:**
```
An API (Application Programming Interface) is a set of rules and specifications that allows different software applications to communicate and exchange data with each other.
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

For CI-friendly tests that don't require an API key:
```bash
bundle exec rake ci_test
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request
