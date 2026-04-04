# Figma Implementation Workflow

## Overview

From JIRA ticket to code implementation but with Figma design as the source of truth.

## Prerequisite

- Figma MCP
- Atlassian MCP

## Example Workflows

```bash
/cook-figma https://<org>.atlassian.net/browse/IMP-1234
```

Example of JIRA ticket:

```markdown
Add new column called `Company Name` into table of page `Company`

Figma design: https://www.figma.com/file/xxxxxx/Design-System?node-id=1234-5678

Acceptance criteria:
- Must add new column `Company Name` into table of page `Company`
- Column key must match with key `company_name` from API response
```

If you only need to implement figma design without JIRA ticket, you can also provide detailed requirement as argument:

```bash
/figma-implementation Add new column called `Company Name` into table of page `Company`. Figma design: https://www.figma.com/file/xxxxxx/Design-System?node-id=1234-5678. Acceptance criteria: Must add new column `Company Name` into table of page `Company`. Column key must match with key `company_name` from API response.
```

## Commands

- `/cook-figma [requirement or JIRA ticket link]` – Implement Figma design based on requirement or JIRA ticket
- `/figma-implementation [requirement + figma link]` – Implement Figma design based on requirement and figma link
