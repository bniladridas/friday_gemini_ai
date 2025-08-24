# Friday Gemini AI

[![Gem Version](https://badge.fury.io/rb/friday_gemini_ai.svg)](https://badge.fury.io/rb/friday_gemini_ai)
[![CI](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/ci.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/ci.yml)
[![Security](https://github.com/bniladridas/friday_gemini_ai/workflows/Security/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/security.yml)
[![Release](https://github.com/bniladridas/friday_gemini_ai/workflows/Release/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/release.yml)

Ruby gem for Google's Gemini AI models.

## Installation

```bash
gem install friday_gemini_ai
```

Create a `.env` file and add your API key:
```
GEMINI_API_KEY=your_api_key_here
```

## Usage

```ruby
require_relative 'lib/gemini'

GeminiAI.load_env

# Use the latest Gemini 2.5 Pro (default)
client = GeminiAI::Client.new
response = client.generate_text('Write a haiku about Ruby')
puts response

# Or choose a specific model
flash_client = GeminiAI::Client.new(model: :flash)  # Gemini 2.5 Flash
pro_client = GeminiAI::Client.new(model: :pro)      # Gemini 2.5 Pro
```

```bash
./bin/gemini test
./bin/gemini generate "Your prompt here"
./bin/gemini chat
```

## Supported Models

| Model Key | Model ID | Description |
|-----------|----------|-------------|
| `:pro` | `gemini-2.5-pro` | Latest and most capable model |
| `:flash` | `gemini-2.5-flash` | Fast and efficient latest model |
| `:flash_2_0` | `gemini-2.0-flash` | Previous generation fast model |
| `:flash_lite` | `gemini-2.0-flash-lite` | Lightweight model |
| `:pro_1_5` | `gemini-1.5-pro` | Gemini 1.5 Pro model |
| `:flash_1_5` | `gemini-1.5-flash` | Gemini 1.5 Flash model |
| `:flash_8b` | `gemini-1.5-flash-8b` | Compact 8B parameter model |

**Model Selection Guide:**
- Use `:pro` for complex reasoning and analysis
- Use `:flash` for fast, general-purpose tasks  
- Use `:flash_2_0` for compatibility with older workflows
- Use `:flash_lite` for simple, lightweight tasks

## What You Can Do

**Text Generation**
- Generate creative content, stories, and articles
- Create explanations and educational content
- Write code comments and documentation

**Conversational AI**
- Build multi-turn chat applications
- Create interactive Q&A systems
- Develop conversational interfaces

**Image Analysis**
- Analyze images with text prompts
- Extract information from visual content
- Generate descriptions of images

**Quick Tasks**
- Test ideas and prompts via CLI
- Prototype AI-powered features
- Generate content with custom parameters

## Features

- Text generation and chat conversations
- Support for Gemini 2.5, 2.0, and 1.5 model families
- Configurable parameters (temperature, tokens, top-p, top-k)
- Error handling and API key security
- CLI interface and .env integration

## Documentation

**Getting Started**
- [Overview](docs/start/overview.md) - Features and capabilities
- [Quickstart](docs/start/quickstart.md) - 5-minute setup

**Reference**
- [API Reference](docs/reference/api.md) - Method documentation
- [Usage Guide](docs/reference/usage.md) - Examples and patterns
- [Models](docs/reference/models.md) - Gemini 2.5 Pro, Flash, and more
- [Capabilities](docs/reference/capabilities.md) - Text generation and chat
- [Cookbook](docs/reference/cookbook.md) - Code recipes
- [Versions](docs/reference/versions.md) - API compatibility

**Guides**
- [Best Practices](docs/guides/practices.md) - Security and performance
- [Troubleshooting](docs/guides/troubleshoot.md) - Common solutions
- [Workflows](docs/guides/workflows.md) - CI/CD and automation
- [Resources](docs/guides/resources.md) - Migration and extras
- [Community](docs/guides/community.md) - Contributing and support
- [Changelog](CHANGELOG.md) - Version history and changes

## Examples

- `examples/basic.rb` - Text generation and chat
- `examples/advanced.rb` - Configuration and error handling

## Testing

```bash
ruby tests/runner.rb
ruby tests/unit/client.rb
ruby tests/integration/api.rb
```

## Contributing

Fork, branch, commit, push, pull request.

## License

MIT - see [LICENSE](LICENSE)
