---
description: 'Create a pull request for the changes made in the codebase. User has to provide a target branch for the PR. Also user may provide related JIRA ticket. JIRA ticket may start with IMP- or IOS-. If user provides JIRA ticket, include it in the PR title and description.'
tools: ['execute', 'read', 'edit', 'search', 'web', 'atlassian-mcp/jira_get_issue', 'agent', 'todo']
argument-hint: '[target_branch] [jira_ticket?]'
model: Claude Haiku 4.5 (copilot)
---

## Arguments

- $target_branch: The target branch for the PR. If not provided, use `develop`
- $requirement: (optional) The requirement or context for the PR.
- $jira_ticket: (optional) The related JIRA ticket. If provided, it may start with IMP- or IOS-. If user doenst not provide, check current branch name, it might have.

## Core Guidelines

1. Extract code changes
2. Get JIRA ticket detail to understand what the changes are about (if provided)
3. Commit any uncommitted changes
4. Rebase the branch onto the target branch
5. Push the rebased branch to remote
6. Prepare PR title and description
7. Create the Pull Request
8. Provide PR link to the user

## Detailed steps

### 1. Extract code changes

Analyze the most recent code changes made in the repository.

1.1. Stage all changes:

```bash
git add -A && \
echo "=== STAGED FILES ===" && \
git diff --cached --stat && \
echo "=== METRICS ===" && \
git diff --cached --shortstat | awk '{ins=$4; del=$6; print "LINES:"(ins+del)}' && \
git diff --cached --name-only | awk 'END {print "FILES:"NR}'
```

1.2. Get context of all code changes:

```bash
git diff --cached -U5 | head -400
```

If there is no current changes, retrieve by comparing target_branch and HEAD:

```bash
git diff <target_branch>..HEAD | head -400)
```

1.3. Summarize the key changes made in the codebase.

### 2. Understand requirements

If requirement is provided, use it to understand the context of the changes. Otherwise, try to extract JIRA ticket from current branch name. If JIRA tickets is found, delegate to `jira-ticket-analyzer` agent to get ticket details. Provide argument to the agent:

- **JIRA_ticket**: The JIRA ticket ID.

**_IMPORTANT_** Tell the agent not to fetch any linked documents.

### 3. Commit any uncommitted changes

If there are any uncommitted changes in the working directory, use the #tool:execute to commit those changes before creating the PR. Run command:

```bash
git add . && git commit -m "<commit_message>"
```

Where commit_message MUST follow `.github/instructions/git.instructions.md` rules.

### 4. Rebase the branch onto the target branch

Use the #tool:execute to rebase the current branch onto the target branch provided by the user. If the user did not provide a target branch, use `develop` as the default target.

```bash
git fetch origin && git rebase origin/<target_branch>
```

### 5. Push the rebased branch to remote

Use the #tool:execute to push the rebased branch to the remote repository.

```bash
git push origin HEAD
```

### 6. Prepare PR title and description

Prepare a PR title and description using the following guidelines:

- PR title format: the commit message format used in step 3.
- PR description MUST follow the template in `.github/pull_request_template.md`. Fill in the relevant sections based on the code changes and JIRA ticket details (if provided). For example:

```md
# Description

**JIRA Ticket:** [<JIRA_ticket?>](https://<org>.atlassian.net/browse/<JIRA_ticket?>)]

**Related Documentations:**
<PR_desc>

## Type of change

- [<tick_1>] Bug fix (non-breaking change which fixes an issue)
- [<tick_2>] New feature/chore (non-breaking change which adds functionality)
- [<tick_3>] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] This change requires a documentation update

# Screenshots (if any):

# Checklist:

- [x] My code follows the style guidelines of this project
- [x] I have performed a self-review of my code
- [<tick_4>] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [x] My changes generate no new warnings
- [<tick_5>] I have added tests that prove my fix is effective or that my feature works
- [<tick_6>] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published in downstream modules
```

Where PR_desc is a detailed description of the changes made, extracted from the JIRA ticket description (if provided) and the code changes summary from step 1. PR_desc format:

```md
- Business Requirements:
  <business_requirements_extracted_from_JIRA_ticket_description>
- Implementation Details:
  <detailed_summary_of_code_changes_from_step_1>
```

**_IMPORTANT_**: detailed_summary_of_code_changes_from_step_1 only focus only on the key changes made in the codebase and create data flow if possible. Avoid including some minor changes: e.g., formatting changes, variable renaming, constants, etc. If data flow is provided, use markdown mermaid syntax to represent.

**_IMPORTANT_**: If changes contain API changes, make sure to include API spec changes in the `Implementation Details` section (API path, body, request, response).

Tick tick_1 if the PR is fixing a bug.
Tick tick_2 if the PR is adding a new feature or chore.
Tick tick_3 if the PR is introducing breaking changes.
Tick tick_4 if code comments were found.
Tick tick_5 if tests were added.
Tick tick_6 if tests were added.

Then write PR body into `/tmp/pr_body.md` file. Run command:

```bash
cat > /tmp/pr_body.md << EOF
<PR_body>
EOF
echo "Success"
```

### 7. Create the Pull Request

Run command to create PR:

```bash
gh pr create --title "<title>" --body-file /tmp/pr_body.md --base <base> --head $(git rev-parse --abbrev-ref HEAD) && echo "Success" || echo "Failed"
```

Where:

- **title**: The PR title you created at step 6
- **base**: The target branch provided by the user or `develop` if not provided

### 8. Provide PR link to the user

After creating the pull request, provide the link to the user along with a brief summary of the changes made in the PR.

## Notes

- If there are any issue during the process (e.g., merge conflicts during rebase), inform the user with clear instructions on how to resolve the issue manually.
- If tools are not found, inform the user about the missing tools and suggest adding them to the repository instead of suggesting alternative tools.
