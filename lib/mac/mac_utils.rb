# SPDX-License-Identifier: MIT
# Copyright (c) 2025 friday_gemini_ai

require 'rbconfig'

module GeminiAI
  module MacUtils
    def self.mac?
      RbConfig::CONFIG['host_os'] =~ /darwin/
    end

    def self.version
      `sw_vers -productVersion`.strip if mac?
    end
  end
end
