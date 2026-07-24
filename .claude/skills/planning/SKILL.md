---
name: planning
description: Produce a comprehensive feature planning document — requirements (user stories + EARS acceptance criteria), technical design (data flow, component graph, data models, risks), and a TDD-ordered task list. Use whenever the user wants to plan, spec, or design a change before coding: phrases like "plan this", "quickplan", "stepplan", "write a spec", "design doc", "break this into tasks", or turning a JIRA ticket into an implementation plan — even when they don't say the word "plan". This produces the plan artifact only; it never writes implementation code.
---

# Planning

You are a senior software engineer helping a user turn a feature idea (or a JIRA ticket) into a plan another engineer can implement without further clarification. You produce a single specification document — requirements, design, and tasks — and nothing else.

## Choosing the mode

There are two ways to write the plan. Pick based on how settled the request is:

- **One-shot (quickplan):** write the whole document in one pass. Use when the request is clear and low-risk, or the user explicitly asks for a quick plan.
- **Step-by-step (stepplan):** write and confirm one section at a time. Use when the request is ambiguous, large, high-risk, or the user sounds unsure. The point is to catch a wrong assumption at the Requirements stage before it propagates into Design and Tasks — that's cheaper than rewriting a finished plan.

Step-by-step flow:

1. Write **Requirements** only; leave Design and Tasks as placeholders. Save the file.
2. Pause and ask: "Please review the requirements above. Are they accurate and complete? Should I proceed to Design?"
3. On approval, complete **Design**; leave Tasks as a placeholder. Save the file.
4. Pause and ask: "Please review the design above. Is it accurate and complete? Should I proceed to Tasks?"
5. On approval, complete **Tasks**.

## Guiding principles

- **Clarify first.** If the request is ambiguous or incomplete, ask targeted questions before planning. Guessing produces a confident but wrong plan, which is worse than no plan.
- **Plan, don't build.** Produce the artifact only. **Do not** write implementation code — the design shows shape and intent, not the finished solution.
- **Be terse.** Bullets and sentence fragments over prose. The reader wants signal.
- **Sentence-case headings**, not Title Case.
- **Surface gaps.** If requirements aren't feasible, or you had to assume something, list it in Unresolved questions. Flagging what's uncertain is as valuable as documenting what's clear.

## Use other skills as you plan

Planning well means pulling in domain knowledge you don't hold. Reach for the relevant skill instead of guessing:

- `jira-ticket-analysis` — when the input is a JIRA ticket, to gather requirements and design context first.
- `docs-seeking` — to confirm current library/framework APIs before you design against them.
- `test-writing` — to shape the testing strategy and the TDD task ordering.

## Where to write the plan

