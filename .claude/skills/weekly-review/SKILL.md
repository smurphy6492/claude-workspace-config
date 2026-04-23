---
name: weekly-review
description: Generate a strategic weekly brief across all active projects. Reads session progress, git history, and plans — then produces a high-level summary and to-do focused on strategic decisions, not tactical minutiae. Use at the start of each week or when stepping back from detailed work.
argument-hint: "(no args needed — run /weekly-review)"
allowed-tools: Read, Glob, Grep, Bash, Write
metadata:
  version: "1.0"
  tier: business-logic
  freedom: medium
  tags: [review, strategy, planning, weekly]
---

# Weekly Review

Produces a strategic brief — not a replay of what happened, but a translation of detailed work into what matters for direction and decision-making.

---

## Instructions

### Step 1 — Establish the Date

Note today's date. The brief will be saved as `weekly-briefs/YYYY-MM-DD.md` in the workspace root.

---

### Step 2 — Gather Signals

Read the following in parallel:

1. **`SESSION-GUIDE.md`** — which sessions changed status since last review? What is blocked?
2. **`FUTURE-IDEAS.md`** — any backlog items that are now more or less relevant given recent work?
3. **All `PLAN.md` files** under `projects/` — what phases are in flight or completed?
4. **Git history** — run `git log --oneline --since="8 days ago"` in each directory under `projects/` that is a git repo. Capture commit messages — these are the ground truth of what shipped.
5. **`weekly-briefs/`** — read the most recent brief (if one exists) to understand what last week's priorities were and whether they were addressed.

Do not summarize raw commit messages or session details verbatim — extract meaning from them.

---

### Step 3 — Write the Strategic Brief

Write to `weekly-briefs/YYYY-MM-DD.md` using this structure:

```markdown
# Weekly Brief — YYYY-MM-DD

## What Shipped (and Why It Matters)
[2-4 bullets. Not what changed — why it matters strategically.
e.g. "Site is now live on Netlify with auto-deploy — removes manual deployment friction for all future iterations"]

## What's In Flight
[Active work with honest assessment of progress and any risks]

## Blockers & Decisions Needed
[Anything that cannot move forward without a decision or external action.
Be specific about what decision is needed and who needs to make it.]

## Recommended Focus This Week
[3-5 prioritized items. Lead with highest-leverage work.
Explain briefly why each is the right priority now, not just what it is.]

## Strategic Questions
[3-5 sharp questions worth sitting with. These are not to-dos —
they are prompts for stepping back and thinking about direction.
Examples: "Is the analytics agent the right second portfolio project, or would a live data pipeline demo be more differentiated?"]

## To-Do List
- [ ] [Specific, actionable item — include project context]
- [ ] ...
```

---

### Step 4 — Deliver the Brief

1. Print the full brief to the conversation so the user can read it immediately.
2. Confirm the file was saved to `weekly-briefs/YYYY-MM-DD.md`.
3. End with this prompt for the user:

> **To engage Strategic Brain mode:** Open a new Claude session and paste:
> *"Act as a strategic thinking partner. Here is my weekly brief — ask me sharp questions, challenge my priorities, and help me think about what matters most. Don't summarize what I've written back to me."*
> Then paste the **Strategic Questions** section.

---

## Output Format

- A saved markdown file at `weekly-briefs/YYYY-MM-DD.md`
- Full brief printed inline in the conversation
- Strategic Brain prompt at the end
