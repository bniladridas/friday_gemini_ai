# Overview

Friday Gemini AI is a Ruby gem that provides a simple, secure, and powerful interface to Google's Gemini AI models. Built with Ruby best practices and comprehensive error handling.

## What is Friday Gemini AI?

Friday Gemini AI bridges Ruby applications with Google's advanced Gemini AI models, enabling developers to integrate text generation, chat conversations, and AI-powered features into their Ruby projects with minimal setup.

## Key Features

### Text Generation
Generate high-quality text responses from prompts with customizable parameters for creativity and precision.

### Chat Conversations
Build interactive chat experiences with multi-turn conversation support and context awareness.

### Multiple Models
Choose from different Gemini models optimized for speed, quality, or specific use cases.

### Security First
Built-in API key validation, masking, and secure environment variable handling.

### Developer Experience
Comprehensive error handling, detailed logging, and intuitive CLI tools for testing and development.

## Architecture

```
Friday Gemini AI
├── Core Client (lib/core/)
│   ├── HTTP API communication
│   ├── Request/response handling
│   └── Error management
├── Utilities (lib/utils/)
│   ├── Environment loading
│   └── Secure logging
├── CLI Interface (bin/)
│   ├── Test commands
│   ├── Generation tools
│   └── Interactive chat
└── Examples & Tests
    ├── Usage examples
    ├── Unit tests
    └── Integration tests
```

## Getting Started

1. **Install the gem**
   ```bash
   gem install friday_gemini_ai
   ```

2. **Get your API key**
   - Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create a new API key
   - Add it to your environment

3. **Start generating**
```ruby
require 'friday_gemini_ai'
GeminiAI.load_env

client = GeminiAI::Client.new
response = client.generate_text("Hello, AI!")
puts response
```

## Use Cases

### Content Creation
Generate blog posts, marketing copy, creative writing, and documentation.

### Chatbots & Assistants
Build conversational interfaces for customer support, education, or entertainment.

### Code Analysis
Analyze code, generate documentation, or create explanations for complex algorithms.

### Data Processing
Transform unstructured text data into structured formats or summaries.

## Next Steps

- [Quickstart Guide](quickstart.md) - Get up and running in 5 minutes
- [API Reference](../reference/api.md) - Complete API documentation
- [Usage Examples](../reference/usage.md) - Comprehensive usage patterns
- [Best Practices](../guides/practices.md) - Security and performance recommendations
