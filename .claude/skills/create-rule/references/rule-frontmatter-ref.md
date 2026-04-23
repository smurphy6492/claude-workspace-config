# Rule Frontmatter Reference

Rules are the simplest workspace artifact — most have no frontmatter at all.

---

## Frontmatter

Only one optional field:

```yaml
---
paths:
  - "glob/pattern/**/*.ext"
---
```

| Field | Type | Description |
|---|---|---|
| `paths` | list of globs | File patterns this rule applies to. If omitted, rule applies to all files. |

---

## Path Scoping Examples

```yaml
# SQL files only
paths:
  - "**/*.sql"

# Python source files only
paths:
  - "src/**/*.py"
  - "scripts/**/*.py"

# TypeScript and TSX files
paths:
  - "**/*.{ts,tsx}"

# dbt model files
paths:
  - "models/**/*.sql"
```

---

## Unconditional vs Conditional

**Unconditional** (no frontmatter) — Claude applies this rule to every file it touches. Use for:
- General coding behavior
- Agent workflow standards
- Cross-language conventions

**Conditional** (with `paths:`) — Claude applies this rule only to matching files. Use for:
- Language-specific style guides
- File-type-specific conventions
- Directory-scoped standards

---

## Naming Conventions

- kebab-case, 2-4 words
- Descriptive of the domain: `git-workflow`, `sql-style`, `python-style`
- Not named after outcomes: `be-readable` ❌ → `code-style` ✅

---

## Existing Rules in This Workspace

| File | Scope | Purpose |
|---|---|---|
| `workflow-orchestration.md` | All files | Agent behavior, plan mode, verification |
| `git-workflow.md` | All files | GitHub conventions, commits, PRs |
| `sql-style.md` | `**/*.sql` | SQL formatting and naming |
| `python-style.md` | `**/*.py` | Python conventions |
