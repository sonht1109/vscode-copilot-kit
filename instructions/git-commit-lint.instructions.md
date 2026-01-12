---
description: 'Use this instruction when creating commit messages to ensure consistency and clarity in version control history.'
name: Git Commit Linting Rules
---

# Git commit linting instructions

Commit message MUST follow the format:

```
<type>(<scope?>): [<JIRA_ticket?>] <subject>
```

Where:

- `<type>` is the type of change (e.g., feat, fix, docs, style, refactor, test, chore). If user provide a JIRA ticket, use `feat` or `fix` based on the JIRA ticket type.
- `<scope?>` (optional) scope of the change (e.g., component or file name).
- `[<JIRA_ticket?>]` is the JIRA ticket if provided by the user. If there are multiple JIRA tickets provided by the user, include all of them in the PR title. JIRA ticket is started by `IMP-`, `IOS-`, `IN-`. If no JIRA ticket is provided, replace by `[ADHOC]`.
- `<subject>` is a brief summary of the code changes made.

***IMPORTANT***: commit message MUST NOT exceed 72 characters in length for the subject line.