# Security Policy

## Supported Versions

We actively support the following versions of Friday Gemini AI with security updates:

| Version | Supported          | Security Updates Until |
| ------- | ------------------ | ---------------------- |
| 0.2.x   | :white_check_mark: | TBD                    |
| 0.1.x   | :warning:          | 2024-12-31             |
| < 0.1   | :x:                | Unsupported            |

> :warning: Version 0.1.x will reach end of security support on December 31, 2024.

## Reporting a Vulnerability

We take security vulnerabilities very seriously. If you discover a security issue in our codebase, we appreciate your help in disclosing it to us in a responsible manner.

### Private Disclosure Process

**IMPORTANT**: Do not report security issues through public GitHub issues, discussions, or other public channels.

Please report security issues by creating a new security advisory in our GitHub repository. This ensures proper tracking and handling of security reports.

### What to Include in Your Report

To help us triage and fix the issue, please include the following information:

1. **Project Information**
    - Affected component/package
    - Version number(s) affected
    - Environment details (OS, Ruby version, etc.)

2. **Vulnerability Details**
    - Type of vulnerability (XSS, CSRF, RCE, etc.)
    - Step-by-step instructions to reproduce
    - Impact of the vulnerability
    - Any potential workarounds

3. **Additional Context**
    - Proof of concept (if available)
    - Suggested fixes or mitigation strategies
    - Any related CVEs or references

### Our Security Process

1. **Initial Response**
    - We will acknowledge receipt of your report within 48 hours
    - We will assign a severity level based on CVSS scoring

2. **Investigation**
    - Our security team will investigate the report
    - We may request additional information

3. **Resolution**
    - We will develop and test a fix
    - The fix will be released according to our severity-based timeline

### Response Timelines

| Severity | Initial Response | Fix Release | Public Disclosure |
|----------|------------------|-------------|-------------------|
| Critical | 24 hours | 1-3 days | After patch available |
| High     | 48 hours | 1-2 weeks | After patch available |
| Medium   | 72 hours | Next release | Next release notes |
| Low      | 5 days   | Next release | Next release notes |

### Security Updates

Security updates are typically released as patch versions (e.g., 1.2.3 → 1.2.4). We recommend always using the latest patch version of your chosen minor version.

### Security Best Practices

1. **Dependencies**
    - Keep all dependencies up to date
    - Use `bundle audit` to check for vulnerable dependencies
    - Enable Dependabot for automated dependency updates

2. **Configuration**
    - Use environment variables for sensitive data
    - Follow the principle of least privilege
    - Enable all available security features

3. **Development**
    - Run security scanners as part of your CI/CD pipeline
    - Perform regular security audits
    - Follow secure coding practices

### Recognition

We believe in giving credit where it's due. Security researchers who report valid vulnerabilities will be:
- Thanked in our release notes (unless you prefer to remain anonymous)
- Listed in our SECURITY.md file (if you wish)
- Eligible for our Security Hall of Fame

### Security Advisories

For the latest security advisories, please check our [GitHub Security Advisories](https://github.com/bniladridas/friday_gemini_ai/security/advisories) page.

---

*Last Updated: 2025-08-31*

---

### Security Hall of Fame

We would like to thank the following individuals for their responsible disclosure of security issues:

- [Your name could be here!]

We appreciate security researchers who help keep our users safe. With your permission, we'll:
- Credit you in the security advisory
- Include you in our acknowledgments
- Provide updates on the fix progress

## Security Best Practices

### For Users

1. **API Key Security**
    - Never commit API keys to version control
    - Use environment variables or secure key management
    - Rotate keys regularly
    - Use least-privilege access

2. **Dependencies**
    - Keep the gem updated to the latest version
    - Monitor for security advisories
    - Use `bundle audit` to check for vulnerabilities

3. **Input Validation**
    - Validate and sanitize user inputs before sending to AI
    - Be cautious with user-generated prompts
    - Implement rate limiting for API calls

### For Developers

1. **Code Security**
    - Follow secure coding practices
    - Validate all inputs
    - Use parameterized queries
    - Implement proper error handling

2. **Dependencies**
    - Regularly update dependencies
    - Use `bundler-audit` in CI/CD
    - Monitor security advisories

## Security Features

- **API Key Masking**: Keys are automatically masked in logs
- **Input Validation**: Prompts are validated before sending
- **Error Handling**: Secure error messages without sensitive data
- **HTTPS Only**: All API communications use HTTPS
- **Timeout Protection**: Prevents hanging requests

## Vulnerability Disclosure Policy

We follow responsible disclosure practices:

1. **Investigation**: We investigate all reports promptly
2. **Confirmation**: We confirm vulnerabilities and assess impact
3. **Fix Development**: We develop and test fixes
4. **Coordinated Release**: We coordinate release with reporter
5. **Public Disclosure**: We publish security advisories after fixes

## Contact

For all security-related concerns, please use GitHub's security advisory feature:
- Open a new security advisory at: https://github.com/bniladridas/friday_gemini_ai/security/advisories/new
- Or contact the maintainers through GitHub

Thank you for helping keep Friday Gemini AI secure!
