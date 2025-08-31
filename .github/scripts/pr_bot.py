#!/usr/bin/env python3
"""
GitHub PR Bot that analyzes pull requests using Google's Gemini API.
"""
import os
import sys
import argparse
import textwrap
from github import Github
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
        model = genai.GenerativeModel('gemini-1.5-flash')
        
        # Prepare the prompt with clear instructions
        prompt = {
            'role': 'user',
            'parts': [f"""
            📝 **Pull Request Review Requested**
            
            **Title**: {pr_details['title']}
            **Description**: {pr_details['body'] or 'No description provided'}
            
            📂 **Files Changed** ({len(pr_details['files_changed'])}):
            {', '.join(pr_details['files_changed'])}
            
            ```diff
            {pr_details['diff'][:4000]}
            ```
            
            Please provide a detailed analysis with the following sections:
            
            ## 🔍 Summary
            A brief overview of the changes and their purpose.
            
            ## 🛠️ Code Quality
            - Code structure and organization
            - Adherence to best practices
            - Style consistency
            - Documentation quality
            
            ## ⚠️ Potential Issues
            - Bugs or logical errors
            - Edge cases not handled
            - Performance considerations
            - Potential race conditions
            
            ## 🔒 Security
            - Input validation
            - Authentication/Authorization
            - Data protection
            - Dependency vulnerabilities
            
            ## 💡 Suggestions for Improvement
            - Code optimizations
            - Refactoring opportunities
            - Test coverage improvements
            - Documentation enhancements
            
            Please format your response in clear markdown with appropriate headers and emojis for better readability.
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

def post_comment(github_token, repo_name, pr_number, comment):
    """Post a comment on the PR."""
    g = Github(github_token)
    repo = g.get_repo(repo_name)
    pr = repo.get_pull(pr_number)
    pr.create_issue_comment(comment)

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
    
    # Format the comment
    comment = f"""
    ## 🤖 PR Analysis by Gemini AI
    
    {analysis}
    
    ---
    *This is an automated analysis. Please review the suggestions carefully.*
    """
    
    # Post the comment
    print("Posting analysis to PR...")
    post_comment(github_token, args.repo, args.pr, comment)
    print("Analysis complete!")

if __name__ == "__main__":
    main()
