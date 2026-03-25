---
name: document-client-design
description: Turn the client's design into a well-structured document that can be used by AI.
---

# Document Client Design Prompt

Your mission is to document the client's design in a clear and organized manner. This document will serve as a reference for AI to understand the client's design and requirements.

## Core Principles

Spawn multiple subagents to gather information about how this repository use components, including installed packages and components. Each subagent should focus on a specific aspect of the design to ensure comprehensive coverage.

Output files should follow the `Output Format` specified below, and be saved in the `docs/design` directory of the repository. Each component should have its own markdown file with detailed information.

Make sure to create folder first:

```bash
mkdir -p docs/design
```

## Output Format

### 1. Overview

This file will provide a high-level overview of the client's design, including the installed packages and a list of components with brief descriptions. Each component should also include a link to a detailed design document if available. This file will be saved as `docs/design/overview.md`. The format should be as follows:

```markdown
# Overview

## Installed packages

- <List of installed packages>

## Component list

- <List of components with brief descriptions, link to detail design document if available>
```

eg:

```markdown
# Overview

## Installed packages

- React: A JavaScript library for building user interfaces.
- Antd: A popular React UI framework that provides a set of high-quality components.
- Styled-components: A library for styling React components using tagged template literals.

## Component list

- [Button](./components/Button.md): A reusable button component that supports various styles and sizes.
- [Input](./components/Input.md): A customizable input component for user text input.
```

### 2. Component Details

Each component should have its own markdown file in the `docs/design/components` directory. The file should include the following sections:

```markdown
# <Component Name>

## Description

- Component location in the codebase (e.g., `src/components/Button.tsx`)
- Component Props type definition
- Component hierarchy. If hierarchy is affected by props, list all possible variations of the hierarchy and the corresponding props values. Include tailwind classes if applicable. DO NOT SKIP THIS IMPORTANT STEP as it provides crucial information about the component's structure and styling.
```

One files can contains multiple components if they are closely related, such as a Button component and its variations (PrimaryButton, SecondaryButton, etc.). In this case, the file should be named after the main component (e.g., `Button.md`) and include sections for each variation.

eg:

```markdown
# Button

## Primary Button

- Location: `src/components/Button/PrimaryButton.tsx`
- Props: {
  text: string; // The text to be displayed on the button
  onClick: () => void; // Function to be called when the button is clicked
  }
- Component hierarchy:
  Button
  |- button (bg-white text-[#4620D1] h-[40px] w-full)

## Secondary Button

- Location: `src/components/Button/SecondaryButton.tsx`
- Props: {
  text: string; // The text to be displayed on the button
  onClick: () => void; // Function to be called when the button is clicked
  }
- Component hierarchy:
  Button
  |- button (bg-[#4620D1] text-white h-[40px] w-full)
```

### 3. Theme

Document the theme used in the client's design, including colors, typography, spacing, and any other relevant design tokens. This file will be saved as `docs/design/theme.md`. The format should be as follows:

```markdown
# Theme

## Colors

### Base colors

| Hex code   | Usage   |
| ---------- | ------- |
| <hex_code> | <usage> |

<other color categories such as input colors, background colors, etc. can be added here following the same format>
```

Eg:

```markdown
# Theme

## Colors

### Base colors

| Hex code | Usage                                |
| -------- | ------------------------------------ |
| #4620D1  | ${(p: any) => p.theme.color.primary} |
| #FFFFFF  | ${(p: any) => p.theme.color.white}   |

### Input colors

| Hex code | Usage                               |
| -------- | ----------------------------------- |
| #E5E5E5  | ${(p: any) => p.theme.input.label}  |
| #CCCCCC  | ${(p: any) => p.theme.input.border} |
```
