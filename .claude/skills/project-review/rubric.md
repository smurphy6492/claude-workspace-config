# Project Review Rubric

A fixed rubric for reviewing a finished data/analytics project as a staff/senior DS hiring
manager. Score each dimension out of its maximum, sum to a total out of 100, and for every
dimension list the specific findings that cost it points, tagged by severity. Judge only
against these dimensions; do not reward length or polish.

The findings matter more than the number. Write each as the concrete thing to fix and the
interview question it exposes ("the writeup reports a 12% MAPE but the code computes it on
the training window, so an interviewer will ask what your held-out error was and you have no
answer"), not a vague observation ("the evaluation could be stronger").

Dimensions 2 and 6 carry the most weight together, because a project that looks polished but
rests on shaky methodology — or that the candidate cannot defend under questioning — is
exactly the one that fails in the room.

---

## 1. Problem framing & business value — 15 points
Is the problem real, well-scoped, and worth solving? Does the project make clear what
decision or outcome it serves, and for whom? Penalize toy problems dressed up as production
work, framing that a stakeholder wouldn't recognize as their actual question, and analysis
that never connects to a business consequence. Reward a sharp problem statement that a hiring
manager reads and thinks "yes, that's a real job."

## 2. Technical & methodological soundness — 25 points
Would a senior practitioner in this project's specific domain endorse the approach? This
dimension **cannot be reduced to a checklist**. Reason from first principles for THIS project
before consulting the archetypes: what does a correct, defensible result require here, and
where could this specific work quietly produce a plausible-but-wrong one?

The archetypes below illustrate the kind, specificity, and severity of finding expected —
a floor for calibration, not the spec:
- **Leakage / temporal integrity** — future information in features, fitting through the
  forecast origin, look-ahead joins, target leakage across a split.
- **Validated against nothing, or unfairly** — no held-out ground truth, no fair baseline,
  comparisons that aren't apples-to-apples, a metric computed on data the model saw.
- **Wrong or mismatched metric** — the metric doesn't measure the real question (MAPE on
  intermittent demand, accuracy on imbalanced classes, a point metric for an interval decision).
- **Unaccounted bias or confounding** — causal claims from observational data with no
  identification strategy; selection, survivorship, or simultaneity ignored.
- **Miscalibrated uncertainty** — intervals emitted but never checked for coverage.
- **The claim the code doesn't support** — a headline number in the writeup that the code
  either doesn't produce or produces under conditions the writeup doesn't state.

The most damaging finding is usually a domain-specific one none of these names. Be the
expert. If the approach is genuinely sound, say so — do not manufacture a problem.

## 3. Code quality & production-readiness — 15 points
Would this survive contact with a real codebase and a real production setting? Look for
reproducibility (does it run for someone other than the author), structure, tests on the
logic that matters, error handling, and the absence of hand-tuned magic numbers and dead
paths. A one-off notebook can still score here if it is clean and reproducible; penalize
work that only runs on the author's machine, or that would need a rewrite before anyone could
deploy or trust it.

## 4. Communication & stakeholder narrative — 15 points
Read the README, case study, and any website/portfolio copy. Could a non-technical
stakeholder understand what was done and why it matters? Does the narrative translate the
model into a decision, and is it honest about what the work does and doesn't show? Penalize
jargon with no translation, buried business value, and — worst — a confident narrative over
methodology that doesn't support it. Reward writing that a hiring manager could forward to a
VP without editing.

## 5. Completeness & rigor — 15 points
Is anything key missing? Validation, sensitivity or robustness checks, stated assumptions,
honest limitations, and the table-stakes steps for this kind of work. Penalize hand-waving on
the hard parts, limitations that are absent or hedged into meaninglessness, and requirements
silently dropped. An honest, specific limitations section raises this score; its absence
lowers it.

## 6. Interview defensibility — 15 points
Could the candidate defend every meaningful decision in this project under sharp questioning?
For each central choice — the model, the metric, the data, the validation, the tradeoffs —
is there a real reason the candidate could articulate, or would they stall? Penalize choices
that look like defaults with no rationale, numbers the candidate couldn't derive on a
whiteboard, and any gap between "what the project says" and "what the candidate would have to
admit when pressed." This is the dimension that most directly predicts the interview outcome.

---

## Scoring guide
- 90-100: advance without reservation; findings are polish. A strong portfolio centerpiece.
- 70-89: advance with reservations; real gaps a hiring manager would want closed first —
  often methodology or defensibility, which don't show up in a surface read.
- 50-69: the shape is right but an interviewer would find a hole that the candidate can't
  currently defend, or the work wouldn't hold up in production.
- below 50: not yet ready to show; a central claim is unsupported, the methodology is unsound,
  or the work doesn't reproduce.
