# Setup Guide

## API Key Configuration

### For Development

1. **Get your Gemini API Key:**
   - Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create a new API key
   - Copy the key (it should start with `AIza`)

2. **Set the environment variable:**
   ```bash
   export GEMINI_API_KEY="your_api_key_here"
   ```

   Or create a `.env` file in the project root:
   ```
   GEMINI_API_KEY=your_api_key_here
   ```

### For CI/CD (GitHub Actions)

1. **Add the API key as a repository secret:**
   - Go to your repository on GitHub
   - Navigate to Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `GEMINI_API_KEY`
   - Value: Your actual API key

2. **The workflow is already configured** to use this secret in `.github/workflows/ci.yml`

### Testing

- **Unit tests** use mock API keys and don't require a real key
- **Integration tests** require a valid `GEMINI_API_KEY` environment variable
- Tests will be skipped if no API key is available

## Running Tests

```bash
# Install dependencies
bundle install

# Run all tests
bundle exec ruby tests/runner.rb

# Run specific test suites
bundle exec ruby tests/unit/client.rb      # Unit tests (no API key needed)
bundle exec ruby tests/integration/api.rb # Integration tests (API key required)
```