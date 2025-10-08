#!/bin/bash

# Read the commit message from stdin
MSG=$(cat)

# Get first line
FIRST_LINE=$(echo "$MSG" | head -n1)

# Make lowercase
FIRST_LINE=$(echo "$FIRST_LINE" | tr '[:upper:]' '[:lower:]')

# Truncate to 60 chars
FIRST_LINE=$(echo "$FIRST_LINE" | cut -c1-60)

# Replace first line in MSG
echo "$MSG" | sed "1s/.*/$FIRST_LINE/"