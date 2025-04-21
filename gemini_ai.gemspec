Gem::Specification.new do |spec|
  spec.name        = "friday_gemini_ai"
  spec.version     = "0.1.5"
  spec.authors     = ["bniladridas"]
  spec.email       = ["bniladridas@gmail.com"]
  spec.summary     = "A Ruby gem for interacting with Google's Gemini AI models"
  spec.description = "Provides easy text generation capabilities using Google's Gemini AI models"
  spec.homepage    = "https://github.com/bniladridas/friday_gemini_ai"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.files = Dir["lib/**/*", "LICENSE", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.21.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "dotenv", "~> 2.8"
end
