---
description: 'Generate instruction file based on current code base'
tools: ['execute', 'read', 'edit', 'search', 'agent', 'todo']
model: Claude Sonnet 4.5 (copilot)
---

You are an expert in writing coding conventions and AI assistant instructions. Generate a `.github/copilot-instructions.md` file for a software project.

## Core Guidelines

1. **Outline**: The instruction file should cover coding conventions, project structure, naming conventions, error handling, logging, testing standards, and security practices.
2. **Tailor to the project**: For each section, customize the content based on the project's tech stack, primary programming language, and existing tools (linters, formatters, test frameworks). Spawn mulitple subagents if needed to gather specific information about the project.
3. **Output**: Use markdown with YAML frontmatter. Follow the section `Output Format` below for structure and content.

**_IMPORTANT_** Ensure instruction is short enough yet clear.
**_IMPORTANT_** Provide file/folder location in each section where applicable.

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
applyTo: '<file_extensions>'
---

**_IMPORTANT_**: Analyze and use skills in `.github/skills` if needed to process tasks.
```

2. Project Overview - Brief description, tech stack, architecture

| Project Name       | <project_name>      |
| ------------------ | ------------------- |
| Tech Stack         | <tech_stack>        |
| ---                | ---                 |
| Linters/Formatters | <existing_tools>    |
| ---                | ---                 |
| Architecture       | <architecture>      |
| ---                | ---                 |
| Testing Framework  | <testing_framework> |

3. Project Structure - ASCII tree diagram with descriptions
4. General Principles - 3-5 core principles

- Consistency
- Type safety
- Avoiding anti-patterns (e.g., any in TS)
- Variable hygiene

5. Path aliases and module resolution

For example:

```markdown
@api -> src/api
@utils -> src/utils
```

6. No Magic Numbers/Strings - With:

- Bad/Good code examples
- Enum usage examples
- Constants file location
- Acceptable exceptions

7. Code Formatting - Table of formatter settings, ESLint rules, run commands
8. Naming Conventions - Tables for:

- Files & directories (with examples)
- Variables, functions, classes, enums
- Database columns (if applicable)

9. Logging - Current project usage patterns with good/bad examples
10. Error Handling - Make example of current error handling pattern of project
```markdown
try {
  // code
} catch (error) {
  // handle error
}
```
11. Testing Standards - File location, structure (AAA pattern), mocking examples, run commands (suggest running only relevant tests)
12. Security Practices - Input validation, injection prevention, security rules
13. External Integrations - Microservices interaction

```markdown
- **<Service>**: <short description>
```

14. Additional Resources - Links to related config files
15. Footer:

```markdown
Last Update in <time> by <company_name>
```

Style Requirements

- Use code blocks with syntax highlighting
- Include "Good" and "Bad" examples for clarity
- Use tables for conventions and settings
- Add horizontal rules between major sections
- Keep examples concise but realistic
- Use **_IMPORTANT_** for critical notes
