# Vscode Copilot Kit

A collection of MD files that helps interact with VSCode Copilot agent.

## Installation

> [!NOTE]
> 💡 **Available tools supported:**
> - VSCode Copilot
> - Opencode
> - Claudecode

### Common Repo Setup

#### 1. First time setup

Clone the repo:

```bash
cd ~ && git clone git@github.com:sonht1109/vscode-copilot-kit.git
```

Expose the kit subcommand from `bin`:

```bash
# add the kit bin folder to PATH
echo 'export PATH="$HOME/vscode-copilot-kit/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Then `cd` into your service and run the subcommand:

```bash
cd project && vck setup

# setup for opencode
cd project && vck setup opencode

# setup for claudecode
cd project && vck setup claude

# setup all supported tools
cd project && vck setup all

# use symbolic links instead of copying
cd project && vck setup all --link
```

Available options:

```bash
Usage:
  vck <command> [options]

Commands:
  setup [target]     Run setup scripts for a target environment
  update [target]    Pull latest kit changes then run setup
  help               Show this help message

Targets:
  copilot            Setup VSCode Copilot files (default)
  opencode           Setup Opencode files
  claude             Setup Claudecode files
  all                Setup all supported tools

Options:
  -cp, --copy        Copy files (default)
  -ln, --link        Create symlinks instead of copying
  -h, --help         Show this help message
```

#### 2. Update the kit

If you want to update the kit to get the latest changes, run update via the subcommand (**in the service folder**):

```bash
cd project && vck update

# or specific targets
cd project && vck update opencode
cd project && vck update claude
cd project && vck update all
```

That's it. You can start using the kit. Check the usage below to know how to use this kit.

> [!TIP]
> 💡 If you don't see the instruction file `copilot-instructions.md`, you SHOULD generate one by running:
>
> ```bash
> /init
> ```
>
> This is optional, but helps Copilot work even better!

### MCP Server

This kit will use MCP server to interact with external data resource. Suggest installing JIRA + Github MCP server in VSCode.

<details>
<summary>For example: VSCode copilot (Click to expand)</summary>

```json
{
  "inputs": [
    {
      "type": "promptString",
      "id": "github_token",
      "description": "GitHub Personal Access Token",
      "password": true
    },
    {
      "type": "promptString",
      "id": "atlassian_token",
      "description": "Atlassian API Token",
      "password": true
    }
  ],
  "servers": {
    "atlassian-mcp": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "CONFLUENCE_URL",
        "-e",
        "CONFLUENCE_USERNAME",
        "-e",
        "CONFLUENCE_API_TOKEN",
        "-e",
        "JIRA_URL",
        "-e",
        "JIRA_USERNAME",
        "-e",
        "JIRA_API_TOKEN",
        "ghcr.io/sooperset/mcp-atlassian:latest"
      ],
      "env": {
        "CONFLUENCE_URL": "https://<org>.atlassian.net/wiki",
        "CONFLUENCE_USERNAME": "<username>@<org>.com", // replace your email
        "CONFLUENCE_API_TOKEN": "${env:ATLASSIAN_API_TOKEN}", // this one is configured below. Avoid hardcoding here
        "JIRA_URL": "https://<org>.atlassian.net",
        "JIRA_USERNAME": "<username>@<org>.com", // replace your email
        "JIRA_API_TOKEN": "${env:ATLASSIAN_API_TOKEN}" // this one is configured below. Avoid hardcoding here
      },
      "type": "stdio"
    },
    "sequentialthinking-mcp": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "mcp/sequentialthinking"]
    }
  }
}
```

</details>

<details>
<summary>For example: Opencode (Click to expand)</summary>

```json ~/.config/opencode/opencode.json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "atlassian-mcp": {
      "enabled": true,
      "type": "local",
      "command": [
        "docker",
        "run",
        "-i",
        "--rm",
        "-e",
        "CONFLUENCE_URL",
        "-e",
        "CONFLUENCE_USERNAME",
        "-e",
        "CONFLUENCE_API_TOKEN",
        "-e",
        "JIRA_URL",
        "-e",
        "JIRA_USERNAME",
        "-e",
        "JIRA_API_TOKEN",
        "ghcr.io/sooperset/mcp-atlassian:latest"
      ],
      "environment": {
        "CONFLUENCE_URL": "https://<org>.atlassian.net/wiki",
        "CONFLUENCE_USERNAME": "<username>@<org>.com",
        "CONFLUENCE_API_TOKEN": "{env:ATLASSIAN_API_KEY}",
        "JIRA_URL": "https://<org>.atlassian.net",
        "JIRA_USERNAME": "<username>@<org>.com",
        "JIRA_API_TOKEN": "{env:ATLASSIAN_API_KEY}"
      }
    },
    "sequentialthinking": {
      "type": "local",
      "command": [
        "docker",
        "run",
        "--rm",
        "-i",
        "mcp/sequentialthinking"
      ]
    },
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "{env:CONTEXT7_API_KEY}"
      },
      "enabled": true
    }
  }
}
```

</details>

<details>
<summary>For example: Claudecode (Click to expand)</summary>

```json ~/.claude.json
{
  "mcpServers": {
    "atlassian-mcp": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "CONFLUENCE_URL",
        "-e",
        "CONFLUENCE_USERNAME",
        "-e",
        "CONFLUENCE_API_TOKEN",
        "-e",
        "JIRA_URL",
        "-e",
        "JIRA_USERNAME",
        "-e",
        "JIRA_API_TOKEN",
        "ghcr.io/sooperset/mcp-atlassian:latest"
      ],
      "env": {
        "CONFLUENCE_URL": "https://<org>.atlassian.net/wiki",
        "CONFLUENCE_USERNAME": "<username>@<org>.com",
        "CONFLUENCE_API_TOKEN": "${ATLASSIAN_API_KEY}",
        "JIRA_URL": "https://<org>.atlassian.net",
        "JIRA_USERNAME": "<username>@<org>.com",
        "JIRA_API_TOKEN": "${ATLASSIAN_API_KEY}"
      },
      "type": "stdio"
    },
    "sequentialthinking-mcp": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "mcp/sequentialthinking"
      ]
    },
    "context7-mcp": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    },
    "figma-mcp": {
      "url": "http://localhost:3845/mcp",
      "type": "http"
    }
  }
}
```

</details>

Make sure to setup your env var as well. For example, im using **zsh**:

```bash
echo 'export GH_TOKEN=<gh_token>' >> ~/.zshrc
echo 'export ATLASSIAN_API_KEY=<atlassian_api_key>' >> ~/.zshrc

