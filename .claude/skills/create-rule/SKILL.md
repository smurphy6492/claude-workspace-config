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

## Step 1 — Gather Requirements

Ask or infer:
- **Name** — kebab-case, 2-4 words (e.g., `api-conventions`, `test-standards`)
- **Purpose** — what behavior or standard does this rule enforce?
- **Scope** — all files, or specific file types?
  - All files: no frontmatter needed
  - Specific files: use `paths:` frontmatter with glob patterns

---

## Step 2 — Check Existing Rules

Read all files in `.claude/rules/` and check:
- No rule with the same name or purpose
- No significant overlap with existing rules
- If overlap: ask whether to extend existing rule or create new

---

## Step 3 — Load Templates

Read:
- `.claude/skills/create-rule/references/rule-template.md`
- `.claude/skills/create-rule/references/rule-frontmatter-ref.md`

---

## Step 4 — Generate Rule File

**Unconditional rule** (applies to everything):
```markdown
# Rule Name

[Rule content — specific, actionable standards]
```

**Path-scoped rule** (applies to specific file types):
```markdown
---
paths:
  - "**/*.ext"
---

# Rule Name

[Rule content]
```

### Writing Good Rules
- Be specific and actionable — not "write clean code"
- Use examples showing correct and incorrect approaches
- Keep each rule focused on one concern
- Use headings to organize multiple sub-rules
- Avoid overlap with existing rules

---

## Step 5 — Confirm

```
## Rule Created: <name>

File: .claude/rules/<name>.md
Scope: <all files | **/*.ext>
Purpose: <what it enforces>
```
