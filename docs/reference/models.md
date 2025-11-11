# Models

Friday Gemini AI supports multiple Google Gemini models, each optimized for different use cases.

> [!TIP]
> Choose the right model based on your use case. Flash Lite for speed, Flash for quality.

## Available Models

### Gemini 2.0 Flash (Default)
- **Model ID**: `gemini-2.0-flash`
- **Symbol**: `:flash` or `:pro`
- **Best for**: General-purpose text generation, complex reasoning
- **Speed**: Medium
- **Quality**: High
- **Context**: Long context support

```ruby
client = GeminiAI::Client.new(model: :flash)
# or
client = GeminiAI::Client.new(model: :pro)
```

### Gemini 2.0 Flash Lite
- **Model ID**: `gemini-2.0-flash-lite`
- **Symbol**: `:flash_lite`
- **Best for**: Quick responses, simple tasks, high-throughput applications
- **Speed**: Fast
- **Quality**: Good
- **Context**: Standard context support

```ruby
client = GeminiAI::Client.new(model: :flash_lite)
```

## Model Comparison

| Feature | Flash | Flash Lite |
|---------|-------|------------|
| Response Speed | Medium | Fast |
| Response Quality | High | Good |
| Complex Reasoning | Excellent | Good |
| Context Length | Long | Standard |
| Cost Efficiency | Standard | High |
| Best Use Cases | Analysis, creative writing, complex tasks | Quick responses, simple Q&A, chatbots |

## Choosing the Right Model

### Use Flash for:

| Use Case | Examples |
| -------- | -------- |
| Creative Writing | Stories, poems, marketing copy |
| Complex Analysis | Code review, data interpretation |
| Detailed Explanations | Technical documentation, tutorials |
| Multi-step Reasoning | Problem-solving, planning |

```ruby
# Creative writing example
client = GeminiAI::Client.new(model: :flash)
story = client.generate_text(
  "Write a science fiction story about AI consciousness",
  temperature: 0.8,
  max_tokens: 500
)
```

### Use Flash Lite for:

| Use Case | Examples |
| -------- | -------- |
| Quick Q&A | Simple questions and answers |
| Chatbots | Fast conversational responses |
| High-Volume Processing | Batch operations |
| Real-time Applications | Live chat, instant responses |

```ruby
# Quick Q&A example
client = GeminiAI::Client.new(model: :flash_lite)
answer = client.generate_text(
  "What is the capital of France?",
  temperature: 0.1,
  max_tokens: 50
)
```

## Model Parameters

### Temperature
Controls randomness in responses:
- **0.0-0.3**: Deterministic, factual responses
- **0.4-0.7**: Balanced creativity and accuracy
- **0.8-1.0**: Highly creative, varied responses

### Max Tokens
Controls response length:
- **Flash**: Up to 8192 tokens
- **Flash Lite**: Up to 2048 tokens

### Top-P (Nucleus Sampling)
Controls diversity of word choices:
- **0.1-0.5**: Conservative, focused responses
- **0.6-0.9**: Balanced diversity
- **0.9-1.0**: Maximum diversity

### Top-K
Limits vocabulary choices:
- **1-20**: Very focused vocabulary
- **20-40**: Balanced vocabulary
- **40+**: Full vocabulary range

## Performance Optimization

### For Speed
```ruby
client = GeminiAI::Client.new(model: :flash_lite)
response = client.generate_text(
  prompt,
  temperature: 0.3,
  max_tokens: 100,
  top_p: 0.8,
  top_k: 20
)
```

### For Quality
```ruby
client = GeminiAI::Client.new(model: :flash)
response = client.generate_text(
  prompt,
  temperature: 0.7,
  max_tokens: 500,
  top_p: 0.9,
  top_k: 40
)
```

### For Creativity
```ruby
client = GeminiAI::Client.new(model: :flash)
response = client.generate_text(
  prompt,
  temperature: 0.9,
  max_tokens: 300,
  top_p: 0.95,
  top_k: 50
)
```

## Model Switching

You can use different models for different tasks in the same application:

```ruby
# Fast model for simple responses
quick_client = GeminiAI::Client.new(model: :flash_lite)

# Full model for complex tasks
detailed_client = GeminiAI::Client.new(model: :flash)

# Route based on complexity
def get_response(prompt, complex: false)
  client = complex ? detailed_client : quick_client
  client.generate_text(prompt)
end

# Simple question
answer = get_response("What time is it?")

# Complex analysis
analysis = get_response("Analyze this code for security issues", complex: true)
```

## Rate Limits

Both models share the same rate limits:

| Limit | Value |
| ----- | ----- |
| Requests per minute | 60 |
| Tokens per minute | 32,000 |
| Requests per day | 1,500 |

The gem automatically handles rate limiting with exponential backoff retry logic.

## Cost Considerations

Flash Lite is more cost-effective for:
- High-volume applications
- Simple text generation
- Real-time chat applications

Flash provides better value for:
- Complex reasoning tasks
- Creative content generation
- Detailed analysis work

## Migration Between Models

Switching models is seamless - just change the model parameter:

```ruby
# Before
client = GeminiAI::Client.new(model: :flash_lite)

# After
client = GeminiAI::Client.new(model: :flash)

# Same API, different capabilities
response = client.generate_text("Same prompt, different model")
```

## Best Practices

1. **Start with Flash Lite** for prototyping and testing
2. **Upgrade to Flash** when you need higher quality responses
3. **Use appropriate parameters** for each model's strengths
4. **Monitor response quality** and adjust models accordingly
5. **Consider cost vs. quality** trade-offs for production use
