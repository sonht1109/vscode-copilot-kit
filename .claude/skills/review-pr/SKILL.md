---
name: "review-pr"
description: "Review pull requests to ensure they meet business requirements and coding conventions."
---

## Arguments

- **PR_link**: A link to the pull request that outlines the changes made to the codebase and the requirements it is trying to solve.

## Core Principles

- **Thoroughness**: Ensure that the review is comprehensive and covers all aspects of the code changes, including functionality, readability, maintainability, and adherence to coding standards.

- **Divide and Conquer**: Break down the review process into manageable parts by reviewing each changed file separately using sub-agents. This approach helps maintain focus and ensures a more detailed review. Never review on the main diff.patch file directly to avoid being overwhelming.

## Steps

1. **Clone PR**: Load and use `./gh-clone-pr/SKILL.md` skill to clone the PR locally. Output will include these information for next step:

- content_path: list of diff patches location
- requirement: what things the PR is trying to solve (in PR description)

If requirement is not enough, and JIRA ticket is linked, delegate to `jira-ticket-analysis` to extract and summarize the requirements with following params:

- JIRA_ticket: link from PR description

2. **Review code changes**: with PR contents that are already cloned in local:

- Check how many content files are changes
- With each file, spawn corresponding `code-review` agent with the following params (can be up to 3 sub-agents at a time):
  - file_path: the file path of this file's own individual patch (one file's changes only, from `contents/`). Only one file per agent.
  - requirement: the requirement that the code change is trying to solve (if any)
  - parent_diff_path: the path to the combined `diff.patch` covering every file changed in the PR, not just this one. The sub-agent needs this to resolve symbols (functions, types, imports) that are defined or modified in a sibling file rather than in `file_path` itself — without it, the sub-agent can only see this one file and will wrongly flag such symbols as undefined.

**_IMPORTANT_**: Never review on the main diff.patch file as the primary target. Treat it as a reference only, passed via `parent_diff_path` for cross-file context. Must use sub-agent to review each changed file separately.

3. **Collect feedback**: Aggregate the feedback provided by the `code-review` agent.

4. **Provide feedback**: Summarize the feedback and save output files into `<cwd>/notes/review/<PR_number>-code-review-feedback.md`. Format must follow section `Output Format` below. Provide the file path to the generated feedback to user.

## Output Format

```markdown
### Overall Assessment

[Summary of overall assessment. No more than 3 sentences.]

### ❌ Critical Issues

[List of critical issues that must be addressed and suggested fixes with code snippets if applicable. These issues should be marked as blockers and must be resolved before merging.]

1. [Issue 1]

- File: [File path where the issue is located]
- Description: [Terse fragment naming the defect only, e.g. "Missing null check on user.email". Max ~30 words, no rationale]
- Suggested fix: [Provide a suggested fix or code snippet to resolve the issue]

2. [Issue 2]

- File: [File path where the issue is located]
- Description: [Terse fragment naming the defect only, e.g. "Missing null check on user.email". Max ~30 words, no rationale]
- Suggested fix: [Provide a suggested fix or code snippet to resolve the issue]

...

### ⚠️ Medium Issues

[List of non-blocking issues from the crucial categories (breaking changes, functionality, exploitable security) that are real but don't need to block the merge. Do NOT use this section for low-risk items (performance nitpicks, hardening suggestions, error-handling polish, test completeness, style) — those should be omitted from the review entirely, not downgraded into here.]

1. [Issue 1]

- File: [File path where the issue is located]
- Description: [Terse fragment naming the defect only, e.g. "Missing null check on user.email". Max ~30 words, no rationale]
- Suggested fix: [Provide a suggested fix or code snippet to resolve the issue]

2. [Issue 2]

- File: [File path where the issue is located]
- Description: [Terse fragment naming the defect only, e.g. "Missing null check on user.email". Max ~30 words, no rationale]
- Suggested fix: [Provide a suggested fix or code snippet to resolve the issue]

...
```
