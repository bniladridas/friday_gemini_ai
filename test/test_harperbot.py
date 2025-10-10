#!/usr/bin/env python3
"""
Unit tests for HarperBot core functionality.
Run with: python -m pytest test/test_harperbot.py
"""
import os
import sys
import unittest
from unittest.mock import Mock, patch, MagicMock

# Add the .harperbot directory to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '.harperbot'))

from harperbot import (
    verify_webhook_signature,
    load_config,
    analyze_with_gemini,
    parse_diff_for_suggestions,
    find_diff_position
)


class TestHarperBot(unittest.TestCase):
    """Test cases for HarperBot functionality."""

    def test_verify_webhook_signature_valid(self):
        """Test webhook signature verification with valid signature."""
        payload = b'{"test": "data"}'
        secret = 'test-secret'
        import hmac
        import hashlib
        expected_sig = 'sha256=' + hmac.new(secret.encode(), payload, hashlib.sha256).hexdigest()

        result = verify_webhook_signature(payload, expected_sig, secret)
        self.assertTrue(result)

    def test_verify_webhook_signature_invalid(self):
        """Test webhook signature verification with invalid signature."""
        payload = b'{"test": "data"}'
        secret = 'test-secret'
        invalid_sig = 'sha256=invalid'

        result = verify_webhook_signature(payload, invalid_sig, secret)
        self.assertFalse(result)

    def test_load_config_defaults(self):
        """Test loading config with defaults when no config file exists."""
        with patch('os.path.exists', return_value=False):
            config = load_config()
            self.assertEqual(config['focus'], 'all')
            self.assertEqual(config['model'], 'gemini-2.0-flash')
            self.assertEqual(config['max_diff_length'], 4000)
            self.assertEqual(config['temperature'], 0.2)
            self.assertEqual(config['max_output_tokens'], 4096)
            self.assertIn('prompt', config)  # Should include default prompt

    @patch('harperbot.genai.GenerativeModel')
    @patch('harperbot.load_config')
    def test_analyze_with_gemini_success(self, mock_load_config, mock_model_class):
        """Test successful Gemini analysis."""
        # Mock config with all required keys
        mock_load_config.return_value = {
            'model': 'gemini-2.0-flash',
            'focus': 'all',
            'max_diff_length': 4000,
            'temperature': 0.2,
            'max_output_tokens': 4096,
            'prompt': 'Test prompt {num_files} {files_list} {diff_content} {focus_instruction}'
        }

        # Mock model and response
        mock_model = Mock()
        mock_response = Mock()
        mock_response.text = "Test analysis"
        mock_model.generate_content.return_value = mock_response
        mock_model_class.return_value = mock_model

        pr_details = {
            'title': 'Test PR',
            'body': 'Test body',
            'files_changed': ['test.py'],
            'diff': 'test diff'
        }

        result = analyze_with_gemini(pr_details)
        self.assertEqual(result, "Test analysis")
        mock_model.generate_content.assert_called_once()

    def test_parse_diff_for_suggestions_valid(self):
        """Test parsing diff suggestions."""
        diff_text = """--- a/test.py
+++ b/test.py
@@ -1,1 +1,1 @@
-old line
+new line"""
        result = parse_diff_for_suggestions(diff_text)
        self.assertIsNotNone(result)
        file_path, line, suggestion = result
        self.assertEqual(file_path, 'test.py')
        self.assertEqual(line, 1)
        self.assertEqual(suggestion, 'new line')

    def test_parse_diff_for_suggestions_invalid(self):
        """Test parsing invalid diff."""
        diff_text = "not a diff"
        result = parse_diff_for_suggestions(diff_text)
        self.assertIsNone(result)

    def test_find_diff_position(self):
        """Test finding position in diff hunk."""
        import textwrap
        diff = textwrap.dedent("""\
            diff --git a/test.py b/test.py
            @@ -1,3 +1,3 @@
             old line 1
            -old line 2
            +new line 2
             old line 3""").strip()
        position = find_diff_position(diff, 'test.py', 2)
        self.assertEqual(position, 3)


if __name__ == '__main__':
    unittest.main()