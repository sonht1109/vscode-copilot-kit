#!/usr/bin/env bash

set -euo pipefail

echo -e "\n🚀🚀🚀 Setting up Configuration files ...\n"

# Absolute path of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p ~/.config/vscode-copilot-kit

cp -n "$SCRIPT_DIR/.agentignore.example" ~/.config/vscode-copilot-kit/.agentignore || true
cp -n "$SCRIPT_DIR/sh-config.json.example" ~/.config/vscode-copilot-kit/sh-config.json || true
