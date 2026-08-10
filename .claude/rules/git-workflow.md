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
- Branch from `master` (personal-website repo) or `main` for new repos

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
| `github` MCP | PRs, issues, file contents, branches, commits, search |
| `gh` CLI | Actions runs, secrets, releases, repo settings and visibility, branch protection — the MCP has no tools for these |
| `git` | Local work: stage, commit, checkout, push |

`gh` is not always on the bash PATH — on Windows it often needs its full path — which is a
further reason to reach for the MCP where both would work.

Full command reference and PR templates: `/github-workflow`.

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
- [ ] Code runs without errors
- [ ] No secrets, API keys, or credentials in the diff
- [ ] Lint and type checks pass
- [ ] New functionality has at least basic tests
- [ ] README or docs updated if behavior changed

---

## Main Branch Rules
- Default branch (`master` or `main`) is always deployable
- No direct commits to the default branch for significant changes
- Use PRs for anything beyond trivial fixes
- Squash or merge — keep history readable

---

