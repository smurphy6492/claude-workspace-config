# Agent Frontmatter Reference

Complete reference for YAML frontmatter fields in `.claude/agents/*.md` files.

---

## Required Fields

| Field | Type | Description |
|---|---|---|
| `name` | string | Agent identifier. Lowercase, hyphenated. Used for routing and display. |
| `description` | string | When/why to invoke this agent. Used by Claude to select the right agent. |
| `tools` | string | Comma-separated list of allowed tools. |
| `model` | string | Model ID (see below). |

---

## Optional Fields

| Field | Type | Default | Description |
|---|---|---|---|
| `memory` | string | none | `project` = reads CLAUDE.md; `user` = reads user preferences |
| `skills` | list | none | Skills pre-loaded for this agent |
| `maxTurns` | int | unlimited | Max autonomous turns before stopping |
| `permissionMode` | string | default | `acceptEdits` auto-accepts file edits; `bypassPermissions` skips all prompts |
| `disallowedTools` | list | none | Tools this agent cannot use |
| `hooks` | object | none | Pre/post hooks for tool calls |

---

## Model IDs

| Model | ID | When to Use |
|---|---|---|
| Claude Opus 4.5 | `claude-opus-4-5` | Complex reasoning, architecture, writing |
| Claude Sonnet 4.5 | `claude-sonnet-4-5` | Most tasks — fast and capable |
| Claude Haiku 4.5 | `claude-haiku-4-5` | Simple, high-volume, latency-sensitive tasks |

---

## Tool Names

Built-in tools (short names):
`Read`, `Write`, `Edit`, `Bash`, `Glob`, `Grep`, `WebSearch`, `WebFetch`

MCP tools (use full name):
`mcp__<server>__<tool>` — e.g., `mcp__github__create_pull_request`

---

## Memory Scopes

| Scope | What the Agent Sees |
|---|---|
| `project` | CLAUDE.md, project context |
| `user` | User preferences, personal settings |
| (none) | No persistent memory |

---

## Example: Minimal

```yaml
---
name: api-designer
description: Designs REST API contracts and OpenAPI specs. Use when planning a new API or reviewing an existing one.
tools: Read, Write, WebSearch
model: claude-sonnet-4-5
---
```

## Example: Full

```yaml
---
name: data-pipeline
description: Designs and builds ETL pipelines and API integrations. Use for data fetching, transformation, and serving.
tools: Read, Write, Edit, Bash, Glob, Grep, WebSearch, WebFetch
model: claude-sonnet-4-5
memory: project
skills:
  - python-patterns
  - systematic-debugging
maxTurns: 30
permissionMode: acceptEdits
---
```
