# Git Workflow

Standards for version control, branching, commits, and pull requests. This workspace uses GitHub.

---

## Branch Naming

```
<type>/<short-description>
```

Types: `feature`, `fix`, `refactor`, `docs`, `chore`, `data`, `pipeline`

Examples:
```
feature/portfolio-live-data-feed
fix/mobile-nav-overflow
docs/project-case-study-pipeline
chore/cleanup-old-work-config
```

Rules:
- Lowercase and hyphens only (no underscores, no spaces)
- Keep descriptions short but meaningful (3-5 words)
- Branch from the repo's default branch
- A repo with its own branch, commit, or PR conventions (in its `CLAUDE.md`, `AGENTS.md`,
  `CONTRIBUTING.md`, or a `/pr` skill) uses those instead of this file

---

## Commit Messages

Use conventional commit format:

```
<type>(<scope>): <short description>

[optional body]
```

Types:
- `feat` — new feature or capability
- `fix` — bug fix
- `refactor` — code change that doesn't add features or fix bugs
- `docs` — documentation, README, case study updates
- `style` — formatting, CSS, no logic change
- `test` — adding or updating tests
- `chore` — build process, dependencies, config
- `data` — data pipeline additions or updates
- `ci` — GitHub Actions / CI changes

Examples:
```
feat(website): add live GitHub stats panel
fix(pipeline): handle null response from GitHub API
docs(readme): add case study for data pipeline demo
ci: add lint and type-check on pull request
```

Rules:
- Subject line: max 72 characters, imperative mood ("add" not "added")
- No period at end of subject line
- Body explains *why*, not *what* (the diff shows what)

---

## Pull Request Workflow

**Tool split** — these are capability boundaries, not preferences:

| Use | For |
|---|---|
| `gh` CLI | PRs, issues, reviews, Actions runs, releases, repo settings, API calls (`gh api`) |
| `git` | Local work: stage, commit, checkout, push |

If the repo has a PR template (`.github/pull_request_template.md`), fill that in instead of the
template below.

### PR Body Template
```markdown
## What
[1-2 sentences describing the change]

## Why
[Why this change is needed]

## How
[Key implementation decisions or approach]

## Test Plan
- [ ] [specific thing to verify]
- [ ] [another thing to verify]
```

### Before Pushing
Lint, type-check, and tests are enforced by CI and pre-commit
(`.claude/rules/mechanical-gates.md`) — don't re-run them as a checklist.
The one thing no gate checks: update the README or docs if behavior changed.

---

## Main Branch Rules
- Default branch (`master` or `main`) is always deployable
- No direct commits to the default branch for significant changes
- Use PRs for anything beyond trivial fixes
- Squash or merge — keep history readable
- Never merge a PR, or push to a default branch, without explicit approval in the current session

---

