---
name: atlassian
description: Use when user asks to work for any tasks related to Jira, Confluence, Bitbucket, Trello, Opsgenie, and all Atlassian operations from the command line.
---

# Atlassian Skill

## Prerequisites

Setup env variables and login:

```bash
export ATLASSIAN_API_TOKEN=<your_atlassian_api_token>

echo ${ATLASSIAN_API_TOKEN} | acli jira auth login --site "<your_org>.atlassian.net" --email "<your_email>" --token

echo ${ATLASSIAN_API_TOKEN} | acli confluence auth login --site "<your_org>.atlassian.net" --email "<your_email>" --token
```

## CLI Structure

```bash
acli                         # Root command
├── jira                     # Jira operations
│   ├── issue                # Issues
│   │   ├── create
│   │   ├── view
│   │   ├── update
│   │   ├── delete
│   │   ├── transition
│   │   └── comment
│   ├── project              # Projects
│   │   └── list
│   └── board                # Boards
│       └── list
├── confluence               # Confluence operations
│   ├── page                 # Pages
│   │   ├── create
│   │   ├── view
│   │   ├── update
│   │   └── delete
│   └── space                # Spaces
│       └── list
├── bitbucket                # Bitbucket operations
├── trello                   # Trello operations
└── opsgenie                 # Opsgenie operations
```
