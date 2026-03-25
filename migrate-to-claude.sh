#!/bin/bash

# Migration script: .github -> .claude for Claude Code project
# This script maps tools and agents from .github folder structure to .claude folder structure
#
# Transformations:
# - .github/agents/*.agent.md -> .claude/agents/*.md (remove .agent suffix)
# - .github/prompts/*.prompt.md -> .claude/commands/*.md (remove .prompt suffix)
# - .github/skills/* -> .claude/skills/* (keep structure)
# - .github/instructions/*.instructions.md -> .claude/rules/*.md (remove .instructions suffix)
# - copilot-instructions.md -> CLAUDE.md (in all file paths and content)
# - .github -> .claude (in all file paths and content)
# - Model name transformations in frontmatter:
#   - Contains "Sonnet" -> "sonnet"
#   - Contains "Opus" -> "opus"
#   - Contains "Haiku" -> "haiku"
# - Remove 'tools:' line from frontmatter (not needed in .claude)
# - Preserve .github/pull_request_template.md references (no replacement)

set -e

# Script directory (where .github exists)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITHUB_DIR="$SCRIPT_DIR/.github"
CLAUDE_DIR="$SCRIPT_DIR/.claude"

# Counters
AGENTS_MIGRATED=0
COMMANDS_MIGRATED=0
SKILLS_MIGRATED=0
SKILLS_TOTAL=0
RULES_MIGRATED=0

echo ""
echo "========================================"
echo "  .github -> .claude Migration Script"
echo "========================================"
echo ""

# Check if .github directory exists
if [[ ! -d "$GITHUB_DIR" ]]; then
    echo "[ERROR] .github directory not found at $GITHUB_DIR"
    exit 1
fi

# Create .claude directory if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Remove only specific subdirectories in .claude
echo "[INFO] Cleaning up existing .claude subdirectories..."
for subdir in agents skills commands rules templates; do
    if [[ -d "$CLAUDE_DIR/$subdir" ]]; then
        echo "  - Removing .claude/$subdir"
        rm -rf "$CLAUDE_DIR/$subdir"
    fi
done

# Function to transform file content
# - Removes tools: from frontmatter (single-line or multi-line array format)
# - Transforms model names (anything containing Sonnet/Opus/Haiku -> sonnet/opus/haiku)
# - Replaces .github -> .claude (preserving .github/pull_request_template.md)
# - Replaces copilot-instructions.md -> CLAUDE.md
transform_content() {
    local input_file="$1"
    local output_file="$2"

    # Use awk for complex multi-line tools: removal and model name transformation in frontmatter
    awk '
    BEGIN { in_frontmatter = 0; frontmatter_count = 0; in_tools = 0 }

    /^---$/ {
        frontmatter_count++
        if (frontmatter_count == 1) {
            in_frontmatter = 1
        } else if (frontmatter_count == 2) {
            in_frontmatter = 0
        }
        print
        next
    }

    # In frontmatter, skip tools: line (single-line format like "tools: [...]")
    in_frontmatter && /^tools:.*\[.*\]/ { next }

    # In frontmatter, handle multi-line tools: array
    in_frontmatter && /^tools:/ {
        in_tools = 1
        next
    }

    # If in multi-line tools array, skip lines that are part of the array
    in_frontmatter && in_tools {
        if (/^[[:space:]]+/ || /^[[:space:]]*\[/ || /^[[:space:]]*\]/) {
            next
        } else {
            in_tools = 0
        }
    }

    # In frontmatter, transform model names
    in_frontmatter && /^model:/ {
        if (/[Ss]onnet/) {
            sub(/:.+$/, ": sonnet")
        } else if (/[Oo]pus/) {
            sub(/:.+$/, ": opus")
        } else if (/[Hh]aiku/) {
            sub(/:.+$/, ": haiku")
        }
        print
        next
    }

    { print }
    ' "$input_file" | \
    sed -e 's/\.github\/pull_request_template\.md/___PRESERVE_PULL_REQUEST_TEMPLATE___/g' \
        -e 's/\.github\/instructions/.claude\/rules/g' \
        -e 's/\.github/.claude/g' \
        -e 's/\.instructions//g' \
        -e 's/___PRESERVE_PULL_REQUEST_TEMPLATE___/.github\/pull_request_template.md/g' \
        -e 's/copilot-instructions\.md/CLAUDE.md/g' \
    > "$output_file"
}

# =====================
# Migrate instructions to rules
# =====================
echo "[INFO] Migrating instructions to rules..."

instructions_src="$GITHUB_DIR/instructions"
rules_dest="$CLAUDE_DIR/rules"

