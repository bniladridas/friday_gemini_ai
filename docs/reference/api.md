# Friday Gemini AI - API Reference

## Overview

This document describes the API for the Friday Gemini AI Ruby gem, which provides a Ruby interface to Google's Gemini AI models.

> [!NOTE]
> This reference covers the public API. For internal implementation details, see the source code.

## Installation

```ruby
gem install friday_gemini_ai
```

Or in your Gemfile:
```ruby
gem 'friday_gemini_ai'
```

## Quick Start

```ruby
require_relative 'src/gemini'

# Load environment variables (if using .env file)
GeminiAI.load_env

# Create client
client = GeminiAI::Client.new

# Generate text
response = client.generate_text("Hello, world!")
puts response
```

## Classes

### `GeminiAI::Client`

Main client class for interacting with Gemini AI API.

#### Constructor

```ruby
GeminiAI::Client.new(api_key = nil, model: :pro)
```

**Parameters:**

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| `api_key` | String, optional | API key for Gemini AI. If not provided, uses `ENV['GEMINI_API_KEY']` |
| `model` | Symbol, optional | Model to use. Options: `:pro`, `:flash`, `:flash_lite`. Default: `:pro` |

**Example:**
```ruby
# Use environment variable
client = GeminiAI::Client.new

# Specify API key
client = GeminiAI::Client.new('your_api_key_here')

# Use different model
client = GeminiAI::Client.new(model: :flash_lite)
```

#### Methods

##### `generate_text(prompt, options = {})`

Generate text from a prompt.

**Parameters:**
- `prompt` (String): Text prompt for generation
- `options` (Hash, optional): Generation options

**Options:**

| Option | Type | Description | Default |
| ------ | ---- | ----------- | ------- |
| `temperature` | Float | Controls randomness (0.0-1.0) | 0.7 |
| `max_tokens` | Integer | Maximum tokens to generate | 1024 |
| `top_p` | Float | Nucleus sampling parameter | 0.9 |
| `top_k` | Integer | Top-k sampling parameter | 40 |

**Returns:** String - Generated text response

**Example:**
```ruby
# Basic usage
response = client.generate_text("Write a haiku about Ruby")

# With custom parameters
response = client.generate_text(
  "Explain quantum computing",
  temperature: 0.3,
  max_tokens: 200
)
```

##### `chat(messages, options = {})`

Conduct a multi-turn conversation.

**Parameters:**
- `messages` (Array): Array of message hashes
- `options` (Hash, optional): Same as `generate_text`

**Message Format:**
```ruby
{
  role: 'user' | 'model',
  content: 'message text'
}
```

**Returns:** String - AI response

**Example:**
```ruby
messages = [
  { role: 'user', content: 'Hello' },
  { role: 'model', content: 'Hi there!' },
  { role: 'user', content: 'How are you?' }
]

response = client.chat(messages)
```

##### `generate_image_text(image_base64, prompt, options = {})`

Analyze an image with a text prompt.

**Parameters:**
- `image_base64` (String): Base64 encoded image data
- `prompt` (String): Text prompt about the image
- `options` (Hash, optional): Same as `generate_text`

**Returns:** String - Analysis response

**Example:**
```ruby
image_data = Base64.encode64(File.read('image.jpg'))
response = client.generate_image_text(image_data, "What's in this image?")
```

## Error Classes

| Error Class | Description |
| ----------- | ----------- |
| `GeminiAI::Error` | Base error class for all gem-related errors |
| `GeminiAI::APIError` | Raised when API returns an error response |
| `GeminiAI::AuthenticationError` | Raised when API key is invalid or missing |
| `GeminiAI::RateLimitError` | Raised when API rate limit is exceeded |
| `GeminiAI::InvalidRequestError` | Raised when request parameters are invalid |
| `GeminiAI::NetworkError` | Raised when network communication fails |

## Utility Classes

### `GeminiAI::Utils::Loader`

Utility for loading environment variables from .env files.

```ruby
GeminiAI::Utils::Loader.load('.env')
# or
GeminiAI.load_env('.env')
```

### `GeminiAI::Utils::Logger`

Centralized logging utility with API key masking.

```ruby
GeminiAI::Utils::Logger.info("Message")
GeminiAI::Utils::Logger.debug("Debug info")
```

## Models

### Available Models

| Symbol | Model ID | Description |
| ------ | -------- | ----------- |
| `:pro` / `:flash` | `gemini-2.0-flash` | Full-featured model |
| `:flash_lite` | `gemini-2.0-flash-lite` | Lightweight, faster model |

### Model Selection

```ruby
# Default (pro/flash)
client = GeminiAI::Client.new

# Lite model for faster responses
client = GeminiAI::Client.new(model: :flash_lite)
```

## Configuration

### Environment Variables

| Variable | Description | Required |
| -------- | ----------- | -------- |
| `GEMINI_API_KEY` | Your Google Gemini API key | Yes |

### .env File Support

Create a `.env` file in your project root:
```
GEMINI_API_KEY=your_api_key_here
```

Load it in your code:
```ruby
GeminiAI.load_env
```

## Error Handling

```ruby
begin
  client = GeminiAI::Client.new
  response = client.generate_text("Hello")
rescue GeminiAI::AuthenticationError => e
  puts "Invalid API key: #{e.message}"
rescue GeminiAI::APIError => e
  puts "API error: #{e.message}"
rescue GeminiAI::Error => e
  puts "Gemini AI error: #{e.message}"
end
```

## CLI Usage

The gem includes a command-line interface:

```bash
# Test connection
./bin/gemini test

# Generate text
./bin/gemini generate "Your prompt here"

# Interactive chat
./bin/gemini chat

# Help
./bin/gemini help
```

## Examples

See the `examples/` directory for comprehensive usage examples:
- `examples/basic_usage.rb` - Basic text generation and chat
- `examples/advanced_usage.rb` - Advanced configuration and error handling
