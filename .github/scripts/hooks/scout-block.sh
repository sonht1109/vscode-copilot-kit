#!/bin/bash
# scout-block.sh

# set -x  # Enable bash debug mode

# example input: {"timestamp":"2026-03-06T10:09:23.451Z","hookEventName":"PreToolUse","sessionId":"29ad52cc-910b-40ac-8470-4f7d85e93d84","transcript_path":"/Users/workspaceStorage/290732473a63c62b42690e214c06197c/GitHub.copilot-chat/transcripts/29ad52cc-910b-40ac-8470-4f7d85e93d84.jsonl","tool_name":"run_in_terminal","tool_input":{"command":"cat .env","explanation":"Reading the .env file contents using cat command","goal":"Read .env file","isBackground":false,"timeout":5000},"tool_use_id":"toolu_vrtx_01CT6mNQvDCPJi56tveTrBtr__vscode-1772791728075","cwd":"/Users/vscode-kit"}

# example input: {"timestamp":"2026-03-06T10:09:18.775Z","hookEventName":"PreToolUse","sessionId":"29ad52cc-910b-40ac-8470-4f7d85e93d84","transcript_path":"/Users/workspaceStorage/290732473a63c62b42690e214c06197c/GitHub.copilot-chat/transcripts/29ad52cc-910b-40ac-8470-4f7d85e93d84.jsonl","tool_name":"read_file","tool_input":{"filePath":"/Users/vscode-kit/.env","startLine":1,"endLine":100},"tool_use_id":"toolu_vrtx_015Xk3HwwxXZjUgpJ3VT5dDB__vscode-1772791728074","cwd":"/vscode-kit"}

INPUT=$(cat)

AGENTIGNORE_FILE="$HOME/.config/vscode-copilot-kit/.agentignore"

# Parse input JSON safely
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name? // empty' 2>/dev/null || echo "")
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.files[]? // .tool_input.filePath? // empty' 2>/dev/null || echo "")
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command? // empty' 2>/dev/null || echo "")

get_protection_patterns() {
  if [ ! -f "$AGENTIGNORE_FILE" ]; then
    # Return empty if file doesn't exist - no patterns to check
    return 0
  fi
  grep -v '^\s*#' "$AGENTIGNORE_FILE" 2>/dev/null | sed '/^\s*$/d' || true
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

  # Skip check if no value provided
  if [ -z "$value" ]; then
    return 0
  fi

  local error_msg
  local additional_ctx

  if [ "$TOOL_NAME" = "read_file" ]; then
    error_msg="Files are protected intentionally and cannot be accessed by any tools. Do not try again."
    additional_ctx="File path: $FILE_PATH"
  fi
  if [ "$TOOL_NAME" = "run_in_terminal" ]; then
    error_msg="Command is blocked due to accessing to protected files. Do not try again."
    additional_ctx="Command: $COMMAND"
  fi

  while IFS= read -r pattern; do
    [ -z "$pattern" ] && continue
    if matches_pattern "$value" "$pattern"; then
      cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "$error_msg",
    "additionalContext": "$additional_ctx"
  }
}
EOF
      return 1
    fi
  done < <(get_protection_patterns)
  return 0
}

if [ "$TOOL_NAME" = "read_file" ]; then
  check_access "read" "$FILE_PATH"
  if [ $? -ne 0 ]; then
    exit 2
  fi
fi

if [ "$TOOL_NAME" = "run_in_terminal" ]; then
  check_access "bash" "$COMMAND"
  if [ $? -ne 0 ]; then
    exit 2
  fi
fi

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "",
    "additionalContext": ""
  }
}
EOF

exit 0