source ~/.zshrc
```



## Workflows

Step-by-step guides for common development tasks:

- 🚀 [Feature Implementation Workflow](./docs/workflows/feature-implement-workflow.md) - Plan, implement, and deliver features
- 🔍 [Code Review Workflow](./docs/workflows/code-review-workflow.md) - Review code changes before committing
- 📝 [Pull Request Workflow](./docs/workflows/pull-request-workflow.md) - Create and manage pull requests
- 🎨 [Figma Implementation Workflow](./docs/workflows/figma-implementation.md) - Implement Figma designs based on requirements or JIRA tickets

## Docs

- Commands:
  - [create-pr]()
  - [review-code-changes]()
  - [review-pr]()
  - [plan]()
  - [init]()
  - [cook-plan]()
  - [cook-figma]()
- Agents:
  - [console-spec]()
  - [code-reviewer]()
  - [planner]()
  - [jira-ticket-analyzer]()
- Skills:
  - [backend-development]()
  - [gh]()
  - [sequential-thinking]()
  - [docs-seeker]()
  - [figma-implementation]()

## Use your local MD

In case you want to use your local MD files along with the kit, you can create files with `*.local.*` in name or `*-local/` folders.

Eg:

```markdown
.github/agents/code-reviewer.local.agent.md
.claude/skills/project-local/SKILL.md
.opencode/commands/command.local.md
```

These files/folders will be preserved during the setup process and won't be overwritten by the kit.

## How to contribute

Contributions are welcome! To contribute, please fork the repository, make your changes in a new branch, and submit a pull request. Follow these steps:

1. Fork the repository and clone it to your local machine and checkout a new branch.
2. If you desire to add new agents/prompts/skills/instructions/templates, please add them into `.github/` folder first. Then run scripts to sync to other tools like opencode and claudecode:

```bash
bash ./migrate-tools.sh
```

3. If you desire to add other things which are specific to a tool, like `.github/hooks`, `.claude/settings.json`, `.opencode/plugins`, etc., please add them into the corresponding folder and make sure to update the setup scripts if needed.

4. Commit and create PR
