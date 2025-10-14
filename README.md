# Friday Gemini AI

[![CI](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/ci.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/ci.yml)
[![Security](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/security.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/security.yml)
[![Dependencies](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/dependencies.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/dependencies.yml)
[![HarperBot](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/harperbot.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/harperbot.yml)

Ruby gem for integrating with Google’s Gemini AI models.

## Installation

```bash
gem install friday_gemini_ai
```

Set your API key in `.env`:

```
GEMINI_API_KEY=your_api_key
```

## HarperBot Integration

HarperBot provides automated PR code reviews using Google's Gemini AI. It supports two deployment modes:

### Webhook Mode (Recommended)
- **Self-hosted on Vercel** for centralized, scalable analysis
- Install the [HarperBot GitHub App](https://github.com/apps/harperbot) once for all repositories
- No per-repository setup required
- **Note:** For self-hosting outside Vercel, use a production WSGI server like Gunicorn instead of Flask's development server for security and performance.

### Workflow Mode (Legacy)
- Repository-specific GitHub Actions workflow
- Requires secrets setup per repository
- Automated setup: `curl -fsSL https://raw.githubusercontent.com/bniladridas/friday_gemini_ai/main/bin/setup-harperbot | bash` (use `--update` to update, `--dry-run` to preview)
- **Note:** This is legacy mode for existing users. New installations should use Webhook Mode for better scalability and centralized management

For detailed setup instructions, see [harperbot/HarperBot.md](harperbot/HarperBot.md).

## Usage

### Basic Setup

**Security Note for Automated Setup:** The recommended `curl | bash` method downloads and executes code from the internet. For security, review the script at https://github.com/bniladridas/friday_gemini_ai/blob/main/bin/setup-harperbot before running. Alternatively, download first: `curl -O https://raw.githubusercontent.com/bniladridas/friday_gemini_ai/main/bin/setup-harperbot`, inspect, then `bash setup-harperbot`.

```ruby
require 'friday_gemini_ai'
GeminiAI.load_env

client = GeminiAI::Client.new               # Default: gemini-2.5-pro
fast_client = GeminiAI::Client.new(model: :flash)
```

### Model Reference

| Key           | ID                      | Use case                        |
| ------------- | ----------------------- | ------------------------------- |
| `:pro`        | `gemini-2.5-pro`        | Most capable, complex reasoning |
| `:flash`      | `gemini-2.5-flash`      | Fast, general-purpose           |
| `:flash_2_0`  | `gemini-2.0-flash`      | Legacy support                  |
| `:flash_lite` | `gemini-2.0-flash-lite` | Lightweight legacy              |

## Capabilities

* **Text:** content generation, summaries, documentation
* **Chat:** multi-turn Q&A and assistants
* **Image:** image-to-text analysis
* **CLI:** for quick prototyping and automation

## Features

* **Multiple Model Support:** Gemini 2.5 + 2.0 families with automatic fallback
* **Text Generation:** configurable parameters, safety settings
* **Image Analysis:** base64 image input, detailed descriptions
* **Chat:** context retention, system instructions
* **Security:** API key masking, retries, and rate limits (1s default, 3s CI)

## Migration Guide

Gemini 1.5 models have been deprecated.
Use:

* `:pro` → `gemini-2.5-pro`
* `:flash` → `gemini-2.5-flash`

Legacy options (`:flash_2_0`, `:flash_lite`) remain supported for backward compatibility.

## Environment Variables

```bash
# Required
GEMINI_API_KEY=your_api_key_here

# Optional
GEMINI_LOG_LEVEL=debug  # debug | info | warn | error
```

### CLI Shortcuts

```bash
./bin/gemini test
./bin/gemini generate "Your prompt"
./bin/gemini chat
```

## GitHub Actions Integration

Friday Gemini AI includes a built-in GitHub Actions workflow for automated PR reviews via **HarperBot**, powered by Gemini AI.

💡 **Install the [HarperBot GitHub App](https://github.com/apps/harperbot)** for automated PR reviews across repositories.

### HarperBot – Automated PR Analysis

HarperBot provides AI-driven code review and analysis directly in pull requests.

**Key Capabilities:**

* Configurable focus: `all`, `security`, `performance`, `quality`
* Code quality, documentation, and test coverage analysis
* Security & performance issue detection
* Inline review comments with actionable suggestions
* Clean, minimal, and structured feedback output

### Setup

**Workflow Mode (default)**

1. Add repository secrets:

   * `GEMINI_API_KEY`
   * `GITHUB_TOKEN` (auto-provided by GitHub)
2. Configure `.github/workflows/harperbot.yml`
3. Optional: tune behavior via `harperbot/config.yaml`

**Webhook Mode (Recommended)**

* Deploy `webhook-vercel` branch to Vercel
* Create a GitHub App and set environment variables:
  - `GEMINI_API_KEY`: Your Google Gemini API key
  - `HARPER_BOT_APP_ID`: App ID from your GitHub App settings (found under "About" section)
  - `HARPER_BOT_PRIVATE_KEY`: Private key content (paste the entire .pem file)
  - `WEBHOOK_SECRET`: Random secret string for webhook verification
* Install the GitHub App on your repositories
* Webhooks will handle PR events automatically
* Preferred for scalability and centralized management

### Workflow Highlights

* **Pull Requests:** triggered on open, update, or reopen
* **Push to main:** runs Gemini CLI verification
* **Concurrency control:** cancels redundant runs for efficiency

Required permissions:

```yaml
permissions:
  contents: read
  pull-requests: write
  issues: write
  statuses: write
```

## Local Development & Testing

```bash
bundle exec rake test          # Run tests
bundle exec rake rubocop       # Optional lint check
gem build *.gemspec            # Verify build
```

### Test Workflows Locally

Using [act](https://github.com/nektos/act):

```bash
brew install act
act -j test --container-architecture linux/amd64
```

## Examples

### Text Generation

```ruby
client = GeminiAI::Client.new
puts client.generate_text('Write a haiku about Ruby')
```

### Image Analysis

```ruby
image_data = Base64.strict_encode64(File.binread('path/to/image.jpg'))
puts client.generate_image_text(image_data, 'Describe this image')
```

### Chat

```ruby
messages = [
  { role: 'user', content: 'Hello!' },
  { role: 'model', content: 'Hi there!' },
  { role: 'user', content: 'Tell me about Ruby.' }
]
puts client.chat(messages, system_instruction: 'Be helpful and concise.')
```

## Conventional Commits

Consistent commit messages are enforced via a local Git hook.

```bash
cp scripts/commit-msg .git/hooks/
chmod +x .git/hooks/commit-msg
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
Example:

```bash
git commit -m "feat: add user authentication"
```

## Documentation

* [Overview](docs/start/overview.md)
* [Quickstart](docs/start/quickstart.md)
* [API Reference](docs/reference/api.md)
* [Cookbook](docs/reference/cookbook.md)
* [Best Practices](docs/guides/practices.md)
* [Changelog](CHANGELOG.md)

## Contributing

Fork → Branch → Commit → Pull Request.

## License

MIT – see [LICENSE](LICENSE).