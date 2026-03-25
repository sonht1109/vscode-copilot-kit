#!/bin/bash
# scout-block.sh

# example input: {"session_id":"98b33781-e8fc-42f3-a879-79c9121aa026","transcript_path":"/Users/.claude/projects/-Users--vscode-kit/98b33781-e8fc-42f3-a879-79c9121aa026.jsonl","cwd":"/Users/vscode-kit","permission_mode":"default","hook_event_name":"PreToolUse","tool_name":"Read","tool_input":{"file_path":"/Users/vscode-kit/.env"},"tool_use_id":"toolu_019opirsFFb4vxxyrWvU8Wk6"}

# example input: {"session_id":"98b33781-e8fc-42f3-a879-79c9121aa026","transcript_path":"/Users/.claude/projects/-Users--vscode-kit/98b33781-e8fc-42f3-a879-79c9121aa026.jsonl","cwd":"/Users/vscode-kit","permission_mode":"default","hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"cat .env","description":"Read .env file contents"},"tool_use_id":"toolu_01EijfmJqKz1s69jhCG3Xg1z"}

INPUT=$(cat)

AGENTIGNORE_FILE="$HOME/.config/vscode-copilot-kit/.agentignore"
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name? // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path? // empty')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command? // empty')

get_protection_patterns() {
  grep -v '^\s*#' "$AGENTIGNORE_FILE" | sed '/^\s*$/d'
}

matches_pattern() {
  local text="$1"
  local pattern="$2"

  # Escape regex special chars
  local escaped
  escaped=$(printf '%s\n' "$pattern" | sed 's/[.[\*^$()+?{|]/\\&/g')

  # Match pattern as a path component or word using grep
  if echo "$text" | grep -qE "(^|[[:space:]\/\\\\])${escaped}([[:space:]\/\\\\]|$)"; then
    return 0
  fi
  return 1
}


check_access() {
  local tool="$1"
  local value="$2"

  local error_msg
  local additional_ctx

  if [ "$TOOL_NAME" = "Read" ]; then
    error_msg="Files are protected intentionally and cannot be accessed by any tools. Do not try again."
    additional_ctx="File path: $FILE_PATH"
  fi
  if [ "$TOOL_NAME" = "Bash" ]; then
    error_msg="Command is blocked due to accessing to protected files. Do not try again."
    additional_ctx="Command: $COMMAND"
  fi

  while IFS= read -r pattern; do
    if matches_pattern "$value" "$pattern"; then
      echo "$error_msg. Context: $additional_ctx"
      return 1
    fi
  done < <(get_protection_patterns)
  return 0
}

if [ "$TOOL_NAME" = "Read" ]; then
  check_access "read" "$FILE_PATH"
  if [ $? -ne 0 ]; then
    exit 2
  fi
fi

if [ "$TOOL_NAME" = "Bash" ]; then
  check_access "bash" "$COMMAND"
  if [ $? -ne 0 ]; then
    exit 2
  fi
fi

exit 0
