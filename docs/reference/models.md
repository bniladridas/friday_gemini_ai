# Models

Friday Gemini AI supports multiple Google Gemini models, each optimized for different use cases.

## Available Models

### Gemini Pro (Default)
- **Model ID**: `gemini-pro`
- **Symbol**: `:pro`
- **Best for**: Complex reasoning, detailed analysis, creative writing
- **Speed**: Medium
- **Quality**: High
- **Context**: Long context support

```ruby
client = GeminiAI::Client.new(model: :pro)
```

### Gemini 1.5 Flash
- **Model ID**: `gemini-1.5-flash`
- **Symbol**: `:flash`
- **Best for**: Fast, general-purpose text generation
- **Speed**: Fast
- **Quality**: High
- **Context**: Long context support

```ruby
client = GeminiAI::Client.new(model: :flash)
```

### Gemini 1.5 Pro
- **Model ID**: `gemini-1.5-pro`
- **Symbol**: `:pro_1_5`
- **Best for**: Image-to-text processing, advanced reasoning
- **Speed**: Medium
- **Quality**: Excellent
- **Context**: Long context support

```ruby
client = GeminiAI::Client.new(model: :pro_1_5)
```

### Gemini 1.5 Flash (Full)
- **Model ID**: `gemini-1.5-flash`
- **Symbol**: `:flash_1_5`
- **Best for**: Lightweight tasks, general-purpose
- **Speed**: Fast
- **Quality**: High
- **Context**: Long context support

```ruby
client = GeminiAI::Client.new(model: :flash_1_5)
```

### Gemini 1.5 Flash 8B
- **Model ID**: `gemini-1.5-flash-8b`
- **Symbol**: `:flash_8b`
- **Best for**: Compact, efficient processing
- **Speed**: Very Fast
- **Quality**: Good
- **Context**: Standard context support

```ruby
client = GeminiAI::Client.new(model: :flash_8b)
```

## Model Comparison

| Feature | Pro | 1.5 Flash | 1.5 Pro | 1.5 Flash (Full) | 1.5 Flash 8B |
|---------|-----|-----------|---------|------------------|--------------|
| Response Speed | Medium | Fast | Medium | Fast | Very Fast |
| Response Quality | High | High | Excellent | High | Good |
| Complex Reasoning | Excellent | Good | Excellent | Good | Basic |
| Context Length | Long | Long | Long | Long | Standard |
| Cost Efficiency | Standard | High | Standard | High | Highest |
| Best Use Cases | Analysis, creative writing, complex tasks | Quick responses, general tasks | Image analysis, detailed reasoning | Lightweight tasks | Compact processing |

## Choosing the Right Model

### Use Pro for:
- **Creative Writing**: Stories, poems, marketing copy
- **Complex Analysis**: Code review, data interpretation
- **Detailed Explanations**: Technical documentation, tutorials
- **Multi-step Reasoning**: Problem-solving, planning

```ruby
# Creative writing example
client = GeminiAI::Client.new(model: :pro)
story = client.generate_text(
  "Write a science fiction story about AI consciousness",
  temperature: 0.8,
  max_tokens: 500
)
```

### Use Flash models for:
- **Quick Q&A**: Simple questions and answers
- **Chatbots**: Fast conversational responses
- **High-Volume Processing**: Batch operations
- **Real-time Applications**: Live chat, instant responses

```ruby
# Quick Q&A example
client = GeminiAI::Client.new(model: :flash)
answer = client.generate_text(
  "What is the capital of France?",
  temperature: 0.1,
  max_tokens: 50
)
```

### Use Pro 1.5 for:
- **Image Analysis**: Image-to-text processing
- **Advanced Reasoning**: Complex multi-modal tasks
- **Detailed Analysis**: In-depth content understanding

```ruby
# Image analysis example
client = GeminiAI::Client.new(model: :pro_1_5)
description = client.generate_image_text(
  base64_image,
  "Describe this image in detail"
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
- **Pro models**: Up to 8192 tokens
- **Flash models**: Up to 8192 tokens
- **Flash 8B**: Up to 4096 tokens

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
client = GeminiAI::Client.new(model: :flash_8b)
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
quick_client = GeminiAI::Client.new(model: :flash_8b)

# Full model for complex tasks
detailed_client = GeminiAI::Client.new(model: :pro)

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
- **Requests per minute**: 60
- **Tokens per minute**: 32,000
- **Requests per day**: 1,500

The gem automatically handles rate limiting with exponential backoff retry logic.

## Cost Considerations

Flash 8B is more cost-effective for:
- High-volume applications
- Simple text generation
- Real-time chat applications

Pro models provide better value for:
- Complex reasoning tasks
- Creative content generation
- Detailed analysis work

## Migration Between Models

Switching models is seamless - just change the model parameter:

```ruby
# Before
client = GeminiAI::Client.new(model: :flash_8b)

# After
client = GeminiAI::Client.new(model: :pro)

# Same API, different capabilities
response = client.generate_text("Same prompt, different model")
```

## Best Practices

1. **Start with Flash 8B** for prototyping and testing
2. **Upgrade to Pro** when you need higher quality responses
3. **Use appropriate parameters** for each model's strengths
4. **Monitor response quality** and adjust models accordingly
5. **Consider cost vs. quality** trade-offs for production use