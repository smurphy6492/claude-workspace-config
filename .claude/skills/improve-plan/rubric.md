# Plan Quality Rubric

A fixed rubric for scoring an implementation plan, tuned for code and data/analytics work
(the dominant planning in this workspace). Score each dimension out of its maximum, sum to
a total out of 100, and for every dimension list the specific, actionable weaknesses that
cost it points. Judge only against these dimensions; do not reward length or polish.

The weaknesses matter more than the number. Write each as the concrete thing to fix ("the
recursive backtest reads test-period actuals into lag features, so the reported error is
optimistic"), not a vague observation ("backtesting could be improved").

A plan can be well-structured and still be wrong. Dimensions 1–3 carry most of the weight
because a complete, specific, nicely-sequenced plan that proposes a leaky backtest or an
unfair benchmark is worse than useless — it looks trustworthy and isn't.

---

## 1. Correctness & feasibility — 20 points
Will the approach work as specified with the named stack and constraints? Penalize
technically wrong steps, APIs or tools used incorrectly, impossible orderings, and
assumptions that don't hold.

## 2. Domain & methodology soundness — 25 points
Would a senior practitioner in this plan's specific domain endorse the technical approach?
This dimension **cannot be reduced to a checklist**. The failures that matter are specific
to the domain, the data, and the method, and the most damaging one in any given plan is
usually not on any list written in advance. The judge's job here is to *be the expert*, not
to tick boxes.

Reason from first principles for THIS plan, before consulting the archetypes below: what
does a correct result in this domain require, and where could this specific approach quietly
produce a plausible-but-wrong one?

The archetypes below illustrate the *kind, specificity, and severity* of finding expected.
They are a floor for calibration, not the spec — the highest-value weakness is often a
domain-specific one none of them names:
- **Leakage / temporal integrity** — using information not available at decision time
  (future actuals in features, fitting through the forecast origin, look-ahead joins, target leakage).
- **Validated against nothing, or unfairly** — no ground truth or fair baseline; comparisons
  that aren't apples-to-apples; a result that looks good only because regularization shrank it toward the answer.
- **Easier than reality** — synthetic data, given-true parameters, or a convenient split that
  makes the modeled problem simpler than the deployed one, without saying so.
- **Wrong or mismatched metric** — the metric doesn't measure the real question (MAPE on
  intermittent demand, accuracy on imbalanced classes, a point metric for a decision that needs intervals).
- **Unaccounted bias or confounding** — causal claims from observational data with no
  identification strategy; selection, survivorship, or simultaneity ignored.
- **Miscalibrated uncertainty** — intervals emitted but never checked for coverage.

For software-engineering plans, apply the equivalent expert lens with the same
first-principles stance (concurrency/race safety, error handling and retries,
data-structure fit, migration and rollback safety, idempotency, anti-patterns).

If, reasoning as the domain expert, you judge the approach sound, say so — do not
manufacture a methodology problem to fill the section.

## 3. Completeness — 20 points
Does it address every requirement, including the hard parts and the table-stakes steps for
this kind of work? Penalize hand-waving on the difficult pieces, unhandled failure modes,
and requirements silently dropped. The harder a requirement, the more its omission costs.

## 4. Specificity & actionability — 15 points
Could a developer execute this without coming back to ask what was meant? Penalize vague
steps, missing file paths, undefined "configure X" instructions, and implicit decisions.
Reward concrete files, commands, and named choices.

## 5. Risk, unknowns & scope discipline — 10 points
Two failure modes, penalize both. Under-reaching: a plan that names no real risks, no
genuine unknowns, and nothing that could break existing behavior. Over-reaching: a plan
that gold-plates — extra abstractions, components, or defensive handling beyond what the
task asked for. Reward an honest "this is the part most likely to fail, here's the
fallback" and a scope matched to the request.

## 6. Sequencing & verifiability — 10 points
Is the work phased so each step leaves a working state, and does each phase say how to
verify it succeeded? Penalize a flat task dump, phases that can't be checked, and an
ordering that forces a half-broken intermediate state. (For pure analysis plans, read
"working state" as "a checkpoint whose output you can sanity-check before building on it.")

---

## Scoring guide
- 90-100: ready to execute; weaknesses are minor polish.
- 70-89: sound but with real gaps a reviewer would want closed first — often a methodology
  gap, since those don't show up in structure.
- 50-69: the shape is right but a developer would hit ambiguity, a missing piece, or a
  methodological landmine mid-build.
- below 50: incomplete, partly infeasible, or methodologically unsound.
