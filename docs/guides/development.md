# Development Guide

This guide covers the essential setup for using the Gemini CLI with GitHub Actions.

## Local Testing with act

### Prerequisites
1. [Docker](https://www.docker.com/products/docker-desktop)
2. [act](https://github.com/nektos/act) - A tool to run GitHub Actions locally

### Setup
1. Install act:
   ```bash
   # macOS (using Homebrew)
   brew install act
   
   # Linux
   curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
   ```

2. Test the workflow:
   ```bash
   act -j run-gemini-cli --container-architecture linux/amd64 --secret GEMINI_API_KEY=your_api_key
   ```

## GitHub Actions Integration

### Setup
1. Get a Gemini API key from [Google AI Studio](https://aistudio.google.com/apikey)
2. Add it as a GitHub Secret named `GEMINI_API_KEY`

### Example Workflow
```yaml
name: Gemini PR Review

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: google-github-actions/run-gemini-cli@v1
        with:
          command: /review
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
```

### Manual Triggers
- `@gemini-cli /review` - Review a PR
- `@gemini-cli /triage` - Triage an issue
- `@gemini-cli explain this code` - Get code explanations
