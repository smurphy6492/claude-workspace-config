---
name: improve-plan
description: Run a draft implementation plan through one independent judge-and-revise pass before acting on it. Spawns the plan-judge agent (fresh context, fixed rubric), then revises the plan from its weaknesses. Use after the planner produces a plan, or on any plan about to be executed.
argument-hint: "once (default) | loop | judge-only"
allowed-tools: Agent, Read, Write, Edit, Glob, Grep
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: low
  tags: [planning, review, quality]
---

# Improve Plan

Take a draft plan, have an independent agent critique it against a fixed rubric, then
revise it from those critiques before anyone executes it. The judge is a separate agent
with no memory of how the plan was written, so it catches gaps that are invisible to the
author but obvious to a reviewer.

The smoke data behind this says one revision does most of the work, so the default is a
single pass. Reach for `loop` only when the first score is low.

---

## Modes

| Mode | What it does |
|---|---|
| `once` (default) | One judge → revise pass. The right call for almost everything. |
| `loop` | Repeat judge → revise until the judge returns no substantive new weakness, the score is ≥ 90, or 3 cycles run — whichever comes first. |
| `judge-only` | Score and critique the plan, present the result, do not revise. |

---

## Inputs

A candidate plan and the task it serves. The plan is usually the one the `planner` agent
just produced or the plan in the current conversation. If there is no plan yet, produce
one first (invoke the `planner` agent) — this skill improves a plan, it does not draft
from nothing.

---

## Procedure

### Step 1 — Judge (independent)
Spawn the `plan-judge` agent. Pass it the task and the full plan text. It reads
`.claude/skills/improve-plan/rubric.md` and returns a `SCORE`, per-dimension scores, a
numbered `WEAKNESSES` list, and a one-line `VERDICT`.

Always use a fresh `plan-judge` agent for each cycle — do not reuse one across cycles, and
do not let the agent that wrote the plan grade it. The independence is the point.

### Step 2 — Revise
Rewrite the plan to address the weaknesses. Work from the `WEAKNESSES` list, **not** the
score — fix the substance, do not optimize the number. Address each weakness or, if you
deliberately reject one, note why in a line. Keep everything the plan already got right;
do not regenerate from scratch.

In `judge-only` mode, skip this step.

### Step 3 — Decide whether to continue
- `once`: stop after one revise.
- `loop`: judge the revised plan with a fresh `plan-judge`. Continue if the new score
  improved and the latest weaknesses are substantive. Stop when the judge returns no
  substantive new weakness, the score is ≥ 90, or 3 cycles have run. Keep the
  highest-scoring plan seen.

### Step 4 — Present
Show the improved plan, then a short delta:

```
## Plan improved (<mode>)

Score: <before> -> <after>
Fixed:
- <top weakness addressed>
- <top weakness addressed>
Left open (with reason):
- <weakness deliberately not addressed, and why>
```

Keep the judge's raw output available if asked, but do not dump it by default.

---

## Notes
- Cost and latency: one cycle is one `plan-judge` agent call plus the revise. The default
  single pass is cheap; `loop` multiplies it by the cycle count.
- Do not gate trivial plans through this. It earns its keep on substantial or multi-file
  work, where an author blind spot is expensive to discover mid-build.
- The rubric is fixed on purpose. If it is consistently rewarding the wrong thing, edit
  `rubric.md` rather than arguing with the judge per-run.
