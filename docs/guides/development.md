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

### Required Permissions

When setting up GitHub Actions workflows that interact with pull requests or issues, use the minimal required permissions:

```yaml
permissions:
  contents: read
  pull-requests: write
  issues: write
```

> **Important Security Note**: Workflows triggered by `pull_request` from forks run with a read-only token by default. While you can use `pull_request_target` to obtain write permissions, this must be done with extreme care due to potential security implications. Always review the security considerations in the [GitHub Docs](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#pull_request_target) before using `pull_request_target`.

### Example Workflow

```yaml
name: Gemini PR Review

on:
  pull_request:
    types: [opened, synchronize, reopened]

permissions:
  contents: read
  pull-requests: write
  issues: write

jobs:
  review:
    runs-on: ubuntu-latest
    container: node:20-slim
    steps:
      - name: Install Gemini CLI
        run: npm install -g @google/gemini-cli

      - name: Run PR Review
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
        run: gemini review
```

### Manual Triggers

Slash commands can be used in issue or pull request comments to trigger specific actions. Note that these commands only work when a workflow is configured to listen to `issue_comment` events.

Available commands:
- `/review` - Review a PR
- `/triage` - Triage an issue

Example workflow for handling slash commands:

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
    if: startsWith(github.event.comment.body, '/review') || startsWith(github.event.comment.body, '/triage')
    steps:
      - name: Install Gemini CLI
        run: npm install -g @google/gemini-cli

      - name: Process Command
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
        run: |
          if [[ ${{ github.event.comment.body }} == /review* ]]; then
            gemini review
          elif [[ ${{ github.event.comment.body }} == /triage* ]]; then
            gemini triage
          fi
```
- `@gemini-cli explain this code` - Get code explanations
