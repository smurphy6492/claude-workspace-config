# Claude Workspace Config

Shared Claude Code workspace configuration for syncing between machines.

## What's included

- `CLAUDE.md` — workspace instructions and routing
- `FUTURE-IDEAS.md` — project backlog
- `.claude/agents/` — specialized agent personas
- `.claude/skills/` — slash-command skills
- `.claude/rules/` — always-on coding standards
- `.claude/agent-memory/` — agent context memory

## Setup on a new machine

```bash
git clone https://github.com/smurphy6492/claude-workspace-config.git
```

Then either:
1. **Use this repo directly as your workspace**, or
2. **Symlink/copy** the `.claude/` directory and `CLAUDE.md` into your project workspace

## What's NOT included

- `.claude/settings.local.json` — machine-specific permissions, env vars, and hooks (create per-machine)
- `.claude/projects/` memory files — conversation-specific, stay local
