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
    model = genai.GenerativeModel('gemini-pro')
    
    # Prepare the prompt
    prompt = f"""
    Please review the following pull request and provide feedback:
    
    Title: {pr_details['title']}
    Description: {pr_details['body']}
    
    Files changed: {', '.join(pr_details['files_changed'])}
    
    Diff:
    ```diff
    {pr_details['diff'][:4000]}  # Limit diff size to avoid context window issues
    ```
    
    Please provide:
    1. A brief summary of the changes
    2. Code quality assessment
    3. Potential issues or bugs
    4. Security concerns, if any
    5. Suggestions for improvement
    """
    
    try:
        response = model.generate_content(prompt)
        return response.text
    except Exception as e:
        return f"Error generating analysis: {str(e)}"

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
