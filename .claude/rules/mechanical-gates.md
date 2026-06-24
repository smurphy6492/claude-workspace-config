---
paths:
  - "**/*"
---

# Mechanical Quality Gates

Every project repo in this workspace gets enforced lint, type-check, and test on every change.
Quality checks live in hooks and CI, not as optional skills.

---

## Enforced vs. Invoked

An **invoked check** is a skill you remember to run.
An **enforced gate** is a hook or CI job that blocks the commit or merge if the check fails.

Invoked checks drift.
You forget to run them, or you run them on the wrong files, or you skip them when you're in a hurry.
The codebase quietly accumulates lint warnings, type errors, and broken tests.

Enforced gates cannot drift.
The commit does not land unless the check passes.
A non-deterministic model wrapped in deterministic gates cannot silently break spec because the gate fails the moment it does.

This workspace moves checks from the first category to the second.

---

## What Gets Enforced

For Python repos:

- **Lint** (ruff check + format)
- **Type-check** (mypy)
- **Tests** (pytest)

These run via `make check` or equivalent.
The Makefile defines the commands; CI and hooks invoke the Makefile.

---

## Where Enforcement Lives

| Layer | Tool | When it runs |
|---|---|---|
| Local | pre-commit hooks | Before each commit |
| Remote | GitHub Actions | On push and pull request |

Both layers invoke the same underlying check command.
If one passes, both pass.
If one fails, the change does not land.

---

## Implementation

This rule states the standard.
Artifacts (CI workflows, Makefiles, pre-commit configs) live in project repos, not in this workspace config.

Use the `/add-gates` skill to deploy enforcement into a new repo.
