# Pull Request Workflow

## Overview
Create, review, and merge pull requests with ease.

## Prerequisite
- GitHub repo with changes
- Target branch (e.g. develop, main)

## Example Workflows

```bash
# Review your changes
/review-code-changes
# Human review: Fix any critical issues found
# Repeat review if needed
/review-code-changes
# Create a PR (auto-commit if needed)
/create-pr develop IMP-1234
```
*Review, fix, and open a PR for your feature or fix.*

## Commands
- `/review-code-changes` – Review before PR
- `/create-pr <branch> <JIRA_ticket>` – Create PR
- `/review-pr <PR_URL>` – Review PR

---
See also: [Feature Workflow](./feature-workflow.md) | [Code Review Workflow](./code-review-workflow.md)
