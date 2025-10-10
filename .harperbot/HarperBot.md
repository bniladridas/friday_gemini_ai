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
   - Go to https://github.com/settings/apps (for personal accounts) or your organization's settings to create a new GitHub App.
   - Create a new GitHub App named "HarperBot"
   - Set permissions: Repository permissions - Contents: Read, Issues: Read & Write, Pull requests: Read & Write
   - Generate and download a private key
   - Install the app on your repository

2. **Required Secrets**
    - `GEMINI_API_KEY`: Your Google Gemini API key
    - `HARPER_BOT_APP_ID`: The App ID from the GitHub App settings
    - `HARPER_BOT_PRIVATE_KEY`: The private key content (paste the entire .pem file content)
    - `WEBHOOK_SECRET`: A secret string for webhook signature verification (used in webhook mode)

3. **Installation**
   The bot is automatically set up to run on pull requests. No additional installation is needed.

## How It Works

### Workflow Mode (Legacy)
1. Copy `.harperbot/` and `.github/workflows/codebot.yml` to your repository
2. Set required secrets: `GEMINI_API_KEY`, `HARPER_BOT_APP_ID`, `HARPER_BOT_PRIVATE_KEY`
3. When a PR is opened/updated, the workflow runs and posts analysis

### Webhook Mode (Recommended)
1. Install the GitHub App on your repository
2. The hosted bot automatically receives webhooks for PR events
3. Analysis is posted directly without repository-specific setup

### CLI Mode
Run manually: `python .harperbot/harperbot.py --repo owner/repo --pr 123`

## Security

- **Webhook signature verification**: All webhook requests are validated using HMAC-SHA256
- **GitHub App authentication**: Uses secure app tokens with minimal required permissions
- **Environment variables**: Sensitive keys are stored securely in Vercel/env vars

## Customization

Modify `.harperbot/config.yaml` to adjust:
- Analysis focus: 'all', 'security', 'performance', 'quality'
- Gemini model: 'gemini-2.0-flash', 'gemini-2.5-pro'
- Temperature and token limits

## Troubleshooting

**Workflow Mode:**
1. Check GitHub Actions runs for the workflow
2. Verify secrets are set in repository settings
3. Ensure PR has write permissions

**Webhook Mode:**
1. Check Vercel function logs at https://vercel.com/harpertoken/harperbot/functions
2. Verify GitHub App webhook URL and secret
3. Confirm app is installed on the repository

**Common Issues:**
- Invalid Gemini API key: Check quota and key validity
- Webhook signature errors: Ensure webhook secret matches
- Permission errors: Verify GitHub App has required permissions
