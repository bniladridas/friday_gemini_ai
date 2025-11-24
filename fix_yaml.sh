# SPDX-License-Identifier: MIT
# Copyright (c) 2025 friday_gemini_ai

#!/bin/bash

# Script to fix common yamllint errors in .github/ directory

set -e

echo "Fixing yamllint errors in .github/ files..."

# List of YAML files in .github/
files=(
    ".github/FUNDING.yml"
    ".github/dependabot.yml"
    ".github/workflows/release.yml"
    ".github/workflows/dependencies.yml"
    ".github/workflows/security.yml"
    ".github/workflows/labeler.yml"
    ".github/workflows/manual.yml"
    ".github/workflows/harperbot.yml"
    ".github/workflows/stale.yml"
    ".github/workflows/cleanup.yml"
    ".github/workflows/e2e.yml"
    ".github/workflows/ci.yml"
    ".github/ISSUE_TEMPLATE/config.yml"
)

for file in "${files[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "File $file not found, skipping."
        continue
    fi

    echo "Processing $file..."

    # Add --- at the top if missing
    if ! head -1 "$file" | grep -q "^---$"; then
        # Remove leading blank lines
        sed -i '/./,$!d' "$file"
        # Add --- at top
        sed -i '1i---' "$file"
        echo "  Added document start to $file"
    fi

    # Fix brackets: remove spaces inside []
    sed -i 's/\[ \([^]]*\) \]/[\1]/g' "$file"
    sed -i 's/\[ \([^]]*\)\]/[\1]/g' "$file"
    sed -i 's/\[\([^]]*\) \]/[\1]/g' "$file"

    # Fix comments: add space before # if missing
    sed -i 's/\([^ ]\)\(#\)/\1 \2/g' "$file"

    # For config.yml, remove --- since it's not needed for issue templates
    if [[ "$file" == ".github/ISSUE_TEMPLATE/config.yml" ]]; then
        if head -1 "$file" | grep -q "^---$"; then
            sed -i '1d' "$file"
            echo "  Removed document start from $file (issue template)"
        fi
    fi

    # Note: Line lengths and indentation are not easily fixed automatically
    # They require manual review

done

echo "Done. Run yamllint again to check remaining errors."
echo "Note: Line length and indentation errors need manual fixing."
