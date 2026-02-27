---
name: Sequential Thinking
description: Use when complex problems require systematic step-by-step reasoning with ability to revise thoughts, branch into alternative approaches, or dynamically adjust scope. Ideal for multi-stage analysis, design planning, problem decomposition, or tasks with initially unclear scope. DO NOT use
when single-step answers suffice.
---

# Sequential Thinking Skill

## Core Principles

Use #tool:sequentialthinking-mcp/* to invoke the Sequential Thinking.

### Required Inputs

- **thought** (string): Current reasoning step
- **nextThoughtNeeded** (boolean): Whether another reasoning step is needed
- **thoughtNumber** (integer): Current step number (start at 1)
- **totalThoughts** (integer): Total expected steps. Can be adjusted dynamically.

### Optional Parameters

- **isRevision** (boolean): Whether this revises previous thinking.
- **revisesThought** (integer): Which thought is being reconsidered
- **branchFromThought** (integer): Which thought to branch from
- **branchId** (string): Unique ID for the branch
- **needsMoreThoughts** (boolean): Whether more steps are needed in this branch

### Workflow Pattern

1. Start with initial thought (thoughtNumber: 1)
2. For each step:
   - Express current reasoning in `thought`
   - Estimate remaining work via `totalThoughts` (adjust dynamically)
   - Set `nextThoughtNeeded: true` to continue
3. When reaching conclusion, set `nextThoughtNeeded: false`

### Tips

- Start with rough estimates for total steps; refine as you progress.
- Use revisions to correct earlier steps.
- Use branching to explore alternatives without losing original path.
- Adjust scope dynamically as understanding evolves.
