#!/usr/bin/env bash

echo "Creating symlinks for Github configuration files..."

set -euo pipefail

# Absolute path of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# TARGET_DIR = where you executed the script from
TARGET_DIR="$(pwd)"

# Destination folder
DEST="$TARGET_DIR/.github"
mkdir -p "$DEST"

INCLUDE_ITEMS=(
  "instructions"
  "prompts"
  "agents"
  "skills"
)

for item in "${INCLUDE_ITEMS[@]}"; do
  SRC_PATH="$SCRIPT_DIR/$item"
  DEST_PATH="$DEST/$(basename "$item")"

  if [[ ! -e "$SRC_PATH" ]]; then
    echo "⚠️  Skipping missing item: $item"
    continue
  fi

  if [[ -e "$DEST_PATH" || -L "$DEST_PATH" ]]; then
    echo "⏭️  Already exists, skipping: $DEST_PATH"
    continue
  fi

  ln -s "$SRC_PATH" "$DEST_PATH"
  echo "🔗 Linked: $item"
done
