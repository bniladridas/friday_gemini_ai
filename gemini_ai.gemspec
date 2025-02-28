Gem::Specification.new do |spec|
  spec.name        = 'friday_gemini_ai'
  spec.version     = '0.1.1'
  spec.date        = '2025-03-01'
  spec.summary     = 'Ruby interface for Google Gemini AI models'
  spec.description = 'A flexible Ruby gem for generating text using Google Gemini AI models with comprehensive error handling and multiple model support.'
  spec.authors     = ['bniladridas']
  spec.email       = ['bniladridas@gmail.com']
  spec.homepage    = 'https://github.com/bniladridas/friday_gemini_ai'
  spec.license     = 'MIT'

  spec.files = [
    'lib/gemini_ai.rb',
    'README.md',
    'LICENSE',
    'gemini_ai.gemspec'
  ]

  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.0.0'

  # Runtime dependencies
  spec.add_runtime_dependency 'httparty', '~> 0.21.0'
  spec.add_runtime_dependency 'json', '~> 2.6.3'

  # Development dependencies
  spec.add_development_dependency 'minitest', '~> 5.25.4'
  spec.add_development_dependency 'dotenv', '~> 2.8'
  spec.add_development_dependency 'rake', '~> 13.0'

  spec.metadata = {
    'source_code_uri' => 'https://github.com/bniladridas/friday_gemini_ai',
    'documentation_uri' => 'https://github.com/bniladridas/friday_gemini_ai/blob/main/README.md',
    'bug_tracker_uri' => 'https://github.com/bniladridas/friday_gemini_ai/issues'
  }
end
