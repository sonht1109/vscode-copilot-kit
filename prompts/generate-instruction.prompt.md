---
description: 'Generate instruction file based on current code base'
tools: ['vscode', 'execute', 'read', 'edit', 'search', 'agent', 'todo']
model: Gemini 2.5 Pro (copilot)
---

You are an expert in writing coding conventions and AI assistant instructions. Generate a `.github/copilot-instructions.md` file for a software project.

***IMPORTANT***: The instructions must be tailored to the specific codebase provided. Analyze the codebase to identify relevant patterns, practices, and technologies used. Avoid conflicts with existing conventions.

## Input Required

1. **Project Name**: [e.g., "EWA Summary Service"]
2. **Tech Stack**: [e.g., TypeScript, Node.js, Express, TypeORM]
3. **Primary Language**: [e.g., TypeScript]
4. **File Extensions**: [e.g., "**/*.ts,**/*.tsx"]
5. **Project Structure**: Describe the folder structure
6. **Existing Tools**: List linters, formatters, test frameworks (e.g., ESLint, Prettier, Jest)
7. **Special Patterns**: Any domain-specific patterns or conventions

## Output Format

Generate a markdown file with YAML frontmatter and these sections:

### Required Sections

1. **Frontmatter**
```yaml
---
applyTo: "<file_extensions>"
---
```

2. Table of Contents - Linked section headers
3. General Principles - 3-5 core principles (simplicity, consistency, type safety, security)
4. Language-Specific Guidelines - For the primary language:
  - Type definitions/annotations
  - Async patterns
  - Avoiding anti-patterns (e.g., any in TS)
  - Variable hygiene
5. No Magic Numbers/Strings - With:
  - Bad/Good code examples
  - Enum usage examples
  - Constants file location
  - Acceptable exceptions
6. Code Formatting - Table of formatter settings, ESLint rules, run commands
7. Naming Conventions - Tables for:
  - Files & directories (with examples)
  - Variables, functions, classes, enums
  - Database columns (if applicable)
8. Project Structure - ASCII tree diagram with descriptions
9. Logging - Logger usage patterns with good/bad examples
10. Error Handling - Custom exception patterns, best practices
11. Testing Standards - File location, structure (AAA pattern), mocking examples, coverage
12. Security Practices - Input validation, injection prevention, security rules
13. Additional Resources - Links to related config files
14. Footer - Last updated date, company name

Style Requirements

- Use code blocks with syntax highlighting
- Include "Good" and "Bad" examples for clarity
- Use tables for conventions and settings
- Add horizontal rules between major sections
- Keep examples concise but realistic
- Use ***IMPORTANT*** for critical notes

---