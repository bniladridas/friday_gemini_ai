# Friday Gemini AI

[![Gem Version](https://badge.fury.io/rb/friday_gemini_ai.svg)](https://badge.fury.io/rb/friday_gemini_ai)
[![CI](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/ci.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/ci.yml)
[![Security](https://github.com/bniladridas/friday_gemini_ai/workflows/Security/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/security.yml)
[![Release](https://github.com/bniladridas/friday_gemini_ai/workflows/Release/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/release.yml)
[![Gemini CLI Integration](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/gemini-cli.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/gemini-cli.yml)

Ruby gem for integrating with Google’s Gemini AI models.

---

## Installation

```bash
gem install friday_gemini_ai
```

Set your API key in `.env`:

```
GEMINI_API_KEY=your_api_key
```

---

## Usage

### Basic Setup
```ruby
require 'friday_gemini_ai'
GeminiAI.load_env  # Loads .env file if present

# Initialize client with default model (Gemini 2.5 Pro)
client = GeminiAI::Client.new

# Or specify a different model
fast_client = GeminiAI::Client.new(model: :flash)  # Gemini 2.5 Flash
image_client = GeminiAI::Client.new(model: :pro_1_5)  # For image analysis
```

### Available Models
```ruby
# Latest models (recommended)
GeminiAI::Client.new(model: :pro)    # Gemini 2.5 Pro
GeminiAI::Client.new(model: :flash)  # Gemini 2.5 Flash

# Image analysis
GeminiAI::Client.new(model: :pro_1_5)  # Gemini 1.5 Pro

# Lightweight options
GeminiAI::Client.new(model: :flash_1_5)  # Gemini 1.5 Flash
GeminiAI::Client.new(model: :flash_8b)   # Compact model
```

### Environment Variables
```bash
# Required
GEMINI_API_KEY=your_api_key_here

# Optional
GEMINI_LOG_LEVEL=debug  # Set log level (debug, info, warn, error)
```

CLI shortcuts:

```bash
./bin/gemini test
./bin/gemini generate "Your prompt"
./bin/gemini chat
```

---

## Models

| Key           | ID                      | Use case                        |
| ------------- | ----------------------- | ------------------------------- |
| `:pro`        | `gemini-2.5-pro`        | Most capable, complex reasoning |
| `:flash`      | `gemini-2.5-flash`      | Fast, general-purpose           |
| `:pro_1_5`    | `gemini-1.5-pro`        | Image-to-text                   |
| `:flash_1_5`  | `gemini-1.5-flash`      | Lightweight tasks               |
| `:flash_8b`   | `gemini-1.5-flash-8b`   | Compact, efficient              |
| `:flash_2_0`  | `gemini-2.0-flash`      | Legacy support                  |
| `:flash_lite` | `gemini-2.0-flash-lite` | Lightweight legacy              |

---

## Capabilities

* **Text:** content generation, explanations, documentation
* **Chat:** multi-turn conversations, Q\&A, assistants
* **Image:** image-to-text analysis and descriptions
* **CLI:** quick prototyping and automation

---

## Features

* **Multiple Model Support**
  - Gemini 2.5, 2.0, and 1.5 families
  - Automatic model selection based on task
  - Backward compatibility with legacy models

* **Text Generation**
  - Flexible prompt handling
  - Configurable parameters (temperature, max tokens, etc.)
  - Safety settings and content filtering

* **Image Analysis**
  - Image-to-text generation
  - Support for base64-encoded images
  - Automatic model selection for image tasks

* **Chat & Conversations**
  - Multi-turn conversations
  - System instructions
  - Message history management

* **Security & Reliability**
  - API key validation and masking
  - Rate limiting (1s default, 3s in CI)
  - Comprehensive error handling
  - Request retries with exponential backoff

---

## Local Development

For local development and testing, including running GitHub Actions workflows locally, see the [Development Guide](docs/guides/development.md).

## GitHub Actions Integration

This repository includes a GitHub Actions workflow for automated code reviews and Gemini CLI integration. The workflow is triggered on pull requests and provides automated feedback.

### Features

- **Automated PR Reviews**: Automatically analyzes pull requests and provides feedback
- **Gemini CLI**: Includes a command-line interface for Gemini AI
- **Concurrent Run Handling**: Automatically cancels in-progress runs when new commits are pushed

### Setup

1. Add the following secrets to your repository:
   - `GEMINI_API_KEY`: Your Google Gemini API key
   - `GITHUB_TOKEN` (automatically provided by GitHub)

2. The workflow is configured in `.github/workflows/codebot.yml` and runs automatically on pull requests and pushes to main.

### Workflow Triggers

- **Pull Requests**: On `opened`, `synchronize`, and `reopened` events
- **Manual Dispatch**: Trigger manually from the Actions tab
- **Push to Main**: Runs the Gemini CLI job on direct pushes to main

### Jobs

1. **Gemini CLI**
   - Runs on workflow dispatch or push to main
   - Installs and verifies Gemini CLI
   - Uses Node.js 20 container

2. **PR Bot**
   - Runs on pull request events
   - Uses Python 3.11 container
   - Installs required dependencies
   - Runs the PR bot script

### Required Permissions

The workflow requires the following permissions:
- `contents: read`
- `pull-requests: write`
- `issues: write`
- `statuses: write`

### Concurrency Control

The workflow includes concurrency control to optimize CI resources:
```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true
```

This ensures that only the most recent workflow run will complete when multiple runs are triggered in quick succession.

## Documentation

* [Overview](docs/start/overview.md)
* [Quickstart](docs/start/quickstart.md)
* [API Reference](docs/reference/api.md)
* [Usage Guide](docs/reference/usage.md)
* [Models](docs/reference/models.md)
* [Cookbook](docs/reference/cookbook.md)
* [Best Practices](docs/guides/practices.md)
* [Troubleshooting](docs/guides/troubleshoot.md)
* [Changelog](CHANGELOG.md)

---

## Examples

### Basic Text Generation
```ruby
require 'friday_gemini_ai'

client = GeminiAI::Client.new
response = client.generate_text('Write a haiku about Ruby')
puts response
```

### Image Analysis
```ruby
require 'base64'

# Read and encode image
image_data = Base64.strict_encode64(File.binread('path/to/image.jpg'))

# Generate text from image
response = client.generate_image_text(
  image_data,
  'Describe this image in detail',
  max_output_tokens: 500
)
puts response
```

### Chat Conversation
```ruby
messages = [
  { role: 'user', content: 'Hello, how are you?' },
  { role: 'model', content: 'I\'m doing well, thank you! How can I assist you today?' },
  { role: 'user', content: 'What can you tell me about Ruby?' }
]

response = client.chat(
  messages,
  system_instruction: 'You are a helpful assistant that specializes in programming languages.',
  temperature: 0.7
)
puts response
```

### Advanced Configuration
```ruby
response = client.generate_text(
  'Write a technical explanation of blockchain',
  {
    max_output_tokens: 1000,
    temperature: 0.3,
    top_p: 0.9,
    top_k: 40,
    safety_settings: [
      {
        category: 'HARM_CATEGORY_DANGEROUS_CONTENT',
        threshold: 'BLOCK_ONLY_HIGH'
      }
    ]
  }
)
```

---

## Development

Run tests:

```bash
bundle exec rake test
```

Lint & fix:

```bash
bundle exec rubocop
bundle exec rubocop -a
```

---

## Contributing

Fork → branch → commit → PR.

## License

MIT – see [LICENSE](LICENSE).