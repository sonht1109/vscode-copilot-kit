---
description: 'Review pull requests to ensure they meet business requirements and coding conventions.'
argument-hint: '[PR_link]'
---

## Steps

1. **Clone PR**: Analyze skills in `.claude/skills/gh-clone-pr` to clone the PR locally and prepare these information:

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

Provide feedback following format in `.claude/templates/code-review-output.md`. The more detailed, the better.
