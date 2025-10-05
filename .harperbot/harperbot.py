#!/usr/bin/env python3
"""
GitHub PR Bot that analyzes pull requests using Google's Gemini API.
"""
import os
import sys
import argparse
import textwrap
from datetime import datetime
from github import Github, Auth, Auth
from dotenv import load_dotenv
import google.generativeai as genai
import yaml

def setup_environment():
    """Load environment variables and configure the Gemini API."""
    load_dotenv()
    
    # Get GitHub token and API key from environment
    github_token = os.getenv('GITHUB_TOKEN')
    gemini_api_key = os.getenv('GEMINI_API_KEY')
    
    if not github_token or not gemini_api_key:
        print("Error: Missing required environment variables. Ensure GITHUB_TOKEN and GEMINI_API_KEY are set.")
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
        'number': pr_number,
        'repo': repo_name
    }

def load_config():
    """Load configuration from config.yaml."""
    config_path = os.path.join(os.path.dirname(__file__), 'config.yaml')
    if os.path.exists(config_path):
        with open(config_path, 'r') as f:
            return yaml.safe_load(f)
    return {
        'focus': 'all',
        'model': 'gemini-1.5-flash',
        'max_diff_length': 4000,
        'temperature': 0.2
    }

def analyze_with_gemini(pr_details):
    """Analyze the PR using Gemini API."""
    try:
        config = load_config()
        model_name = config.get('model', 'gemini-2.0-flash')
        focus = config.get('focus', 'all')
        max_diff = config.get('max_diff_length', 4000)
        temperature = config.get('temperature', 0.2)

        # Auto-select model based on PR complexity
        diff_length = len(pr_details['diff'])
        num_files = len(pr_details['files_changed'])
        if diff_length > 10000 or num_files > 10:
            model_name = 'gemini-1.5-pro'  # More powerful model for complex PRs
        # For simple PRs, use the configured model (default gemini-1.5-flash)

        # Initialize with selected model
        model = genai.GenerativeModel(model_name)
        
        # Prepare the prompt based on focus
        focus_instruction = ""
        if focus == 'security':
            focus_instruction = "Focus primarily on security concerns, authentication, data handling, and potential vulnerabilities."
        elif focus == 'performance':
            focus_instruction = "Focus primarily on performance optimizations, efficiency, and potential bottlenecks."
        elif focus == 'quality':
            focus_instruction = "Focus primarily on code quality, maintainability, readability, and best practices."

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
                - [Provide specific code changes with inline diffs where applicable]
                - [Use ```diff format for code suggestions]

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
                'max_output_tokens': 2048,
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
        try:
            # Try the standard text accessor first
            if hasattr(response, 'text'):
                return response.text
                
            # Try to get text from parts
            if hasattr(response, 'parts'):
                parts = [part.text for part in response.parts if hasattr(part, 'text')]
                if parts:
                    return '\n'.join(parts)
                    
            # Try candidates structure
            if hasattr(response, 'candidates') and response.candidates:
                for candidate in response.candidates:
                    if hasattr(candidate, 'content') and hasattr(candidate.content, 'parts'):
                        parts = [part.text for part in candidate.content.parts if hasattr(part, 'text')]
                        if parts:
                            return '\n'.join(parts)
                            
            # Try direct access to the first part's text
            if hasattr(response, 'parts') and len(response.parts) > 0:
                part = response.parts[0]
                if hasattr(part, 'text'):
                    return part.text
                    
            # If we get here, try to stringify the response
            return str(response)
            
        except Exception as e:
            # If all else fails, return a detailed error
            return f"Error processing response: {str(e)}\n\nResponse structure: {dir(response)}\n" + \
                   f"Response type: {type(response)}\n" + \
                   f"Response content: {response}"
        
    except Exception as e:
        return "Error generating analysis: API quota exceeded or unavailable. Please try again later."

def format_comment(analysis):
    """Format the analysis with proper markdown and emojis."""
    return f"""[![HarperBot](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/codebot.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/codebot.yml)

{analysis}

---"""

def post_comment(github_token, repo_name, pr_number, comment):
    """Post a comment on the PR with proper formatting."""
    try:
        g = Github(auth=Auth.Token(github_token))
        repo = g.get_repo(repo_name)
        pr = repo.get_pull(pr_number)
        
        # Format the comment with consistent styling
        formatted_comment = format_comment(comment)
        
        # Post the comment
        pr.create_issue_comment(formatted_comment)
        
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
    print("Analyzing PR with Gemini...")
    analysis = analyze_with_gemini(pr_details)
    
    # Post the comment with formatted analysis
    print("Posting analysis to PR...")
    post_comment(github_token, args.repo, args.pr, analysis)
    print("Analysis complete!")

if __name__ == "__main__":
    main()
