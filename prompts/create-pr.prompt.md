---
description: 'Create a pull request for the changes made in the codebase. User has to provide a target branch for the PR. Also user may provide related JIRA ticket. JIRA ticket may start with IMP- or IOS-. If user provides JIRA ticket, include it in the PR title and description.'
tools: ['vscode', 'execute', 'read', 'edit', 'search', 'web', 'atlassian-mcp/*', 'github-mcp/*', 'agent', 'todo']
argument-hint: '[target_branch] [jira_ticket?]'
---

## Arguments

- $target_branch: The target branch for the PR. If not provided, use `develop`
- $jira_ticket: (optional) The related JIRA ticket. If provided, it may start with IMP- or IOS-.

## Core Guidelines

1. Extract code changes
2. Get JIRA ticket detal to understand what the changes are about (if provided)
3. Commit any uncommitted changes
4. Rebase the branch onto the target branch
5. Push the rebased branch to remote
6. Prepare PR title and description
7. Create the Pull Request
8. Provide PR link to the user

## Detailed steps

### 1. Extract code changes

Analyze the most recent code changes made in the repository.
Use the #tool:search/changes tool to get a summary of the code changes.

Then summarize the key changes made in the codebase.

### 2. Get JIRA ticket detal to understand what the changes are about (if provided)

If JIRA tickets is provided, use #tool:agent/runSubagent to delegate to `jira-ticket-analyzer` agent to get ticket details. Provide argument to the agent:
- **JIRA_ticket**: The JIRA ticket ID.

***IMPORTANT*** Tell the agent not to fetch any linked documents.

### 3. Commit any uncommitted changes

If there are any uncommitted changes in the working directory, use the #tool:execute tool to commit those changes before creating the PR.

```bash
git add . && git commit -m "<commit_message>"
```
***IMPORTANT***: commit_message MUST follow `.github/instructions/git-commit-lint.instructions.md`

### 4. Rebase the branch onto the target branch
Use the #tool:execute tool to rebase the current branch onto the target branch provided by the user. If the user did not provide a target branch, use `develop` as the default target.

```bash
git fetch origin && git rebase origin/<target_branch>
```

### 5. Push the rebased branch to remote
Use the #tool:execute tool to push the rebased branch to the remote repository.

```bash
git push origin HEAD
```

### 6. Prepare PR title and description

Prepare a PR title and description using the following guidelines:

- PR title format: the commit message format used in step 3.
- PR description MUST follow the template in `.github-mcp/pull_request_template.md`. Fill in the relevant sections based on the code changes and JIRA ticket details (if provided). For example:

```
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
```
- Business Requirements:
<business_requirements_extracted_from_JIRA_ticket_description>
- Implementation Details:
<detailed_summary_of_code_changes_from_step_1>
```

Tick tick_1 if the PR is fixing a bug.
Tick tick_2 if the PR is adding a new feature or chore.
Tick tick_3 if the PR is introducing breaking changes.
Tick tick_4 if code comments were found.
Tick tick_5 if tests were added.
Tick tick_6 if tests were added.

### 7. Create the Pull Request

Use the #tool:github-mcp/create_pull_request tool to create a pull request with the title and description you created in the previous step.
Make sure to set the target branch as provided by the user.

- **title**: The PR title you created at step 6
- **body**: The PR description you created at step 6
- **base**: The target branch provided by the user or `develop` if not provided

### 8. Provide PR link to the user
After creating the pull request, provide the link to the user along with a brief summary of the changes made in the PR.

## Notes
- If there are any issue during the process (e.g., merge conflicts during rebase), inform the user with clear instructions on how to resolve the issue manually.
- If tools are not found, inform the user about the missing tools and suggest adding them to the repository instead of suggesting alternative tools.