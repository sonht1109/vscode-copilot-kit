#!/bin/bash
# notify.sh

BASH_SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if command -v terminal-notifier >/dev/null 2>&1; then
  terminal-notifier "$@" \
    -sound default \
    -appIcon "file://$BASH_SOURCE_DIR/claude-logo.svg" \
    -sender "com.apple.Terminal"
elif command -v notify-send >/dev/null 2>&1; then
  notify-send "$@"
fi

exit 0