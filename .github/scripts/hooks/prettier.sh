#!/bin/bash
# prettier.sh

# set -x  # Enable bash debug mode

# example input: {"tool_input":{"filePath":"/Users/path/.env.test","startLine":1,"endLine":400}}

INPUT=$(cat)

FILES=$(echo "$INPUT" | jq -r '.tool_input.filePath? // empty')

if [[ -n "$FILES" ]]; then
  npx prettier --write "$FILES" >/dev/null 2>&1
fi

exit 0