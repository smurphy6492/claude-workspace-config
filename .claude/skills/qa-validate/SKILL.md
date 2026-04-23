---
name: qa-validate
description: End-to-end QA and functional validation for everything in this workspace. Validates that features actually work — builds succeed, pipelines run, outputs are correct, and the site renders. Use after completing a feature and before marking a session done or demoing. Distinct from verification-loop (which checks code quality). This checks functional correctness.
argument-hint: "website | analytics-agent | full | <specific feature>"
allowed-tools: Bash, Read, Glob, Grep
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: medium
  tags: [qa, testing, validation, functional]
---

# QA Validate

Functional validation across both workspace projects. Answers: **does it actually work?**

Run this after building a feature, before demoing, or before marking a session complete.

> **Distinct from `/verification-loop`:** That skill checks code quality (lint, types, static analysis). This skill checks functional correctness — builds, runtime behavior, pipeline output, and UI rendering.

---

## Argument Routing

| Argument | Runs |
|---|---|
| `website` | Phases 1–3 (frontend only) |
| `analytics-agent` | Phases 4–6 (Python pipeline only) |
| `full` | All phases |
| *(no arg or feature name)* | Infer from current working directory and recent changes |

---

## Phase 1 — Dependency Install (Website)

**Target:** `projects/personal-website/`

```bash
cd projects/personal-website
pnpm install --frozen-lockfile
```

Pass criteria: zero install errors, no missing peer dependencies

---

## Phase 2 — Build Validation (Website)

```bash
pnpm build
```

Pass criteria:
- Build completes without errors
- `dist/` directory is created with `index.html` and bundled assets
- No unresolved imports in build output
- Bundle size is not unexpectedly large (flag if > 2MB)

If build fails: read the error, identify the root cause (broken import, missing env var, TypeScript error), fix it.

---

## Phase 3 — Website Functional Spot-Check

Read the built output and source to verify:

**Homepage**
- [ ] Hero section: name, title, and tagline are present and accurate
- [ ] Project cards: at least one project card renders with title + description
- [ ] Navigation links are present and point to valid in-page anchors or routes

**Content Accuracy**
- [ ] No placeholder text like "Lorem ipsum", "TODO", "Your Name Here", or "Coming Soon" in visible sections (unless intentionally marked)
- [ ] Bio reads as Sean Murphy — Analytics + AI Systems Builder
- [ ] GitHub stats panel (if built): data file is present and not stale (check file modified date)

**Technical**
- [ ] No `console.error` or uncaught promise rejections visible in source
- [ ] No hardcoded localhost URLs in production code
- [ ] Images have alt text
- [ ] TypeScript: `pnpm type-check` passes (or `tsc --noEmit`)

```bash
grep -r "localhost" dist/ 2>/dev/null | grep -v ".map" | head -10
grep -r "TODO\|FIXME\|lorem ipsum" src/ -i | head -10
```

---

## Phase 4 — Python Environment Check (Analytics Agent)

**Target:** `projects/autonomous-analytics-agent/`

```bash
cd projects/autonomous-analytics-agent
python -m pip check
python -c "import duckdb, anthropic, plotly, jinja2, pydantic; print('All imports OK')"
```

Pass criteria: all core imports succeed, no dependency conflicts

Also verify:
- `.env` or `ANTHROPIC_API_KEY` is set (check `os.environ` or `.env` file presence — do NOT print the key)
- `.env` is in `.gitignore`

```bash
grep -q "ANTHROPIC_API_KEY" .env 2>/dev/null && echo "API key set" || echo "WARNING: API key not found"
grep ".env" .gitignore || echo "WARNING: .env not in .gitignore"
```

---

## Phase 5 — Analytics Agent Test Suite

```bash
pytest --tb=short -q
```

Pass criteria: all tests pass with zero failures

If tests fail:
1. Read the failure output
2. Identify if it's a logic error, missing fixture, or environment issue
3. Fix logic errors immediately; flag environment issues for the user

Also run a smoke test if a sample data file is available:

```bash
python -m analytics_agent.main --data-dir data/sample/ --question "What are the top 3 product categories by revenue?" --output /tmp/smoke_test.html 2>&1 | tail -20
```

Pass criteria: script exits 0, `smoke_test.html` is produced and non-empty

---

## Phase 6 — Analytics Agent Output Validation

After a pipeline run (smoke test or real run), validate the output:

**HTML Report**
- [ ] Output file exists and is non-empty (`ls -lh <output>.html`)
- [ ] File contains `<html>` and `</html>` tags
- [ ] File contains at least one Plotly chart (`grep -c "plotly" <output>.html`)
- [ ] Executive summary section is present and non-empty
- [ ] File is self-contained (no external script tags pointing to CDNs that could break offline)

```bash
# Quick output validation
OUTPUT="path/to/report.html"
[ -s "$OUTPUT" ] && echo "File exists and non-empty" || echo "FAIL: empty or missing"
grep -c "plotly" "$OUTPUT" && echo "Charts embedded" || echo "WARNING: no Plotly found"
grep -q "<html" "$OUTPUT" && echo "Valid HTML wrapper" || echo "FAIL: not valid HTML"
```

**Pydantic Schema**
- [ ] ProfileResult, QueryPlan, ChartSpec, AnalysisReport all parse without errors on sample data
- Verified by test suite passing (Phase 5)

---

## Phase 7 — Cross-Cutting Checks (full mode)

Run regardless of target:

**Secrets**
```bash
grep -r "sk-ant-\|api_key\s*=\s*['\"]" --include="*.py" --include="*.ts" --include="*.js" src/ 2>/dev/null | grep -v ".env.example"
```
Pass criteria: zero matches

**Dead code / debug artifacts**
```bash
grep -rn "print(\|console\.log\|breakpoint()\|debugger" src/ --include="*.py" --include="*.ts" | grep -v "# noqa\|// ignore" | head -20
```
Review matches — flag intentional logging, remove debug statements

**README accuracy**
- [ ] README install instructions match actual `pyproject.toml` or `package.json` dependencies
- [ ] CLI usage in README matches actual argument names in code

---

## Output Format

Produce a QA summary table after all phases complete:

```
## QA Validate: <target> — <date>

| Phase | Check | Status | Notes |
|---|---|---|---|
| 1 | Dependency install | ✅ Pass | |
| 2 | Build | ✅ Pass | dist/ 1.2MB |
| 3 | Website spot-check | ⚠️ Warning | "Coming Soon" in projects section |
| 4 | Python env | ✅ Pass | All imports OK |
| 5 | Test suite | ✅ Pass | 24 passed, 0 failed |
| 6 | Pipeline output | ✅ Pass | report.html 187KB, 3 charts |
| 7 | Cross-cutting | ✅ Pass | No secrets, no debug code |

Overall: ✅ QA Passed — ready to demo / merge
```

**Status values:**
- `✅ Pass` — check completed, criteria met
- `⚠️ Warning` — minor issue found, noted but not blocking
- `❌ Fail` — blocking issue, must be fixed before proceeding

If any phase is `❌ Fail`: stop, fix the issue, re-run that phase before continuing.
