# GitHub Workflows

This repository uses GitHub Actions for automated CI/CD, security, and maintenance.

## Workflows Overview

### **CI** (`.github/workflows/ci.yml`)
**Purpose**: Comprehensive testing across platforms  
**Triggers**: Push/PR to main or develop branches  
**Features**:
- Tests on Ubuntu, macOS, Windows
- Tests Ruby 3.1, 3.2, 3.3
- Runs linting (RuboCop)
- Security scanning (Bundler Audit, Brakeman)
- Builds gem artifact

### **Release** (`.github/workflows/release.yml`)
**Purpose**: Automated releases and publishing  
**Triggers**: Git tags (e.g., `v1.0.0`)  
**Features**:
- Pre-release testing
- Publishes to RubyGems.org
- Publishes to GitHub Packages
- Creates GitHub Release with changelog
- Attaches gem file to release

### ⚡ **Quick Check** (`.github/workflows/push.yml`)
**Purpose**: Fast feedback on main branch  
**Triggers**: Push to main branch  
**Features**:
- Quick test run for immediate feedback
- Lightweight validation

### **Dependencies** (`.github/workflows/dependencies.yml`)
**Purpose**: Keep dependencies up to date  
**Triggers**: Weekly (Mondays 9 AM UTC) + manual  
**Features**:
- Updates gems conservatively
- Runs tests to ensure compatibility
- Creates PR with dependency updates

### **Security** (`.github/workflows/security.yml`)
**Purpose**: Regular security scanning  
**Triggers**: Daily (2 AM UTC) + push to main + manual  
**Features**:
- Bundler vulnerability audit
- Brakeman security analysis
- Uploads security reports
- Fails on vulnerabilities

### **HarperBot** (`.harper/codebot.yml`)
**Purpose**: Automated PR analysis and code review  
**Triggers**: Pull requests (opened, synchronize, reopened) + manual  
**Features**:
- Automated code quality assessment
- Security vulnerability detection
- Performance analysis and optimization suggestions
- Documentation and testing coverage review
- Issue identification with severity levels
- Clean, organized feedback with collapsible sections
- Powered by Gemini AI for intelligent analysis

### **Cleanup** (`.github/workflows/cleanup.yml`)
**Purpose**: Repository maintenance  
**Triggers**: Monthly (1st day, 3 AM UTC) + manual  
**Features**:
- Closes stale issues (60 days inactive)
- Closes stale PRs (30 days inactive)
- Cleans up old artifacts (30+ days)

## Usage

### For Development
- **Push/PR**: CI workflow runs automatically
- **Security**: Runs daily, check Actions tab for results

### For Releases
1. Update version in `src/core/version.rb`
2. Update `CHANGELOG.md` (optional)
3. Create and push tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
4. Release workflow publishes automatically

### Manual Triggers
All workflows support manual triggering via GitHub Actions UI:
- Go to Actions tab
- Select workflow
- Click "Run workflow"

### Rerunning Failed Workflows
To rerun a failed workflow run:
- Go to Actions tab
- Find the failed run
- Click "Re-run jobs" or "Re-run failed jobs"
- Or use GitHub CLI: `gh run rerun <run-id>`

## Required Secrets

Add these secrets in repository settings:

- `GEMINI_API_KEY` - For integration tests
- `RUBYGEMS_API_KEY` - For publishing to RubyGems.org
- `GITHUB_TOKEN` - Automatically provided by GitHub

## Status Badges

Add to README.md:
```markdown
[![CI](https://github.com/bniladridas/friday_gemini_ai/workflows/CI/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/ci.yml)
[![Security](https://github.com/bniladridas/friday_gemini_ai/workflows/Security/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/security.yml)
[![HarperBot](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/codebot.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/codebot.yml)
```