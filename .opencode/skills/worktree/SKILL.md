---
name: worktree
description: Use when user asks to create an isolated git worktree for parallel development. Useful for working on multiple features or bug fixes simultaneously without affecting the main branch.
---

## Arguments

- `$branch_name`: The name of the branch to be created for the worktree. Invent a new one if not provided.
- `$path_to_remove`: The path of the worktree to be removed. Required when using the `remove` action. 
- `$action`: The action to perform. Can be `create`, `list`, or `remove`. If not provided, default to `list`.
  - `create`: Create a new worktree. Requires a branch name and a path.
  - `list`: List all existing worktrees.
  - `remove`: Remove an existing worktree. Requires the path of the worktree to be removed.

Eg:
```bash
/worktree create <branch_name> <path_to_worktree_root> <base_branch_name>
/worktree list
/worktree remove <path_to_worktree>
```

If none of the above commands are provided, use the `list` command by default.

## Workflow

1. Prepare `branch_name` and `path_to_remove` arguments based on user input and command requirements. If `branch_name` is not provided for the `create` command, generate a new one. Use `/git` skill to do.

2. Run command to with proper actions:

```bash
node skills/worktree/scripts/worktree.js --action=<action>
```

Where:
- `action` can be `create`, `list`, or `remove`. With each action, required arguments must be provided.

2.1. `create` action:

```bash
node skills/worktree/scripts/worktree.js --action=create --branch=<branch_name> --worktree-root=<path_to_worktree_root> --base=<base_branch_name>
```

Where:
- `branch_name` is the name of the branch to be created for the worktree.
- `path_to_worktree_root` (optional) is the path where the new worktree will be created. By default, it is `<cwd>/.worktrees/<branch_name>`. Only specify this if user asks.
- `base` (optional) is the name of the base branch from which the new branch will be created. By default, it is `develop`.

Eg:

```bash
node skills/worktree/scripts/worktree.js --action=create --branch=feature/new-feature
```

2.2. `list` action:

```bash
node skills/worktree/scripts/worktree.js --action=list
```

2.3. `remove` action:

```bash
node skills/worktree/scripts/worktree.js --action=remove --path=<path_to_worktree>
```

Where:
- `path_to_worktree` is the path of the worktree to be removed. Must be the absolute path.

Eg:

```bash
node skills/worktree/scripts/worktree.js --action=remove --path=/Users/<username>/.worktrees/feature/new-feature
```

If you are not sure about the path of the worktree to be removed, you can use the `list` action to find it first.
