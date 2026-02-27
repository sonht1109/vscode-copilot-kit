#!/bin/bash
# scout-block.sh

# set -x  # Enable bash debug mode

# example input: {"tool_input":{"filePath":"/Users/path/.env.test","startLine":1,"endLine":400}}

INPUT=$(cat)
FILES=$(echo "$INPUT" | jq -r '.tool_input.files[]? // .tool_input.filePath? // empty')

# terminal_notifier -title \"Test\" -message \"Scouting files for protected patterns...\"

# echo "$INPUT" >> .github/scout-block-input.jsonl

PROTECTED_PATTERNS=()
IGNORE_FILE="$PWD/.github/.agentignore"

while IFS= read -r line; do
  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
  # Trim whitespace from pattern
  echo "$line"
  line=$(echo "$line" | xargs)
  [[ -z "$line" ]] && continue
  PROTECTED_PATTERNS+=("$line")
done < "$IGNORE_FILE"

for pattern in "${PROTECTED_PATTERNS[@]}"; do
  while IFS= read -r FILE_PATH; do
    [[ -z "$FILE_PATH" ]] && continue
    basename_file="$(basename "$FILE_PATH")"
    # match exact filename or directory name as path segment
    if [[ "$basename_file" == "$pattern" || "$FILE_PATH" == *"/$pattern/"* ]]; then
      cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Files are protected and cannot be accessed",
    "updatedInput": { "files": [$(echo "$FILES" | jq -R -s 'split("\n") | map(select(length > 0) | @json) | join(", ")')] },
    "additionalContext": "Protected files are blocked"
  }
}
EOF
      exit 2
    fi
  done <<< "$FILES"
done

cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "Files are allowed to be accessed",
    "updatedInput": { "files": [$(echo "$FILES" | jq -R -s 'split("\n") | map(select(length > 0) | @json) | join(", ")')] },
    "additionalContext": ""
  }
}
EOF

exit 0