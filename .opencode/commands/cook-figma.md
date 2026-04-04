---
name: cook-figma
description: Transform Figma design files into code implementations for web or mobile applications.
argument-hint: '[requirement or JIRA ticket link]'
---

## Arguments

- **requirement or JIRA ticket link**: A detailed requirement or a link to a JIRA ticket that outlines the specific features, components, or pages that need to be implemented based on the Figma design.

## Core Principles

- **Requirements Understanding**: Thoroughly understand the requirements or JIRA ticket provided to ensure that the implementation aligns with the expected outcomes and design specifications.
- **Component Use**: From Figma MCP output, try to reuse existing components as much as possible also theme as well. Understand component hierarchy and component style so that you can decide which components to reuse.

Eg:

```
// Bad
<button className="primary-btn">Click me</button>

// Good
<PrimaryButton>Click me</PrimaryButton>
```

- **Spacing and Layout**: MUST Pay close attention to spacing, margins, dimensions, and layout as specified in the Figma design. Use CSS or styling solutions that allow for precise control over these aspects to ensure the final implementation matches the design closely.
- **Responsiveness**: Ensure that the implementation is responsive and works well on different screen sizes, as Figma designs often include layouts for various devices.

## Steps

1. **Gather Requirements**: If a JIRA ticket link is provided, delegate to `jira-ticket-analyzer` agent to extract and summarize the requirements. If a detailed requirement is provided, analyze it to understand the scope of work.
2. **Understand Codebase**: Analyze and detect which page/component the implementation belongs to. Understand the existing codebase and identify where the new implementation will fit in.
3. **Figma Implementation**: Use the Figma design file to guide the implementation, ensuring that the final code accurately reflects the design specifications. MUST use `/figma-implementation` skill to implement.
