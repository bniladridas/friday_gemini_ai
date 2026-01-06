# CI/CD Workflows

This document describes the automated workflows configured for the Friday Gemini AI project.

## Overview

The project uses GitHub Actions for continuous integration, automated testing, security scanning, and release management. All workflows are defined in `.github/workflows/` and run automatically based on triggers like pushes, pull requests, and schedules.

## Workflows

### CI (`ci.yml`)
**Purpose**: Comprehensive testing and validation pipeline
**Triggers**: Push to main/develop, pull requests to main/develop
**Jobs**:
- `test`: Matrix testing across Ubuntu/macOS/Windows with Ruby 3.2/3.3
- `lint`: Code style checking with RuboCop
- `security`: Security scanning with Bundler Audit
- `build`: Gem packaging and artifact upload

### Analysis (`analysis.yml`)
**Purpose**: Code quality and security analysis
**Triggers**: Pull requests
**Jobs**:
- Code analysis with various security and quality tools
- Automated issue detection and reporting

### E2E (`e2e.yml`)
**Purpose**: End-to-end testing
**Triggers**: Push to main/develop
**Jobs**:
- Comprehensive end-to-end test suite
- Integration testing across different scenarios

### Release (`release.yml`)
**Purpose**: Automated release management with release-please
**Triggers**: Push to main
**Jobs**:
- Automated version bumping based on conventional commits
- Changelog generation and GitHub release creation
- Publishing to RubyGems and GitHub Packages

### Fix Changelog (`fix-changelog.yml`)
**Purpose**: Automatic changelog formatting for release PRs
**Triggers**: Pull requests with release-please branch names
**Jobs**:
- Removes extra blank lines in CHANGELOG.md
- Commits formatting fixes automatically

### Security (`security.yml`)
**Purpose**: Automated security monitoring and scanning
**Triggers**: Scheduled (daily), push to main
**Jobs**:
- Security vulnerability scanning
- Dependency security checks
- Automated security report generation

### Dependencies (`dependencies.yml`)
**Purpose**: Automated dependency management
**Triggers**: Scheduled, pull requests
**Jobs**:
- Dependency updates and security patches
- Automated PR creation for dependency bumps

### Cleanup (`cleanup.yml`)
**Purpose**: Repository maintenance and cleanup
**Triggers**: Scheduled
**Jobs**:
- Automated cleanup of old artifacts and branches
- Repository maintenance tasks

### Stale (`stale.yml`)
**Purpose**: Issue and PR lifecycle management
**Triggers**: Scheduled (daily)
**Jobs**:
- Marks inactive issues/PRs as stale
- Closes stale items after grace period

### Labeler (`labeler.yml`)
**Purpose**: Automated labeling of issues and PRs
**Triggers**: Issues/PRs opened/edited
**Jobs**:
- Applies appropriate labels based on content and paths
- Maintains consistent labeling across the repository

### PR Title (`pr-title.yml`)
**Purpose**: Pull request title validation and formatting
**Triggers**: PRs opened/edited/synchronized
**Jobs**:
- Validates PR title format
- Ensures conventional commit style

### Manual (`manual.yml`)
**Purpose**: Manual workflow triggers for special cases
**Triggers**: Manual dispatch
**Jobs**:
- Custom workflows for specific maintainer actions
- Manual release and deployment options

### MkDocs (`mkdocs.yml`)
**Purpose**: Documentation site deployment
**Triggers**: Push to main
**Jobs**:
- Builds and deploys documentation site
- Updates live documentation with latest changes

### Suggestions (`suggestions.yml`)
**Purpose**: Automated code improvement suggestions
**Triggers**: Pull requests
**Jobs**:
- AI-powered code review and suggestions
- Automated improvement recommendations

## Workflow Management

### Adding New Workflows
1. Create YAML file in `.github/workflows/`
2. Follow naming conventions (lowercase, descriptive)
3. Include proper triggers and permissions
4. Test workflow before merging

### Workflow Permissions
Most workflows use minimal permissions:
- `contents: read` for basic repository access
- Additional permissions granted only when needed (e.g., `contents: write` for releases)

### Troubleshooting
- Check Actions tab for workflow run details
- Review logs for error messages
- Ensure proper branch protection rules
- Verify secret configurations

## Contributing

When modifying workflows:
- Test changes in a branch before merging
- Update this documentation
- Ensure workflows don't break existing CI/CD
- Follow security best practices