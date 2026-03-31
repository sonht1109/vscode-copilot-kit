---
description: 'Review current code changes to ensure they meet coding conventions and business requirements.'
---

## Arguments

- **requirements or JIRA ticket**: A detailed description of the requirements or a link to the JIRA ticket that outlines the changes made to the codebase.

## Core Principles

- **Thoroughness**: Ensure that the review is comprehensive and covers all aspects of the code changes, including functionality, readability, maintainability, and adherence to coding standards.

- **Divide and Conquer**: Break down the review process into manageable parts by reviewing each changed file separately using sub-agents. This approach helps maintain focus and ensures a more detailed review. Never review on the main diff.patch file directly to avoid being overwhelming.

## Steps

1. **Understand the Requirements**:

- If requirements are provided, read them carefully to understand what changes were intended.
- If a JIRA ticket is provided, delegate `jira-ticket-analyzer` to extract and summarize the requirements.

2. **Clone code changes**: load and use `/clone-code-changes` skill to stage and clone the code changes from the local repository to a new directory for review. Output will include these information for next step:

- content_path: list of diff patches location

3. **Review code changes**: with code changes that are already cloned in local:

- Check how many content files are changes
- With each file, spawn corresponding `code-reviewer` agent with the following params (can be up to 3 sub-agents at a time): 
  - file_path: the file path of the code change. Only one file per agent.
  - requirement: the requirement that the code change is trying to solve (if any)

4. **Collect feedback**: Aggregate the feedback provided by the `code-reviewer` agent. Provide output following the specified format.

## Output Format

Provide feedback following format in `.claude/templates/code-review-output.md`. The more detailed, the better.
