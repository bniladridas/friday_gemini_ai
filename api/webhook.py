import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from harperbot.harperbot import webhook_handler

def handler(request):
    """Vercel serverless function handler for HarperBot webhook."""
    return webhook_handler()