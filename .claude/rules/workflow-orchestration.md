# Workflow Orchestration

Core principles for how Claude operates in this workspace. These apply to all tasks.

---

## 1. Plan Before Building

For multi-file or multi-phase work, get Sean's approval on a plan before editing (plan mode,
or the `planner` agent for larger builds). Single-file edits and small fixes don't need one.

### Plans size their own orchestration

Every plan — whether from the `planner` agent or plan mode directly — must classify how the
work should run, not just what the work is:

- **Single-session** — turn-based, no extra machinery. Most plans. One line and move on.
- **Goal-sized** — done is deterministically verifiable; state explicit stop criteria and a
  turn cap in the plan. If it should run autonomously to that stop condition, drive it with a
  self-paced `/loop` (no interval); otherwise run it turn-based.
- **Multi-session** — 3+ phases or distinct specialties; assign each phase a workspace
  agent, and save the plan to `projects/<project>/PLAN.md` so future sessions and agents
  resume from it instead of re-deriving it.
- **Recurring / external** — the work waits on CI, reviews, or a schedule; include a
  `/loop` or `/schedule` prompt with the interval matched to how fast the watched thing
  actually changes.

For anything beyond single-session, the plan includes the actual loop prompts (written out,
ready to paste) and marks human gates — phases that must not start without approval (spend,
publishing, destructive operations). The planner agent's Step 5 defines the full format.

### Every phase carries a command-shaped Verify

Also true of plans from plan mode, not just the `planner` agent. Each phase states a
`Verify:` — a command that exits non-zero when the phase is not done, not a sentence
describing success. A phase that genuinely cannot be decided by a command gets
`Verify: HUMAN — <what to look at>`; that answer is useful, because it marks what must not
run unattended. A prose criterion shaped like a check is the failure mode: "X beats Y, or
we note that it doesn't" passes either way and decides nothing.

Missing acceptance criteria are the most common defect `plan-judge` finds — 20% of 176
weaknesses over five weeks (`.claude/skills/improve-plan/data/`). The planner agent's
Step 4 has the full format.

### Offer to pressure-test the plan

After producing an initial plan for a substantial or data/analysis task, **offer to run
`/improve-plan`** before execution — an independent judge scores the plan against the
plan-quality rubric and flags methodology gaps the author can't see, then revises from
them. Ask it as a quick yes/no in the same message as plan approval, not as a separate
stop; do not run it automatically.

Skip the offer for trivial plans (a rename, a one-line fix, a single-file edit) where the
loop would be overkill. The judgment of "is this plan substantial enough to be worth
pressure-testing" is yours to make — when in doubt on a data/analysis plan, offer it,
since that is where unseen methodology footguns are most expensive.

### Publish a review artifact as the final step

Sean reads the chat summary, not the PLAN.md. So once a substantial plan is final (after
`/improve-plan`, if it ran), publish it as an Artifact built for approving the plan, and
link it in the reply. Skip this for the same trivial plans that skip `/improve-plan`.

The page is a summary to review, not a copy of the plan. It should make these easy to
see and question: the goal, what is out of scope, the phases and their order (a diagram
when there is a real sequence or dependency to show), each phase's Verify, the human
gates, and the risks and open questions Sean has to answer. Lead with what he is
approving.

PLAN.md stays the source of truth, because agents and later sessions resume from files,
not artifacts. Add the artifact URL near the top of PLAN.md so the two stay linked. If
Sean comments on the page, change PLAN.md first, then republish to the same URL.

> Added 2026-09-25 as an experiment. Re-evaluate after a few plans: if Sean doesn't open
> or comment on the pages, cut this section.

---

## 2. Use Agent Teams for Complex Work

Each agent's description carries its own routing, and `CLAUDE.md` holds the index. The part
no description states: agents chain — plan → build → review → document.

---

## 3. Self-Improvement Loop

When a task reveals a gap in the workspace (missing skill, outdated rule, missing agent):
1. Complete the current task first
2. Then propose the workspace improvement
3. Use `/create-agent`, `/create-rule`, or `/create-skill` to scaffold the new tooling

---

## 4. Verify Before Committing

Lint, type-check, and tests are enforced mechanically by CI and pre-commit
(`.claude/rules/mechanical-gates.md`) — not by an invoked checklist. Before committing,
run the repo's own check command (usually `make check`) and confirm the diff carries no
credentials or machine-specific paths.

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

- When starting new build work, check `FUTURE-IDEAS.md` for relevant backlog items
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

---

## 10. Report Long Runs

A long run is any work with subagents, a `/loop`, or several unattended phases.
End it with three headings, in this order:

- **Blocked on me** — decisions, approvals, or access waiting on Sean, each with a
  recommendation. Write "none" if there are none.
- **Changed** — files, branches, PRs, and commits, with links.
- **Found** — bugs, surprises, and workspace gaps, including proposed skills or rules and
  any `FUTURE-IDEAS.md` additions.

A skill with its own output contract (`/improve-plan`, `/project-review`) keeps that format
and adds only the headings it doesn't already cover.

> Added 2026-09-25 from Anthropic's Opus 5.5 prompting guide, replacing "Capture Lessons".
> Re-evaluate after a few long runs: if Sean still has to dig for what's waiting on him,
> tighten it; if the headings are always empty, cut it.

---

## 11. Keep vs. Cage

The keep-vs-cage test, for anything in this harness — a rule, a skill step, a checklist:
**if the model were twice as capable, would this help it use that capability (KEEP) or
block it (CAGE)?**

- **KEEP** — deterministic verifiers, human approval gates, un-derivable facts (voice,
  project scope, business rules, schema constraints, tool wiring), thin goal statements.
- **CAGE** — prescribed reasoning procedures, routing that restates what a description
  already says, model-weakness patches, checklists repeating what a capable model does.

Numbers in a list are load-bearing when they encode a data dependency, a safety sequence, a
human gate, or an output contract. They are a cage only when they encode a judgment order
the model should own.

Two corollaries worth stating, both learned the expensive way:

- **Same text in two load contexts is not duplication.** Before cutting something as
  redundant, check *where each copy actually loads* — a rule file and an agent file reach
  different sessions.
- **Mark weakness-patches with an expiry.** If an instruction exists because the current
  model over- or under-produces something, say so in the text, so a later session knows to
  re-test it rather than inherit it.

---

## 12. Ask Before Assuming

When a request could reasonably mean two different things, and the two readings lead to
different work, use `AskUserQuestion` before starting.
Sean would rather answer two questions up front than review the wrong deliverable.

Ask when the answer changes what gets built.
Don't ask when it changes a variable name, a file location, or anything a careful reader
could settle from the repo.
Routine judgment calls stay yours.

> Added 2026-08-25 as an experiment, to test whether an explicit nudge scopes work better
> than the model's own default. Re-evaluate after a few weeks of real sessions: if the
> questions turn out to be ones the repo already answered, cut this section.
