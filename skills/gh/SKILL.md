---
name: gh
description: Use when user asks to work with any tasks related to GitHub, including repositories, issues, pull requests, Actions, projects, releases, gists, codespaces, organizations, extensions, and all GitHub operations from the command line.
---

# Github Skill

**_IMPORTANT:_** MUST use `GH_PAGER=cat` before `gh` commands to avoid pagination issues in some environments.

## Prerequisites

Setup env variables:

```bash
export GH_TOKEN=<your_github_token>
```

## CLI Structure

```bash
gh                          # Root command
├── auth                    # Authentication
├── browse                  # Open in browser
├── codespace               # GitHub Codespaces
├── gist                    # Gists
├── issue                   # Issues
├── org                     # Organizations
│   └── list
├── pr                      # Pull Requests
│   ├── create
│   ├── list
│   ├── status
│   ├── checkout
│   ├── checks
│   ├── close
│   ├── comment
│   ├── diff
│   ├── edit
│   ├── lock
│   ├── merge
│   ├── ready
│   ├── reopen
│   ├── revert
│   ├── review
│   ├── unlock
│   ├── update-branch
│   └── view
├── project                 # Projects
├── release                 # Releases
├── repo                    # Repositories
├── cache                   # Actions caches
├── run                     # Workflow runs
├── workflow                # Workflows
├── agent-task              # Agent tasks
├── alias                   # Command aliases
│   ├── delete
│   ├── import
│   ├── list
│   └── set
├── api                     # API requests
├── attestation             # Artifact attestations
├── completion              # Shell completion
├── config                  # Configuration
│   ├── clear-cache
│   ├── get
│   ├── list
│   └── set
├── extension               # Extensions
├── gpg-key                 # GPG keys
├── label                   # Labels
├── preview                 # Preview features
├── ruleset                 # Rulesets
├── search                  # Search
│   ├── code
│   ├── commits
│   ├── issues
│   ├── prs
│   └── repos
├── secret                  # Secrets
├── ssh-key                 # SSH keys
├── status                  # Status overview
└── variable                # Variables
```

## Example workflows

### Check auth status

```bash
gh auth status
```

### Create PR

```bash
gh pr create --title "My PR Title" --body "Description of my PR" --base <target_branch> --head <feature_branch>
```

### Get PR detail

```bash
# Get PR title and body
GH_PAGER=cat gh pr view <pr_number> --repo <owner>/<repo> --json title,body

# Get code changes
GH_PAGER=cat gh pr diff <pr_number> --repo <owner>/<repo>
```

## Notes

If there are any commands you are unsure about, run `gh <command> <subcommand> --help` to get more information on usage and options.
eg: `gh pr create --help`
