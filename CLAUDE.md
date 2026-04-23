# Sean Murphy — Personal Claude Code Workspace

**Mission:** Build and showcase expertise in Analytics + AI Systems — demonstrating autonomous task execution, multi-agent orchestration, real-world data pipelines, and decision-making loops.

---

## Workspace Layout

```
ClaudeWorkspace/
├── CLAUDE.md                  ← you are here
├── FUTURE-IDEAS.md            ← backlog of bigger ideas & future iterations
├── .claude/
│   ├── agents/                ← specialized agent personas
│   ├── skills/                ← slash-command skills (/skill-name)
│   └── rules/                 ← always-on coding & workflow standards
└── projects/                  ← individual project directories
    └── personal-website/      ← primary active project
```

---

## Active Project: Personal Website

**Goal:** A live portfolio site that doesn't just *describe* AI skills — it *demonstrates* them.
**Stack:** Netlify (hosting) · GitHub (version control + Actions) · Claude Code (agentic dev)
**Theme:** "Sean Murphy — Analytics + AI Systems Builder"

### Key Principles
- The site itself is built by AI tools, visibly (commit history, case studies, build logs)
- Every project section shows *how* it was built, not just *what* it does
- Data pipelines should serve live data where possible, not static screenshots

---

## MCP Servers (User-Scoped)

| Server | Package | Use For |
|---|---|---|
| `github` | `@modelcontextprotocol/server-github` | Read/search repos, manage issues and PRs, push files — prefer over `gh` CLI for file-level and API operations |
| `playwright` | `@playwright/mcp` | Browser automation, screenshots, scraping, testing web pages |

> Use `/mcp` in any session to check server status and available tools.

---

## Available Agents

| Agent | Role |
|---|---|
| `planner` | Architecture + implementation planning before any build |
| `python-reviewer` | Python code review — quality, types, security, testing |
| `code-reviewer` | General code review — any language or file type |
| `web-developer` | HTML/CSS/JS/React — frontend and site work |
| `content-writer` | Project case studies, READMEs, About copy, portfolio text |
| `data-pipeline` | Data pipeline design, ETL patterns, API integrations |

---

## Available Skills (Slash Commands)

| Skill | Trigger |
|---|---|
| `/weekly-review` | Strategic weekly brief — what shipped, what's blocked, recommended focus, strategic questions |
| `/systematic-debugging` | Reproduce → Isolate → Root-Cause → Fix |
| `/bootstrap-python-project` | Scaffold new Python project with full tooling |
| `/verification-loop` | Multi-phase verify: lint → type-check → test → security |
| `/qa-validate` | End-to-end QA — builds, pipeline runs, output correctness, UI spot-check |
| `/python-patterns` | Python best practice reference |
| `/python-testing` | pytest guide and testing patterns |
| `/github-workflow` | PR creation, Actions setup, repo management |
| `/portfolio-updater` | Add a new project to the personal website |
| `/create` | Scaffold new agents, skills, or rules |
| `/create-agent` | Create a new agent persona |
| `/create-skill` | Create a new skill |
| `/create-rule` | Create a new rule file |

---

## Rules (Always Active)

| Rule | Scope |
|---|---|
| `workflow-orchestration.md` | All files — agent behavior, plan mode, verification |
| `git-workflow.md` | All files — GitHub conventions, commit style, PR workflow |
| `sql-style.md` | `**/*.sql` — SQL formatting and naming |
| `python-style.md` | `**/*.py` — Python conventions |

---

## Skill Routing Quick Reference

| I want to... | Use |
|---|---|
| Review the week / step back strategically | `/weekly-review` |
| Plan before building anything | `planner` agent |
| Debug a broken thing | `/systematic-debugging` |
| Start a new Python project | `/bootstrap-python-project` |
| Review code before committing | `code-reviewer` or `python-reviewer` agent |
| Verify everything passes | `/verification-loop` |
| QA a feature end-to-end | `/qa-validate` |
| Push a PR to GitHub | `/github-workflow` |
| Add a project to the website | `/portfolio-updater` |
| Write a case study or README | `content-writer` agent |
| Build or update website UI | `web-developer` agent |
| Build a data pipeline | `data-pipeline` agent |
| Create new workspace tooling | `/create` |

---

## Setup Notes

- `.claude/agents/`, `.claude/skills/`, `.claude/rules/` are the single source of truth
- No three-layer sync — edit files directly in `.claude/`
- Version control: GitHub (`master` branch on personal-website, feature branches for experiments)
- See `FUTURE-IDEAS.md` for the backlog of bigger things to build
