# frozen_string_literal: true

module GeminiAI
  module Utils
    # Content moderation utility for filtering potentially harmful or inappropriate content
    class Moderation
      # Patterns for detecting potentially harmful content
      HARMFUL_PATTERNS = [
        /\b(hack|exploit|malware|virus|trojan|ransomware)/i,
        /\b(illegal|unlawful|criminal)/i,
        /\b(violence|kill|harm|attack)/i,
        /\b(drug|weapon|nuclear)/i
      ].freeze

      # Moderate text by checking for harmful patterns and redacting them
      def self.moderate_text(text)
        return text unless text.is_a?(String)

        moderated = text.dup
        warnings = []

        HARMFUL_PATTERNS.each do |pattern|
          if moderated =~ pattern
            warnings << "Detected potentially harmful pattern: #{pattern.inspect}"
            moderated.gsub!(pattern, '[REDACTED]')
          end
        end

        # Log warnings if any
        warnings.each { |w| Client.logger.warn(w) } unless warnings.empty?

        moderated
      end
    end
  end
end
