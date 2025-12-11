# SPDX-License-Identifier: MIT
# Copyright (c) 2025 friday_gemini_ai

require 'test_helper'
require 'mac/mac_utils'

class MacUtilsTest < Minitest::Test
  def test_mac_detection
    # This test assumes it's running on macOS
    assert GeminiAI::MacUtils.mac?
  end

  def test_version_retrieval
    # This test assumes it's running on macOS
    version = GeminiAI::MacUtils.version
    assert version.is_a?(String)
    assert_match(/\d+\.\d+/, version)
  end

  def test_version_nil_on_non_mac
    # Mock non-mac platform
    original_platform = RUBY_PLATFORM
    RUBY_PLATFORM = 'linux'
    begin
      assert_nil GeminiAI::MacUtils.version
    ensure
      RUBY_PLATFORM = original_platform
    end
  end
end