# API Versions

Friday Gemini AI version history, compatibility, and migration information.

## Current Version

### v0.1.5 (Current)
- **Release Date**: January 2026
- **Status**: Stable
- **Support**: Full support and active development

#### Features
- Text generation with Gemini 2.0 Flash models
- Multi-turn chat conversations
- Multiple model support (Flash, Flash Lite)
- Comprehensive error handling
- CLI interface
- Environment variable support
- Secure API key handling

#### Supported Ruby Versions
- **Ruby 3.1+** - Minimum supported version
- **Ruby 3.1** - Fully supported
- **Ruby 3.2** - Fully supported

#### Supported Gemini Models
- **gemini-2.0-flash** - Primary model (`:flash`, `:pro`)
- **gemini-2.0-flash-lite** - Lightweight model (`:flash_lite`)

## Version History

### v0.1.5 - Latest Release
**Released**: January 2026

#### New Features
- Complete Ruby interface to Gemini AI API
- Text generation with customizable parameters
- Chat conversation support with context
- Multiple model selection
- Comprehensive error handling hierarchy
- CLI tool for testing and development
- Environment variable and .env file support
- Secure API key masking in logs
- Detailed logging with configurable levels

#### API Methods
```ruby
# Core client methods
client = GeminiAI::Client.new
client.generate_text(prompt, options = {})
client.chat(messages, options = {})

# Utility methods
GeminiAI.load_env(file = '.env')
```

#### Error Classes
```ruby
GeminiAI::Error                 # Base error class
GeminiAI::APIError             # API-related errors
GeminiAI::AuthenticationError  # API key issues
GeminiAI::RateLimitError       # Rate limiting
GeminiAI::InvalidRequestError  # Invalid parameters
GeminiAI::NetworkError         # Network issues
```

### v0.1.0 - Initial Release
**Released**: January 2026

#### New Features
- Complete Ruby interface to Gemini AI API
- Text generation with customizable parameters
- Chat conversation support with context
- Multiple model selection
- Comprehensive error handling hierarchy
- CLI tool for testing and development
- Environment variable and .env file support
- Secure API key masking in logs
- Detailed logging with configurable levels

#### API Methods
```ruby
# Core client methods
client = GeminiAI::Client.new
client.generate_text(prompt, options = {})
client.chat(messages, options = {})

# Utility methods
GeminiAI.load_env(file = '.env')
```

#### Error Classes
```ruby
GeminiAI::Error                 # Base error class
GeminiAI::APIError             # API-related errors
GeminiAI::AuthenticationError  # API key issues
GeminiAI::RateLimitError       # Rate limiting
GeminiAI::InvalidRequestError  # Invalid parameters
GeminiAI::NetworkError         # Network issues
```

## Compatibility Matrix

### Ruby Compatibility
| Ruby Version | v1.0.0 | Notes |
|--------------|--------|-------|
| 2.5 | No | Not supported |
| 2.6 | No | Not supported |
| 2.7 | No | Not supported |
| 3.0 | No | Not supported |
| 3.1 | Yes | Minimum version |
| 3.2 | Yes | Fully supported |
| 3.3 | Yes | Fully supported |
| 3.3 | Yes | Fully supported |

### Framework Compatibility
| Framework | v1.0.0 | Notes |
|-----------|--------|-------|
| Rails 6.0+ | Yes | Full integration support |
| Rails 7.0+ | Yes | Full integration support |
| Sinatra | Yes | Works with all versions |
| Hanami | Yes | Compatible |
| Roda | Yes | Compatible |
| Plain Ruby | Yes | No framework required |

### Gemini API Compatibility
| Gemini API Version | Friday Gemini AI v1.0.0 | Status |
|-------------------|-------------------------|---------|
| v1 | Yes | Current API version |
| v1beta | No | Not supported |

## Migration Guides

### From Direct HTTP Requests

#### Before (Direct HTTP)
```ruby
require 'net/http'
require 'json'

uri = URI('https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent')
uri.query = "key=#{ENV['GEMINI_API_KEY']}"

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

request = Net::HTTP::Post.new(uri)
request['Content-Type'] = 'application/json'
request.body = {
  contents: [
    {
      parts: [
        { text: "Hello, world!" }
      ]
    }
  ],
  generationConfig: {
    temperature: 0.7,
    maxOutputTokens: 1024
  }
}.to_json

response = http.request(request)
result = JSON.parse(response.body)
text = result.dig('candidates', 0, 'content', 'parts', 0, 'text')
```

#### After (Friday Gemini AI)
```ruby
require_relative 'src/gemini'

GeminiAI.load_env
client = GeminiAI::Client.new
text = client.generate_text("Hello, world!", temperature: 0.7, max_tokens: 1024)
```

