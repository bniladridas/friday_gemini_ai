#!/usr/bin/env python3
"""
GitHub PR Bot that analyzes pull requests using Google's Gemini API.
Supports both CLI and webhook modes.
"""
import argparse
import hashlib
import hmac
import logging
import os
import re
import sys
import textwrap
from dotenv import load_dotenv
from github import Github, Auth
import google.generativeai as genai
import yaml

def find_diff_position(diff, file_path, line_number):
    """
    Find the position in the diff hunk for a given file and line number.

    Parses the unified diff to locate the hunk containing the specified line,
    then calculates the position within that hunk for inline comments.
    """
    lines = diff.split('\n')
    i = 0
    while i < len(lines):
        # Look for the diff header for the specific file
        if lines[i].startswith('diff --git') and f'b/{file_path}' in lines[i]:
            i += 1  # Skip the header
            # Process hunks for this file
            while i < len(lines) and not lines[i].startswith('diff --git'):
                if lines[i].startswith('@@'):
                    # Parse hunk header to get starting line in new file
                    match = re.match(r'@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@', lines[i])
                    if match:
                        hunk_start = int(match.group(1))
                        i += 1  # Move to hunk content
                        # Collect all lines in this hunk
                        hunk_lines = []
                        while i < len(lines) and not lines[i].startswith('@@') and not lines[i].startswith('diff --git'):
                            hunk_lines.append(lines[i])
                            i += 1
                        # Find the position of the target line in the hunk
                        position = 1
                        plus_count = 0
                        for line in hunk_lines:
                            if line.startswith('+'):
                                # Calculate the actual line number in the file
                                current_line = hunk_start + plus_count
                                plus_count += 1
                                if current_line == line_number:
                                    return position
                            position += 1
                else:
                    i += 1
        else:
            i += 1
    return None  # Line not found in any hunk

def setup_environment():
    """Load environment variables and configure the Gemini API."""
    load_dotenv()

    # Setup logging
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

    # Get GitHub token and API key from environment
    github_token = os.getenv('GITHUB_TOKEN')
    gemini_api_key = os.getenv('GEMINI_API_KEY')

    if not github_token or not gemini_api_key:
        logging.error("Missing required environment variables. Ensure GITHUB_TOKEN and GEMINI_API_KEY are set.")
        sys.exit(1)

    # Configure Gemini API
    genai.configure(api_key=gemini_api_key)
    return github_token

def get_pr_details(github_token, repo_name, pr_number):
    """Fetch PR details from GitHub."""
    g = Github(auth=Auth.Token(github_token))
    repo = g.get_repo(repo_name)
    pr = repo.get_pull(pr_number)
    
    # Get PR details
    files_changed = [f.filename for f in pr.get_files()]
    diff_url = pr.diff_url
    
    # Get diff content
    import requests
    diff_content = requests.get(diff_url).text
    
    return {
        'title': pr.title,
        'body': pr.body or "",
        'author': pr.user.login,
        'files_changed': files_changed,
        'diff': diff_content,
        'base': pr.base.ref,
        'head': pr.head.ref,
        'head_sha': pr.head.sha,
        'number': pr_number
    }

def load_config():
    default_config = {
        'focus': 'all',
        'model': 'gemini-2.0-flash',
        'max_diff_length': 4000,
        'temperature': 0.2,
        'max_output_tokens': 4096
    }
    config_path = os.path.join(os.path.dirname(__file__), 'config.yaml')
    if os.path.exists(config_path):
        with open(config_path, 'r') as f:
            try:
                user_config = yaml.safe_load(f) or {}
                return {**default_config, **user_config}
            except yaml.YAMLError as e:
                print(f"Error loading config.yaml: {e}")
                return default_config
    return default_config

