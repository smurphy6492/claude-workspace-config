---
name: github-workflow
description: GitHub operations — create PRs, set up GitHub Actions CI/CD, manage repos, and work with secrets. Use when pushing branches, opening PRs, setting up automation, or managing repo settings.
argument-hint: "pr | actions | setup | secrets"
allowed-tools: Bash, Read, Write, Edit, Glob, mcp__github__create_pull_request, mcp__github__create_branch, mcp__github__push_files, mcp__github__get_pull_request, mcp__github__list_pull_requests, mcp__github__merge_pull_request, mcp__github__get_pull_request_status, mcp__github__list_commits, mcp__github__create_or_update_file, mcp__github__get_file_contents, mcp__github__search_repositories, mcp__github__list_issues, mcp__github__create_issue
metadata:
  version: "1.1"
  tier: guided-workflow
  freedom: medium
  tags: [github, ci-cd, automation, git]
---

# GitHub Workflow

**Prefer GitHub MCP tools over `gh` CLI or `git` commands wherever possible.** MCP tools don't require permission prompts and are more reliable in this environment.

---

## MCP vs CLI: When to Use Each

| Operation | Prefer |
|---|---|
| Create a PR | `mcp__github__create_pull_request` |
| Push files to a branch | `mcp__github__push_files` |
| Create a branch | `mcp__github__create_branch` |
| Merge a PR | `mcp__github__merge_pull_request` |
| View PR status/checks | `mcp__github__get_pull_request_status` |
| Stage + commit locally | `git add` + `git commit` (Bash) |
| Checkout / switch branches | `git checkout` (Bash) |
| GitHub Actions setup | Write YAML files directly |

---

## Creating a Pull Request (MCP preferred)

```
# 1. Stage and commit locally (git still needed for local commits)
git add <files>
git commit -m "feat(scope): description"

# 2. Push the branch — use mcp__github__push_files OR git push
git push -u origin feature/my-feature

# 3. Create PR via MCP (no permission prompt)
mcp__github__create_pull_request:
  owner: <owner>
  repo: <repo>
  title: "feat(scope): description"
  head: feature/my-feature
  base: main
  body: |
    ## What
    [1-2 sentences]

    ## Why
    [reason for change]

    ## How
    [key decisions]

    ## Test Plan
    - [ ] [verify this]
    - [ ] [verify that]
```

## Creating a Pull Request (CLI fallback)

```bash
# If MCP is unavailable, use gh CLI
gh pr create --title "feat(scope): description" --body "$(cat <<'EOF'
## What
[1-2 sentences]

## Why
[reason for change]

## How
[key decisions]

## Test Plan
- [ ] [verify this]
- [ ] [verify that]
EOF
)"
```

---

## GitHub Actions: Common Workflows

### CI on Pull Request

Create `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  pull_request:
    branches: [main]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - run: pip install -e ".[dev]"
      - run: ruff check .
      - run: mypy src/
      - run: pytest --tb=short
```

### Deploy on Push to Main

Netlify auto-deploys from GitHub on push to `master` — no GitHub Actions deploy step needed.
If a manual deploy workflow is required, use the Netlify CLI:

```yaml
name: Deploy

on:
  push:
    branches: [master]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to Netlify
        run: npx netlify-cli deploy --prod --dir=dist
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```

### Scheduled Data Pipeline

```yaml
name: Refresh Data

on:
  schedule:
    - cron: '0 9 * * *'   # daily at 9am UTC
  workflow_dispatch:        # also allow manual trigger

jobs:
  refresh:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - run: pip install -r requirements.txt
      - run: python scripts/fetch_data.py
        env:
          API_KEY: ${{ secrets.API_KEY }}
      - name: Commit updated data
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add data/
          git diff --staged --quiet || git commit -m "chore: refresh data [skip ci]"
          git push
```

---

## Managing Secrets

```bash
# Set a secret
gh secret set API_KEY

# List secrets (names only)
gh secret list

# Use in workflow: ${{ secrets.API_KEY }}
```

Never commit secrets to the repo. Always use `gh secret set` or the GitHub UI.

---

## Useful `gh` Commands

```bash
gh repo view                      # view repo info
gh repo create <name> --public    # create new repo
gh pr list                        # list open PRs
gh pr view <number>               # view PR details
gh pr merge <number> --squash     # merge PR
gh run list                       # list Actions runs
gh run view <id>                  # view run details
gh run watch                      # watch current run live
gh release create v1.0.0          # create a release
```

---

## Branch Hygiene

```bash
# Delete local branch after merge
git branch -d feature/my-feature

# Delete remote branch after merge
git push origin --delete feature/my-feature

# Or let GitHub auto-delete on merge (recommended — enable in repo settings)

# Sync local main with remote
git checkout main && git pull
```

---

## Repo Setup Checklist

For a new project repo:
- [ ] `main` branch protection enabled (require PR + passing CI)
- [ ] Auto-delete branches on merge enabled
- [ ] GitHub Actions CI workflow in place
- [ ] Required secrets set (`gh secret set`)
- [ ] `.gitignore` covers `.env`, `__pycache__`, build artifacts
- [ ] README has setup and run instructions
