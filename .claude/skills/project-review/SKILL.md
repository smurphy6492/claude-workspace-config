---
name: project-review
description: Review a finished data/analytics project as a staff/senior DS hiring manager would — code, business logic, narrative, and website copy together. Spawns the staff-ds-reviewer agent (fresh context, fixed rubric), triages findings by severity, fixes the critical ones with your approval, re-reviews to confirm they closed, and parks medium/low findings in a backlog for future iteration. Use when a project is nominally done and you need to know whether it survives an interview and production.
argument-hint: "<project path or name> [fix-criticals (default) | critique-only]"
allowed-tools: Agent, Read, Write, Edit, Glob, Grep, Bash
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: low
  tags: [review, quality, interview-prep, portfolio]
---

# Project Review

Take a finished project and have an independent hiring manager tear into it — the whole
deliverable, not just the code: methodology, business framing, stakeholder narrative, and
website copy. The reviewer is a separate agent with no memory of how the work was built, so
it catches the holes the author can't see and names the interview question each one exposes.

This is the *after* bookend to `/improve-plan`: that reviews the plan before you build, this
reviews the deliverable before you show it.

The default is not a pure critique and not a blind auto-fix. It is a severity-triaged loop:
fix the critical findings (with your approval), verify they actually closed, and write the
medium and low findings to a backlog so nothing important is lost and nothing unimportant
blocks you.

---

## Modes

| Mode | What it does |
|---|---|
| `fix-criticals` (default) | Review → triage → fix approved Criticals → re-review the Criticals → backlog Medium/Low. The right call for a project you intend to ship or defend. |
| `critique-only` | Review and present the triaged findings. Fix nothing, but still write Medium/Low (and un-actioned Criticals) to the backlog. Use when you want to read the review before deciding, or plan to fix by hand. |

---

## Inputs

A project — a path under `projects/`, a repo, or a name you can resolve to one. Read what
actually exists before reviewing: code and notebooks, README and case study, and any
portfolio/website copy that describes the project. If the target is ambiguous, ask which
project before spawning the reviewer.

Optionally, the role being targeted. If unspecified, the review assumes staff/senior data
scientist.

---

## Procedure

### Step 1 — Review (independent)
Spawn the `staff-ds-reviewer` agent. Give it the project path (and the target role, if
known). It reads `.claude/skills/project-review/rubric.md` and returns `OVERALL`,
per-dimension scores, a `TOTAL`, severity-tagged `FINDINGS` (each with a fix and the
interview question it exposes), `STRONGEST PARTS`, and a one-line `VERDICT`.

Always use a fresh `staff-ds-reviewer` — never let an agent that built the work review it.
The independence is the point.

### Step 2 — Present and triage
Show the user the `OVERALL`, the `TOTAL` with dimension scores, and the findings grouped by
severity. Lead with the Criticals. For each Critical, show the interview question it exposes —
that is the payload, not the fix.

In `critique-only` mode, skip to Step 5 (backlog everything, fix nothing).

### Step 3 — Approve the critical fixes (human gate)
Propose fixing the Critical findings. This is a gate — do not touch files until the user
confirms which Criticals to fix. They may approve all, a subset, or none. A finding they
decline stays in the backlog with a note that it was declined and why. Never fix Medium or
Low findings automatically; those are always future-iteration.

### Step 4 — Fix the approved Criticals, then re-review them
Make the approved fixes, changing only what each finding calls for — do not regenerate the
project and do not touch the `STRONGEST PARTS`. Preserve what already works.

Then spawn a fresh `staff-ds-reviewer` scoped to confirm the approved Criticals actually
closed (pass it the specific findings and the changed files). For each: closed, partly
closed, or still open. If a fix opened a new Critical, surface it — do not silently loop on
it; report it and let the user decide whether to run another pass.

### Step 5 — Backlog the rest
Write the Medium and Low findings — plus any Critical the user declined or that remains open —
to `<project>/REVIEW-BACKLOG.md`. Each entry keeps its severity, the fix, and the interview
question it exposes, so a future session can pick it up cold. If the file exists, update it:
keep still-open items, mark closed ones done, don't duplicate.

### Step 6 — Present the outcome
Show a short close-out:

```
## Project reviewed: <project> (<mode>)

Score: <total>/100
Verdict: <reviewer's one-line verdict>

Criticals fixed & verified:
- <finding> — now closed
Criticals left open (with reason):
- <finding> — <declined / still open / new>
Backlogged for future iteration: <n> medium, <n> low → <project>/REVIEW-BACKLOG.md

Top interview questions to be ready for:
- <the sharpest question the review exposed>
- <the next one>
```

Keep the reviewer's raw output available if asked, but do not dump it by default.

---

## Notes
- The `STRONGEST PARTS` list is load-bearing: it tells the fix step what not to break. Honor it.
- Cost: one reviewer call for the review, one scoped call to verify the fixes. `critique-only`
  is a single call.
- Do not run this on a project that is still mid-build — it is for work that is nominally done
  and about to be shown or defended. For pre-build methodology, use `/improve-plan`.
- The rubric is fixed on purpose. If it consistently rewards the wrong thing, edit `rubric.md`
  rather than arguing with the reviewer per-run.
- Pairs naturally with the portfolio: a project that passes this cleanly is ready for
  `/portfolio-updater`; one that doesn't tells you exactly what to fix first.
