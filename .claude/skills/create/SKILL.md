---
name: create
description: Unified entry point for scaffolding new workspace tooling. Routes to the right creator based on what you need to build. Use when you want to add a new agent, skill, or rule to this workspace.
argument-hint: "agent <name> | skill <name> | rule <name>"
allowed-tools: Read, Write, Edit, Glob
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: medium
  tags: [workspace, scaffold, meta]
---

# Create — Workspace Scaffolding Router

Parses your request and routes to the right creator skill.

---

## Step 1 — Parse the Request

Determine what type of thing is being created:

| If the user wants... | Route to |
|---|---|
| A new persona that does a specific job | `create-agent` |
| A new slash command / reusable workflow | `create-skill` |
| A new always-on coding or behavior standard | `create-rule` |

**Decision tree:**
- Should it be invoked only when triggered? → Skill or Agent
- Does it need persistent context/memory across a session? → Agent
- Is it a reusable procedure that takes an argument? → Skill
- Should it always apply silently? → Rule

---

## Step 2 — Route

Once type is determined:
- For agents: follow `/create-agent`
- For skills: follow `/create-skill`
- For rules: follow `/create-rule`

---

## Step 3 — Confirm

After creation, confirm:
- File created in the right location (`.claude/agents/`, `.claude/skills/`, or `.claude/rules/`)
- No naming conflicts with existing tooling
- User knows the trigger (agent name, `/skill-name`, or auto-applied rule)