def analyze_with_gemini(pr_details):
    """Analyze the PR using Gemini API."""
    try:
        config = load_config()
        model_name = config.get('model', 'gemini-2.0-flash')
        focus = config.get('focus', 'all')
        max_diff = config.get('max_diff_length', 4000)
        temperature = config.get('temperature', 0.2)
        max_output_tokens = config.get('max_output_tokens', 4096)

        # Auto-select model based on PR complexity
        diff_length = len(pr_details['diff'])
        num_files = len(pr_details['files_changed'])
        if diff_length > 10000 or num_files > 10:
            model_name = 'gemini-2.5-pro'  # More powerful model for complex PRs
        # For simple PRs, use the configured model (default gemini-2.0-flash)

        # Initialize with selected model
        model = genai.GenerativeModel(model_name)

        # Prepare the prompt based on focus
        focus_instructions = {
            'security': "Focus primarily on security concerns, authentication, data handling, and potential vulnerabilities.",
            'performance': "Focus primarily on performance optimizations, efficiency, and potential bottlenecks.",
            'quality': "Focus primarily on code quality, maintainability, readability, and best practices."
        }
        focus_instruction = focus_instructions.get(focus, "")

        prompt = {
            'role': 'user',
            'parts': [textwrap.dedent(f"""
                **Files Changed** ({len(pr_details['files_changed'])}):
                {', '.join(pr_details['files_changed'])}

                ```diff
                {pr_details['diff'][:max_diff]}
                ```

                {focus_instruction}

                Provide a concise code review analysis in this format:

                ## Summary
                [Brief overview of changes and purpose]

                ### Scores
                - Code Quality: [score]/10
                - Maintainability: [score]/10
                - Security: [score]/10

                ### Strengths
                - [Key positives]
                - [What's working well]

                ### Areas Needing Attention
                - [Potential issues or improvements]
                - [Be specific and constructive]

                ### Recommendations
                - [Specific suggestions for code, docs, or tests]

                ### Code Suggestions
                - [Provide specific code changes as diff blocks]
                - [Use ```diff format for each suggestion]

                ### Next Steps
                - [Actionable items for the author]
            """)]
        }

        # Generate content with safety settings
        response = model.generate_content(
            contents=[prompt],
            generation_config={
                'temperature': temperature,
                'top_p': 0.95,
                'top_k': 40,
                'max_output_tokens': max_output_tokens,
            },
            safety_settings=[
                {
                    "category": "HARM_CATEGORY_HARASSMENT",
                    "threshold": "BLOCK_NONE"
                },
                {
                    "category": "HARM_CATEGORY_HATE_SPEECH",
                    "threshold": "BLOCK_NONE"
                },
                {
                    "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                    "threshold": "BLOCK_NONE"
                },
                {
                    "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                    "threshold": "BLOCK_NONE"
                },
            ]
        )
        
        # Handle different response formats
        def extract_text(resp):
            """
            Extract text from Gemini API response object.

            Attempts to extract text from various possible response structures:
            - Direct text attribute
            - Candidates with content parts
            - Direct parts array

            Args:
                resp: The response object from Gemini API

            Returns:
                str: Sanitized extracted text, or None if extraction fails
            """
            try:
                # Try the standard text accessor first
                if getattr(resp, 'text', None):
                    logging.debug("Extracted text from direct response.text")
                    return sanitize_text(resp.text.strip())

                # Try candidates structure (most common for Gemini API)
                candidates = getattr(resp, 'candidates', None)
                if candidates:
                    logging.debug(f"Found {len(candidates)} candidates")
                    for i, candidate in enumerate(candidates):
                        content = getattr(candidate, 'content', None)
                        if content and getattr(content, 'parts', None):
                            parts = [getattr(part, 'text', '') for part in content.parts if getattr(part, 'text', None)]
                            if parts:
                                logging.debug(f"Extracted text from candidate {i}")
                                return sanitize_text('\n'.join(parts).strip())

                # Try direct parts access as fallback
                parts = getattr(resp, 'parts', None)
                if parts:
                    parts = [getattr(part, 'text', '') for part in parts if getattr(part, 'text', None)]
                    if parts:
                        logging.debug("Extracted text from direct response.parts")
                        return sanitize_text('\n'.join(parts).strip())

                logging.warning("No text found in any response structure")
            except Exception as extract_error:
                logging.error(f"Error during text extraction: {str(extract_error)}")
                return None

            return None

        def sanitize_text(text):
            """Comprehensive sanitization of extracted text for security."""
            if not text:
                return text
            # Remove potentially dangerous patterns
            text = re.sub(r'</?script[^>]*>', '', text, flags=re.IGNORECASE)
            text = re.sub(r'<[^>]+>', '', text)  # Remove all HTML tags
            text = re.sub(r'javascript:', '', text, flags=re.IGNORECASE)
            text = re.sub(r'on\w+\s*=', '', text, flags=re.IGNORECASE)  # Remove event handlers
            # Limit length to prevent abuse
            if len(text) > 10000:
                text = text[:10000] + '... (truncated for length)'
            return text.strip()

        try:
            text = extract_text(response)
            if text:
                return text

            # If we get here, no text found - log and return safe message
            logging.warning(f"No text extracted from response. Response type: {type(response)}")
            raise ValueError("No text could be extracted from the AI response")

        except Exception as e:
            # Log the error and return safe info
            logging.error(f"Error processing Gemini response: {str(e)}")
            return f"Error processing response: {str(e)}\n\nResponse type: {type(response)}"

        except Exception as e:
            # Log the error and return safe info (avoid leaking sensitive response data)
            print(f"Error processing Gemini response: {str(e)}")
            return f"Error processing response: {str(e)}\n\nResponse type: {type(response)}"

    except Exception as e:
        error_msg = str(e).lower()
        context = f" (PR: {pr_details.get('title', 'Unknown')}, Model: {model_name}, Diff length: {len(pr_details.get('diff', ''))})"
        if 'quota' in error_msg or 'rate limit' in error_msg or 'billing' in error_msg:
            logging.error(f"API quota/rate limit error{context}: {str(e)}")
            return f"Error generating analysis: API quota exceeded{context}. Please check your billing or try again later."
        elif 'api key' in error_msg or 'authentication' in error_msg or 'unauthorized' in error_msg:
            logging.error(f"API authentication error{context}: {str(e)}")
            return f"Error generating analysis: Invalid API key or authentication failed{context}. Please check your GEMINI_API_KEY."
        elif 'model' in error_msg or 'not found' in error_msg:
            logging.error(f"Model error{context}: {str(e)}")
            return f"Error generating analysis: Requested model not available{context}. Please try again later."
        else:
            logging.error(f"Unexpected API error{context}: {str(e)}")
            return f"Error generating analysis: API unavailable{context}. Please try again later."

