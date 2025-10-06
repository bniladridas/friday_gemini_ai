# Friday Gemini AI

[![CI](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/ci.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/ci.yml)
[![Security](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/security.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/security.yml)
[![Dependencies](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/dependencies.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/dependencies.yml)
[![HarperBot](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/codebot.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/codebot.yml)

Ruby gem for integrating with Google's Gemini AI models.

## Installation

```bash
gem install friday_gemini_ai
```

Set your API key in `.env`:

```
GEMINI_API_KEY=your_api_key
```

For automated PR reviews, install the [HarperBot GitHub App](https://github.com/apps/harperbot).

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

# Lightweight options

# Legacy options
GeminiAI::Client.new(model: :flash_2_0)  # Gemini 2.0 Flash
GeminiAI::Client.new(model: :flash_lite) # Gemini 2.0 Flash Lite
```

### Model Reference

| Key          | ID                     | Use case                        |
| ------------ | ---------------------- | ------------------------------- |
| `:pro`        | `gemini-2.5-pro`        | Most capable, complex reasoning |
| `:flash`      | `gemini-2.5-flash`      | Fast, general-purpose           |
| `:flash_2_0`  | `gemini-2.0-flash`      | Legacy support                  |
| `:flash_lite` | `gemini-2.0-flash-lite` | Lightweight legacy              |

## Capabilities

* **Text:** content generation, explanations, documentation
* **Chat:** multi-turn conversations, Q\&A, assistants
* **Image:** image-to-text analysis and descriptions
* **CLI:** quick prototyping and automation

## Features

* **Multiple Model Support**
  - Gemini 2.5 and 2.0 families
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

## Environment Variables
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

## Local Development

For local development and testing, including running GitHub Actions workflows locally, see the [Development Guide](docs/guides/development.md).

## GitHub Actions Integration

This repository includes a GitHub Actions workflow for automated code reviews and Gemini CLI integration. The workflow is triggered on pull requests and provides automated feedback using HarperBot.

### Features

- **Automated PR Reviews**: HarperBot automatically analyzes pull requests and provides detailed feedback including code quality assessment, potential issues, and improvement suggestions
- **Gemini CLI**: Includes a command-line interface for Gemini AI
- **Concurrent Run Handling**: Automatically cancels in-progress runs when new commits are pushed

### HarperBot PR Analysis Capabilities

HarperBot provides comprehensive automated analysis of pull requests with the following features:

- **Configurable Analysis Focus**: Choose from all, security, performance, or quality-focused reviews
- **Code Quality Assessment**: Evaluates code structure, readability, and adherence to best practices
- **Security Analysis**: Identifies potential security vulnerabilities and suggests mitigations
- **Performance Review**: Analyzes code for performance bottlenecks and optimization opportunities
- **Documentation Check**: Ensures proper documentation and comments for new code
- **Testing Coverage**: Reviews test coverage and suggests additional test cases
- **Issue Detection**: Identifies bugs, edge cases, and potential runtime errors
- **Improvement Suggestions**: Provides actionable recommendations and inline code suggestions

The analysis output includes:
- Summary of changes and purpose
- Quality scores (Code Quality, Maintainability, Security)
- Strengths and areas needing attention
- Specific recommendations and code suggestions
- Actionable next steps
- Inline code suggestions posted as review comments
- Severity levels for easy prioritization
- Collapsible summary for organized feedback
- Clean, focused prompts optimized for accurate analysis

The HarperBot prompt is specifically designed to avoid noise, repetition, and unnecessary content. It enforces clean, focused writing with no clutter.

### Setup

1. Add the following secrets to your repository:
   - `GEMINI_API_KEY`: Your Google Gemini API key
   - `GITHUB_TOKEN` (automatically provided by GitHub)

2. The workflow is configured in `.github/workflows/codebot.yml` and runs HarperBot automatically on pull requests and pushes to main.

3. Optionally, customize HarperBot analysis in `.harperbot/config.yaml` (focus: all/security/performance/quality, model selection, etc.).

### Local Testing

For local development and testing:

1. Set up environment variables in `.env`:
   ```
   GEMINI_API_KEY=your_api_key
   GITHUB_TOKEN=your_github_token
   ```

2. Install Python dependencies:
   ```
   pip install --no-cache-dir PyGithub python-dotenv PyYAML google-generativeai
   ```

3. Run HarperBot on a specific PR:
    ```
    python3 .harperbot/harperbot.py --repo owner/repo --pr number
    ```

   Example:
   ```
    python3 .harperbot/harperbot.py --repo bniladridas/friday_gemini_ai --pr 59
    ```

### Workflow Triggers

- **Pull Requests**: On `opened`, `synchronize`, and `reopened` events
- **Manual Dispatch**: Trigger manually from the Actions tab
- **Push to Main**: Runs the Gemini CLI job on direct pushes to main

### Jobs

1. **CLI**
   - Runs on workflow dispatch or push to main
   - Installs and verifies Gemini CLI
   - Uses Node.js 20 container

2. **Bot**
   - Runs on pull request events
   - Uses Python 3.11 container
   - Installs required dependencies (PyGithub, python-dotenv, PyYAML, google-generativeai)
   - Runs the HarperBot PR analysis script

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

## Contributing

Fork → branch → commit → PR.

## License

MIT – see [LICENSE](LICENSE).