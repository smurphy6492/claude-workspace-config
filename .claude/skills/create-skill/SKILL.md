---
name: create-skill
description: Scaffold a new skill (slash command) for this workspace. Gathers requirements, checks for conflicts, and generates a properly formatted SKILL.md in .claude/skills/.
argument-hint: "describe the skill's purpose and trigger"
allowed-tools: Read, Write, Glob
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: medium
  tags: [workspace, scaffold, skills, meta]
---

# Create Skill

Scaffolds a new skill in `.claude/skills/<name>/SKILL.md`.

---

## Step 1 — Gather Requirements

Ask or infer:
- **Name** — lowercase, hyphenated (becomes `/name` slash command)
- **Description** — when should this skill be triggered? (used for auto-routing)
- **Argument hint** — example input the user provides (shown as hint)
- **Tools needed** — which tools does the skill use?
- **Tier** — see tier definitions below
- **Freedom** — `low` (strict steps), `medium` (some judgment), `high` (autonomous)

### Tiers
| Tier | Meaning |
|---|---|
| `conventions` | Enforces a style or standard |
| `platform-knowledge` | Reference guide or best practices |
| `guided-workflow` | Step-by-step procedure |
| `business-logic` | Domain-specific logic |

---

## Step 2 — Check for Conflicts

Read all files in `.claude/skills/` and check:
- No skill with the same name exists
- No skill with highly overlapping purpose
- If overlap: ask whether to create new or update existing

---

## Step 3 — Generate Files

### SKILL.md

Write `.claude/skills/<name>/SKILL.md`:

```markdown
---
name: <name>
description: <when to trigger this skill>
argument-hint: "<example input>"
allowed-tools: <comma-separated>
metadata:
  version: "1.0"
  tier: <tier>
  freedom: <low|medium|high>
  tags: [<2-4 tags>]
---

# <Skill Display Name>

## Instructions
<Step-by-step workflow. Be specific and actionable.>

## Output Format
<What the skill produces.>
```

### FEEDBACK.md

Write `.claude/skills/<name>/FEEDBACK.md`:

```markdown
# Feedback: <name>

| Date | Input | Outcome | Notes |
|---|---|---|---|
```

---

## Step 4 — Confirm

```
## Skill Created: <name>

File: .claude/skills/<name>/SKILL.md
Slash command: /<name>
Tier: <tier> | Freedom: <freedom>

Trigger description: <description>
```
