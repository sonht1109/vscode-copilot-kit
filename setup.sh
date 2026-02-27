#!/usr/bin/env bash

set -euo pipefail

# Absolute path of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# TARGET_DIR = where you executed the script from
TARGET_DIR="$(pwd)"

# Destination folder
DEST="$TARGET_DIR/.github"
mkdir -p "$DEST"

INCLUDE_ITEMS=(
  ".github/instructions"
  ".github/prompts"
  ".github/skills"
  ".github/hooks"
  ".github/scripts"
  ".github/agents"
)

TO_REMOVE_ITEMS=(
  "instructions"
  "prompts"
  "skills"
  "hooks"
  "scripts"
  "agents"
  ".copilotignore"
)

echo "Pulling latest changes from the repository..."

cd "$SCRIPT_DIR" && git pull origin main && cd "$TARGET_DIR"

echo "Creating symlinks for Github configuration files..."

for item in "${TO_REMOVE_ITEMS[@]}"; do
  TARGET_PATH="$DEST/$(basename "$item")"
  if [[ -e "$TARGET_PATH" || -L "$TARGET_PATH" ]]; then
    rm -rf "$TARGET_PATH"
    echo "🗑️  Removed existing item: $TARGET_PATH"
  fi
done

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

chmod +x .github/scripts/hooks/*.sh

echo "Creating .agentignore if it doesn't exist..."

cp -n "$SCRIPT_DIR/.agentignore.example" "$TARGET_DIR/.github/.agentignore" 2>/dev/null || true
