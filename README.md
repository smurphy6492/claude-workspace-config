# Claude Code Workspace Config

How I orchestrate Claude Code as a multi-agent development team.

This repo contains the full workspace configuration I use daily with [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — specialized agents, reusable skills (slash commands), coding standards (rules), and the CLAUDE.md file that ties it all together. Every project on [my portfolio site](https://smurphy.netlify.app) was built using this system.

---

## How It Works

```
User Request
    |
    v
CLAUDE.md (routing layer)
    |
    +---> /skill (slash command)     e.g. /systematic-debugging, /verification-loop
    |         |
    |         v
    |     Guided workflow with phases, gates, and structured output
    |
    +---> agent (specialized persona)  e.g. planner, web-developer, python-reviewer
    |         |
    |         v
    |     Autonomous execution with domain-specific instructions
    |
    +---> rule (always-on standard)    e.g. python-style, git-workflow
              |
              v
          Applied automatically to matching files — no invocation needed
```

**CLAUDE.md** is the control plane. It tells Claude Code which agents exist, which skills are available, which rules are active, and how to route work. Skills are invoked explicitly (`/verification-loop`). Agents are spawned for complex tasks. Rules fire automatically on matching file patterns.

---

## What's Inside

### Agents — Specialized Personas

Each agent has a defined role, tools, model, and detailed instructions. They don't share a generic prompt — each one is purpose-built.

| Agent | Role | Why It Exists |
|---|---|---|
| [`planner`](.claude/agents/planner.md) | Architecture and implementation planning | Forces structured thinking before any code is written. Prevents the "just start coding" trap. |
| [`web-developer`](.claude/agents/web-developer.md) | Frontend — HTML/CSS/JS/React | Knows the site's stack, conventions, and accessibility requirements. |
| [`content-writer`](.claude/agents/content-writer.md) | Portfolio copy, case studies, READMEs | Writes in a specific voice — direct, technical, not corporate. |
| [`data-pipeline`](.claude/agents/data-pipeline.md) | ETL, API integrations, data pipelines | Handles fetch/transform/store patterns with proper error handling and scheduling. |
| [`python-reviewer`](.claude/agents/python-reviewer.md) | Python code review | Checks types, patterns, security, testing. Outputs structured severity levels. |
| [`code-reviewer`](.claude/agents/code-reviewer.md) | General code review (any language) | Same rigor as the Python reviewer, adapted per file type. |

**Design decision:** Separate agents per domain instead of one general-purpose agent. Each agent carries only the context it needs, so instructions stay focused and don't compete.

### Skills — Reusable Slash Commands

Skills are guided workflows invoked with `/skill-name`. They define phases, gates, and output formats — turning repeatable processes into one-command operations.

| Skill | What It Does | Key Design Choice |
|---|---|---|
| [`/systematic-debugging`](.claude/skills/systematic-debugging/SKILL.md) | 4-phase debugging: Reproduce, Isolate, Root-Cause, Fix | Enforces discipline — no jumping to fixes before understanding the bug. |
| [`/verification-loop`](.claude/skills/verification-loop/SKILL.md) | Pre-commit checks: lint, type-check, test, security scan | Multiple modes (`full`, `quick`, `security`) so it fits any context. |
| [`/weekly-review`](.claude/skills/weekly-review/SKILL.md) | Strategic weekly brief across all projects | Produces *strategic* output, not a commit log replay. |
| [`/bootstrap-python-project`](.claude/skills/bootstrap-python-project/SKILL.md) | Scaffold a new Python project with full tooling | One command to get pyproject.toml, ruff, mypy, pytest, pre-commit, and directory structure. |
| [`/qa-validate`](.claude/skills/qa-validate/SKILL.md) | End-to-end functional QA | Distinct from verification-loop — this checks that features *actually work*, not just that code passes linting. |
| [`/github-workflow`](.claude/skills/github-workflow/SKILL.md) | PR creation, Actions setup, repo management | Standardizes the GitHub workflow so PRs have consistent format and checks. |
| [`/portfolio-updater`](.claude/skills/portfolio-updater/SKILL.md) | Add a new project to the portfolio site | Guided process: gather details, generate content, update site files, open PR. |
| [`/create`](.claude/skills/create/SKILL.md) | Scaffold new agents, skills, or rules | The workspace builds its own tooling. |

### Rules — Always-On Standards

Rules apply automatically to files matching their glob pattern. No invocation needed — they're the coding standards every agent and skill follows.

| Rule | Scope | What It Enforces |
|---|---|---|
| [`workflow-orchestration`](.claude/rules/workflow-orchestration.md) | All files | Plan before building, verify before committing, capture lessons learned. |
| [`git-workflow`](.claude/rules/git-workflow.md) | All files | Conventional commits, branch naming, PR templates, pre-push checklist. |
| [`python-style`](.claude/rules/python-style.md) | `**/*.py` | Type hints, ruff formatting, pathlib, dataclasses over bare dicts. |
| [`sql-style`](.claude/rules/sql-style.md) | `**/*.sql` | CTEs over subqueries, explicit JOINs, named CTE conventions. |

### CLAUDE.md — The Control Plane

[`CLAUDE.md`](CLAUDE.md) is what Claude Code reads at the start of every session. It contains:

- **Workspace layout** — where things live
- **Agent roster** — who does what
- **Skill catalog** — available slash commands
- **Rule index** — active coding standards
- **Routing table** — "I want to X" maps to the right tool
- **MCP server config** — external tool integrations (GitHub, Playwright)

Think of it as the operating manual for a software team — except the team is a set of AI agents.

---

## The Philosophy

**Agents should operate like a well-run team, not a single chatbot.**

A few principles that shaped this setup:

1. **Plan before building.** The `planner` agent exists because the most expensive bugs are design bugs. Thinking is cheaper than refactoring.

2. **Separate concerns.** The `web-developer` doesn't review Python. The `python-reviewer` doesn't write copy. Specialization keeps instructions focused.

3. **Verify before shipping.** `/verification-loop` runs before every significant commit. Quality is a workflow, not a manual checklist.

4. **The workspace improves itself.** When a task reveals a missing capability, `/create` scaffolds a new agent, skill, or rule. The system grows from use.

5. **Elegance over cleverness.** Simple solutions with fewer moving parts. If code needs a comment to explain why it works, simplify the code.

---

## Using This

You can use this repo as:

1. **A reference** — read the agents, skills, and rules for ideas on structuring your own Claude Code workspace
2. **A starting point** — fork it and adapt the agents/skills/rules to your own workflow
3. **A direct config** — clone it and point Claude Code at it as your workspace

### Setup

```bash
git clone https://github.com/smurphy6492/claude-workspace-config.git
cd claude-workspace-config
```

Then either use this directory as your Claude Code workspace, or copy the `.claude/` directory and `CLAUDE.md` into your own project.

### What's NOT included

- `.claude/settings.local.json` — machine-specific permissions, env vars, and hooks (create per-machine)
- `.claude/projects/` memory files — conversation-specific, stay local
- Project source code — this is the *config*, not the projects themselves

---

## See It In Action

The portfolio at [smurphy.netlify.app](https://smurphy.netlify.app) was built entirely using this workspace config. The commit history on every project repo shows the agentic workflow in practice — planning, building, reviewing, and documenting through specialized agents.

---

## License

[MIT](LICENSE) — use it, fork it, adapt it.
