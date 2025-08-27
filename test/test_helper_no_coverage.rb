# frozen_string_literal: true

# Minimal test helper for CI environments where coverage is not needed
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'gemini'
require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/minitest'
require 'stringio'

# Use spec-style reporting
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]
