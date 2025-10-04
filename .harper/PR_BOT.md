# PR Bot with Gemini AI

This bot automatically analyzes pull requests using Google's Gemini AI and posts code review comments.

## Features

- Analyzes code changes in pull requests
- Provides code quality feedback
- Identifies potential issues and bugs
- Suggests improvements
- Posts detailed analysis as PR comments

## Setup

1. **GitHub App**
   Create a GitHub App for HarperBot to post comments as a dedicated bot:
   - Go to https://github.com/settings/apps
   - Create a new GitHub App named "HarperBot"
   - Set permissions: Repository permissions - Contents: Read, Issues: Read & Write, Pull requests: Read & Write
   - Generate and download a private key
   - Install the app on your repository

2. **Required Secrets**
   - `GEMINI_API_KEY`: Your Google Gemini API key
   - `HARPER_BOT_APP_ID`: The App ID from the GitHub App settings
   - `HARPER_BOT_PRIVATE_KEY`: The private key content (paste the entire .pem file content)

3. **Installation**
   The bot is automatically set up to run on pull requests. No additional installation is needed.

## How It Works

1. When a PR is opened or updated, the GitHub Action workflow is triggered
2. The bot analyzes the code changes using Gemini AI
3. It posts a detailed comment with:
   - Summary of changes
   - Code quality assessment
   - Potential issues
   - Suggestions for improvement

## Customization

You can modify the analysis prompt in `.github/scripts/pr_bot.py` to adjust:
- The type of feedback provided
- The format of the analysis
- Specific checks to perform

## Troubleshooting

If the bot isn't working:
1. Check the GitHub Actions workflow runs
2. Verify that the `GEMINI_API_KEY` secret is set correctly
3. Ensure the PR has the necessary permissions to post comments
