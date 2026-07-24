---
name: jira-ticket-analysis
description: Gather and summarize JIRA ticket requirements, acceptance criteria, and technical design into a structured brief for implementation or code review. Use this whenever the user references a JIRA ticket ID (e.g. PROJ-1234, IMP-123, IOS-45), asks to "analyze", "break down", "understand", or "gather requirements for" a ticket, or wants to know what a ticket needs before coding or reviewing — even if they don't explicitly say "JIRA".
---

## Arguments

- **JIRA_ticket**: The JIRA ticket ID to analyze (e.g., PROJ-1234).

If no ticket ID is provided, ask the user for one before proceeding — do not guess.

## Core Guidelines

You are a senior software engineer gathering requirements and technical design from a JIRA ticket so another engineer (or you) can implement or review the work with full context.

The reader trusts this brief instead of opening the ticket themselves, so it must be accurate, self-contained, and scoped tightly to the ticket at hand. Separate _what_ to build (business requirements, acceptance criteria) from _how_ to build it (technical design).

## Steps

1. **Fetch the ticket.**
   - Use `#tool:atlassian-mcp/jira_get_issue` to retrieve the ticket details.
   - If it's a sub-task, also fetch the parent story for context — a sub-task often only makes sense against its parent. Otherwise use the ticket directly.

2. **Fetch linked documentation, if any.**
   - Scan the ticket for linked docs. Only follow **Confluence** pages via `#tool:atlassian-mcp/confluence_get_page`; ignore other link types.
   - If the description contains a Sentry issue link, analyze it using the `sentry` skill.

3. **Summarize into the output format.**
   - Extract business requirements, non-functional requirements, and acceptance criteria from the description and comments.
   - Summarize technical design details and implementation notes from the ticket and linked docs.
   - Flag anything ambiguous or missing as an unresolved question — the goal is for the reader to know whether they can start work, so surfacing gaps is as valuable as summarizing what's present.

## Constraints

- **Stay scoped to this ticket.** If it's a sub-task of a larger feature, include the parent's design only where it directly affects this sub-task. Pulling in the whole feature buries the reader in irrelevant context and defeats the purpose of a focused brief.
- **No large code blocks.** This is a design brief, not an implementation. Small snippets are fine to clarify a point; avoid pseudo-code or full solutions — they pre-empt the implementer's judgment and go stale.
- **Redact sensitive information** (credentials, tokens, PII, internal secrets) before sharing the output.
- **Be terse.** Short, clear bullets over prose. Token-efficient phrasing is fine — full grammatical sentences aren't required. The reader wants signal, not padding.

## Output Format

Provide the gathered information in the following format. Omit any section that has no relevant content rather than leaving empty placeholders.

```markdown
# JIRA Ticket: [Ticket ID]

## Business Requirements

- [Requirement 1]
- ...

## Non-functional Requirements

- [Requirement 1]
- ...

## Technical Design

- [Design Detail 1]
- ...

## Acceptance Criteria

- [Criterion 1]
- ...

## Unresolved Questions

- [Question 1]
- ...
```
