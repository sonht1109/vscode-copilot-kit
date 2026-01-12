# Vscode Copilot Kit

A collection of MD files that helps interact with VSCode Copilot agent.

## Installation

### MCP Server setup

This kit will use MCP server to interact with external data resource. Suggest installing JIRA + Github MCP server in VSCode.

<details>
<summary>For example (Click to expand)</summary>

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
  "github-mcp": {
   "command": "docker",
   "args": [
    "run",
    "-i",
    "--rm",
    "-e",
    "GITHUB_PERSONAL_ACCESS_TOKEN",
    "ghcr.io/github/github-mcp-server"
   ],
   "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GH_TOKEN}" // this one is configured below. Avoid hardcoding here
   },
   "type": "stdio"
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

### Repo Setup

Clone the repo:

```bash
cd ~ && git clone git@github.com:sonht1109/vscode-copilot-kit.git

### OR if you did cloned before, just pull the latest changes
cd ~/vscode-copilot-kit && git pull origin main
```

Add permission to execute bash file:

```bash
chmod +x ~/vscode-copilot-kit/setup.sh
```

Then `cd` into your service which you want to use this kit to link MD files.

For example:

```bash
cd <your-project> && ~/vscode-copilot-kit/setup.sh
```


That's it. You can start using the kit. Check the usage below to know how to use this kit.

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