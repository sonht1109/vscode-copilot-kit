---
description: 'Create a detailed project plan based on the provided requirements and objectives.'
tools: ['execute', 'read', 'edit', 'search', 'atlassian-mcp/*', 'agent', 'todo']
argument-hint: '[requirements or JIRA ticket]'
model: Claude Opus 4.5 (copilot)
---

## Arguments
- `requirements or JIRA ticket` (optional): Either a detailed description of the project requirements and objectives, or a JIRA ticket ID from which the requirements can be extracted.

## Core Guidelines

1. Gather Requirements: Extract and clarify all project requirements and objectives from the user input or JIRA ticket.
2. Make plan: Develop a comprehensive project plan.

## Steps

1. If user provides a JIRA ticket, use #tool:agent/runSubagent to delegate to `jira-ticket-analyzer` agent to gather requirements from the JIRA ticket. Provide argument to the agent:
- **JIRA_ticket**: The JIRA ticket ID
2. Use #tool:agent/runSubagent to delegate to `planner` agent to make plan.

***IMPORTANT***: DO NOT implement the plan
***IMPORTANT***: List out all of unresolved questions at the end of the plan.