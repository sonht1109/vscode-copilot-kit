---
description: 'Review current code changes to ensure they meet coding conventions and business requirements.'
tools: ['execute', 'read', 'search', 'agent', 'todo']
---

## Steps

## Arguments

- **requirements or JIRA ticket**: A detailed description of the requirements or a link to the JIRA ticket that outlines the changes made to the codebase.

## Steps

1. **Understand the Requirements**:

- If requirements are provided, read them carefully to understand what changes were intended.
- If a JIRA ticket is provided, delegate `jira-ticket-analyzer` to extract and summarize the requirements.

2. **Clone code changes**: analyze skills in `.github/skills/clone-code-changes` to stage and clone the code changes from the local repository to a new directory for review.

3. **Review code changes**: delegate `code-reviewer` to review the staged code changes against the extracted requirements. Provide following inputs to the `code-reviewer`:

- file_path: Path to the cloned code changes directory from step 2.
- requirement: The summarized requirements from step 1 (if any).

4. **Collect feedback**: Aggregate the feedback provided by the `code-reviewer` agent. Provide output following the specified format.

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
