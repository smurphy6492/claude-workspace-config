---
name: create-rule
description: Create a new rule file for this workspace. Rules are always-on standards applied automatically to matching files. Use when you want to enforce a new convention, style guide, or behavior standard.
argument-hint: "describe the rule's purpose and what files it applies to"
allowed-tools: Read, Write, Glob
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: medium
  tags: [workspace, scaffold, rules, meta]
---

# Create Rule

Creates a new rule file in `.claude/rules/`.

---

Three phases. The order matters only where noted: the conflict check and template load are mandatory gates and must happen before writing the file.

## Understand the rule

Gather or infer:
- **Name** — kebab-case, 2-4 words (e.g., `api-conventions`, `test-standards`)
- **Purpose** — what behavior or standard this rule enforces
- **Scope** — all files (no frontmatter) or specific file types (`paths:` frontmatter with glob patterns)

## Verify and load context (required before writing)

- **Check for conflicts.** Read all files in `.claude/rules/` and confirm no existing rule has the same name or purpose and none significantly overlaps. If there is overlap, ask whether to extend the existing rule instead of creating a new one. This check is mandatory; skipping it produces duplicate or contradictory rules.
- **Load the templates.** Read `.claude/skills/create-rule/references/rule-template.md` and `.claude/skills/create-rule/references/rule-frontmatter-ref.md`.

## Write and confirm

Generate the rule file at `.claude/rules/<name>.md`. Unconditional rules (apply to everything) need no frontmatter; path-scoped rules use `paths:` glob frontmatter:

```markdown
---
paths:
  - "**/*.ext"
---

# Rule Name

[Rule content]
```

Good rules are specific and actionable (not "write clean code"), show correct and incorrect examples, keep one concern each, and don't overlap existing rules. Then confirm:

```
## Rule Created: <name>

File: .claude/rules/<name>.md
Scope: <all files | **/*.ext>
Purpose: <what it enforces>
```
