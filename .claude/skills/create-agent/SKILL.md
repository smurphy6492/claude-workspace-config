---
name: create-agent
description: Scaffold a new agent persona for this workspace. Gathers requirements, checks for conflicts, and generates a properly formatted agent file in .claude/agents/.
argument-hint: "describe the agent's role and specialization"
allowed-tools: Read, Write, Glob
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: medium
  tags: [workspace, scaffold, agents, meta]
---

# Create Agent

Scaffolds a new agent persona in `.claude/agents/`.

---

## Step 1 — Gather Requirements

Ask or infer:
- **Name** — short, lowercase, hyphenated (e.g., `api-designer`)
- **Role** — what does this agent specialize in?
- **Tools** — which Claude tools does it need? (Read, Write, Edit, Bash, Glob, Grep, WebSearch, WebFetch)
- **Model** — `claude-opus-4-5` for complex reasoning, `claude-sonnet-4-5` for fast execution
- **Memory** — `project` (knows CLAUDE.md) or `user` (knows user preferences)
- **Pre-loaded skills** — any skills that should always be available to this agent?

---

## Step 2 — Check for Conflicts

Read all files in `.claude/agents/` and check:
- No agent with the same name exists
- No agent with highly overlapping purpose exists
- If overlap found: ask whether to create a new agent or update the existing one

---

## Step 3 — Load Templates

Read:
- `.claude/skills/create-agent/references/agent-template.md`
- `.claude/skills/create-agent/references/agent-frontmatter-ref.md`

---

## Step 4 — Generate Agent File

Write `.claude/agents/<name>.md` with:

```markdown
---
name: <name>
description: <clear description of when to invoke this agent>
tools: <comma-separated tool list>
model: <model-id>
memory: project
---

# <Display Name>

## Role
<What this agent is and what job it does. 2-3 sentences.>

## Domain Context
<What it needs to know about the workspace, project, or tech stack.>

## Approach
<How it thinks and works. Step-by-step process if applicable.>

## Output Style
<Format, length, tone of responses.>
```

---

## Step 5 — Confirm

Report:
```
## Agent Created: <name>

File: .claude/agents/<name>.md
Model: <model>
Tools: <tools>

To invoke: use the agent name in a task or reference it explicitly
```
