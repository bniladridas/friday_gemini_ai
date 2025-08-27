# frozen_string_literal: true

require 'yard'

namespace :docs do
  desc 'Generate YARD documentation'
  task :generate do
    YARD::Rake::YardocTask.new do |t|
      t.files   = ['lib/**/*.rb', 'README.md']
      t.options = ['--output-dir', 'doc']
    end
    puts 'Documentation generated in doc/ directory'
  end

  desc 'Start a local documentation server'
  task :preview do
    puts 'Starting YARD documentation server at http://localhost:8808'
    puts 'Press CTRL+C to stop'
    system('yard server -r -p 8808')
  end
end

desc 'Alias for docs:generate'
task docs: 'docs:generate'
