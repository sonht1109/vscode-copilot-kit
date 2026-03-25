#!/bin/bash
# notify.sh

BASH_SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

which terminal-notifier >/dev/null 2>&1 && terminal-notifier "$@" \
  -sound default \
  -appIcon "file://$BASH_SOURCE_DIR/claude-logo.svg" \
  -sender "com.apple.Terminal"