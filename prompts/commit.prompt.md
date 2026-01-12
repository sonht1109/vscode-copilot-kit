---
description: 'Commit any uncommitted changes in the working directory.'
tools: ['vscode', 'execute', 'read', 'edit', 'search', 'web', 'agent', 'todo']
argument-hint: '[jira_ticket?]'
---

## Arguments
- `jira_ticket` (optional): The JIRA ticket identifier associated with the changes being committed. This can help in linking the commit to a specific task or issue in your project management system.

## Steps
1. Check for any uncommitted changes in the working directory and understand what has been modified. Use the #tool:search/changes tool.

2. If there are no uncommitted changes, respond with "No changes to commit."

3. Use the #tool:execute tool to commit those changes.

```bash
git add . && git commit -m "<commit_message>"
```
Where commit_message **MUST** follow `.github/instructions/git-commit-lint.instructions.md`
