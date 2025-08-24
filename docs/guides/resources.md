# Resources

Additional resources, links, and references for Friday Gemini AI.

## Official Documentation

### Google AI Documentation
- [Google AI Studio](https://makersuite.google.com/) - Create and manage API keys
- [Gemini API Documentation](https://ai.google.dev/docs) - Official API reference
- [Model Documentation](https://ai.google.dev/models/gemini) - Gemini model details
- [API Pricing](https://ai.google.dev/pricing) - Current pricing information

### Friday Gemini AI Documentation
- [GitHub Repository](https://github.com/your-username/friday_gemini_ai) - Source code and issues
- [RubyGems Page](https://rubygems.org/gems/friday_gemini_ai) - Gem installation and versions
- [API Reference](api.md) - Complete method documentation
- [Usage Guide](usage.md) - Comprehensive examples

## Migration Guides

### From Other AI Libraries

#### From OpenAI Ruby
```ruby
# OpenAI Ruby
client = OpenAI::Client.new(access_token: "your-token")
response = client.completions(
  parameters: {
    model: "text-davinci-003",
    prompt: "Hello world",
    max_tokens: 100
  }
)

# Friday Gemini AI equivalent
client = GeminiAI::Client.new
response = client.generate_text(
  "Hello world",
  max_tokens: 100
)
```

#### From Anthropic Ruby
```ruby
# Anthropic Ruby
client = Anthropic::Client.new(api_key: "your-key")
response = client.complete(
  prompt: "Human: Hello\n\nAssistant:",
  model: "claude-v1",
  max_tokens_to_sample: 100
)

# Friday Gemini AI equivalent
client = GeminiAI::Client.new
messages = [{ role: 'user', content: 'Hello' }]
response = client.chat(messages, max_tokens: 100)
```

### From Direct HTTP Requests
```ruby
# Direct HTTP with Net::HTTP
require 'net/http'
require 'json'

uri = URI('https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent')
uri.query = "key=#{api_key}"

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

request = Net::HTTP::Post.new(uri)
request['Content-Type'] = 'application/json'
request.body = {
  contents: [{ parts: [{ text: "Hello" }] }]
}.to_json

response = http.request(request)

# Friday Gemini AI equivalent
client = GeminiAI::Client.new
response = client.generate_text("Hello")
```

## Release Notes

### Version 1.0.0 (Current)
- Initial release
- Text generation support
- Chat conversation support
- Multiple model support (Flash, Flash Lite)
- Comprehensive error handling
- CLI interface
- Environment variable support
- Detailed logging with API key masking

### Planned Features
- Image analysis support
- Streaming responses
- Function calling
- Batch processing optimization
- Advanced caching strategies

## API Troubleshooting

### Common HTTP Status Codes

#### 200 OK
Request successful, response contains generated content.

#### 400 Bad Request
Invalid request format or parameters.
```ruby
# Common causes:
# - Empty prompt
# - Invalid parameters
# - Malformed request body
```

#### 401 Unauthorized
Invalid or missing API key.
```ruby
# Solutions:
# - Check API key format (starts with "AIza")
# - Verify API key is active
# - Ensure proper environment variable setup
```

#### 403 Forbidden
API key doesn't have required permissions.
```ruby
# Solutions:
# - Check API key permissions in Google AI Studio
# - Verify billing is set up if required
# - Ensure API is enabled for your project
```

#### 429 Too Many Requests
Rate limit exceeded.
```ruby
# Current limits:
# - 60 requests per minute
# - 32,000 tokens per minute
# - 1,500 requests per day
```

#### 500 Internal Server Error
Server-side error on Google's end.
```ruby
# Solutions:
# - Retry with exponential backoff
# - Check Google AI status page
# - Try again later
```

### Rate Limits and Quotas

#### Free Tier Limits
- 15 requests per minute
- 1 million tokens per day
- 1,500 requests per day

#### Paid Tier Limits
- 60 requests per minute
- 4 million tokens per day
- Higher daily request limits

#### Best Practices
```ruby
# Implement exponential backoff
def with_retry(max_retries: 3)
  retries = 0
  begin
    yield
  rescue GeminiAI::RateLimitError
    retries += 1
    if retries <= max_retries
      sleep(2 ** retries)
      retry
    else
      raise
    end
  end
end

# Use batch processing
prompts.each_slice(10) do |batch|
  batch.each { |prompt| client.generate_text(prompt) }
  sleep(1) # Pause between batches
end
```

## Fine-tuning

### When to Consider Fine-tuning
- Specific domain knowledge required
- Consistent output format needed
- Performance optimization for specific tasks
- Custom behavior patterns

### Alternatives to Fine-tuning
```ruby
# Use detailed prompts
prompt = <<~PROMPT
  You are a Ruby expert specializing in Rails applications.
  Always provide code examples and explain best practices.
  Format your response with clear sections.
  
  Question: #{user_question}
PROMPT

# Use conversation context
messages = [
  { role: 'user', content: 'You are a helpful Ruby programming assistant.' },
  { role: 'model', content: 'I understand. I will help with Ruby programming questions.' },
  { role: 'user', content: user_question }
]
```

## Google AI Studio

### Getting Started
1. Visit [Google AI Studio](https://makersuite.google.com/)
2. Sign in with Google account
3. Create new project (if needed)
4. Generate API key
5. Test prompts in the playground

### API Key Management
- Create separate keys for development/production
- Rotate keys regularly
- Monitor usage in the dashboard
- Set up billing alerts

### Prompt Engineering
- Use the playground to test prompts
- Experiment with different parameters
- Save successful prompt templates
- Share prompts with team members

## Community Resources

### Ruby AI Community
- [Ruby AI Discord](https://discord.gg/ruby-ai) - Community discussions
- [Ruby AI Subreddit](https://reddit.com/r/ruby_ai) - News and discussions
- [Ruby Weekly](https://rubyweekly.com/) - Ruby news including AI developments

### AI/ML Resources
- [Prompt Engineering Guide](https://www.promptingguide.ai/) - Comprehensive prompting techniques
- [AI Safety Guidelines](https://ai.google.dev/docs/safety_guidance) - Responsible AI practices
- [Machine Learning Mastery](https://machinelearningmastery.com/) - ML tutorials and guides

## Contributing

### Development Setup
```bash
# Clone repository
git clone https://github.com/your-username/friday_gemini_ai.git
cd friday_gemini_ai

# Install dependencies
bundle install

# Run tests
ruby tests/test_runner.rb

# Run CLI tests
./bin/gemini test
```

### Code Style
- Follow Ruby Style Guide
- Use RuboCop for linting
- Write comprehensive tests
- Document public methods

### Submitting Issues
Include:
- Ruby version
- Gem version
- Full error message
- Minimal reproduction code
- Expected vs actual behavior

### Pull Requests
1. Fork the repository
2. Create feature branch
3. Write tests for new features
4. Ensure all tests pass
5. Update documentation
6. Submit pull request

## Security

### API Key Security
```ruby
# Good practices
# - Use environment variables
# - Never commit keys to version control
# - Rotate keys regularly
# - Use different keys for different environments

# Bad practices
# - Hardcoding keys in source code
# - Sharing keys in chat/email
# - Using production keys in development
# - Logging API keys
```

### Input Validation
```ruby
# Sanitize user input
def sanitize_prompt(input)
  # Remove potentially harmful content
  input.gsub(/[<>]/, '')
       .strip
       .slice(0, 2000) # Limit length
end

# Validate input
def validate_prompt(prompt)
  raise ArgumentError, "Prompt cannot be empty" if prompt.strip.empty?
  raise ArgumentError, "Prompt too long" if prompt.length > 5000
end
```

### Rate Limiting
```ruby
# Implement user-level rate limiting
class UserRateLimiter
  def initialize(user_id, limit: 100, window: 3600)
    @user_id = user_id
    @limit = limit
    @window = window
    @requests = []
  end
  
  def allow_request?
    now = Time.now.to_i
    @requests.reject! { |time| time < now - @window }
    
    if @requests.length < @limit
      @requests << now
      true
    else
      false
    end
  end
end
```

## Legal and Compliance

### Terms of Service
- Review [Google AI Terms of Service](https://ai.google.dev/terms)
- Understand usage restrictions
- Comply with content policies
- Respect rate limits and quotas

### Privacy Considerations
- Don't send personal data to AI models
- Implement data retention policies
- Consider GDPR/CCPA compliance
- Log and audit AI usage

### Content Policies
- Prohibited content types
- Safety filtering
- Content moderation
- User-generated content handling

## Performance Optimization

### Caching Strategies
```ruby
# Redis caching
class CachedGeminiClient
  def initialize
    @client = GeminiAI::Client.new
    @redis = Redis.new
  end
  
  def generate_text(prompt, options = {})
    cache_key = "gemini:#{Digest::MD5.hexdigest("#{prompt}:#{options}")}"
    
    cached = @redis.get(cache_key)
    return cached if cached
    
    response = @client.generate_text(prompt, options)
    @redis.setex(cache_key, 3600, response) # Cache for 1 hour
    
    response
  end
end
```

### Monitoring
```ruby
# Application monitoring
class MonitoredGeminiClient
  def initialize
    @client = GeminiAI::Client.new
    @metrics = {
      requests: 0,
      errors: 0,
      total_time: 0
    }
  end
  
  def generate_text(prompt, options = {})
    @metrics[:requests] += 1
    start_time = Time.now
    
    begin
      @client.generate_text(prompt, options)
    rescue => e
      @metrics[:errors] += 1
      raise e
    ensure
      @metrics[:total_time] += Time.now - start_time
    end
  end
  
  def stats
    {
      success_rate: (@metrics[:requests] - @metrics[:errors]).to_f / @metrics[:requests],
      average_response_time: @metrics[:total_time] / @metrics[:requests]
    }
  end
end
```

## Support

### Getting Help
1. Check this documentation
2. Search existing GitHub issues
3. Create new issue with reproduction steps
4. Join community discussions

### Commercial Support
For enterprise support, custom integrations, or consulting services, contact the maintainers through the GitHub repository.

### Training and Workshops
- Ruby AI workshops
- Custom team training
- Integration consulting
- Best practices sessions