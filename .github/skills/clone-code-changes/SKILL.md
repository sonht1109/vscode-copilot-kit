---
name: Clone code changes
description: Use when user asks to clone code changes from local repository to a new directory for review or testing.
---

# Clone Code Changes

Use this skill when the user requests to clone code changes from local repository to a new directory for review or testing.

## Arguments

- now: The current timestamp in the format YYYYMMDD_HHMMSS. Invent this value at runtime.

## Steps

1. **Stage all code changes**: Stage all changes in the local git repository to prepare for cloning. Run command:

```bash
git add -A && \
echo "=== STAGED FILES ===" && \
git diff --cached --stat && \
echo "=== METRICS ===" && \
git diff --cached --shortstat | awk '{ins=$4; del=$6; print "LINES:"(ins+del)}' && \
git diff --cached --name-only | awk 'END {print "FILES:"NR}'
```

2. **Clone the changes**: Run command to create a patch file with the staged changes into `<pwd>/notes/code-changes/<now>/diff.patch`:

```bash
git diff --cached > <pwd>/notes/code-changes/<now>/diff.patch
```

3. **Separate patch file**: separate patch files for the PR diff into multiple files to keep changes organized. Run script:

```bash
node <pwd>/.github/skills/clone-code-changes/scripts/separate-patch.js <now>
```

5. **Provide confirmation**: Inform the user that the PR has been successfully cloned and provide the local path to the cloned PR. Provide output following the specified format.

## Output Format

Provide output in the following format:

```markdown
The code changes have been successfully cloned.

- PR diff patch directory: `<pwd>/notes/code-changes/<now>/contents`
```
