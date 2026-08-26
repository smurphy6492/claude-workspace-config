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
- **Sentence-fragment pairs.** Two clipped fragments stuck together for rhythm: "Fast. Simple." / "No fluff. Just answers." Write one real sentence instead.
- **Fake precision ranges.** "5 to 10 minutes", "a 20-30% lift". A range where a measurement exists says you never ran it. Give the number you actually have, or say you did not measure it.
- **Significance-claiming "-ing" tails.** Don't append vague import to a sentence. Bad: "…uses typed contracts, ensuring reliability across the pipeline." Good: "…uses typed contracts. Without them, hallucinated field names silently break pipelines."
- **Self-applause asides.** Standalone sentences that clap for the point just made: "And that matters." "That's the part everyone misses." "Which is exactly the point." Delete them; the sentence before survives intact.
- **Summary endings.** "In short...", "At the end of the day...", a closing paragraph that restates the piece. Stop at the last real point.
- **"Despite X, Y" challenge-then-optimism endings**, and telling the reader something is important, significant, or transformative instead of showing what it does and letting them judge.
- **Vague attributions** to unnamed experts, observers, or reports. Cite specifically or state it as your own view.
- **Elegant variation.** If you said "agents" last sentence, say "agents" again. Don't cycle through "personas", "specialized workers", "autonomous entities".
- **Punctuation and emphasis restraint.** Em dashes sparingly (about one per paragraph). Bold for headings and first-use key terms, not for body emphasis.

> These tells describe current-model tendencies, so this section is a weakness-patch with an expiry. When the model no longer over-produces this register, re-read this section and cut what it satisfies on its own. See the keep-vs-cage rule in `workflow-orchestration.md`.

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
