---
description: 'A set of rules to work with git in repositories, including commit message format, branch naming conventions, and other best practices to ensure consistency and clarity in version control.'
name: Git instructions
---

# Git rules

## Git commit lint

Commit message MUST follow the format:

```bash
<type>(<scope?>): [<JIRA_ticket?>] <subject>
```

Where:

- `<type>` is the type of change (e.g., feat, fix, docs, style, refactor, test, chore). If user provide a JIRA ticket, use `feat` or `fix` based on the JIRA ticket type.
- `<scope?>` (optional) scope of the change (e.g., component or file name). Must be lower-case.
- `[<JIRA_ticket?>]` is the JIRA ticket if provided by the user. If there are multiple JIRA tickets provided by the user, include all of them in the PR title. JIRA ticket is started by `IMP-`, `IOS-`, `IN-`. If no JIRA ticket is provided, replace by `[ADHOC]`.
- `<subject>` is a brief summary of the code changes made.

**_IMPORTANT_**: commit message MUST NOT exceed 72 characters in length for the subject line.

## Branch naming convention

Branch names MUST follow the format:

```bash
<type>/<scope?>/<JIRA_ticket?>
```

Where:

- `<type>` is the type of change (e.g., feat, fix, docs, style, refactor, test, chore). If user provide a JIRA ticket, use `feat` or `fix` based on the JIRA ticket type.
- `<scope?>` (optional) scope of the change (e.g., component or file name). Must be lower-case.
- `<JIRA_ticket?>` is the JIRA ticket if provided by the user. If no JIRA ticket is provided, replace by `adhoc`.

Notes:

- If JIRA_ticket is provided, it MUST start with `IMP-`, `IOS-`, or `IN-` and scope can be omitted.
- If JIRA_ticket is not provided, scope MUST be included to avoid branch name conflicts.

Eg:

- `feat/IMP-1234`
- `fix/IOS-5678`
- `docs/adhoc/update-readme`

## Notes

- NEVER work directly on protected branches like main, develop, staging.
