---
name: "create-pr"
description: "Create a pull request for the changes made in the codebase. User has to provide a target branch for the PR. Also user may provide related JIRA ticket. JIRA ticket may start with IMP- or IOS-. If user provides JIRA ticket, include it in the PR title and description."
---

## Arguments

- $target_branch: The target branch for the PR. If not provided, use `develop`
- $requirement: (optional) The requirement or context for the PR. If provided, no need to analyze JIRA ticket to get requirement.
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
git diff --cached -U5 | head -500
```

If there is no current changes, retrieve by comparing target_branch and HEAD:

```bash
git diff <target_branch>..HEAD | head -500
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
- PR description MUST follow the template below. Fill in the relevant sections based on the code changes and JIRA ticket details (if provided). For example:

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

- [<tick_4>] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my code
- [<tick_5>] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [<tick_6>] My changes generate no new warnings
- [<tick_7>] I have added tests that prove my fix is effective or that my feature works
- [<tick_8>] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published in downstream modules
```

Where PR_desc is a short description of the changes made, extracted from the JIRA ticket description (if provided) and the code changes summary from step 1. PR_desc format:

```md
- 🎯 **Business Requirements**:
  <business_requirements_extracted_from_JIRA_ticket_description>
- ⚒️ **Implementation Overview**:
  <summary_of_core_changes_from_step_1>
```

**_IMPORTANT_**: Keep PR_desc as short as possible. summary_of_core_changes_from_step_1 must only cover changes that carry business/functional impact (new behavior, bug fix, API/data flow changes, logic changes). Explicitly EXCLUDE from the summary: formatting/style-only diffs, renames, comments, tests, lint fixes, and other non-functional changes — do not mention them at all, even to say they were skipped. Prefer short bullet points over paragraphs. Include a mermaid data flow diagram only if the change alters a data flow and it meaningfully aids understanding.

**_IMPORTANT_**: If changes contain API changes, include the API spec changes (path, body, request, response) as part of the Implementation Overview bullets.

Tick tick_1 if the PR is fixing a bug.
Tick tick_2 if the PR is adding a new feature or chore.
Tick tick_3 if the PR is introducing breaking changes.
Tick tick_4 if the code follows the style guidelines of the project. Evaluate your self code and tick it if it follows the style guidelines, otherwise leave it unticked and provide a brief explanation in the PR description about which style guideline is not followed and why.
Tick tick_5 if jsdocs/comment is added.
Tick tick_6 if the changes generate no new warnings. Use eslint to check on code changes.
Tick tick_7, tick_8 if tests are added to prove the fix is effective or the feature works.

Then write PR body into `/tmp/pr_body.md` file. Run command:

```bash
cat > /tmp/pr_body.md << EOF
<PR_body>
EOF
echo "Success"
```

If its failed to write file, write into <cwd>/notes/pr_body.md instead, but remember to delete the file after finishing PR creation.

### 7. Create the Pull Request

Run command to create PR:

```bash
gh pr create --title "<title>" --body-file /tmp/pr_body.md --base <base> --head $(git rev-parse --abbrev-ref HEAD) && echo "Success" || echo "Failed"
```

Where:

- **title**: The PR title you created at step 6
- **base**: The $target_branch provided by the user or `develop` if not provided

### 8. Provide PR link to the user

After creating the pull request, provide the link to the user along with a brief summary of the changes made in the PR.

## Tips

- Load and use `/git` skills to perform git operations.
- If there are any issue during the process (e.g., merge conflicts during rebase), inform the user with clear instructions on how to resolve the issue manually.
- If tools are not found, inform the user about the missing tools and suggest adding them to the repository instead of suggesting alternative tools.
