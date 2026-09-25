---
paths:
  - "**/*.md"
  - "**/*.txt"
  - "**/projects.ts"
---

# Writing Style Guide

Standards for all written content: case studies, READMEs, project descriptions, portfolio copy, and documentation. Applies to markdown files and any data files containing prose (e.g., project data in TypeScript).

---

## Voice & Tone

- **Direct** — lead with what matters. No throat-clearing preambles: "Here's the thing", "Let me be clear", "The truth is", "It's worth noting". Start one sentence later.
- **Specific** — name tools, decisions, numbers. Vague claims are worse than none.
- **Confident but honest** — state what was built and what it does. Acknowledge limitations without hedging everything.
- **Human** — first person where natural. Not corporate passive voice.
- **Technical when needed** — don't simplify for the sake of simplifying. The audience is technical.

---

## Don't Write in the Generic-LLM Register

The goal: copy here must not read as AI-generated, because that costs credibility with a technical hiring manager. Write plain, specific, and first-person where natural, so the prose sounds like Sean thought it rather than like a model produced it. This is about register, not a word blocklist. Judgment applies to every item below.

Avoid the generic-LLM tells:

- **Inflated diction where a plain word is exact.** Prefer "use" over "leverage/utilize", "important" over "pivotal/crucial", "show" over "showcase", "strong" over "robust", "includes" over "encompasses". A domain term is never banned: "leverage" is correct in finance, "robust" in "robust standard errors", "landscape" in ordinary prose. Use the precise word; only swap out the inflated one where a plainer word says the same thing.
- **"Not just X, but Y" / "Not only X, but also Y", and the negate-then-correct pair ("That's not compliance. That's stalling.").** The single most recognizable tell. Rewrite as a direct statement. Bad: "This isn't just a config repo, it's a showcase of orchestration." Good: "This repo shows how I orchestrate Claude Code as a multi-agent team."
- **Reflexive rule of three.** AI defaults to three parallel items. Vary list length; two or four is fine.
- **Self-applause asides.** Standalone sentences that clap for the point just made: "And that matters." "That's the part everyone misses." "Which is exactly the point." The honesty-applause variant counts too: "I'd rather show it than hide it", "I'd rather state it plainly than dress it up". Delete them; the sentence before survives intact.
- **Summary endings.** "In short...", "At the end of the day...", a closing paragraph that restates the piece. Stop at the last real point.
- **"Despite X, Y" challenge-then-optimism endings**, and telling the reader something is important, significant, deliberate, or transformative instead of showing what it does and letting them judge. Bad: "The split between me and the tooling is deliberate." "The first decision was the one that shaped everything else." Good: say what the split was, or what the decision changed.
- **Vague attributions** to unnamed experts, observers, or reports, including the straw-man opener about what other people do: "Most teams run one test and never another", "A lot of churn projects pick 90 days because it's a round number." Cite specifically, state it as your own view, or start with your own project.
- **Emphasis restraint.** Bold for headings and first-use key terms, not for body emphasis.

> These tells describe current-model tendencies, so this section is a weakness-patch with an expiry. When the model no longer over-produces this register, re-read this section and cut what it satisfies on its own. See the keep-vs-cage rule in `workflow-orchestration.md`.
>
> Re-tested 2026-09-25 on Opus 5.5: 5 projects x 2 formats (600-word README, 400-word "how it was built"), 10 drafts with this section and 10 without, two independent blind scorers. The section is still load-bearing. Clear tells fell from 49/40 (scorer 1/2) to 13/12, and the with-section draft scored lower on 10 of 10 paired prompts for scorer 1 and 9 of 10 for scorer 2 (one tie). It eliminated negate-then-correct pairs, bold body emphasis and summary endings, and cut rule-of-three and self-applause by about two-thirds. It barely moved "most teams..." generalizations or "the split is deliberate" importance claims. Fragment pairs, fake ranges, "-ing" tails, elegant variation and em dashes never appeared in either arm (0 em dashes in 20 drafts), and inflated diction appeared once. An earlier n=3 pilot on 2026-09-24 showed almost no difference, so do not re-test with fewer than about 10 drafts per arm.
>
> Follow-up the same day: the self-applause, importance and vague-attribution items gained the examples above, then this strengthened list (10 drafts) was run against a copy with fragment pairs, fake ranges, "-ing" tails, elegant variation and the em-dash clause removed (10 drafts). The shorter list scored as well or better: 3/5 clear tells against 9/8, and 18/16 borderline against 24/29. None of the removed tells appeared in the shorter-list drafts, so those items were cut. Inflated diction stays, since it appeared once and the domain-term carve-out is worth keeping.

---

## Content Patterns

### Project Descriptions
- Lead with what it does, in one sentence
- Then why it's hard or interesting (the real problem, not sanitized)
- Then how you approached it (tools, decisions, mistakes)
- Then what it demonstrates or what you learned

### Limitations
- State them plainly. Don't hedge with "while there are some areas for improvement."
- Specific limitations are more credible than vague ones.
- "Showing limitations isn't a weakness" — but only if the limitations are honest.

### How It Was Built
- Describe what actually happened, including wrong turns
- Name the specific tools and agents used
- Say what the human decided vs. what the AI executed

---

## Markdown Formatting

Mechanical formatting is enforced by `markdownlint` plus a straight-quotes check, deployed by
`/add-gates` (config in `.markdownlint.jsonc`). The linter handles heading increments, list markers,
fenced-code languages, descriptive link text, no trailing whitespace, single blank lines between
blocks, and straight quotes over curly. Don't restate those; let the gate catch them.

The one convention a linter can't enforce: **one sentence per line in source**, for cleaner diffs.
