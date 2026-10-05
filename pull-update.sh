#!/usr/bin/env bash

set -euo pipefail

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Pulling latest changes from the repository..."

if ! git -C "$KIT_ROOT" pull --ff-only origin main; then
  echo "Error: cannot fast-forward the kit at $KIT_ROOT." >&2
  echo "Fix it manually, for example: git -C \"$KIT_ROOT\" pull --rebase origin main" >&2
  exit 1
fi
