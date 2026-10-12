# Claude Code Workspace

**Mission:** A portable Claude Code config — agents, skills, and rules — that I load at user level and carry into every repo I work in, plus the projects I build with it.

---

## Workspace Layout

```
workspace/
├── CLAUDE.md                  ← you are here (control plane)
├── FUTURE-IDEAS.md            ← backlog of ideas and iterations
├── .claude/
│   ├── agents/                ← specialized agent personas
│   ├── skills/                ← slash-command skills (/skill-name)
│   └── rules/                 ← always-on coding & workflow standards
└── projects/                  ← per-project plans and notes (gitignored)
```

The agents, skills, and rules are symlinked into `~/.claude/` so they load in every session.
Machine- and employer-specific context lives in the user-level `~/.claude/CLAUDE.md`, which is not
part of this repo.

---

## Tools

| Tool | Use For |
|---|---|
| `gh` CLI | PRs, issues, Actions runs, releases, `gh api` |
| `uv` | Python versions, project environments, and CLI tools (`ruff`, `mypy`, `pre-commit`, `sqlfluff`) |
| Built-in browser | Screenshots, testing web pages, reading docs |

> Repos may add their own MCP servers in `.mcp.json`; use `/mcp` to check what's connected.

---

## Available Agents

| Agent | Role |
|---|---|
| `planner` | Architecture + implementation planning before any build |
| `plan-judge` | Independent reviewer — scores a draft plan against the rubric, flags methodology gaps |
| `python-reviewer` | Python code review — quality, types, security, testing |
| `code-reviewer` | General code review — any language or file type |
| `data-pipeline` | Data pipeline design, ETL patterns, API integrations |

Personal set (in the repo, not loaded at user level):

| Agent | Role |
|---|---|
| `web-developer` | HTML/CSS/JS/React for the portfolio site |
| `staff-ds-reviewer` | Hiring-manager review of a finished portfolio project |

---

## Available Skills (Slash Commands)

| Skill | Trigger |
|---|---|
| `/systematic-debugging` | Reproduce, Isolate, Root-Cause, Fix |
| `/grill` | Adversarial questioning before a plan, so nothing is silently assumed |
| `/improve-plan` | Independent judge scores a draft plan, then revises it before execution |
| `/diagnose-metric` | Why did a metric move — confirm, size, decompose, rank causes |
| `/optimize-dashboard` | Measure-first performance pass on a slow data-heavy dashboard |
| `/bootstrap-python-project` | Scaffold new Python project with full tooling |
| `/add-gates` | Install CI + pre-commit enforcement into a repo I own |
| `/create-agent` | Create a new agent persona |
| `/create-skill` | Create a new skill |
| `/create-rule` | Create a new rule file |

Personal set (in the repo, not loaded at user level):

| Skill | Trigger |
|---|---|
| `/project-review` | Hiring-manager review of a finished portfolio project |
| `/interview-explainer` | First-principles HTML walkthrough of a project for interview prep |
| `/portfolio-updater` | Add a new project to the portfolio site |

---

## Rules (Always Active)

| Rule | Scope |
|---|---|
| `workflow-orchestration.md` | All files — agent behavior, plan mode, verification, repo precedence |
| `git-workflow.md` | All files — GitHub conventions, commit style, PR workflow |
| `mechanical-gates.md` | All files — enforced lint, type-check, and test; the repo's own tooling wins |
| `testing-standards.md` | Which tests are worth writing |
| `python-style.md` | `**/*.py` — Python conventions |
| `sql-style.md` | `**/*.sql` — SQL formatting and naming |
| `writing-style.md` | `**/*.md`, `**/*.txt`, `**/projects.ts` — prose voice, AI trope avoidance, content patterns |

---

## Skill Routing Quick Reference

| I want to... | Use |
|---|---|
| Plan before building anything | `planner` agent |
| Surface hidden assumptions before planning | `/grill` |
| Pressure-test a plan before building | `/improve-plan` |
| Debug a broken thing | `/systematic-debugging` |
| Explain why a metric moved | `/diagnose-metric` |
| Speed up a slow dashboard | `/optimize-dashboard` |
| Start a new Python project | `/bootstrap-python-project` |
| Review code before committing | `code-reviewer` or `python-reviewer` agent |
| Add CI + pre-commit to a repo I own | `/add-gates` |
| Build a data pipeline | `data-pipeline` agent |
| Create new workspace tooling | `/create-agent`, `/create-skill`, `/create-rule` |

In a repo with its own skills (a `/pr`, `/review`, or `/implement`), use those first.

---

## Setup Notes

- `.claude/agents/`, `.claude/skills/`, `.claude/rules/` are the single source of truth
- Edit files directly in `.claude/` — the `~/.claude/` symlinks pick up changes immediately
- See `FUTURE-IDEAS.md` for the backlog of bigger things to build