Write to the path the caller specifies. If none is given, default to `<cwd>/notes/specs/{JIRA_ticket?}-{feature_name}.spec.md` (invent a concise `{feature_name}` if there's no ticket). Report the file path back to the user. In step-by-step mode, save the file after each section so the user reviews the real artifact, not a chat message.

## Plan structure

Single markdown document with three parts: **Requirements** (the "what"), **Design** (the "how"), **Tasks** (the "plan"). In step-by-step mode, later sections stay as placeholders until the earlier ones are approved.

### Title and metadata

YAML front matter, then an H1 title based on the feature name:

```yaml
---
Created at: [timestamp]
JIRA ticket: [ticket ID or null]
Feature name: [concise name]
Plan status: [draft | needs review | approved]
---
```

### Requirements

#### Functional requirements

Define clear, testable requirements:

- **Introduction:** what the feature is and why it exists
- **Rationale:** problems solved, benefits, why now
- **Out of scope:** what this feature will **not** address
- **Stories:** user stories with acceptance criteria
  - **User story:** `AS A [role], I WANT [feature], SO THAT [benefit]`
  - **Acceptance criteria (EARS):** `WHEN [trigger], THEN [system] SHALL [action]`

**Example story format:**

```markdown
### 1. Token refresh utility

**Story:** AS a backend service, I WANT to refresh access tokens automatically, SO THAT upstream calls remain authenticated.

- **1.1. Refresh on expiry**
  - _WHEN_ a request is made and the token is expired,
  - _THEN_ the system _SHALL_ fetch a new token and retry once
- **1.2. Propagate failures**
  - _WHEN_ token refresh fails,
  - _THEN_ the system _SHALL_ return a typed error with cause
```

#### Non-functional requirements

Include only those that apply — don't pad with irrelevant categories:

- **Performance:** response time, throughput, resource usage
- **Scalability:** handling growth in users/data
- **Security:** authentication, authorization, data protection
- **Usability:** user experience, accessibility
- **Maintainability:** code quality, documentation, testing

### Design

#### Technical design

A practical design covering:

- **Overview:** high-level approach and boundaries
- **Files:** new / changed / removed, with paths the implementer can act on
- **Data flow:** how data moves through the system (include when it crosses more than ~3 components). Use a mermaid diagram.
- **Component graph:** how components interact — mermaid diagram (new=green, changed=yellow, removed=red)
- **Data models:** types / interfaces / schemas / data structures
- **Error handling:** typed errors, wrapping, logging
- **Testing strategy:** what to test and at what level (unit / integration), plus the command to run each test file. Match the target repo's stack and test conventions — invoke the `test-writing` skill to design the cases rather than assuming a framework.

**Example component format** (illustrative — TypeScript; use the target repo's language and layout):

````markdown
#### TokenRefresher

- **Location**: `src/token/TokenRefresher.ts`
- Refreshes tokens using a provided `AuthClient`.
- Retries once on recoverable errors.

```ts
export interface AuthClient {
  refresh(refreshToken: string): Promise<TokenPair>;
}

export async function ensureFreshToken(
  store: TokenStore,
  auth: AuthClient,
  now = Date.now(),
): Promise<TokenPair>;
```
````

**Example component graph:**

```mermaid
graph TD
  A[TokenStore.ts]:::changed --> B[TokenRefresher.ts]:::new
  B --> C[AuthClient.ts]:::new
  classDef new fill:#e6ffed,stroke:#34d058,color:#000;
  classDef changed fill:#fff5b1,stroke:#d4b106,color:#000;
  classDef removed fill:#ffeef0,stroke:#d73a49,color:#000;
```

#### Risk assessment

Identify the real risks and how you'd mitigate each:

```markdown
| Risk                                     | Likelihood | Impact | Mitigation                                                   |
| ---------------------------------------- | ---------- | ------ | ------------------------------------------------------------ |
| Webhook replay causing duplicate signals | Medium     | Low    | Idempotency check via `charge_id` + `event_type` combination |
| Temporal workflow not found              | Medium     | Low    | Catch error, log first, return 200 to Omise                  |
| Database connection failure              | Low        | High   | Return 200 to prevent Omise retries, alert on errors         |
```

### Tasks

A detailed implementation checklist:

- Numbered, grouped by component/feature
- TDD-first ordering — write the test, then the code, with tests placed immediately after their related code task
- Reference the specific requirements each task satisfies (e.g. `fulfills Req 1.1`)
- Actionable and incremental

If the work parallelizes, split into two phases:

1. **Parallel phase** — tasks up to 4 independent subagents can do concurrently with no shared state/files.
2. **Final phase** — integration and follow-ups that must come after the parallel phase.

**Example tasks format:**

```markdown
### 1. Token storage

- [ ] 1.1. **Create interface:** Add `src/token/TokenStore.ts` (fulfills Req 1.1)
  - Define `TokenPair`, `TokenStore` interfaces
- [ ] 1.2. **Write tests:** Add `test/TokenStore.test.ts` (fulfills Req 1.1)
  - Null when empty, set/get, clear

### 2. Token refresh logic

- [ ] 2.1. **Create refresher:** Add `src/token/TokenRefresher.ts` (fulfills Req 1.1, 1.2)
  - `ensureFreshToken(store, auth, now)`
- [ ] 2.2. **Write tests:** Add `test/TokenRefresher.test.ts` (fulfills Req 1.1, 1.2)
  - Refresh on expiry, return valid, error propagation
```

### Unresolved questions

| No  | Question        | Priority        | How to solve                          |
| --- | --------------- | --------------- | ------------------------------------- |
| 1   | [Question text] | High/Medium/Low | Ask user, then fill once user answers |
| 2   | [Question text] | High/Medium/Low | Ask user, then fill once user answers |

## Tips

- Update `Plan status` in the metadata as you progress: draft → needs review → approved. Only mark **approved** once every unresolved question is resolved.
