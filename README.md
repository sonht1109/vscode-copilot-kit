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

Add permission to execute bash file:

```bash
chmod +x ~/vscode-copilot-kit/*.sh
```

Then `cd` into your service which you want to use this kit to link MD files.

For example:

```bash
cd project && ~/vscode-copilot-kit/setup.sh

# or for opencode
cd project && ~/vscode-copilot-kit/setup-opencode.sh

# or for claudecode
cd project && ~/vscode-copilot-kit/setup-claudecode.sh

# or it you want to setup ALL tools at once
cd project && ~/vscode-copilot-kit/setup.sh --all
```

#### 2. Update the kit

If you want to update the kit to get the latest changes, just run the setup script again (**in the service folder**):

```bash
cd project && ~/vscode-copilot-kit/pull-update.sh && ~/vscode-copilot-kit/setup.sh # or setup-opencode.sh or setup-claudecode.sh
```

That's it. You can start using the kit. Check the usage below to know how to use this kit.

> [!TIP]
> 💡 If you don't see the instruction file `copilot-instructions.md`, you SHOULD generate one by running:
>
> ```bash
> /generate-instruction
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

## Docs

- Commands:
  - [create-pr]()
  - [review-code-changes]()
  - [review-pr]()
  - [commit]()
  - [plan]()
  - [cook-plan]()
  - [generate-instruction]()
- Agents:
  - [code-reviewer]()
  - [planner]()
  - [jira-ticket-analyzer]()
- Skills:
  - [backend-development]()
  - [gh]()
  - [sequential-thinking]()
  - [docs-seeker]()
