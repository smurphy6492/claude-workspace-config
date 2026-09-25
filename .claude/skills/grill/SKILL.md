---
name: grill
description: Adversarial questioning until nothing is silently assumed. Two modes — grill a task before it becomes a plan (design tree, rounds of numbered questions, stop when the frontier is empty), or grill Sean on a finished project the way a hostile interviewer would. Use before invoking the planner agent, or when prepping to defend a portfolio project in a loop.
argument-hint: "plan (default) | defend <project path>"
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch, AskUserQuestion
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: medium
  tags: [planning, alignment, interview, questioning]
---

# Grill

Interrogate until the assumptions are on the table. Two things get grilled: a task that is
about to become a plan, and a finished project that is about to be defended out loud.

The gap this fills: `planner` and `/improve-plan` both operate on a plan **that already
exists**, which means its premises were set by one reading of an ambiguous ask.
`plan-judge` then scores that reading rather than challenging it. Grilling attacks the
premises before they harden into a plan worth judging.

```
/grill plan  ->  planner  ->  /improve-plan  ->  build
                                                    |
                          /project-review  ->  /grill defend
```

---

## Modes

| Mode | What it grills | Ends when |
|---|---|---|
| `plan` (default) | A task, feature, analysis, or decision about to be committed to | The frontier is empty — every branch visited, nothing silently assumed |
| `defend <project>` | A finished project Sean will have to defend in an interview | Every claim on the card has survived two follow-ups, or is marked to drop |

---

## The primitive (both modes)

**Build a design tree.** Decisions branch into dependent sub-decisions. Hold the whole tree,
not a flat question list.

**Ask at the frontier only.** The frontier is the set of decisions whose prerequisites are
already settled. A question that depends on an unsettled answer waits for a later round —
asking it now produces a guess that contaminates everything downstream.

**Ask in rounds.** Every frontier question at once, numbered, then stop and wait. Never
one-at-a-time interrogation, never the whole tree dumped in round one.

**Every question carries a recommended answer and a one-line why.** Sean should be able to
reply `1 yes, 2 B, 3 your call` without writing essays. A question with no recommendation
is a question you have not thought about hard enough to ask.

**The brief is source zero.** Sean's own framing — the paragraphs he wrote when invoking
this, the conversation so far — gets read before anything else, and everything it settles is
settled. Do not re-ask it in different words, do not ask him to confirm what he just told
you, and do not treat a detail as unsettled because he stated it in passing rather than
under a heading. The whole value of a details-dump is that it front-loads the answers; a
round-one question he already answered says the brief was not read.

What a brief does *not* settle is what it never mentions. Grill the gaps and the
implications, not the content — "you did not say which of these is the deliverable" is the
right question after a four-paragraph brief; "what are you building?" is not.

**Find your own facts.** Read the repo, search the web, check the memory index. Never ask
Sean to look something up, and never ask what a careful reader could settle from the files
in front of you — that is the failure mode Rule 12 exists to prevent, and this skill is
held to it harder, not looser.

**Do not act on the outcome.** Grilling produces shared understanding, not a plan and not
code. Stop at the summary and wait for confirmation.

Use `AskUserQuestion` only when a round reduces to four or fewer questions that each have
four or fewer discrete options. Otherwise numbered prose — the tool's shape is too narrow
for most rounds and forcing questions into it loses the recommendations.

---

## Mode: plan

Before the first round, read what already exists — in this order: **Sean's brief**, then the
target files, `CLAUDE.md`, relevant `project_*` entries in the memory index, and
`FUTURE-IDEAS.md` if the task smells like backlog. Questions the brief or the repo already
answers do not get asked.

The common invocation is `/grill` plus a written brief in the same message, so expect the
answers to arrive before the questions. That is the good case: it means round one can open
on the branches the brief left implicit instead of on basics.

Grill for the branches that change what gets built:

- **Scope edges** — what is deliberately *not* in this, and what would have to be true for
  that to change
- **Success** — what command decides this worked, and what it prints when it did not
- **Audience** — a VP/CTO reading the output, or Sean reading it, or a script consuming it
- **Reversibility** — what is cheap to undo and what is a one-way door
- **Prior art** — what in the workspace already does most of this
- **Motivated reasoning** — when the brief arrives with its conclusion already chosen (a
  trade thesis, a rule Sean wants to keep, a result he hopes holds), ask whether the
  conclusion is driving the evidence: what result would change his mind, and which
  inconvenient data points were explained away rather than tested. Investing decisions
  are the main case — a trading rule that contradicts his own trade history is exactly
  where this bites.

When the frontier empties, hand off: summarize the settled tree, then offer to invoke
`planner`. The summary is the planner's input — a plan built on a grilled tree starts
several rounds ahead of one built on the raw ask.

---

## Mode: defend

Read the project first — code, README, case study, and the site copy if it has a card.
Then read the coaching-profile memory (`project_interview_coaching_profile.md`) for the
open presentation habits and the depth-calibration rule.

The tree here is the project's **decision tree as built**: every choice a hiring manager
could pull on. For each claim the project makes, press **two follow-ups deep** — the first
follow-up is the obvious one and Sean will land it; the second is where the card either
holds or falls over.

Grill hardest at:

- **Methodology depth vs. how the card is pitched.** The standing rule is never to build
  interview strategy on a card that cannot survive two follow-ups. A project pitched as
  orchestration when the domain expertise is POC-level is fine; the same project pitched as
  domain expertise is a trap. Flag every mismatch.
- **The choice not taken** — why this model, this window, this baseline, and what the
  runner-up would have shown
- **What the number excludes** — the scope of any estimate, stated out loud
- **The ablation** — what breaks the result, and whether the project already publishes it
- **Findings from `/project-review`** — if `staff-ds-reviewer` has run, its "interview
  question this exposes" lines are pre-loaded ammunition. Ask them.

Do not debrief mid-answer. Let Sean develop the full answer including the second-order
point, then verdict at the end.

Per claim, return one of:

| Verdict | Meaning |
|---|---|
| `DEFENSIBLE` | Survived two follow-ups. Lead with it. |
| `NEEDS WORK` | The substance is there, the answer is not. What to rehearse. |
| `DROP THE CARD` | Cannot survive the second follow-up. Do not put it in front of a panel. |

---

## Output

End a `plan` grill with:

```
## Grilled: <task>

Settled:
- <decision> -> <answer>
Assumed (say so if wrong):
- <assumption you took a recommendation on>
Deferred (needs a later round):
- <branch, and what unblocks it>

Ready for `planner`? (y/n)
```

End a `defend` grill with the per-claim verdict table, then the single weakest branch and
what to do about it before the loop.

---

## Notes

- Do not grill trivial work. A rename, a one-line fix, a single-file edit — just do it.
  This earns its keep where a wrong premise is expensive to discover mid-build, which is
  the same bar `/improve-plan` uses.
- Rounds are usually two or three. If you are on round five, the tree was built wrong —
  say so and restart it rather than grinding.
- `plan` mode does not replace `/improve-plan`; they sit on opposite sides of the planner
  and catch different things. Front end catches wrong premises, back end catches missing
  acceptance criteria.
