# Quickstart

Get started with Friday Gemini AI in under 5 minutes.

> [!NOTE]
> This guide assumes you have basic Ruby knowledge. For detailed API documentation, see the [API Reference](../reference/api.md).

## Prerequisites

| Requirement | Details |
| ----------- | ------- |
| Ruby | 2.6 or higher |
| Google AI API Key | From [Google AI Studio](https://makersuite.google.com/app/apikey) |

## Step 1: Installation

```bash
gem install friday_gemini_ai
```

Or add to your Gemfile:
```ruby
gem 'friday_gemini_ai'
```

## Step 2: Get API Key

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy your API key (starts with `AIza...`)

## Step 3: Set Up Environment

Create a `.env` file in your project root:
```bash
echo "GEMINI_API_KEY=your_api_key_here" > .env
```

Replace `your_api_key_here` with your actual API key.

## Step 4: First Request

Create a Ruby file and add:

```ruby
require_relative 'src/gemini'

# Load environment variables
GeminiAI.load_env

# Create client
client = GeminiAI::Client.new

# Generate text
response = client.generate_text("Write a haiku about programming")
puts response
```

Run it:
```bash
ruby your_file.rb
```

## Step 5: Test CLI

Test your setup with the CLI:
```bash
./bin/gemini test
```

You should see:
```
Test successful!
Response: Connection successful!
```

## Quick Examples

### Generate Creative Content
```ruby
response = client.generate_text(
  "Write a short story about a robot learning to paint",
  temperature: 0.8,
  max_tokens: 200
)
```

### Have a Conversation
```ruby
messages = [
  { role: 'user', content: 'What is Ruby?' },
  { role: 'model', content: 'Ruby is a programming language.' },
  { role: 'user', content: 'What makes it special?' }
]

response = client.chat(messages)
```

### Interactive CLI Chat
```bash
./bin/gemini chat
```

## Common Issues

| Issue | Solution |
| ----- | -------- |
| "API key is required" | Ensure your `.env` file exists and contains `GEMINI_API_KEY=AIza...` |
| "Invalid API key format" | Check that your API key starts with `AIza` and has no extra spaces |
| Permission errors on CLI | Make the CLI executable: `chmod +x bin/gemini` |

## Next Steps

- [Usage Guide](../reference/usage.md) - Comprehensive examples and patterns
- [API Reference](../reference/api.md) - Complete method documentation
- [Models Guide](../reference/models.md) - Understanding different Gemini models
- [Error Handling](../guides/troubleshoot.md) - Common issues and solutions
