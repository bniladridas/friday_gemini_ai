#!/usr/bin/env python3
"""
GitHub PR Bot that analyzes pull requests using Google's Gemini API.
"""
import os
import sys
import argparse
import textwrap
from datetime import datetime
from github import Github, Auth
from dotenv import load_dotenv
import google.generativeai as genai

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
    g = Github(github_token)
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

def analyze_with_gemini(pr_details):
    """Analyze the PR using Gemini API."""
    try:
        # Initialize with a stable model version
        model = genai.GenerativeModel('gemini-2.5-flash')
        
        # Prepare the prompt with clear instructions
        prompt = {
            'role': 'user',
            'parts': [f"""
             **Files Changed** ({len(pr_details['files_changed'])}):
             {', '.join(pr_details['files_changed'])}
             
             ```diff
             {pr_details['diff'][:4000]}
             ```
             
             Please provide a detailed analysis following this exact format. Ensure the analysis is accurate, concise, and noise-free. Replace all [placeholder] text with actual content:
            
            ## 🔍 Summary
            [Brief overview of changes and purpose]
            
             ### Strengths
             - [List key strengths]
            - [Focus on what's working well]
            
             ### Areas Needing Attention
             - [List potential issues]
            - [Be specific and constructive]
            
             <details><summary>Code Quality</summary>
             Structure & Organization
             - [Comments on code structure]
             
             Style & Readability
             - [Comments on code style and readability]
             </details>
            
             <details><summary>Potential Issues</summary>
             Bugs & Edge Cases
             - [List any potential bugs]
             
             Performance
             - [Performance considerations]
             </details>
            
             <details><summary>Security</summary>
             Authentication & Data
             - [Security considerations]
             
             Dependencies
             - [Dependency analysis]
             </details>
            
             <details><summary>Recommendations</summary>
             Code Improvements
             - [Specific improvement suggestions with code examples in code blocks if applicable]
             
             Documentation
             - [Documentation suggestions]
             </details>
            
             ### Next Steps
             - [Actionable next steps]
            
Format your response with:
             - Clear section headers (minimal emojis)
             - Bullet points for lists
             - Code blocks with syntax highlighting
             - Bold text for important points
             - Keep lines under 100 characters
             - Craft the language for a clearer, more harmonious reading experience with no clutter
             - Ensure cleaner, more focused writing with no unnecessary repetition
             - Create no linguistic noise
             - Refine the language and structure for a seamless and noise-free narrative
             - Absolutely no excess or repetition
             - Do not add any extra headings, footers, or repetitions
             - Stick exactly to the format provided
             - Do not wrap the response in code blocks or backticks
             - Use only 🐛 and 🔍 emojis if any, no other emojis
             - Typography to create a cleaner, more harmonious visual experience with no noise
             - Cleaner, more focused user interface with no redundancy
             - Creates no visual noise
             - Further refine the typography and interface to create an even cleaner, more harmonious visual experience with absolutely no noise or redundancy
            """]
        }
        
        # Generate content with safety settings
        response = model.generate_content(
            contents=[prompt],
            generation_config={
                'temperature': 0.2,
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
        import traceback
        error_details = f"""
        Error details:
        - Type: {type(e).__name__}
        - Message: {str(e)}
        - Available models: {', '.join([m.name for m in genai.list_models()]) if hasattr(genai, 'list_models') else 'N/A'}
        """
        return f"Error generating analysis: {str(e)}\n{error_details}"

def format_comment(analysis):
    """Format the analysis with proper markdown and emojis."""
    return f"""[![HarperBot](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/codebot.yml/badge.svg)](https://github.com/bniladridas/friday_gemini_ai/actions/workflows/codebot.yml)

## PR Analysis by HarperBot

Generated at {datetime.now().strftime('%Y-%m-%d %H:%M:%S UTC')}

{analysis}

---
*This is an automated analysis by [@harpertoken](https://github.com/harpertoken) (Harper). Please review the suggestions carefully.*"""

def post_comment(github_token, repo_name, pr_number, comment):
    """Post a comment on the PR with proper formatting."""
    try:
        g = Github(github_token)
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
