#!/bin/bash
# prettier.sh

# set -x  # Enable bash debug mode

# example input: {"toolName": "edit", "toolArgs": {"path": "src/index.js", "old_str": "foo", "new_str": "bar"}}

INPUT=$(cat)

FILES=$(echo "$INPUT" | jq -r '.toolArgs.path? // empty')
TOOL_NAME=$(echo "$INPUT" | jq -r '.toolName? // empty')

# echo $INPUT > /tmp/prettier_input.log.jsonl

# only run if tool_name = edit or create, and file exists
if [[ ("$TOOL_NAME" == "edit" || "$TOOL_NAME" == "create") && -n "$FILES" && -f "$FILES" ]]; then
  npx prettier --write "$FILES" >/dev/null 2>&1
fi

exit 0