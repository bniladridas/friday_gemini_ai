# Friday Gemini AI

[![CI](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/ci.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/ci.yml)

Ruby gem for integrating with Google’s Gemini AI models.

---

## Installation

```bash
gem install friday_gemini_ai
````

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

For local testing and workflows, see the [Development Guide](docs/guides/development.md).

---

## GitHub Actions Integration

The Gemini Tools workflow provides:

1. **Gemini CLI** – installs and verifies the CLI for AI tasks
2. **PR Bot** – analyzes PR changes with Gemini AI and posts feedback

See `.github/workflows/codebot.yml` for configuration.

Required permissions:

* `contents: read`
* `pull-requests: write`
* `issues: write`
* `statuses: write`

---

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