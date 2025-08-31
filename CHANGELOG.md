# Changelog

All notable changes are tracked here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) · Versioning: [SemVer](https://semver.org/spec/v2.0.0.html)

## \[Unreleased]

### Added

* GitHub Actions workflow for automated PR reviews with Gemini AI
* PR Bot script for automated code review feedback
* Documentation updates for new workflow and bot

### Changed

* Updated README with new CodeBot badge and workflow documentation
* Improved Git configuration in CI/CD pipeline
* Enhanced repository checkout process in workflows

### Fixed

* Resolved Git ownership issues in GitHub Actions
* Fixed workflow file syntax and configuration

---

## \[0.1.6] – 2025-08-31

### Added

* Automated changelog generation in release workflow
* Contributor recognition in release notes

### Changed

* Improved release notes formatting with emojis
* Better organization of changes in release notes

---

## \[0.1.5] – 2025-08-30

### Added

* Gemini 2.5 Pro & Flash support
* Legacy alias: `pro_2_0` → `flash_2_0`
* Auto image-to-text model (`pro_1_5`)
* Rate limiting (1s default, 3s in CI)
* API key validation & prompt length check

### Changed

* More reliable test suite
* Clearer error messages/logging
* Smarter model selection on init
* GitHub Actions hardened with proper permissions
* Enhanced release workflow with automated changelog generation

### Fixed

* Ruby 3.1 test helper compatibility
* Syntax & parsing errors in tests/fixtures
* Rate limiting test stability

---

## \[0.1.4] – 2025-08-24

### Added

* RubyGems MFA auth in release workflows
* Manual release workflow with OTP
* Release helper script

### Changed

* Hardened workflows with correct permissions
* Safer gem publishing error handling
* Updated release to support MFA

---

## \[0.1.3] – 2025-04-21

### Added

* First release
* Gemini Pro, Flash, Flash Lite models
* Text generation + chat
* Image-to-text
