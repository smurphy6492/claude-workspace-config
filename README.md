# Claude Code Workspace Config

How I orchestrate Claude Code as a multi-agent development team.

This repo contains the full workspace configuration I use daily with [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — specialized agents, reusable skills (slash commands), coding standards (rules), and the CLAUDE.md file that ties it all together. Every project on [my portfolio site](https://seanmurphy.app) was built using this system.

---

## How It Works

```
User Request
    |
    v
CLAUDE.md (routing layer)
    |
    +---> /skill (slash command)     e.g. /systematic-debugging, /improve-plan
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

**CLAUDE.md** is the control plane. It tells Claude Code which agents exist, which skills are available, which rules are active, and how to route work. Skills are invoked explicitly (`/improve-plan`). Agents are spawned for complex tasks. Rules fire automatically on matching file patterns.

---

## What's Inside

### Agents — Specialized Personas

Each agent has a defined role, tools, model, and detailed instructions. They don't share a generic prompt — each one is purpose-built.

| Agent | Role | Why It Exists |
|---|---|---|
| [`planner`](.claude/agents/planner.md) | Architecture and implementation planning | Forces structured thinking before any code is written. Prevents the "just start coding" trap. |
| [`web-developer`](.claude/agents/web-developer.md) | Frontend — HTML/CSS/JS/React | Knows the site's stack, conventions, and accessibility requirements. |
| [`data-pipeline`](.claude/agents/data-pipeline.md) | ETL, API integrations, data pipelines | Handles fetch/transform/store patterns with proper error handling and scheduling. |
| [`python-reviewer`](.claude/agents/python-reviewer.md) | Python code review | Checks types, patterns, security, testing. Outputs structured severity levels. |
| [`code-reviewer`](.claude/agents/code-reviewer.md) | General code review (any language) | Same rigor as the Python reviewer, adapted per file type. |
| [`plan-judge`](.claude/agents/plan-judge.md) | Independent plan review | Scores a draft plan against a fixed rubric and finds the methodology gaps the author can't see, because it never wrote the plan. |
| [`staff-ds-reviewer`](.claude/agents/staff-ds-reviewer.md) | Hiring-manager review of a finished project | Reviews the whole deliverable — code, methodology, narrative — as a staff-level hiring manager, and names the interview question each finding exposes. |

**Design decision:** Separate agents per domain instead of one general-purpose agent. Each agent carries only the context it needs, so instructions stay focused and don't compete.

### Skills — Reusable Slash Commands

Skills are guided workflows invoked with `/skill-name`. They define phases, gates, and output formats — turning repeatable processes into one-command operations.

| Skill | What It Does | Key Design Choice |
|---|---|---|
| [`/grill`](.claude/skills/grill/SKILL.md) | Adversarial questioning before a task becomes a plan | Rounds of numbered questions until nothing is silently assumed, so the plan starts from stated facts. |
| [`/diagnose-metric`](.claude/skills/diagnose-metric/SKILL.md) | Explain why a business metric moved | Confirms the change is real and sizes it against normal variation before decomposing it into drivers. |
| [`/optimize-dashboard`](.claude/skills/optimize-dashboard/SKILL.md) | Performance pass on a slow data-heavy dashboard | Measures first, so the fix targets the actual bottleneck. |
| [`/create-agent`, `/create-skill`, `/create-rule`](.claude/skills/create-skill/SKILL.md) | Scaffold new agents, skills, or rules | The workspace builds its own tooling. |
| [`/systematic-debugging`](.claude/skills/systematic-debugging/SKILL.md) | 4-phase debugging: Reproduce, Isolate, Root-Cause, Fix | Enforces discipline — no jumping to fixes before understanding the bug. |
| [`/improve-plan`](.claude/skills/improve-plan/SKILL.md) | Score a draft plan with an independent judge, then revise it from the critique | The judge is a separate agent with a fixed rubric, so it catches the methodology footguns — leaked backtests, wrong metrics — that pass a structural read. |
| [`/project-review`](.claude/skills/project-review/SKILL.md) | Hiring-manager review of a finished project, then fix the criticals | Triages findings by severity, fixes the critical ones with approval, re-reviews to confirm, and backlogs the rest. The after-build bookend to `/improve-plan`. |
| [`/interview-explainer`](.claude/skills/interview-explainer/SKILL.md) | First-principles HTML walkthrough of a project or technique | Explains the math and the real code, with an interview Q&A layer, so a project can be defended in depth. Grounded in the actual implementation, with a required accuracy pass. |
| [`/bootstrap-python-project`](.claude/skills/bootstrap-python-project/SKILL.md) | Scaffold a new Python project with full tooling | One command to get pyproject.toml, ruff, mypy, pytest, pre-commit, and directory structure. |
| [`/add-gates`](.claude/skills/add-gates/SKILL.md) | Install CI + pre-commit enforcement into a target repo | Reads the repo's existing tooling and writes the GitHub Actions workflow plus pre-commit wiring, so the checks run on their own instead of being remembered. |
| [`/portfolio-updater`](.claude/skills/portfolio-updater/SKILL.md) | Add a new project to the portfolio site | Guided process: gather details, generate content, update site files, open PR. |

### Rules — Always-On Standards

Rules apply automatically to files matching their glob pattern. No invocation needed — they're the coding standards every agent and skill follows.

| Rule | Scope | What It Enforces |
|---|---|---|
| [`workflow-orchestration`](.claude/rules/workflow-orchestration.md) | All files | Plan before building, verify before committing, capture lessons learned. |
| [`git-workflow`](.claude/rules/git-workflow.md) | All files | Conventional commits, branch naming, PR templates, pre-push checklist. |
| [`python-style`](.claude/rules/python-style.md) | `**/*.py` | Type hints, ruff formatting, pathlib, dataclasses over bare dicts. |
| [`sql-style`](.claude/rules/sql-style.md) | `**/*.sql` | CTEs over subqueries, explicit JOINs, named CTE conventions. |
| [`writing-style`](.claude/rules/writing-style.md) | `**/*.md`, `**/*.txt` | Voice, tone, AI trope avoidance, content structure patterns. |
| [`testing-standards`](.claude/rules/testing-standards.md) | All files | Tests earn their place only when the expected value comes from outside the code. |
| [`mechanical-gates`](.claude/rules/mechanical-gates.md) | All files | Every repo enforces lint, type-check, and tests as CI and pre-commit hooks, not skills you remember to run. |

### CLAUDE.md — The Control Plane

[`CLAUDE.md`](CLAUDE.md) is what Claude Code reads at the start of every session. It contains:

- **Workspace layout** — where things live
- **Agent roster** — who does what
- **Skill catalog** — available slash commands
- **Rule index** — active coding standards
- **Routing table** — "I want to X" maps to the right tool
- **Tools** — the CLIs the workflow relies on (`gh`, `uv`)

Think of it as the operating manual for a software team — except the team is a set of AI agents.

---

## The Philosophy

**Agents should operate like a well-run team, not a single chatbot.**

A few principles that shaped this setup:

1. **Plan before building.** The `planner` agent exists because the most expensive bugs are design bugs. Thinking is cheaper than refactoring.

2. **Separate concerns.** The `web-developer` doesn't review Python. The `python-reviewer` doesn't write copy. Specialization keeps instructions focused.

3. **Verify before shipping.** Lint, type-check, and tests run as pre-commit hooks and CI (`mechanical-gates`), so quality doesn't depend on remembering a checklist.

4. **The workspace improves itself.** When a task reveals a missing capability, `/create-agent`, `/create-skill`, or `/create-rule` scaffolds the new tooling. The system grows from use.

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

Then either use this directory as your Claude Code workspace, or load it at user level so it applies in every repo:

```bash
mkdir -p ~/.claude/agents ~/.claude/skills ~/.claude/rules
ln -s "$PWD"/.claude/rules/*.md ~/.claude/rules/
ln -s "$PWD"/.claude/agents/planner.md ~/.claude/agents/   # repeat per agent you want
ln -s "$PWD"/.claude/skills/grill ~/.claude/skills/        # repeat per skill you want
```

Symlinks keep the repo the single source of truth. At user level, a repo's own `CLAUDE.md`,
`AGENTS.md`, and skills take precedence where they overlap (see `workflow-orchestration.md`).

### What's NOT included

- `.claude/settings.local.json` — machine-specific permissions, env vars, and hooks (create per-machine)
- `.claude/projects/` memory files — conversation-specific, stay local
- Project source code — this is the *config*, not the projects themselves

---

## See It In Action

The portfolio at [seanmurphy.app](https://seanmurphy.app) was built entirely using this workspace config. The commit history on every project repo shows the agentic workflow in practice — planning, building, reviewing, and documenting through specialized agents.

---

## License

[MIT](LICENSE) — use it, fork it, adapt it.

## Privacy scan

This repo is public and mirrors a private workspace, so every change is scanned for content
that should not be published — private project names, absolute paths carrying a username,
email addresses, credentials.

`scripts/privacy-scan.sh` holds the patterns and is the single source of truth. It runs in
two places:

- **Pre-commit**, via `.githooks/pre-commit`. Arm it once after cloning:
  `git config core.hooksPath .githooks`
- **CI**, via `.github/workflows/privacy-scan.yml`, on every PR — where `--no-verify`
  cannot reach.

Only added lines are scanned; removing a flagged line is the fix, not a violation.
