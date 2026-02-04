---
description: 'Review pull requests to ensure they meet business requirements and coding conventions.'
tools: ['execute', 'read', 'agent', 'todo']
argument-hint: '[PR_link]'
---

## Steps

1. **Clone PR**: Analyze skills in `.github/skills/gh-clone-pr` to clone the PR locally and prepare these information:

- file_path: list of diff patches location
- requirement: what things the PR is trying to solve (in PR description)

If requirement is not enough, and JIRA ticket is linked, delegate to `jira-ticket-analyzer` to extract and summarize the requirements with following params:

- JIRA_ticket: link from PR description

2. **Review code changes**: to delegate to `code-reviewer` agent to review the code changes. Provide the following instructions to the agent:

- file_path
- requirement

***IMPORTANT*** Stop if any of the steps fail and report the issue.

3. **Collect feedback**: Aggregate the feedback provided by the `code-reviewer` agent.

## Output Format

Provide feedback in the following format. The more detailed, the better:

```markdown
### Overall Assessment
[Summary of the overall code quality and key issues]

### ❌ Critical Issues
[List of critical issues that must be addressed and suggested fixes]
1. [Issue 1 with suggested fix]

2. [Issue 2 with suggested fix]

...

### ⚠️ Medium Issues
[List of medium-severity issues that should be addressed and suggested fixes]
1. [Issue 1 with suggested fix]

2. [Issue 2 with suggested fix]

...

### 📚 Minor Suggestions
[List of minor suggestions for improvement]
1. [Suggestion 1 with suggested fix]

2. [Suggestion 2 with suggested fix]

...
```
