# Workflow Orchestration

Core principles for how Claude operates in this workspace. These apply to all tasks.

---

## 1. Plan Before Building

For any task that involves creating or significantly modifying files:
- Enter plan mode first
- Use the `planner` agent for complex or multi-file work
- Get confirmation before executing

**Never start writing code for a complex task without a plan.**

### Offer to pressure-test the plan

After producing an initial plan for a substantial or data/analysis task, **offer to run
`/improve-plan`** before execution — an independent judge scores the plan against the
plan-quality rubric and flags methodology gaps the author can't see, then revises from
them. Present it as a quick yes/no and let the user decide; do not run it automatically.

Skip the offer for trivial plans (a rename, a one-line fix, a single-file edit) where the
loop would be overkill. The judgment of "is this plan substantial enough to be worth
pressure-testing" is yours to make — when in doubt on a data/analysis plan, offer it,
since that is where unseen methodology footguns are most expensive.

---

## 2. Use Agent Teams for Complex Work

Match the task to the right agent:
- Architecture decisions → `planner`
- Python code review → `python-reviewer`
- General code review → `code-reviewer`
- Frontend/site work → `web-developer`
- Portfolio writing → `content-writer`
- Data pipelines → `data-pipeline`

Agents can be chained: plan → build → review → document.

---

## 3. Self-Improvement Loop

When a task reveals a gap in the workspace (missing skill, outdated rule, missing agent):
1. Complete the current task first
2. Then propose the workspace improvement
3. Use `/create` to scaffold the new tooling

---

## 4. Verify Before Committing

Run `/verification-loop` before committing significant changes:
- Lint passes
- Type checks pass
- Tests pass
- No secrets in diff

---

## 5. Elegance Over Cleverness

- Prefer simple, readable solutions over clever ones
- Fewer moving parts = fewer failure modes
- If a solution needs a comment to explain why it works, consider simplifying it

---

## 6. Autonomous Bug Fixing

When a bug is found during implementation:
1. Fix it immediately if it is small and clearly understood
2. Flag it and continue if it is complex or risky
3. Never silently work around a bug without documenting it

---

## 7. Context Awareness

Before starting any task:
- Read `CLAUDE.md` if it has not been read this session
- Check `FUTURE-IDEAS.md` for relevant backlog items
- Read existing files in the area being changed — don't assume, read

---

## 8. Research First

For any task involving an unfamiliar API, library, or pattern:
- Search documentation before writing code
- Prefer official docs over Stack Overflow
- Cite the source if making an assumption based on docs

---

## 9. Incremental Delivery

- Prefer small, verifiable steps over large single commits
- Each step should leave the codebase in a working state
- Commit frequently with meaningful messages

---

## 10. Capture Lessons

After completing a significant task:
- Note anything that went wrong and how it was resolved
- If a pattern emerged that would be useful again, propose a skill or rule for it
- Update `FUTURE-IDEAS.md` if a bigger idea surfaced during the work
