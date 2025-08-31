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

```ruby
require_relative 'lib/gemini'
GeminiAI.load_env

# Default: Gemini 2.5 Pro
client = GeminiAI::Client.new
puts client.generate_text('Write a haiku about Ruby')

# Specific models
GeminiAI::Client.new(model: :flash) # Gemini 2.5 Flash
GeminiAI::Client.new(model: :pro)   # Gemini 2.5 Pro
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

* Gemini 2.5, 2.0, and 1.5 families
* Image-to-text auto-selection (`pro_1_5`)
* Configurable parameters (temperature, tokens, etc.)
* Rate limiting (1s default, 3s in CI)
* Secure API key + prompt validation
* Robust error handling and CLI integration

---

## Local Development

For local development and testing, including running GitHub Actions workflows locally, see the [Development Guide](docs/guides/development.md).

## GitHub Actions Integration

### Gemini CLI Workflow

The Gemini Tools workflow provides two main jobs:

1. **Gemini CLI**
   - Triggered on workflow_dispatch or push to main
   - Installs and verifies the Gemini CLI
   - Available for manual execution of AI tasks

2. **PR Bot**
   - Automatically runs on PR events (open, sync, reopen)
   - Analyzes PR changes using Gemini AI
   - Posts review comments with AI-generated feedback
   - Supports both Node.js and Python environments

### Required Secrets
   - `GITHUB_TOKEN` (automatically provided by GitHub)

2. The workflow is already configured in `.github/workflows/gemini-cli.yml` and will run automatically on pull requests.

### Manual Trigger

You can also manually trigger the workflow from the Actions tab in your GitHub repository:
1. Go to Actions
2. Select "Gemini Tools" workflow
3. Click "Run workflow"

### Customization

You can customize the behavior by modifying the workflow file (`.github/workflows/gemini-cli.yml`). The workflow includes:

- **Gemini CLI**: For direct interaction with Google's Generative AI
- **PR Bot**: For automated code reviews on pull requests

### Required Permissions

The workflow requires the following permissions:
- `contents: read`
- `pull-requests: write`
- `issues: write`
- `statuses: write`

These are already configured in the workflow file.

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

* `examples/basic.rb` – text generation
* `examples/advanced.rb` – advanced configs
* `examples/modelsdemo.rb` – model comparison

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