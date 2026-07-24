---
name: "jira-to-spec"
description: "Create a detailed project specification based on JIRA ticket"
---

## Arguments

- `JIRA ticket` (optional): Either a detailed description of the project requirements and objectives, or a JIRA ticket ID from which the requirements can be extracted.

## Core Guidelines

1. Gather Requirements: Extract and clarify all project requirements and objectives from the user input or JIRA ticket.
2. Make specification: Develop a comprehensive project specification.

## Steps

1. If user provides a JIRA ticket, use #tool:agent/runSubagent to delegate to `jira-ticket-analysis` to gather requirements from the JIRA ticket. Provide argument to the agent:

- **JIRA_ticket**: The JIRA ticket ID

2. Load and use the `/planning` skill to make the specification.
3. Create a detailed specification based on the gathered requirements. Output then must be stored at `<cwd>/notes/specs/{JIRA_ticket?}-{feature_name}.spec.md` (invent `{feature_name}` if missing). Provide the file path to the generated specification to user.

**_IMPORTANT_**: DO NOT implement the specification
**_IMPORTANT_**: If there are any unresolved questions, remind user to check the generated specification and ask for clarification.
