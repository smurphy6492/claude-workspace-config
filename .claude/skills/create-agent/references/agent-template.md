# Agent Template

Copy and fill in this skeleton when creating a new agent.

---

```markdown
---
name: <name>                          # lowercase, hyphenated
description: <when to invoke>         # used for agent selection routing
tools: Read, Write, Edit, Bash        # comma-separated, only what's needed
model: claude-sonnet-4-5              # sonnet for most, opus for complex reasoning
memory: project                       # project = sees CLAUDE.md; user = sees user preferences
# skills: []                          # optional: pre-loaded skills
# maxTurns: 20                        # optional: limit autonomous turns
# permissionMode: default             # optional: acceptEdits | bypassPermissions
---

# <Display Name>

## Role
<What this agent is. What job it does. Who it is in a team of agents.>
<2-3 sentences. Be specific about the domain.>

## Domain Context
<What the agent needs to know about the project, stack, or business context.>
<Reference specific technologies, conventions, or constraints.>

## Approach
<How the agent approaches its work. Include a numbered process if the work is procedural.>

1. Step one
2. Step two
3. Step three

## Output Style
<Format, length, tone. Examples:>
- Always produce a summary table before detailed output
- Use severity levels: 🔴 Critical, 🟡 Suggestion, 🔵 Nit
- Write in plain English, not bullet salads
- Deliver complete, working code — no placeholders
```
