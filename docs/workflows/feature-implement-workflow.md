# Feature Workflow

## Overview
Plan, build, and deliver new features with clarity and speed.

## Prerequisite
- JIRA ticket (recommended)
- Git repo ready

## Example Workflows

### 1. Plan a Feature
```bash
# Generate a feature plan from JIRA
/plan IMP-1234
```
*Creates a step-by-step plan for your feature.*

### 2. Human Review the Plan
```bash
# Open and review the generated plan file
# Edit or add details as needed
```
*Ensures the plan is clear, complete, and ready for implementation.*

### 3. Implement the Plan
```bash
# Build the feature from the plan
/cook notes/specs/IMP-1234-feature-name.spec.md
```
*Agent follows the plan, writes code, and runs checks.*

### 4. Deliver
```bash
# Create a pull request
/create-pr develop IMP-1234
```
*Commits, pushes, and opens a PR for your feature.*

## Commands
- `/plan <JIRA_ticket>` – Generate feature plan
- `/cook <plan_file>` – Implement from plan
- `/create-pr <branch> <JIRA_ticket>` – Create PR

---
See also: [Code Review Workflow](./code-review-workflow.md) | [Pull Request Workflow](./pull-request-workflow.md)
