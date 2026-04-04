#!/usr/bin/env bash

set -euo pipefail

# Absolute path of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# TARGET_DIR = where you executed the script from
TARGET_DIR="$(pwd)"

# Parse command-line arguments
USE_LINK=false
USE_ALL=false

for arg in "$@"; do
  case "$arg" in
    -ln|--link)
      USE_LINK=true
      ;;
    -cp|--copy)
      USE_LINK=false
      ;;
    -a|--all)
      USE_ALL=true
      ;;
    -h|--help)
      echo "Usage: ./setup.sh [options]"
      echo ""
      echo "Options:"
      echo "  [blank]        Setup for VSCode Copilot"
      echo "  -cp, --copy    Copy files instead of linking (default)"
      echo "  -ln, --link    Create symbolic links instead of copying"
      echo "  -a,  --all     Also run setup-claude.sh and setup-opencode.sh"
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
DEST="$TARGET_DIR/.github"
mkdir -p "$DEST"

INCLUDE_ITEMS=(
  ".github/instructions"
  ".github/prompts"
  ".github/skills"
  ".github/hooks"
  ".github/scripts"
  ".github/agents"
  ".github/templates"
)

TO_REMOVE_ITEMS=(
  "instructions"
  "prompts"
  "skills"
  "hooks"
  "scripts"
  "agents"
  ".agentignore"
  "templates"
)

echo -e "\n🚀🚀🚀 Setting up Copilot ...\n"

if [[ "$USE_LINK" == true ]]; then
  echo "Creating symlinks for Github configuration files..."
  MODE_MSG="Linked"
  MODE_EMOJI="🔗"
else
  echo "Copying Github configuration files..."
  MODE_MSG="Copied"
  MODE_EMOJI="📋"
fi

# Create temporary directory for backing up *.local.* files
TMP_BACKUP_DIR=$(mktemp -d)
trap "rm -rf '$TMP_BACKUP_DIR'" EXIT

# Backup *.local.* files and *-local/ folders from TO_REMOVE_ITEMS
for item in "${TO_REMOVE_ITEMS[@]}"; do
  TARGET_PATH="$DEST/$(basename "$item")"
  
  if [[ -d "$TARGET_PATH" ]]; then
    BACKUP_ITEM_DIR="$TMP_BACKUP_DIR/$(basename "$item")"
    mkdir -p "$BACKUP_ITEM_DIR"
    
    # Backup *.local.* files
    if compgen -G "$TARGET_PATH/*.local.*" > /dev/null 2>&1; then
      cp "$TARGET_PATH"/*.local.* "$BACKUP_ITEM_DIR/" 2>/dev/null || true
      echo "💾 Backed up local files from: $TARGET_PATH"
    fi
    
    # Backup *-local/ folders
    if compgen -G "$TARGET_PATH/*-local" > /dev/null 2>&1; then
      cp -r "$TARGET_PATH"/*-local "$BACKUP_ITEM_DIR/" 2>/dev/null || true
      echo "💾 Backed up local folders from: $TARGET_PATH"
    fi
  fi
done

# Now remove all TO_REMOVE_ITEMS
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

chmod +x .github/scripts/hooks/*.sh

bash "$SCRIPT_DIR/setup-config.sh"

# Restore backed up *.local.* files and *-local/ folders
for backup_item in "$TMP_BACKUP_DIR"/*; do
  if [[ -d "$backup_item" ]]; then
    item_name=$(basename "$backup_item")
    TARGET_PATH="$DEST/$item_name"
    RESTORE_PATH="$TARGET_PATH"
    
    # If TARGET_PATH is a symlink, resolve to the actual directory
    if [[ -L "$TARGET_PATH" ]]; then
      RESTORE_PATH=$(readlink -f "$TARGET_PATH")
    fi
    
    # Create the directory if it doesn't exist
    if [[ ! -d "$RESTORE_PATH" ]]; then
      mkdir -p "$RESTORE_PATH"
    fi
    
    # Restore *.local.* files
    if compgen -G "$backup_item/*.local.*" > /dev/null 2>&1; then
      cp "$backup_item"/*.local.* "$RESTORE_PATH/" 2>/dev/null || true
      echo "♻️  Restored local files to: $RESTORE_PATH"
    fi
    
    # Restore *-local/ folders
    if compgen -G "$backup_item/*-local" > /dev/null 2>&1; then
      cp -r "$backup_item"/*-local "$RESTORE_PATH/" 2>/dev/null || true
      echo "♻️  Restored local folders to: $RESTORE_PATH"
    fi
  fi
done

echo -e "\n✅ Done Copilot\n"

# If --all is passed, also run setup-claude.sh and setup-opencode.sh
if [[ "$USE_ALL" == true ]]; then
  LINK_FLAG=""
  if [[ "$USE_LINK" == true ]]; then
    LINK_FLAG="--link"
  fi
  echo ""
  echo "Running additional setup scripts..."
  bash "$SCRIPT_DIR/setup-claude.sh" $LINK_FLAG && bash "$SCRIPT_DIR/setup-opencode.sh" $LINK_FLAG
fi
