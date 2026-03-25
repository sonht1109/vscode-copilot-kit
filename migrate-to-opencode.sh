#!/bin/bash

# Migration script: .github -> .opencode for OpenCode project
# This script maps tools and agents from .github folder structure to .opencode folder structure
#
# Transformations:
# - .github/agents/*.agent.md -> .opencode/agents/*.md (remove .agent suffix)
# - .github/prompts/*.prompt.md -> .opencode/commands/*.md (remove .prompt suffix)  
# - .github/skills/* -> .opencode/skills/* (keep structure)
# - copilot-instructions.md -> AGENT.md (in all file paths and content)
# - .github -> .opencode (in all file paths and content)
# - Model name transformations in frontmatter:
#   - "Claude Sonnet 4.5 (copilot)" -> "anthropic/claude-sonnet-4-5"
#   - "Claude Opus 4.5 (copilot)" -> "anthropic/claude-opus-4-5"
#   - "Claude Haiku 4.5 (copilot)" -> "anthropic/claude-haiku-4-5"
# - Remove 'tools:' line from frontmatter (not needed in .opencode)

set -e

# Script directory (where .github exists)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITHUB_DIR="$SCRIPT_DIR/.github"
OPENCODE_DIR="$SCRIPT_DIR/.opencode"

# Counters
AGENTS_MIGRATED=0
COMMANDS_MIGRATED=0
SKILLS_MIGRATED=0
RULES_MIGRATED=0

echo ""
echo "========================================"
echo "  .github -> .opencode Migration Script"
echo "========================================"
echo ""

# Check if .github directory exists
if [[ ! -d "$GITHUB_DIR" ]]; then
    echo "[ERROR] .github directory not found at $GITHUB_DIR"
    exit 1
fi

# Create .opencode directory if it doesn't exist
mkdir -p "$OPENCODE_DIR"

# Remove only specific subdirectories in .opencode
echo "[INFO] Cleaning up existing .opencode subdirectories..."
for subdir in agents skills commands rules templates; do
    if [[ -d "$OPENCODE_DIR/$subdir" ]]; then
        echo "  - Removing .opencode/$subdir"
        rm -rf "$OPENCODE_DIR/$subdir"
    fi
done

# Function to transform file content
# Removes tools: from frontmatter (single-line or multi-line array format)
transform_content() {
    local input_file="$1"
    local output_file="$2"
    
    # Use awk for more complex multi-line tools: removal in frontmatter
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
        # Check if this line is still part of the array (indented or starts with [ or ])
        if (/^[[:space:]]+/ || /^[[:space:]]*\[/ || /^[[:space:]]*\]/) {
            next
        } else {
            # End of tools array, process this line normally
            in_tools = 0
        }
    }
    
    { print }
    ' "$input_file" | \
    sed -e 's/Claude Sonnet 4\.6 (copilot)/anthropic\/claude-sonnet-4-6/g' \
        -e 's/Claude Opus 4\.6 (copilot)/anthropic\/claude-opus-4-6/g' \
        -e 's/Claude Haiku 4\.5 (copilot)/anthropic\/claude-haiku-4-5/g' \
        -e 's/\.github\/pull_request_template\.md/___PRESERVE_PULL_REQUEST_TEMPLATE___/g' \
        -e 's/\.github\/instructions/.opencode\/rules/g' \
        -e 's/\.github/.opencode/g' \
        -e 's/\.instructions//g' \
        -e 's/___PRESERVE_PULL_REQUEST_TEMPLATE___/.github\/pull_request_template.md/g' \
        -e 's/copilot-instructions\.md/AGENT.md/g' \
    > "$output_file"
}

# =====================
# Migrate instructions to rules
# =====================
echo "[INFO] Migrating instructions to rules..."

instructions_src="$GITHUB_DIR/instructions"
rules_dest="$OPENCODE_DIR/rules"

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
agents_dest="$OPENCODE_DIR/agents"

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
commands_dest="$OPENCODE_DIR/commands"

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
skills_dest="$OPENCODE_DIR/skills"

if [[ -d "$skills_src" ]]; then
    # Copy entire skills directory structure
    cp -r "$skills_src" "$skills_dest"
    
    # Transform content in all .md files
    find "$skills_dest" -type f -name "*.md" | while read -r skill_file; do
        rel_path="${skill_file#$skills_dest/}"
        echo "  - $rel_path"
        
        temp_file=$(mktemp)
        sed -e 's/Claude Sonnet 4\.6 (copilot)/anthropic\/claude-sonnet-4-6/g' \
            -e 's/Claude Opus 4\.6 (copilot)/anthropic\/claude-opus-4-6/g' \
            -e 's/Claude Haiku 4\.5 (copilot)/anthropic\/claude-haiku-4-5/g' \
            -e 's/\.github\/pull_request_template\.md/___PRESERVE_PULL_REQUEST_TEMPLATE___/g' \
            -e 's/\.github\/instructions/.opencode\/rules/g' \
            -e 's/\.github/.opencode/g' \
            -e 's/\.instructions//g' \
            -e 's/___PRESERVE_PULL_REQUEST_TEMPLATE___/.github\/pull_request_template.md/g' \
            -e 's/copilot-instructions\.md/AGENT.md/g' \
            -e '/^tools: /d' \
            "$skill_file" > "$temp_file"
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
templates_dest="$OPENCODE_DIR/templates"
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
echo "[INFO] Migration complete! Files are now in $OPENCODE_DIR"
echo ""

