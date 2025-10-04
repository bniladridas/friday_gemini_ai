# Contributing to Friday Gemini AI

Thank you for your interest in contributing! We welcome contributions from everyone.

## Quick Start

1. **Fork** the repository
2. **Clone** your fork locally
3. **Create** a feature branch
4. **Make** your changes
5. **Test** your changes
6. **Run code quality checks**
7. **Update documentation**
8. **Submit** a pull request

## Development Setup

### Prerequisites
- Ruby 3.1+ (we test on 3.1, 3.2, 3.3)
- Bundler 2.0+
- Git 2.25+

### Setup
```bash
# Clone your fork
git clone https://github.com/bniladridas/friday_gemini_ai.git
cd friday_gemini_ai

# Install dependencies
bundle install

# Set up environment
cp .env.example .env
# Add your GEMINI_API_KEY to .env

# Install Git hooks for pre-commit checks
bundle exec overcommit --install
```

## Development Workflow

### Running Tests
```bash
# Run all tests with coverage
bundle exec rake test

# Run specific test file
bundle exec ruby -Ilib:test path/to/test_file.rb

# Run tests with coverage report
COVERAGE=true bundle exec rake test
```

### Code Quality
```bash
# Run RuboCop
bundle exec rake rubocop

# Auto-correct RuboCop offenses
bundle exec rubocop -a

# Run security audit
bundle exec bundle-audit
```

### Documentation
```bash
# Generate documentation
bundle exec rake docs

# Preview documentation locally
bundle exec rake docs:preview  # View at http://localhost:8808
```

## Pull Request Guidelines

1. **Branch Naming**: Use descriptive branch names like `feature/add-new-model` or `fix/issue-123`
2. **Commit Messages**: Follow [Conventional Commits](https://www.conventionalcommits.org/)
3. **Testing**: Ensure all tests pass and add new tests for your changes
4. **Documentation**: Update relevant documentation including CHANGELOG.md
5. **Code Style**: Follow the project's RuboCop configuration
6. **Keep PRs Focused**: Each PR should address a single issue or feature
7. **PR Review**: All PRs will be automatically reviewed by our AI-powered CodeBot
8. **Workflow Status**: Ensure all GitHub Actions workflows pass before requesting review

## Code Review Process

1. **Draft PR**: Create a draft PR early for feedback
2. **Automated Review**: Our CodeBot will automatically review your PR for:
   - Code quality
   - Test coverage
   - Documentation updates
   - Security best practices
3. **Human Review**: Request reviews from maintainers
4. **Address Feedback**: Respond to all review comments
5. **CI Verification**: Ensure all GitHub Actions workflows pass
6. **Approval**: A maintainer will merge your PR once approved

### PR Review Expectations
- All new features require tests
- Documentation must be updated
- Follow the project's coding standards
- Keep commits focused and well-documented
- Update the CHANGELOG.md for user-facing changes

### Test Requirements
- **Unit tests**: Should not require API keys
- **Integration tests**: May require API keys
- **All tests**: Must pass before PR approval
- **Code Coverage**: Aim for 90%+ test coverage
- **CI/CD**: All GitHub Actions workflows must pass

## Code Style

### Ruby Style Guide
- Follow [Ruby Style Guide](https://rubystyle.guide/)
- Use 2 spaces for indentation
- Keep lines under 120 characters
- Use descriptive variable names

### Code Quality
```bash
# Run RuboCop (if available)
bundle exec rubocop

# Check security
bundle exec brakeman
```

## Pull Request Process

### Before Submitting
- [ ] Tests pass locally
- [ ] Code follows style guidelines
- [ ] Documentation is updated
- [ ] Commit messages are clear

### PR Guidelines
1. **Branch naming**: `feature/description` or `fix/description`
2. **Commit messages**: Clear and descriptive
3. **Description**: Explain what and why
4. **Tests**: Include tests for new features
5. **Documentation**: Update docs if needed

### PR Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests pass
- [ ] New tests added (if applicable)

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
```

## Bug Reports

### Before Reporting
- Check existing issues
- Try latest version
- Gather reproduction steps

### Bug Report Template
```markdown
**Describe the bug**
Clear description of the bug

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '....'
3. See error

**Expected behavior**
What you expected to happen

**Environment:**
- Ruby version:
- Gem version:
- OS:

**Additional context**
Any other context about the problem
```

## Feature Requests

### Before Requesting
- Check existing issues
- Consider if it fits the project scope
- Think about implementation

### Feature Request Template
```markdown
**Is your feature request related to a problem?**
Description of the problem

**Describe the solution you'd like**
Clear description of what you want

**Describe alternatives you've considered**
Alternative solutions or features

**Additional context**
Any other context or screenshots
```

## Documentation

### Types of Documentation
- **Code comments**: For complex logic
- **README**: User-facing documentation
- **API docs**: Method documentation
- **Guides**: How-to documentation

### Documentation Standards
- Clear and concise
- Include examples
- Keep up to date
- Test code examples

## Versioning

We use [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

## Areas for Contribution

### High Priority
- Bug fixes
- Performance improvements
- Documentation improvements
- Test coverage

### Medium Priority
- New features
- Code refactoring
- Developer experience

### Ideas for Contributors
- Add support for new Gemini models
- Improve error handling
- Add more configuration options
- Enhance CLI functionality
- Write more examples

## Getting Help

### Communication Channels
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and ideas
- **Email**: [bniladridas@gmail.com](mailto:bniladridas@gmail.com)

### Response Times
- **Issues**: Within 48 hours
- **PRs**: Within 1 week
- **Email**: Within 2-3 days

## Recognition

Contributors are recognized in:
- README acknowledgments
- Release notes
- GitHub contributors page

## Code of Conduct

### Our Pledge
We pledge to make participation in our project a harassment-free experience for everyone.

### Standards
- Use welcoming and inclusive language
- Be respectful of differing viewpoints
- Accept constructive criticism gracefully
- Focus on what's best for the community

### Enforcement
Report unacceptable behavior to [bniladridas@gmail.com](mailto:bniladridas@gmail.com).

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to Friday Gemini AI!