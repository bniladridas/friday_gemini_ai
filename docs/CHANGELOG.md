# Changelog

All notable changes are tracked here.  
Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) · Versioning: [SemVer](https://semver.org/spec/v2.0.0.html)

## [Unreleased]

## [0.1.6] - 2025-10-07

### Added

- PR reviews with Gemini AI
- PR Bot script
- Documentation updates
- Changelog generation
- Contributor recognition
- End-to-end tests with real API integration
- Dedicated e2e CI workflow
- Windows CI support
- E2E tests documentation

### Changed

- RuboCop configuration
- Method naming
- Predicate methods renamed
- README updated
- Git configuration
- Repository checkout
- Release notes formatting
- Changes organization

### Fixed

- RuboCop offenses
- Code style consistency
- Git ownership issues
- Workflow syntax
- HarperBot model updated to gemini-2.5-flash for compatibility
- Security workflow gitleaks license requirement removed
- CI bundler installation issues resolved by configuring Bundler to use vendor/bundle path
- Development dependencies restored: rubocop, minitest-reporters, github-markup, redcarpet
- simplecov temporarily removed due to simplecov-html native extension issues in CI

### Security

- TBD

---

## [0.1.5] – 2025-08-24

### Added

- Gemini 2.5 models
- Legacy alias
- Auto image-to-text
- Rate limiting
- API validation

### Changed

- Test suite reliability
- Error messages
- Model selection
- GitHub Actions permissions
- Release workflow

### Fixed

- Ruby 3.1 compatibility
- Syntax errors
- Rate limiting stability

---

## [0.1.4] – 2025-08-24

### Added

- MFA auth
- Manual release workflow
- Release helper script

### Changed

- Workflow permissions
- Gem publishing handling
- Release MFA support

---

## [0.1.3] – 2025-03-03

### Added

- First release
- Gemini models
- Text generation
- Image-to-text
