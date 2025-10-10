import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from harperbot.harperbot import app

# Export the Flask app as the handler for Vercel
handler = app