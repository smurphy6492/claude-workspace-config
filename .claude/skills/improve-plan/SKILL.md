---
name: improve-plan
description: Run a draft implementation plan through one independent judge-and-revise pass before acting on it. Spawns the plan-judge agent (fresh context, fixed rubric), then revises the plan from its weaknesses. Use after the planner produces a plan, or on any plan about to be executed.
argument-hint: "once (default) | loop | judge-only"
allowed-tools: Agent, SendMessage, Read, Write, Edit, Glob, Grep
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

The default is a single pass, but treat that as unsettled. 27 recovered judgements from
real use (2026-07 to 2026-08) show the **first** revision gaining +2.0 on average and
**later** revisions gaining +4.6 — the opposite of the "one pass does most of the work"
assumption the default was built on. That evidence is observational and thin (n=4 and n=5),
which is exactly why Step 1b logs every pass. Reach for `loop` when the first score is low,
and revisit this default once the logged data is thicker.

---

## Modes

| Mode | What it does |
|---|---|
| `once` (default) | One judge → revise pass. The right call for almost everything. |
| `loop` | Repeat judge → revise until a pass returns no `[BLOCKER]` weakness, or 3 cycles run — whichever comes first. |
| `judge-only` | Score and critique the plan, present the result, do not revise. |

Every mode logs each judge pass (Step 1b) — there is no separate measure mode.

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
numbered severity-tagged `WEAKNESSES` list, and a one-line `VERDICT`.

Always use a fresh `plan-judge` agent for each cycle — do not reuse one across cycles, and
do not let the agent that wrote the plan grade it. The independence is the point.

### Step 1a — Closure audit (iteration ≥ 2 only)
When a prior pass exists on this `plan_id` (this session or in `runs/`), then **after** the
judge returns its cold read, send that same judge a follow-up via `SendMessage` containing
the previous pass's `WEAKNESSES` list verbatim, and ask for its `CLOSURE AUDIT` (format in
the agent file: each prior weakness classified closed / open / regressed, plus a closure
rate).

Sequencing is the contract: the prior list goes in the follow-up, never in the initial
prompt — included up front it anchors the cold read and the independence is lost. The
closure audit is what answers "did the revision work"; the score cannot (see Step 3).

### Step 1b — Log the judgement (always, every pass)
Immediately after each judge returns, write one record to
`<workspace-root>/.claude/skills/improve-plan/data/runs/<UTC-timestamp>-<plan_id>-<iteration>.json`.

Resolve `<workspace-root>` to the absolute path of your workspace and write that — this
skill also runs from project subdirectories, where a relative path would miss. Create
`runs/` if it does not exist. The record is:

```json
{
  "ts": "2026-08-24T15:04:00Z",
  "plan_id": "checkout-rewrite-phase2",
  "iteration": 1,
  "score": 78,
  "correctness": 15, "methodology": 18, "completeness": 16,
  "specificity": 13, "risk": 9, "sequencing": 7,
  "verdict": "<the judge's one-line VERDICT, verbatim>",
  "weaknesses": ["<each WEAKNESSES item, verbatim including its [SEVERITY] tag, first ~2 sentences>"],
  "closure": {"closed": [1, 2, 5], "open": [3], "regressed": [4]},
  "plan_label": "<the description you gave the plan-judge agent>",
  "plan_source": "planner | plan-mode | hand-written | external",
  "mode": "once"
}
```

- `plan_id` is a stable kebab-case slug for the plan **across revisions** — the same slug
  for pass 1 and pass 4. This is what makes iteration curves possible; a new slug per pass
  destroys the series.
- `iteration` is 1-based and counts judge passes on that `plan_id`, including passes from
  earlier sessions. Check `runs/` for existing records on the slug before numbering.
- Log every pass, including `judge-only` runs and passes where the score did not move.
  A flat or falling score is data; silently dropping it biases the record.
- Write the record even if the user abandons the plan afterwards.
- `plan_source` says where the plan came from. The `planner` agent's contracts (Step 2
  citations, Step 4 verify) only bind plans it wrote, so without this field a shift in the
  numbers cannot be attributed. Use `external` for a plan someone else authored.
- `weaknesses` carries the actionable half. Scores say whether the skill worked;
  the weakness text says **what keeps going wrong**, which is what actually changes the
  rubric, the `planner` agent, or the plan template. Record them verbatim — do not
  summarize or re-word, or the recurrence signal is lost.
- `closure` records the Step 1a audit. The integers index the **previous** pass's
  `weaknesses` array (1-based, matching the judge's numbering). Omit the field entirely on
  iteration 1. Records before 2026-08-27 predate both this field and the severity tags.

This costs one `Write` per pass and is what turns routine use into a dataset. See
`.claude/skills/improve-plan/data/README.md` for why it exists and how it is analyzed.

### Step 2 — Revise
Rewrite the plan to address the weaknesses. Work from the `WEAKNESSES` list, **not** the
score — fix the substance, do not optimize the number. Address each weakness or, if you
deliberately reject one, note why in a line. Keep everything the plan already got right;
do not regenerate from scratch.

In `judge-only` mode, skip this step.

### Step 3 — Decide whether to continue
- `once`: stop after one revise.
- `loop`: judge the revised plan with a fresh `plan-judge` (Step 1 + 1a + 1b). Continue
  while the latest pass reports any `[BLOCKER]` weakness; stop when a pass returns none,
  or when 3 cycles have run. Keep the **latest** revision — with closure audited, later
  revisions dominate; do not pick by score.

  The score does not gate continuation and a score delta is not the improvement signal.
  The judge is not a fixed instrument across passes: each revision adds mechanism, new
  mechanism is new attack surface, and a fresh judge reads a more detailed plan more
  forensically — so scores can fall while the plan improves (one plan went
  59 → 67 → 60 → 82 while closing nearly every weakness each pass). Log the score;
  steer by severity and closure.

  If the closure rate comes back low (under roughly 2/3 closed), the revise step itself is
  failing — stop and tell the user rather than burning another cycle on it.

### Step 4 — Present
Show the improved plan, then a short delta:

```
## Plan improved (<mode>)

Score: <before> -> <after>  (logged for the dataset; severity is the signal)
Closed: <n>/<m> prior weaknesses (<r> regressed)   <- loop passes only
Remaining: <b> blocker / <ma> major / <mi> minor
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
