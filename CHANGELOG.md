# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.4] - 2025-04-22

### Added
- Added VERSION constant to the GeminiAI module
- Added CI-friendly tests that don't require API keys
- Added Rakefile with test tasks
- Added this CHANGELOG file

### Changed
- Improved GitHub Actions workflow to better handle existing gem versions
- Split the workflow into separate build and publish jobs
- Added checks to avoid publishing duplicate versions

## [0.1.3] - 2025-04-21

### Added
- Initial release
- Support for Gemini Pro, Flash, and Flash Lite models
- Text generation capabilities
- Chat functionality
- Image-to-text generation
