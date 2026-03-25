#!/usr/bin/env bash

set -euo pipefail

echo -e "\n🚀🚀🚀 Setting up Opencode ...\n"

# Absolute path of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# TARGET_DIR = where you executed the script from
TARGET_DIR="$(pwd)"

# Parse command-line arguments
USE_LINK=false

for arg in "$@"; do
  case "$arg" in
    -ln|--link)
      USE_LINK=true
      ;;
    -cp|--copy)
      USE_LINK=false
      ;;
    -h|--help)
      echo "Usage: ./setup-opencode.sh [options]"
      echo ""
      echo "Options:"
      echo "  -cp, --copy    Copy files instead of linking (default)"
      echo "  -ln, --link    Create symbolic links instead of copying"
      echo "  -h, --help     Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Use -h or --help for usage information"
      exit 1
      ;;
  esac
done

# Destination folder
DEST="$TARGET_DIR/.opencode"
mkdir -p "$DEST"

INCLUDE_ITEMS=(
  ".opencode/agents"
  ".opencode/commands"
  ".opencode/skills"
  ".opencode/rules"
  ".opencode/plugins"
  ".opencode/templates"
)

TO_REMOVE_ITEMS=(
  "agents"
  "commands"
  "skills"
  "rules"
  "plugins"
  ".agentignore"
  "sh-config.json"
  "templates"
)

if [[ "$USE_LINK" == true ]]; then
  echo "Creating symlinks for OpenCode configuration files..."
  MODE_MSG="Linked"
  MODE_EMOJI="🔗"
else
  echo "Copying OpenCode configuration files..."
  MODE_MSG="Copied"
  MODE_EMOJI="📋"
fi

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

  if [[ "$USE_LINK" == true ]]; then
    ln -s "$SRC_PATH" "$DEST_PATH"
  else
    cp -r "$SRC_PATH" "$DEST_PATH"
  fi
  echo "$MODE_EMOJI $MODE_MSG: $item"
done

# chmod +x .opencode/scripts/hooks/*.sh

echo "Creating opencode.json if it doesn't exist..."

cp -n "$SCRIPT_DIR/.opencode/opencode.example.json" "$TARGET_DIR/.opencode/opencode.json" 2>/dev/null || true

bash $SCRIPT_DIR/setup-config.sh

echo -e "\n✅ Done Opencode\n"