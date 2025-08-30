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

## Manual Triggers

You can interact with the Gemini AI directly in your GitHub issues and pull requests using slash commands. Note that these commands require a workflow to be set up to listen to `issue_comment` events.

### Setting Up Slash Commands

Add this workflow to your repository (e.g., `.github/workflows/slash-commands.yml`):

```yaml
name: Slash Command Handler

on:
  issue_comment:
    types: [created]

permissions:
  contents: read
  pull-requests: write
  issues: write

jobs:
  handle-command:
    runs-on: ubuntu-latest
    container: node:20-slim
    if: startsWith(github.event.comment.body, '/review') || 
        startsWith(github.event.comment.body, '/triage') ||
        startsWith(github.event.comment.body, '@gemini-cli')
    steps:
      - name: Install Gemini CLI
        run: npm install -g @google/gemini-cli

      - name: Process Command
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
        run: |
          COMMENT_BODY="${{ github.event.comment.body }}"
          if [[ "$COMMENT_BODY" == "/review"* ]]; then
            gemini review
          elif [[ "$COMMENT_BODY" == "/triage"* ]]; then
            gemini triage
          elif [[ "$COMMENT_BODY" == *"@gemini-cli"* ]]; then
            # Handle @gemini-cli commands
            if [[ "$COMMENT_BODY" == *"explain this code"* ]]; then
              gemini explain
            elif [[ "$COMMENT_BODY" == *"write tests"* ]]; then
              gemini test
            fi
          fi
```

### Available Commands

#### Code Review
```markdown
/review
# or
@gemini-cli /review
```
Reviews the pull request and provides feedback on code quality and potential issues.

#### Issue Triage
```markdown
/triage
# or
@gemini-cli /triage
```
Helps categorize and prioritize new issues.

#### Code Explanation
```markdown
@gemini-cli explain this code
```
Explains the code in the current context.

#### Test Generation
```markdown
@gemini-cli write tests for this
```
Generates test cases for the current code.

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