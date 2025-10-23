#!/usr/bin/env python3

import glob
import os

from ruamel.yaml import YAML

yaml = YAML()
yaml.indent(mapping=2, sequence=4, offset=2)
yaml.preserve_quotes = True
yaml.width = 80  # Try to keep lines under 80, but may not always work

# Directory to fix
dir_path = ".github"

# Find all .yml and .yaml files
files = glob.glob(os.path.join(dir_path, "**", "*.yml"), recursive=True) + glob.glob(
    os.path.join(dir_path, "**", "*.yaml"), recursive=True
)

for file_path in files:
    print(f"Processing {file_path}...")
    try:
        with open(file_path, "r") as f:
            data = yaml.load(f)

        # Write back with proper formatting
        with open(file_path, "w") as f:
            yaml.dump(data, f)

        # Add --- at the top if missing
        with open(file_path, "r") as f:
            content = f.read()
        if not content.startswith("---"):
            with open(file_path, "w") as f:
                f.write("---\n" + content)

        print(f"  Fixed {file_path}")
    except Exception as e:
        print(f"  Error processing {file_path}: {e}")

print("Done fixing YAML files.")
