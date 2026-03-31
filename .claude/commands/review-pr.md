---
description: 'Review pull requests to ensure they meet business requirements and coding conventions.'
argument-hint: '[PR_link]'
---

## Arguments

- **PR_link**: A link to the pull request that outlines the changes made to the codebase and the requirements it is trying to solve.

## Core Principles

- **Thoroughness**: Ensure that the review is comprehensive and covers all aspects of the code changes, including functionality, readability, maintainability, and adherence to coding standards.

- **Divide and Conquer**: Break down the review process into manageable parts by reviewing each changed file separately using sub-agents. This approach helps maintain focus and ensures a more detailed review. Never review on the main diff.patch file directly to avoid being overwhelming.

## Steps

1. **Clone PR**: Load and use `/gh-clone-pr` skill to clone the PR locally. Output will include these information for next step:

- content_path: list of diff patches location
- requirement: what things the PR is trying to solve (in PR description)

If requirement is not enough, and JIRA ticket is linked, delegate to `jira-ticket-analyzer` to extract and summarize the requirements with following params:

- JIRA_ticket: link from PR description

2. **Review code changes**: with PR contents that are already cloned in local:

- Check how many content files are changes
- With each file, spawn corresponding `code-reviewer` agent with the following params (can be up to 3 sub-agents at a time): 
  - file_path: the file path of the code change. Only one file per agent.
  - requirement: the requirement that the code change is trying to solve (if any)

**_IMPORTANT_** Never review on the main diff.patch file. Must use sub-agent to review each changed file separately. This is critical to ensure the quality of the review.

3. **Collect feedback**: Aggregate the feedback provided by the `code-reviewer` agent.

## Output Format

Provide feedback following format in `.claude/templates/code-review-output.md`. The more detailed, the better.
