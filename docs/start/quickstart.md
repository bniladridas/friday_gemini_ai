# Quickstart

Get started with Friday Gemini AI in minutes.

## Prerequisites

- Ruby 2.6 or higher
- Google AI API key from [Google AI Studio](https://makersuite.google.com/app/apikey)

## Installation

Install the gem:

```bash
gem install friday_gemini_ai
```

Or add to Gemfile:

```ruby
gem 'friday_gemini_ai'
```

## Get API Key

1. Visit Google AI Studio
2. Sign in with Google account
3. Create API key
4. Copy the key (starts with `AIza...`)

## Setup Environment

Create `.env` file:

```bash
echo "GEMINI_API_KEY=your_api_key_here" > .env
```

Replace with your actual key.

## First Request

Create a Ruby file:

```ruby
require 'friday_gemini_ai'

client = GeminiAI::Client.new
response = client.generate_text("Hello, world!")
puts response
```

Run it:

```bash
ruby your_file.rb
```

## Test CLI

Test with CLI:

```bash
./bin/gemini test
```

Should show success message.

## Examples

Creative content:

```ruby
response = client.generate_text(
  "Write a story",
  temperature: 0.8
)
```

Conversation:

```ruby
messages = [
  { role: 'user', content: 'What is Ruby?' }
]
response = client.chat(messages)
```

Interactive chat:

```bash
./bin/gemini chat
```

## Common Issues

- API key required: Check `.env` file
- Invalid key: Ensure starts with `AIza`
- CLI permission: Run `chmod +x bin/gemini`

## Next Steps

- [Usage Guide](../reference/usage.md)
- [API Reference](../reference/api.md)
- [Models](../reference/models.md)
- [Troubleshooting](../guides/troubleshoot.md)
