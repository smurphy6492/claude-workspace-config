---
name: add-gates
description: Deploy mechanical quality gates (CI workflow + pre-commit) into a target repo. Reads existing Makefile and tooling, then generates enforcement artifacts. Use when setting up a new project or adding enforcement to an existing repo.
argument-hint: "<repo-path> [--ci-only | --pre-commit-only]"
allowed-tools: Bash, Read, Write, Edit, Glob
metadata:
  version: "1.0"
  tier: deployment
  freedom: low-medium
  tags: [ci, quality, enforcement, pre-commit, github-actions]
---

# Add Gates

Deploy the enforcement layer from `.claude/rules/mechanical-gates.md` into a target repo.
This skill writes files that make checks run automatically.
It does not run the checks itself (use `/verification-loop` for that).

---

## Inputs

| Input | Required | Description |
|---|---|---|
| `repo-path` | Yes | Absolute path to the target repo |
| `--ci-only` | No | Only generate GitHub Actions workflow, skip pre-commit |
| `--pre-commit-only` | No | Only wire pre-commit hooks, skip CI |

---

## Outputs

| Artifact | Location | Condition |
|---|---|---|
| GitHub Actions workflow | `.github/workflows/ci.yml` | Always (unless `--pre-commit-only`) |
| pre-commit wired | Local git hooks | If `.pre-commit-config.yaml` exists |

---

## Prerequisites

The target repo must already define its check commands.
This skill invokes existing tooling; it does not create check logic.

Required:
- A `Makefile` with a `check` target (or equivalent command documented in `pyproject.toml`)
- Python project with `pyproject.toml` that supports `pip install -e ".[dev]"`

If no Makefile exists, stop and create one first.
The `make check` target should run lint + type-check + tests.

---

## Procedure

### Step 1: Read Target Repo Tooling

Read these files to understand the existing setup:

```
<repo-path>/Makefile
<repo-path>/pyproject.toml
<repo-path>/.pre-commit-config.yaml (if exists)
<repo-path>/.github/workflows/ (check for existing CI)
```

Identify:
- The check command (usually `make check`)
- Python version (from pyproject.toml `requires-python` or default to 3.11)
- Whether pre-commit is already configured

### Step 2: Generate GitHub Actions Workflow

Create `.github/workflows/ci.yml` with this template:

```yaml
name: CI

on:
  push:
    branches: [main, master]
  pull_request:
    branches: [main, master]

jobs:
  check:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"
          cache: pip

      - name: Install dependencies
        run: pip install -e ".[dev]"

      - name: Run checks
        run: make check
```

Adjustments:
- If the repo uses a different check command, replace `make check` with that command
- If `requires-python` specifies a different version, use that version
- If the repo has additional setup steps (e.g., downloading models), add them before `Run checks`

### Step 3: Wire Pre-Commit (if applicable)

If `.pre-commit-config.yaml` exists:

1. Check if hooks are already installed:
   ```bash
   ls -la .git/hooks/pre-commit
   ```

2. If not installed, run:
   ```bash
   pre-commit install
   ```

3. Verify the hook runs:
   ```bash
   pre-commit run --all-files
   ```

If `.pre-commit-config.yaml` does not exist, skip this step.
Do not create a pre-commit config from scratch (that is a separate task).

### Step 4: Verify

After writing artifacts:

1. Confirm `.github/workflows/ci.yml` exists and is valid YAML
2. If pre-commit was wired, confirm `.git/hooks/pre-commit` exists
3. Report what was created

---

## Output: Deployment Summary

```
## Gates Deployed: <repo-name>

| Artifact | Status | Notes |
|---|---|---|
| CI workflow | Created | .github/workflows/ci.yml |
| Pre-commit | Wired | Hooks installed |

Check command: make check
Python version: 3.11

Next: Push to GitHub and verify Actions run on PR.
```

---

## Related

- `.claude/rules/mechanical-gates.md` - The standard this skill implements
- `/verification-loop` - Run checks manually (this skill makes them run automatically)
