# Development Guide

This guide covers the setup and development of the Gemini AI integration for GitHub Actions.

## Local Development Setup

### Prerequisites
1. [Docker](https://www.docker.com/products/docker-desktop)
2. [act](https://github.com/nektos/act) - For running GitHub Actions locally
3. Python 3.11+ (for PR bot development)
4. Node.js 20+ (for Gemini CLI)
5. [GitHub CLI](https://cli.github.com/) (recommended for PR management)

### Local Testing with act

1. Install act:
   ```bash
   # macOS (using Homebrew)
   brew install act
   
   # Linux
   curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
   ```

2. Test the PR Bot locally:
   ```bash
   # Run PR bot job
   act -j pr-bot --container-architecture linux/amd64 \
       -s GEMINI_API_KEY=your_api_key \
       -s GITHUB_TOKEN=your_github_token
   ```

3. Test Gemini CLI installation:
   ```bash
   # Run Gemini CLI job
   act -j gemini-cli --container-architecture linux/amd64
   ```

## GitHub Actions Integration

### Setup
1. Get a Gemini API key from [Google AI Studio](https://aistudio.google.com/apikey)
2. Add it as a GitHub Secret named `GEMINI_API_KEY`

### Required Permissions

The workflow requires the following permissions:

```yaml
permissions:
  contents: read
  pull-requests: write
  issues: write
  statuses: write
```

## Workflow Components

The Gemini integration consists of two main components:

### 1. Gemini CLI Job
- Installs and verifies Gemini CLI
- Available for manual execution
- Runs on workflow_dispatch or push to main

### 2. PR Bot Job
- Automated PR analysis using Gemini AI
- Runs on pull request events
- Posts review comments with AI feedback
- Supports both Node.js and Python environments

## Security Considerations

1. **Secrets Management**:
   - Store sensitive data in GitHub Secrets
   - Use minimal required permissions
   - Never hardcode API keys

2. **Dependencies**:
   - Always pin versions in workflows
   - Regularly update dependencies
   - Use Dependabot for security updates

3. **Code Review**:
   - All PRs require review
   - Run security scans on PRs
   - Use branch protection rules

### 1. Gemini CLI
- Installs the `@google/generative-ai` package
- Provides a command-line interface for Gemini AI
- Runs on workflow dispatch or push to main

### 2. PR Bot
- Python-based bot for automated code reviews
- Analyzes pull requests and provides feedback
- Runs automatically on pull request events

## Development

### Testing the PR Bot Locally

1. Install Python dependencies:
   ```bash
   pip install PyGithub python-dotenv
   ```

2. Create a `.env` file with your credentials:
   ```
   GITHUB_TOKEN=your_github_token
   GEMINI_API_KEY=your_gemini_api_key
   ```

3. Run the bot locally:
   ```bash
   # Set required environment variables
   export GITHUB_REPOSITORY="your_username/your_repo"
   export GITHUB_REF="refs/pull/1/head"  # PR number
   
   # Run the bot
   python3 .github/workflows/pr_bot.py
   ```

## Security Considerations

- Never expose your `GEMINI_API_KEY` in your code or logs
- Use GitHub Secrets for sensitive information
- Review all third-party actions and dependencies
- Follow the principle of least privilege for GitHub tokens
