---
name: gh-clone-pr
description: Use when user asks to clone a GitHub Pull Request locally using the GitHub CLI.
---

# GitHub Clone PR Skill

Use this skill when the user requests to clone a GitHub Pull Request (PR) locally using the GitHub CLI (`gh` command).

## Notes

- cwd: The current working directory of the local repository where the user is running the commands (not `.github` directory).

## Steps

1. **Extract PR Information**: Identify the repository owner, repository name, and PR number from the user's request.

- `<OWNER>` is the GitHub repository owner.
- `<REPO>` is the GitHub repository name.
- `<PR_NUMBER>` is the number of the Pull Request.

2. **Get PR description**: Use the GitHub CLI to fetch the PR details to ensure it exists and gather necessary information and save into `notes/prs/<PR_NUMBER>/details.json`. Run command:

```bash
gh pr view <PR_NUMBER> --repo <OWNER>/<REPO> --json title,body > <cwd>/notes/prs/<PR_NUMBER>/details.json
```

3. **Clone the PR**: Use the GitHub CLI to clone the PR locally into `<cwd>/notes/prs/<PR_NUMBER>`. Run command:

```bash
gh pr diff <PR_NUMBER> --repo <OWNER>/<REPO> > <cwd>/notes/prs/<PR_NUMBER>/diff.patch
```

4. **Separate patch file**: separate patch files for the PR diff into multiple files to keep changes organized. Run script:

```bash
node <cwd>/.github/skills/gh-clone-pr/scripts/separate-patch.js <PR_NUMBER>
```

5. **Provide confirmation**: Inform the user that the PR has been successfully cloned and provide the local path to the cloned PR. Provide output following the specified format.

## Output Format

Provide output in the following format:

```markdown
The GitHub Pull Request has been successfully cloned.

- PR description: `<cwd>/notes/prs/<PR_NUMBER>/details.json`
- PR diff patch dir: `<cwd>/notes/prs/<PR_NUMBER>/contents`
```

## Notes

- Stop and inform user if there are any errors during the process, especially when running the separate patch script.
