# Security Policy

## Supported Versions

We actively support the following versions of Friday Gemini AI:

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |
| < 0.1   | :x:                |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security vulnerability, please follow these steps:

### Private Disclosure

**DO NOT** create a public GitHub issue for security vulnerabilities.

Instead, please report security issues privately by:

1. **Email**: Send details to [bniladridas@gmail.com](mailto:bniladridas@gmail.com)
2. **Subject**: Include "SECURITY" in the subject line
3. **Details**: Provide as much information as possible:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Include

Please include the following information:
- **Vulnerability type** (e.g., injection, authentication bypass)
- **Affected versions**
- **Attack scenario** and potential impact
- **Proof of concept** (if applicable)
- **Suggested mitigation** (if you have ideas)

### Response Timeline

- **Initial response**: Within 48 hours
- **Status update**: Within 7 days
- **Fix timeline**: Depends on severity
  - Critical: 1-3 days
  - High: 1-2 weeks
  - Medium: 2-4 weeks
  - Low: Next release cycle

### Recognition

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

For security-related questions or concerns:
- **Email**: [bniladridas@gmail.com](mailto:bniladridas@gmail.com)
- **GitHub**: [@bniladridas](https://github.com/bniladridas)

Thank you for helping keep Friday Gemini AI secure!