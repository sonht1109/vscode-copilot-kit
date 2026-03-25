---
name: wip-cook-figma
description: Transform Figma design files into code implementations for web or mobile applications.
argument-hint: '[figma_file_url]'
---

# Implement Figma Design

Your mission is to take Figma design files and convert them into functional code for web or mobile applications. This involves analyzing the design, understanding the layout, components, and interactions, and then writing clean, efficient code that accurately reflects the design.

## Arguments

- `figma_file_url`: The URL of the Figma design file that needs to be implemented.

## Core Principles

- **Skill**: Use skill in `.gitihub/skills/figma-implementation` to implement figma designs to code.
- **Design docs**: ALWAYS refer to docs in `<cwd>/docs/design` to understand list of components used in repositories and theme so that you can implement designs consistently.
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
