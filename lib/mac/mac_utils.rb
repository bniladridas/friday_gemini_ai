# SPDX-License-Identifier: MIT
# Copyright (c) 2025 friday_gemini_ai

module GeminiAI
  module MacUtils
    def self.mac?
      require 'rbconfig'
      RbConfig::CONFIG['host_os'] =~ /darwin/
    end

    def self.version
      `/usr/bin/sw_vers -productVersion`.strip if mac?
    end
  end
end
