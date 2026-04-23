# Rule Template

Two variants depending on scope.

---

## Variant 1: Unconditional Rule (applies to all files)

```markdown
# Rule Name

Brief description of what this rule enforces and why.

---

## Section One

[Specific, actionable standard]

Good:
\`\`\`
[correct example]
\`\`\`

Bad:
\`\`\`
[incorrect example]
\`\`\`

---

## Section Two

[Another standard]
```

---

## Variant 2: Path-Scoped Rule (applies to specific file types)

```markdown
---
paths:
  - "**/*.sql"        # all SQL files
  - "src/**/*.py"     # Python files in src/
  - "**/*.{ts,tsx}"   # TypeScript files
---

# Rule Name

[Rule content — same structure as unconditional]
```

---

## Writing Guidelines

- **Specific** — "Use CTEs over subqueries" not "write readable SQL"
- **Actionable** — tell Claude exactly what to do, not what to aim for
- **Exemplified** — include code examples for non-obvious rules
- **Focused** — one concern per rule file; don't bundle everything
- **Non-overlapping** — check existing rules before writing
- **Headed** — use `##` headings to organize multiple sub-rules