def parse_diff_for_suggestions(diff_text):
    """Parse a diff block to extract file, line, and suggestion code."""
    lines = diff_text.strip().split('\n')
    if not lines or not lines[0].startswith('--- a/'):
        return None
    file_path = lines[0][6:]  # --- a/file
    hunk_start = None
    suggestion_lines = []
    for line in lines:
        if line.startswith('@@'):
            match = re.match(r'@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@', line)
            if match:
                hunk_start = int(match.group(1))
        elif line.startswith('+') and hunk_start is not None:
            suggestion_lines.append(line[1:])  # remove +
    if hunk_start is not None and suggestion_lines:
        return file_path, hunk_start, '\n'.join(suggestion_lines)
    return None

def format_comment(analysis):
    """Format the analysis with proper markdown and emojis."""
    return f"""[![HarperBot](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/codebot.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/codebot.yml)

<details>
<summary>HarperBot Analysis</summary>

{analysis}

</details>

---"""

def post_comment(github_token, repo_name, pr_details, analysis):
    """Post a comment on the PR with proper formatting and inline suggestions."""
    try:
        g = Github(auth=Auth.Token(github_token))
        repo = g.get_repo(repo_name)
        pr = repo.get_pull(pr_details['number'])
        
        # Parse suggestions from analysis (diff blocks)
        diff_blocks = re.findall(r'```diff\n(.*?)\n```', analysis, re.DOTALL)
        suggestions = []
        for diff_text in diff_blocks:
            parsed = parse_diff_for_suggestions(diff_text)
            if parsed:
                file_path, line, suggestion = parsed
                suggestions.append((file_path, str(line), suggestion))
        
        # Remove suggestions from main comment to avoid duplication
        main_comment = re.sub(r'### Code Suggestions\n.*?(?=###|$)', '### Code Suggestions\n- Suggestions posted as inline comments below.\n', analysis, flags=re.DOTALL)
        
        # Format and post main comment
        formatted_comment = format_comment(main_comment)
        pr.create_issue_comment(formatted_comment)
        
        # Post inline suggestions as a review
        if suggestions:
            comments = []
            for file_path, line_str, suggestion in suggestions:
                try:
                    line = int(line_str)
                    position = find_diff_position(pr_details['diff'], file_path, line)
                    if position is not None:
                        comments.append({
                            'path': file_path,
                            'position': position,
                            'body': f"```suggestion\n{suggestion}\n```"
                        })
                    else:
                        print(f"Could not find diff position for {file_path}:{line}")
                except ValueError:
                    print(f"Invalid line number: {line_str}")
            if comments:
                try:
                    pr.create_review(
                        commit=pr_details['head_sha'],
                        comments=comments,
                        event='COMMENT'
                    )
                except Exception as e:
                    print(f"Error posting review with suggestions: {str(e)}")
        
    except Exception as e:
        print(f"Error posting comment: {str(e)}")
        raise

def main():
    """Main function to run the PR bot."""
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='GitHub PR Bot with Gemini AI')
    parser.add_argument('--repo', required=True, help='GitHub repository in format: owner/repo')
    parser.add_argument('--pr', type=int, required=True, help='Pull request number')
    args = parser.parse_args()
    
    # Setup environment and get PR details
    github_token = setup_environment()
    pr_details = get_pr_details(github_token, args.repo, args.pr)
    
    # Analyze PR with Gemini
    logging.info("Analyzing PR with Gemini...")
    analysis = analyze_with_gemini(pr_details)
    logging.debug("Analysis response received")
    logging.debug(analysis)

    # Post the comment with formatted analysis
    logging.info("Posting analysis to PR...")
    post_comment(github_token, args.repo, pr_details, analysis)
    logging.info("Analysis complete!")

if __name__ == "__main__":
    main()

