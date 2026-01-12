
# Code Review Workflow

## Overview
Quickly review your code for quality, bugs, and best practices before commit or PR.

## Prerequisite
- Code changes ready
- For `/review-pr`: Both Atlassian and GitHub MCP servers must be configured

## Example Workflows

### 1. Local Review
```bash
# Review your changes
/review-code-changes
# Fix issues if any, then re-run
/review-code-changes
```
*Checks your code for issues before you commit or PR.*

### 2. Team Review
```bash
# Review teammate's PR
/review-pr <PR_URL>
# Address feedback as needed
```
*Ensures team code meets standards before merge.*

## Commands
- `/review-code-changes` – Review local changes
- `/review-pr <PR_URL>` – Review a pull request

---
See also: [Feature Workflow](./feature-workflow.md) | [Pull Request Workflow](./pull-request-workflow.md)
