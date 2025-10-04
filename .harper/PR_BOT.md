# PR Bot with Gemini AI

This bot automatically analyzes pull requests using Google's Gemini AI and posts code review comments.

## Features

- Analyzes code changes in pull requests
- Provides code quality feedback
- Identifies potential issues and bugs
- Suggests improvements
- Posts detailed analysis as PR comments

## Setup

1. **Bot Account**
   Create a dedicated GitHub account for HarperBot (e.g., @harper-bot) to post comments as a custom user instead of github-actions.

2. **Required Secrets**
   - `GEMINI_API_KEY`: Your Google Gemini API key
   - `HARPER_BOT_TOKEN`: Personal Access Token from the HarperBot account (with repo, issues, pull_requests scopes)

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
