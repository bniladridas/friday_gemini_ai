Gem::Specification.new do |spec|
  spec.name        = 'friday_gemini_ai'
  spec.version     = '0.1.6'
  spec.authors     = ['Niladri Das']
  spec.email       = ['bniladridas@gmail.com']
  spec.summary     = "A Ruby gem for interacting with Google's Gemini AI models"
  spec.description = "Provides easy text generation capabilities using Google's Gemini AI models"
  spec.homepage    = 'https://github.com/bniladridas/friday_gemini_ai'
  spec.license     = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.files = Dir['lib/**/*', 'LICENSE', 'README.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '>= 0.21', '< 0.24'
  # Testing
  spec.add_development_dependency 'dotenv', '~> 2.8'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0.6'
  # spec.add_development_dependency 'simplecov', '~> 0.22.0'
  # spec.add_development_dependency 'simplecov-lcov', '~> 0.9.0'

  # Documentation
  spec.add_development_dependency 'github-markup', '~> 5.0'
  # spec.add_development_dependency 'redcarpet', '~> 3.6' # For markdown in YARD
  spec.add_development_dependency 'yard', '~> 0.9.34'

  # Code quality
  spec.add_development_dependency 'rubocop', '~> 1.72.1'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.25.0'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