### From Other AI Libraries

#### From OpenAI Ruby
```ruby
# Before (OpenAI)
require 'openai'

client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
response = client.completions(
  parameters: {
    model: "text-davinci-003",
    prompt: "Hello, world!",
    max_tokens: 100,
    temperature: 0.7
  }
)
text = response.dig("choices", 0, "text")

# After (Friday Gemini AI)
require_relative 'src/gemini'

GeminiAI.load_env
client = GeminiAI::Client.new
text = client.generate_text("Hello, world!", max_tokens: 100, temperature: 0.7)
```

#### From Anthropic Ruby
```ruby
# Before (Anthropic)
require 'anthropic'

client = Anthropic::Client.new(api_key: ENV['ANTHROPIC_API_KEY'])
response = client.complete(
  prompt: "Human: Hello\n\nAssistant:",
  model: "claude-v1",
  max_tokens_to_sample: 100
)
text = response['completion']

# After (Friday Gemini AI)
require_relative 'src/gemini'

GeminiAI.load_env
client = GeminiAI::Client.new
messages = [{ role: 'user', content: 'Hello' }]
text = client.chat(messages, max_tokens: 100)
```

## Deprecation Policy

### Deprecation Timeline
1. **Announcement** - Feature marked as deprecated in documentation
2. **Warning Period** - 6 months minimum with deprecation warnings
3. **Removal** - Feature removed in next major version

### Current Deprecations
*No current deprecations in v1.0.0*

### Future Deprecations
*None planned for v1.x series*

## Upgrade Guidelines

### Semantic Versioning
Friday Gemini AI follows [Semantic Versioning](https://semver.org/):

- **MAJOR** (x.0.0) - Breaking changes, API modifications
- **MINOR** (1.x.0) - New features, backward compatible
- **PATCH** (1.0.x) - Bug fixes, backward compatible

### Breaking Changes Policy
- **Major versions only** - Breaking changes only in major releases
- **Clear migration path** - Detailed upgrade guides provided
- **Deprecation warnings** - Advanced notice before removal
- **LTS support** - Long-term support for major versions

### Upgrade Process
1. **Read release notes** - Understand what's changed
2. **Check compatibility** - Verify Ruby/framework versions
3. **Update dependencies** - Use latest compatible versions
4. **Run tests** - Ensure your code still works
5. **Update code** - Make necessary changes for new version

## Support Lifecycle

### Version Support
- **Current version** - Full support, active development
- **Previous major** - Security fixes for 12 months
- **Older versions** - Community support only

### Security Updates
- **Critical vulnerabilities** - Immediate patches
- **High severity** - Patches within 1 week
- **Medium/Low severity** - Patches in next minor release

### End of Life
- **12 months notice** - Before ending support
- **Migration assistance** - Help upgrading to supported versions
- **Security patches** - Continue for critical issues

## Future Roadmap

### Planned Features (v1.1.0)
- **Image analysis** - Support for image inputs
- **Streaming responses** - Real-time response streaming
- **Function calling** - Tool use capabilities
- **Batch processing** - Optimized bulk operations

### Planned Features (v1.2.0)
- **Advanced caching** - Intelligent response caching
- **Retry strategies** - Configurable retry policies
- **Metrics collection** - Built-in usage analytics
- **Plugin system** - Extensible architecture

### Long-term Vision (v2.0.0)
- **Multi-provider support** - Support for other AI providers
- **Advanced routing** - Intelligent model selection
- **Cost optimization** - Automatic cost management
- **Enterprise features** - Advanced security and compliance

## API Stability

### Stable APIs
These APIs are considered stable and will not change in v1.x:
```ruby
GeminiAI::Client.new(api_key = nil, model: :flash)
client.generate_text(prompt, options = {})
client.chat(messages, options = {})
GeminiAI.load_env(file = '.env')
```

### Experimental APIs
*No experimental APIs in v1.0.0*

### Internal APIs
Internal APIs may change without notice:
- `GeminiAI::Utils::*` - Utility classes
- Private methods in public classes
- Undocumented methods

## Version Checking

### Check Current Version
```ruby
require_relative 'src/gemini'
puts GeminiAI::VERSION
```

### Runtime Version Checks
```ruby
# Check minimum version
if Gem::Version.new(GeminiAI::VERSION) >= Gem::Version.new('1.0.0')
  # Use v1.0.0+ features
else
  # Fallback for older versions
end
```

### Gemspec Version Constraints
```ruby
# In your Gemfile
gem 'friday_gemini_ai', '~> 1.0'  # Allow patch updates
gem 'friday_gemini_ai', '~> 1.0.0'  # Exact minor version
gem 'friday_gemini_ai', '>= 1.0.0', '< 2.0'  # Version range
```
