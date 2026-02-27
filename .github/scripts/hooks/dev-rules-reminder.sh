#!/bin/bash

# Development Rules Reminder
#
# Injects modularization reminders before Session start.
#
# Exit Codes:
#   0 - Success (non-blocking, allows continuation)

get_git_remote_url() {
  local url
  url=$(git config --get remote.origin.url 2>/dev/null || echo "Not available")
  echo "$url"
}

get_python_version() {
  local version
  if command -v python3 &> /dev/null; then
    version=$(python3 --version 2>&1)
    echo "$version"
  elif command -v python &> /dev/null; then
    version=$(python --version 2>&1)
    echo "$version"
  else
    echo "Not available"
  fi
}

get_go_version() {
  local version
  if command -v go &> /dev/null; then
    version=$(go version 2>&1)
    echo "$version"
  else
    echo "Not available"
  fi
}

get_node_version() {
  local version
  if command -v node &> /dev/null; then
    version=$(node --version 2>&1)
    echo "$version"
  else
    echo "Not available"
  fi
}

# Main execution
main() {
  local current_user="${USERNAME:-${USER:-${LOGNAME:-$(whoami)}}}"
  local git_remote_url=$(get_git_remote_url)
  local python_version=$(get_python_version)
  local node_version=$(get_node_version)
  local go_version=$(get_go_version)
  local current_date=$(date)
  local timezone=$(date +%Z)
  
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
  local project_info=$(basename "$(pwd)")
  local additional_context="Timezone: $timezone | Current working dir (cwd): $(pwd) | Git remote url: $git_remote_url | Node: $node_version | Python: $python_version | Go: $go_version | OS: $(uname -s). **IMPORTANT**: Include these environment information when prompting subagents to perform tasks."
  
  cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "$additional_context"
  }
}
EOF

  exit 0
}
main