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
| markdownlint config | `.markdownlint.jsonc` | Always (every repo has markdown) |
| sqlfluff config | `.sqlfluff` | If the repo has `.sql` files |
| Doc/SQL pre-commit hooks | `.pre-commit-config.yaml` | If a base pre-commit config exists |
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

      - name: Run pre-commit hooks (docs, SQL, hygiene)
        run: |
          pip install pre-commit
          pre-commit run --all-files
```

Adjustments:
- If the repo uses a different check command, replace `make check` with that command
- If `requires-python` specifies a different version, use that version
- If the repo has additional setup steps (e.g., downloading models), add them before `Run checks`

### Step 2.5: Deploy Doc and SQL Linters

These gates move the deterministic parts of `rules/writing-style.md` and `rules/sql-style.md` out of
prose and into linters. Deploy them conditionally on what the repo contains.

**Always (every repo has markdown):** write `.markdownlint.jsonc` and add the markdownlint +
straight-quotes hooks.

`.markdownlint.jsonc`:
```jsonc
{
  "default": true,
  "MD013": false,              // one sentence per line means long lines; don't cap length
  "MD024": { "siblings_only": true },  // duplicate headings ok across sections
  "MD033": false,              // inline HTML allowed in docs
  "MD041": false,              // first line need not be a top-level heading
  "MD060": false               // compact table pipes are the workspace style; don't enforce spacing
}
```

**Only if the repo has `.sql` files:** write `.sqlfluff` and add the sqlfluff hook. Set `dialect`
to the repo's engine (`duckdb`, `bigquery`, `snowflake`, `postgres`, or `ansi`).

`.sqlfluff`:
```ini
[sqlfluff]
dialect = ansi
max_line_length = 120

[sqlfluff:rules:capitalisation.keywords]
capitalisation_policy = upper

[sqlfluff:rules:capitalisation.identifiers]
capitalisation_policy = lower

[sqlfluff:rules:capitalisation.functions]
extended_capitalisation_policy = upper
```

**Append the hooks to `.pre-commit-config.yaml`** (if it exists; if not, run
`/bootstrap-python-project` first to create the base config, then re-run this skill):
```yaml
  - repo: https://github.com/DavidAnson/markdownlint-cli2
    rev: v0.13.0
    hooks:
      - id: markdownlint-cli2
  - repo: local
    hooks:
      - id: no-smart-quotes
        name: no smart quotes (use straight quotes in md/txt)
        language: pygrep
        # Must be alternation, NOT a character class. pygrep compiles the pattern
        # as bytes and scans file bytes, so [‘’“”] collapses to a class of single
        # bytes — including 0xe2, the lead byte of every em dash and box-drawing
        # char — and false-flags clean prose. Alternation matches each curly
        # quote's full 3-byte UTF-8 sequence.
        entry: "‘|’|“|”"
        files: '\.(md|txt)$'
  # SQL block — include only when the repo has .sql files
  - repo: https://github.com/sqlfluff/sqlfluff
    rev: 3.0.7
    hooks:
      - id: sqlfluff-lint
```

Don't restate lint rules in the workspace rule files — the config is the source of truth. The rule
files carry only what the linter can't check (voice, CTE naming vocabulary, the context-dependent
`SELECT *` call).

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
