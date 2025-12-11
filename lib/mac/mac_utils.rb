# SPDX-License-Identifier: MIT
# Copyright (c) 2025 friday_gemini_ai

module GeminiAI
  module MacUtils
    def self.mac?
      RUBY_PLATFORM.include?('darwin')
    end

    def self.version
      `sw_vers -productVersion`.strip if mac?
    end
  end
end