if [[ -d "$instructions_src" ]]; then
    mkdir -p "$rules_dest"

    for instructions_file in "$instructions_src"/*.instructions.md; do
        [[ -f "$instructions_file" ]] || continue

        filename=$(basename "$instructions_file" .instructions.md)
        dest_file="$rules_dest/${filename}.md"

        echo "  - $(basename "$instructions_file") -> $(basename "$dest_file")"
        transform_content "$instructions_file" "$dest_file"
        ((RULES_MIGRATED++))
    done
fi

echo "[SUCCESS] Migrated $RULES_MIGRATED rules"
echo ""

# =====================
# Migrate agents
# =====================
echo "[INFO] Migrating agents..."

agents_src="$GITHUB_DIR/agents"
agents_dest="$CLAUDE_DIR/agents"

if [[ -d "$agents_src" ]]; then
    mkdir -p "$agents_dest"

    for agent_file in "$agents_src"/*.agent.md; do
        [[ -f "$agent_file" ]] || continue

        filename=$(basename "$agent_file" .agent.md)
        dest_file="$agents_dest/${filename}.md"

        echo "  - $(basename "$agent_file") -> $(basename "$dest_file")"
        transform_content "$agent_file" "$dest_file"
        ((AGENTS_MIGRATED++))
    done
fi

echo "[SUCCESS] Migrated $AGENTS_MIGRATED agents"
echo ""

# =====================
# Migrate prompts to commands
# =====================
echo "[INFO] Migrating prompts to commands..."

prompts_src="$GITHUB_DIR/prompts"
commands_dest="$CLAUDE_DIR/commands"

if [[ -d "$prompts_src" ]]; then
    mkdir -p "$commands_dest"

    for prompt_file in "$prompts_src"/*.prompt.md; do
        [[ -f "$prompt_file" ]] || continue

        filename=$(basename "$prompt_file" .prompt.md)
        dest_file="$commands_dest/${filename}.md"

        echo "  - $(basename "$prompt_file") -> $(basename "$dest_file")"
        transform_content "$prompt_file" "$dest_file"
        ((COMMANDS_MIGRATED++))
    done
fi

echo "[SUCCESS] Migrated $COMMANDS_MIGRATED commands"
echo ""

# =====================
# Migrate skills
# =====================
echo "[INFO] Migrating skills..."

skills_src="$GITHUB_DIR/skills"
skills_dest="$CLAUDE_DIR/skills"

if [[ -d "$skills_src" ]]; then
    # Copy entire skills directory structure
    cp -r "$skills_src" "$skills_dest"

    # Transform content in all .md files
    find "$skills_dest" -type f -name "*.md" | while read -r skill_file; do
        rel_path="${skill_file#$skills_dest/}"
        echo "  - $rel_path"

        temp_file=$(mktemp)
        awk '
        BEGIN { in_frontmatter = 0; frontmatter_count = 0; in_tools = 0 }

        /^---$/ {
            frontmatter_count++
            if (frontmatter_count == 1) {
                in_frontmatter = 1
            } else if (frontmatter_count == 2) {
                in_frontmatter = 0
            }
            print
            next
        }

        in_frontmatter && /^tools:.*\[.*\]/ { next }

        in_frontmatter && /^tools:/ {
            in_tools = 1
            next
        }

        in_frontmatter && in_tools {
            if (/^[[:space:]]+/ || /^[[:space:]]*\[/ || /^[[:space:]]*\]/) {
                next
            } else {
                in_tools = 0
            }
        }

        in_frontmatter && /^model:/ {
            if (/[Ss]onnet/) {
                sub(/:.+$/, ": sonnet")
            } else if (/[Oo]pus/) {
                sub(/:.+$/, ": opus")
            } else if (/[Hh]aiku/) {
                sub(/:.+$/, ": haiku")
            }
            print
            next
        }

        { print }
        ' "$skill_file" | \
        sed -e 's/\.github\/pull_request_template\.md/___PRESERVE_PULL_REQUEST_TEMPLATE___/g' \
            -e 's/\.github/.claude/g' \
            -e 's/\.github\/instructions/.claude\/rules/g' \
            -e 's/\.instructions//g' \
            -e 's/___PRESERVE_PULL_REQUEST_TEMPLATE___/.github\/pull_request_template.md/g' \
            -e 's/copilot-instructions\.md/CLAUDE.md/g' \
        > "$temp_file"
        mv "$temp_file" "$skill_file"
        ((SKILLS_MIGRATED++))
    done

    # Count all skill files (not just .md)
    SKILLS_TOTAL=$(find "$skills_dest" -type f | wc -l | tr -d ' ')
fi

echo "[SUCCESS] Migrated $SKILLS_TOTAL skill files"
echo ""

# =====================
# Migrate templates
# =====================
echo "[INFO] Migrating templates..."

templates_src="$GITHUB_DIR/templates"
templates_dest="$CLAUDE_DIR/templates"
TEMPLATES_MIGRATED=0

if [[ -d "$templates_src" ]]; then
    mkdir -p "$templates_dest"

    for template_file in "$templates_src"/*.md; do
        [[ -f "$template_file" ]] || continue

        filename=$(basename "$template_file")
        dest_file="$templates_dest/$filename"

        echo "  - $filename -> $filename"
        transform_content "$template_file" "$dest_file"
        ((TEMPLATES_MIGRATED++))
    done
fi

echo "[SUCCESS] Migrated $TEMPLATES_MIGRATED templates"
echo ""

# =====================
# Summary
# =====================
echo "========================================"
echo "            Migration Summary"
echo "========================================"
echo ""
echo "  Rules migrated:    $RULES_MIGRATED"
echo "  Agents migrated:   $AGENTS_MIGRATED"
echo "  Commands migrated: $COMMANDS_MIGRATED"
echo "  Skill files:       $SKILLS_TOTAL"
echo "  Templates:         $TEMPLATES_MIGRATED"
echo ""
echo "[INFO] Migration complete! Files are now in $CLAUDE_DIR"
echo ""
