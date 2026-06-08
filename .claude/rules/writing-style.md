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

- **Direct** — lead with what matters. No throat-clearing preambles.
- **Specific** — name tools, decisions, numbers. Vague claims are worse than none.
- **Confident but honest** — state what was built and what it does. Acknowledge limitations without hedging everything.
- **Human** — first person where natural. Not corporate passive voice.
- **Technical when needed** — don't simplify for the sake of simplifying. The audience is technical.

---

## AI Writing Tropes to Avoid

LLMs produce recognizable patterns. This workspace generates a lot of text through Claude. Actively avoid these tells.

### Banned Vocabulary

These words are overused in AI-generated text and should almost never appear in this workspace's writing. Use plain, specific alternatives instead.

| Avoid | Write Instead |
|---|---|
| delve / delve into | explore, examine, look at, dig into |
| leverage (as verb) | use |
| utilize | use |
| foster | build, encourage, support |
| garner | get, earn, attract |
| pivotal | important, key (or just say why it matters) |
| crucial / vital | important (or remove — if it's obviously important, don't say so) |
| tapestry | (remove entirely — it's always metaphorical filler) |
| vibrant | (be specific about what makes it lively) |
| robust | strong, reliable, thorough |
| meticulous / meticulously | careful, thorough (or just show the care in the description) |
| intricate / intricacies | complex, detailed (or describe the actual complexity) |
| landscape (abstract) | space, field, area, world (or just name the thing) |
| showcase (verb) | show, demonstrate, display |
| underscore / highlight / emphasize | show, reveal, prove (or let the fact speak for itself) |
| testament (to) | proof, evidence, sign (or remove — usually filler) |
| enduring | lasting, persistent (or remove) |
| groundbreaking | (remove — let the reader decide) |
| bolstered | strengthened, supported |
| nestled | located, situated (or just say where it is) |
| interplay | interaction, relationship |
| encompasses | includes, covers |
| Additionally, | (start the sentence without it) |
| Furthermore, | (start the sentence without it) |
| Moreover, | (start the sentence without it) |

### Structural Patterns to Avoid

**"Not just X, but Y" / "Not only X, but also Y"**
This is the single most recognizable AI writing pattern. Rewrite as a direct statement.

- Bad: "This isn't just a config repo — it's a showcase of multi-agent orchestration."
- Good: "This repo shows how I orchestrate Claude Code as a multi-agent team."

**"Not X, but Y" framing**
Avoid constructions that sound like they're correcting a misconception the reader never had.

- Bad: "The goal isn't to replace analysts. It's to multiply them."
- Better: "The goal is to multiply what one analyst can do."

**Rule of three**
AI loves grouping things in threes, especially with parallel structure. Vary list lengths. Two items is fine. Four is fine. Don't default to three.

**Superficial analysis via present participle ("-ing") phrases**
Don't attach vague significance claims to the end of sentences.

- Bad: "The system uses typed contracts between agents, ensuring reliability across the pipeline."
- Good: "The system uses typed contracts between agents. Without them, hallucinated field names silently break pipelines."

**"Despite X, Y" challenge-then-optimism pattern**
Don't end sections with "Despite these challenges, [subject] continues to [positive thing]." If there are real limitations, state them plainly.

**Undue emphasis on significance and legacy**
Don't tell the reader something is important, significant, or transformative. Show what it does and let them judge.

- Bad: "This represents a significant shift in how analytics teams operate."
- Good: "One analyst with this setup produces the output of a four-person team."

**Vague attributions**
Don't attribute claims to unnamed experts, observers, or industry reports. Either cite specifically or state it as your own view.

**Elegant variation / thesaurus syndrome**
Don't cycle through synonyms to avoid repetition. If you said "agents" in the last sentence, say "agents" again. Don't switch to "personas" then "specialized workers" then "autonomous entities."

### Style Patterns to Avoid

- **Excessive em dashes** — one per paragraph maximum. Use commas or periods instead.
- **Excessive boldface** — bold is for headings and key terms on first use, not for emphasis in body text.
- **Title Case in body text** — only capitalize proper nouns and headings.
- **Curly quotes** — use straight quotes and apostrophes in all files.

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

- One sentence per line in source (for cleaner diffs)
- Headings: `##` for sections, `###` for subsections. Don't skip levels.
- Lists: use `-` for unordered, `1.` for ordered
- Code: use backticks for inline code, triple backticks with language for blocks
- Links: `[text](url)` — descriptive text, not "click here"
- No trailing whitespace
- One blank line between sections
