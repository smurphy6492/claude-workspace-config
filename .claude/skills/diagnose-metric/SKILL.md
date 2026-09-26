---
name: diagnose-metric
description: Investigate why a business metric moved — confirm the change is real, size it against normal variation, decompose it into drivers, and rank causes by evidence. Use when someone asks "why did X go up/down", a KPI looks off, or a dashboard number changed unexpectedly. If the cause turns out to be broken code or a broken pipeline, hand off to /systematic-debugging.
argument-hint: "<metric> <change> <period> [data source]  e.g. \"weekly active users down 8% last week, events table in acme.duckdb\""
allowed-tools: Read, Glob, Grep, Bash, Write
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: medium
  tags: [analytics, metrics, root-cause, sql]
---

# Diagnose Metric

Explain why a metric moved, with evidence a skeptical stakeholder would accept, or say
plainly that it didn't really move. The deliverable is a ranked set of causes, each backed
by a query result, plus the checks that would confirm or kill the leading one.

## Instructions

The order of the first three steps is load-bearing: each one can end the investigation,
and decomposing a change that isn't real produces a confident story about noise.

1. **Pin down the metric.** Find its actual definition (SQL, dbt model, dashboard
   calc, or docs) and write it out: numerator, denominator, filters, grain, timestamp
   that assigns a row to a period. If there is no written definition, say so and state
   the one you are using. Reproduce the reported number. If you can't match it, the
   discrepancy is the finding. Stop and report it.
2. **Rule out artifacts.** Check that the change isn't produced by the data itself:
   late-arriving or incomplete data for the latest period, pipeline or load failures,
   duplicate or dropped rows, a definition or filter change, a tracking or instrumentation
   change, timezone and calendar boundaries (partial weeks, holidays, month length). An
   artifact is a complete answer. Report it and stop.
3. **Size the change.** Compare against the same period last year or last cycle, the
   trailing baseline, and the normal week-to-week spread. If the move is inside normal
   variation, say so and stop. Don't decompose noise.
4. **Decompose.** Split the change across the dimensions that could plausibly drive it
   (segment, region, channel, product, customer tier, cohort). For ratio metrics,
   separate **mix** (the population shifted) from **rate** (behavior within segments
   changed), because they point to different fixes. Check that segment contributions
   sum to the total change; if they don't, the decomposition is wrong.
5. **Look for causes outside the data.** Launches, pricing changes, outages, campaigns,
   seasonality, and upstream process changes. Check whatever the repo, changelogs or
   the user can supply. A driver segment is not a cause. "Enterprise accounts fell"
   still needs a why.

Write every query you rely on to a file next to the report so each number can be rerun.
Never state a number you didn't query. Label anything inferred as a hypothesis.

## Output Format

A markdown report (`diagnosis-<metric>-<date>.md` beside the queries), leading with the answer:

- **Verdict** — one or two sentences: real or artifact, size versus normal variation,
  and the leading cause with a confidence level (high / medium / low).
- **Definition used** — the metric as computed, and whether it matched the reported number.
- **Artifacts checked** — each check and its result, one line each.
- **Drivers** — table of segment contributions (mix vs rate for ratio metrics) that
  sums to the total change.
- **Ranked causes** — each with its evidence (query file + result) and what would
  disprove it.
- **Next checks** — the two or three queries or questions that would most change the
  confidence, including anything that needs a person (who shipped what, when).
- **Caveats** — data gaps and definitional ambiguity a reader must know before acting.
