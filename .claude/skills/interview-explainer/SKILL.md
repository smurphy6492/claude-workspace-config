---
name: interview-explainer
description: First-principles HTML walkthrough of a finished project or technique — motivation, math, real code, and an interview Q&A layer, grounded in the actual implementation rather than a textbook version. Use when prepping to defend a project or method in a technical interview.
argument-hint: "<project> [technique or concept to focus on] [--md]"
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, WebSearch, WebFetch
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: low
  tags: [interview-prep, explanation, portfolio, teaching]
---

# Interview Explainer

Take a finished project — or one technique inside it — and produce a walkthrough
that teaches it from first principles: what problem it solves, the math or theory
underneath, how the actual code implements it, how it was used in context, and the
questions an interviewer will ask with crisp answers. The output is a
self-contained HTML document you can study and return to.

The goal is two things at once: to be able to **explain it in depth in an
interview**, and to **genuinely understand it** — not memorize a script. The
difference shows the moment an interviewer asks a follow-up, so the explainer
builds real intuition, not talking points.

This is the companion to `/project-review`: the review tells you what you can't
yet defend; this teaches you to defend it.

---

## The one rule that makes this good

**Explain THIS implementation, grounded in the real code and the real numbers —
not a generic textbook version of the technique.**

An interviewer is looking at *your* project. They will ask why *your* code does
what it does, what *your* numbers mean, and where *your* approach is weak. A
generic explanation of conformal prediction or Bayesian MMM is worthless in that
room; it is the gap between the textbook and your actual code that gets probed.
So read the source before writing a word, cite real files and functions, and
trace the project's real data through to its real output. If the implementation
diverges from the textbook (a shortcut, a simplification, an assumption), that
divergence is the most important thing to explain — it is exactly what gets
challenged.

---

## Inputs

- **A project** — a path under `projects/`, a repo, or a name you can resolve.
- **Optionally, a technique or concept to focus on** — e.g. "conformal
  calibration", "the funnel-mediated MMM", "the churn model's feature pipeline".
  With a focus, deep-dive that one thing. Without one, explain the project's
  central method(s). If the project has several distinct methods and no focus is
  given, ask which one before generating — a shallow tour of everything is less
  useful than a deep dive on the thing you'll be asked about.
- **Assumed reader:** you, smart but relatively new to this specific technique,
  preparing for a senior/staff-level interview. Pitch accordingly — build
  intuition first, never assume the jargon is already understood, but do not
  condescend on the fundamentals of your own field.

Default output is a self-contained HTML file. Pass `--md` for Markdown instead.

---

## Procedure

### Step 1 — Scope and read the real implementation
Resolve the target. Then read deeply before explaining anything:
- The code that implements the technique — the actual functions, the data flow,
  the key lines. Not just the README's description of them.
- The math or statistical method as the code actually applies it (a fitted
  parameter, a calibration step, a loss, a test) — read what the code computes,
  not what you assume it computes.
- Docs, notebooks, and any case-study writeup for the intended narrative.
- The real outputs: the numbers, plots, or results the project produced, so the
  worked example can use them.

If the technique is unfamiliar or the math is subtle, verify the standard
formulation against an authoritative source (search official docs or a canonical
reference) so the first-principles section is correct — then reconcile it with
what the code does.

### Step 2 — Build the explanation from first principles
Construct the arc a newcomer needs: motivation → intuition → formalism → this
code → worked example → defense. Build intuition before notation; motivate every
formula before showing it. Prefer a concrete worked example with the project's
real numbers over abstract description.

### Step 3 — Generate the document
Write the HTML (or Markdown) with the section structure below. Self-contained:
inline CSS, and if it uses math, render it cleanly (MathJax from CDN, or clean
HTML notation — never raw unrendered LaTeX). Teaching voice: direct, plain, no
filler. Follow the workspace writing style — avoid the AI tropes in
`writing-style.md` even here.

### Step 4 — Accuracy pass (do not skip)
Re-read the source and verify the document against it:
- Every math claim: is the formula right, and does the code actually do this?
- Every code citation: does that file, function, and behavior exist as described?
- Every number in the worked example: does it match the project's real output?
- The interview answers: is each one true, and would it survive a follow-up?

Fix anything that does not hold. A confident, wrong explanation is worse than
none — it teaches you to walk into a trap. If a claim can't be verified against
the code or a source, either correct it or mark it plainly as your interpretation.

For high-stakes math you want a second set of eyes on, you can spawn a fresh
agent to check the derivation cold — but the accuracy pass above is required, the
agent is optional.

### Step 5 — Present
Write the file (default `<project>/interview-prep/<slug>-explainer.html`, creating
the directory). Then give a short summary: what it covers, and the two or three
sharpest interview questions it prepares you for — especially any the source made
clear you currently couldn't answer.

---

## Document structure

The explainer contains these sections, in order:

1. **The 60-second answer** — how you'd respond to "walk me through this" at the
   top of an interview. One tight paragraph. Everything below builds the depth to
   back it up.
2. **The problem it solves** — why this technique exists, what goes wrong without
   it, why the project needed it. Motivation before mechanism.
3. **First principles** — build the concept from the ground up for someone new.
   Intuition and a plain-language picture before any formula.
4. **The math / theory** — the actual method, each formula motivated before it
   appears, with a small concrete numeric example. Only the math this project
   uses; no tangents.
5. **How it's implemented here** — walk the real code. Name the files and
   functions, show the key lines, trace the data flow, and tie each piece of the
   theory to where it lives in the repo.
6. **How it was used in context** — the decision or output it served, and the
   real numbers it produced.
7. **A worked example** — trace one concrete input through to output using the
   project's actual data, so the abstract becomes mechanical.
8. **The interview layer** — the questions that get asked, easy to hard, each
   with a crisp answer. Include common misconceptions, the traps, and "if they
   push deeper." Surface the questions you currently *couldn't* answer and answer
   them. This is the payload.
9. **Limitations and honest caveats** — what the implementation simplifies or
   assumes, where it's weakest, and what you'd concede under pressure. Interviewers
   probe exactly here; have the honest answer ready.
10. **Quick reference** — a compact glossary of terms and the key formulas, for
    last-minute review before you walk in.

Depth over breadth. A deep, correct explanation of one technique beats a shallow
tour of the whole project.

---

## Notes
- The accuracy of Section 4 (math) and Section 5 (code) is the whole product. If
  either is wrong, the document actively hurts you. This is why Step 4 exists.
- One technique per document. If the project has several distinct methods worth
  defending, run the skill once per method rather than cramming them together.
- Pairs with `/project-review`: review a finished project, then run this on each
  finding you couldn't defend, until you can.
- Not for code you didn't build or don't need to defend — this is interview prep,
  not general documentation. For that, write a README.
