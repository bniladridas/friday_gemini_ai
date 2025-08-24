# Security Policy

## Supported Versions

We actively support the following versions of Friday Gemini AI:

| Version | Supported |
| ------- | --------- |
| 1.0.x   | Yes       |
| < 1.0   | No        |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security vulnerability, please follow these steps:

### 1. Do NOT create a public issue

Please do not report security vulnerabilities through public GitHub issues, discussions, or pull requests.

### 2. Report privately

Instead, please report security vulnerabilities by:

- **GitHub Security Advisories**: Use the [GitHub Security Advisory](https://github.com/bniladridas/friday_gemini_ai/security/advisories/new) feature
- **Email**: Send details to security@bniladridas.com

### 3. Include details

Please include as much information as possible:

- Type of vulnerability
- Full paths of source file(s) related to the vulnerability
- Location of the affected source code (tag/branch/commit or direct URL)
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the vulnerability, including how an attacker might exploit it

### 4. Response timeline

- **Initial response**: Within 48 hours
- **Status update**: Within 7 days
- **Fix timeline**: Depends on severity and complexity

## Security Best Practices

When using Friday Gemini AI:

### API Key Security
- Never commit API keys to version control
- Use environment variables or secure key management
- Rotate API keys regularly
- Use different keys for different environments

### Environment Variables
```bash
# Good - Use environment variables
export GEMINI_API_KEY="your_api_key_here"

# Bad - Never hardcode in source
client = GeminiAI::Client.new("AIza...")
```

### Input Validation
- Always validate user inputs before sending to the API
- Sanitize data appropriately for your use case
- Be cautious with user-generated prompts

### Error Handling
- Don't expose sensitive information in error messages
- Log security events appropriately
- Handle API failures gracefully

## Vulnerability Disclosure

We follow responsible disclosure practices:

1. We will acknowledge receipt of your vulnerability report
2. We will investigate and validate the vulnerability
3. We will develop and test a fix
4. We will release the fix and publish a security advisory
5. We will credit you for the discovery (if desired)

## Security Updates

Security updates will be:
- Released as patch versions (e.g., 1.0.1)
- Documented in security advisories
- Announced through our communication channels

## Contact

For security-related questions or concerns:
- Security team: security@bniladridas.com
- General inquiries: hello@bniladridas.com

Thank you for helping keep Friday Gemini AI secure!