#!/usr/bin/env bash
set -e  # Exit on error
LOG_FILE=~/Obsidian/Laurent/fabric/patterns/flatten.log
PATTERNS_DIR=~/Obsidian/Laurent/fabric/patterns

echo "Starting flattening process at $(date)" > "$LOG_FILE"

# Move system.md files
find "$PATTERNS_DIR" -type f -name "system.md" -not -path "$PATTERNS_DIR/system.md" -exec sh -c '
  folder_name=$(basename "$(dirname "{}")")
  mv "{}" "$0/$folder_name_system.md" && echo "Moved {} to $0/$folder_name_system.md" >> "$1"
' "$PATTERNS_DIR" "$LOG_FILE" \;

# Move README.md files
find "$PATTERNS_DIR" -type f -name "README.md" -not -path "$PATTERNS_DIR/README.md" -exec sh -c '
  folder_name=$(basename "$(dirname "{}")")
  mv "{}" "$0/$folder_name_README.md" && echo "Moved {} to $0/$folder_name_README.md" >> "$1"
' "$PATTERNS_DIR" "$LOG_FILE" \;

# Remove empty directories
find "$PATTERNS_DIR" -type d -mindepth 1 -empty -delete -exec echo "Deleted empty directory {}" >> "$LOG_FILE" \;

# Remove remaining directories, ignoring non-empty ones
find "$PATTERNS_DIR" -type d -mindepth 1 -exec rmdir --ignore-fail-on-non-empty {} + -exec echo "Attempted to delete {}" >> "$LOG_FILE" \;

echo "Flattening complete at $(date)" >> "$LOG_FILE"

