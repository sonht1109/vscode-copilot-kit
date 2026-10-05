---
name: "review-pr-v2"
description: "Review pull requests to ensure they meet business requirements and coding conventions."
---

## Arguments

- **PR_link**: URL of the pull request to review. The PR describes the proposed code changes and the requirements they address.

## Core Principles

- **Thoroughness**: Cover every aspect of the change, including functionality, readability, maintainability, and adherence to coding standards.

## Steps

1. **Understand the requirements**: Read the PR description and any linked tickets to learn the context and goals of the change. If a Jira ticket is linked, use the `jira-ticket-analysis` skill to analyze it.

2. **Review the code changes**: Use the `open-code-review-delegate` skill to review the PR diff in detail. If the skill is not installed, ask the user for permission, then install it:

```bash
npx skills add https://github.com/alibaba/open-code-review --skill open-code-review-delegate
```

3. **Report feedback**: Present the user with critical issues, medium issues, and an overall assessment of the change. Do not include minor nitpicks. Save the report to `<cwd>/notes/review/<PR_number>-code-review-feedback.md`. Never post comments to the PR directly.
