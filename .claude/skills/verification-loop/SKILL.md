---
name: verification-loop
description: Multi-phase verification pipeline before committing or deploying. Runs lint, type-check, tests, and security scan. Use before any significant commit or PR.
argument-hint: "full | quick | lint | test | security | pre-commit"
allowed-tools: Bash, Read, Glob
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: low
  tags: [testing, quality, security, pre-commit]
---

# Verification Loop

Run before committing. Choose a phase set based on what changed.

---

## Phase Sets

| Mode | Phases Run | When to Use |
|---|---|---|
| `full` | All 6 phases | Before merging to main |
| `quick` | Lint + Type + Test | During active development |
| `lint` | Lint only | After formatting changes |
| `test` | Test only | After logic changes |
| `security` | Security only | Before pushing credentials-adjacent code |
| `pre-commit` | Lint + Type | As a pre-commit hook |

---

## Phase 1: Lint

```bash
ruff check . --fix
ruff format .
```

Pass criteria: zero errors after auto-fix

---

## Phase 2: Type Check

```bash
mypy src/
```

Pass criteria: zero type errors

---

## Phase 3: Tests

```bash
pytest --tb=short
```

Pass criteria: all tests pass, no new failures

---

## Phase 4: Coverage (full mode only)

```bash
pytest --cov=src --cov-report=term-missing
```

Pass criteria: coverage does not decrease from previous run

---

## Phase 5: Security Scan (full and security modes)

Check for:
- Hardcoded secrets or API keys (`grep -r "api_key\s*=" src/`)
- Passwords or tokens in config files
- `.env` not in `.gitignore`
- Dependencies with known vulnerabilities (`pip audit` if available)

---

## Phase 6: Diff Review (full mode only)

```bash
git diff --staged
```

Manual check:
- [ ] No debug `print()` statements
- [ ] No commented-out code blocks
- [ ] No TODOs that weren't there before
- [ ] No secrets in diff

---

## Output: Phase Summary

```
## Verification: <mode>

| Phase | Status | Notes |
|---|---|---|
| Lint | ✅ Pass | |
| Type Check | ✅ Pass | |
| Tests | ✅ Pass | 42 passed |
| Security | ✅ Pass | |
| Diff Review | ✅ Pass | |

Overall: ✅ Ready to commit
```

If any phase fails, stop and fix before proceeding.
