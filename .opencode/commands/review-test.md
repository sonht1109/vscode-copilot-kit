---
name: review-test
description: This prompt is used to review a unit test for a given code snippet. The model will analyze the unit test and provide feedback on its effectiveness, coverage, and potential improvements.
---

## Core Principles

Delegate to `code-reviewer` agent to review the test file.

## Output format

```markdown
# Unit Test Review

## Tests to Add
- List any additional tests that should be added to improve coverage.

## Tests to Remove
- List any tests that should be removed due to redundancy or irrelevance.

## Tests to Modify
- List any tests that should be modified for better clarity, effectiveness, or coverage.
```
