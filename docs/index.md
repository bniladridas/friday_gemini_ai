# Friday Gemini AI

A Ruby interface to Google's Gemini AI models, designed for simplicity, security, and power.

## Quick Start

Install the gem:

```bash
gem install friday_gemini_ai
```

Set your API key:

```bash
export GEMINI_API_KEY="your-api-key-here"
```

Generate text:

```ruby
require 'friday_gemini_ai'

client = GeminiAI::Client.new
response = client.generate_text("Hello, Gemini!")
puts response
```

## HarperBot

[HarperBot](reference/harperbot.md) automates code reviews using Gemini AI, analyzing PRs and providing feedback.

## Documentation

- [Quick Start](start/quickstart.md)
- [API Reference](reference/api.md)
- [HarperBot](reference/harperbot.md)
- [Guides](guides/community.md)
- [Testing](reference/testing.md)

## Links

- [RubyGems](https://rubygems.org/gems/friday_gemini_ai)
- [Issues](https://github.com/bniladridas/friday_gemini_ai/issues)
- [Discussions](https://github.com/bniladridas/friday_gemini_ai/discussions)
- [Security](SECURITY.md)
- [License](https://github.com/bniladridas/friday_gemini_ai/blob/main/LICENSE)
