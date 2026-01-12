---
description: 'Review pull requests to ensure they meet business requirements and coding conventions.'
tools: ['execute', 'read', 'atlassian-mcp/*', 'github-mcp/*', 'agent', 'todo']
argument-hint: '[PR_link]'
---

## Steps

1. **Extract code changes**:
Use the tool #tool:github-mcp/pull_request_read to retrieve:
- The PR description
- All code changes included in the pull request

2. **Gather context**:
- From the PR description, identify all JIRA ticket references (which start with `IMP-`, `IOS-`, or `IN-`)
- If there are any JIRA ticket references, use #tool:agent/runSubagent to delegate to `jira-ticket-analyzer` agent to gather business requirements.Provide argument to the agent:
- **JIRA_ticket**: The JIRA ticket ID.

3. **Review code changes**: use #tool:agent/runSubagent to delegate to `code-reviewer` agent to review the code changes. Provide the following instructions to the agent:
- code_change: gathered from step 1.
- requirement: gathered from step 2 (if applicable).

***IMPORTANT*** Tell `code-reviewer` to focus only collected code changes which is remote changes. Do NOT try to access any local codes.

***IMPORTANT*** Stop if any of the steps fail and report the issue.

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