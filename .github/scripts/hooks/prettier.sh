#!/bin/bash
# prettier.sh

# set -x  # Enable bash debug mode

# example input: {"tool_input":{"filePath":"/Users/path/.env.test","startLine":1,"endLine":400}}

INPUT=$(cat)
# FILES=$(echo "$INPUT" | jq -r '.tool_input.files[]? // .tool_input.filePath? // empty')

# echo "$INPUT" >> .github/post-tool-use-input.jsonl

exit 0