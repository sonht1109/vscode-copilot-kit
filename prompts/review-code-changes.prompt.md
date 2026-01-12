---
description: 'Review current code changes to ensure they meet coding conventions and business requirements.'
tools: ['vscode', 'execute', 'read', 'search', 'atlassian-mcp/*', 'agent', 'todo']
---

## Steps

1. **Extract code changes**: Use #tool:search/changes to get the list of changed files and their diffs.

2. **Gather context**: If a JIRA ticket is provided (starts with `IMP-`, `IOS-`, or `IN-`), use #tool:atlassian-mcp/jira_get_issue to fetch relevant business requirements and context.

3. **Review code changes**: use #tool:agent/runSubagent to delegate to `code-reviewer` agent to review the code changes. Provide the following instructions to the agent:
- code_change: gathered from step 1.
- requirement: gathered from step 2 (if applicable).

4. **Collect feedback**: Aggregate the feedback provided by the `code-reviewer` agent.

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