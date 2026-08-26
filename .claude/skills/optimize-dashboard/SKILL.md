---
name: optimize-dashboard
description: Measure-first performance pass on a slow data-heavy dashboard — React, Python API, DuckDB. Use when a page, table, chart, filter, or query is slow or heavy. Not for functional bugs — use /systematic-debugging for those.
argument-hint: "the slow interaction, e.g. 'portfolio table takes 3s to sort'"
allowed-tools: Read, Glob, Grep, Bash, Edit, Write
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: medium
  tags: [performance, dashboard, duckdb, react]
---

# Optimize a Data-Heavy Dashboard

The "second pass" after a feature works: the page is correct but slow to load or laggy to
interact with. This skill makes it fast **without guessing and without breaking behavior**.

Adapted from wwwazzz/optimize-data-heavy-skill (methodology retained; recipes rewritten for
this workspace's stack: React + Python API + DuckDB).

**The one rule: measure before touching code, and re-measure after.** The most expensive
mistake in performance work is fixing the thing that *looked* slow instead of the thing that
*was* slow.

---

## Invariant: speed is never bought with functionality

Every change must be behavior-preserving. Hard constraints, not trade-offs:

- **Same data, same rows, same order, same totals.** If a computation is replaced (e.g. pandas
  aggregation pushed into DuckDB SQL), pin it with a test asserting the new output equals the
  old across several inputs.
- **No feature loss.** Don't drop a filter, column, or drill-down to make code simpler. Cap the
  *default view* if needed, but keep the full dataset reachable.
- **No silent data hiding.** A capped view must say "showing 25 of 1,100" with an accurate total.
- **Chart fidelity stays.** Downsample with min-max or LTTB (preserves peaks/troughs), never
  blind every-Nth (drops spikes). Keep tooltips, axes, interactivity.
- **If the only speedup you can find removes functionality, stop and raise it** — there is
  almost always a higher rung on the ladder (cache, precompute, index) that preserves behavior.

---

## The methodology (in order)

### 0. Baseline — get ONE number
Reproduce the exact slow interaction and capture the metric that decides success (ms to
interactive, bytes on the wire, query ms). Take it **cold** (fresh process / cache cleared) AND
**warm** (second run). A big cold/warm gap → caching is the lever. Flat slow warm → the
per-request work itself is the problem. Write the number down; it is what step 4 must move.

Measure the *current* state — a stale note saying "endpoint X is unoptimized" may already be
half-fixed.

### 1. Localize — which layer owns the time?

| Bucket | How to measure |
|---|---|
| **Server** (query + Python) | `curl -s -o NUL -w "%{time_starttransfer}s TTFB, %{time_total}s total\n" <url>` — if TTFB dominates, it's the backend |
| **Transfer** (payload size) | `curl -s -o NUL -w "%{size_download} bytes\n"` with and without `-H "Accept-Encoding: gzip"` |
| **Client render** | React DevTools Profiler — what re-rendered on the interaction, and how long? |
| **Fetch orchestration** | Network panel — same URL firing multiple times per load, or refetching on tab-switch/back-nav? |

Rule of thumb: curl fast + browser slow → render or fetch orchestration. curl slow → DuckDB or
Python. Both fast but first load heavy → payload/bundle.

Within the server bucket, split query vs Python: time the DuckDB query alone
(`EXPLAIN ANALYZE SELECT ...` in the DuckDB CLI, or `time.perf_counter()` around the
`conn.execute`), then compare to total handler time. The gap is Python-side shaping
(pandas ops, serialization, per-row loops).

### 2. Rank by impact (Amdahl)
Fix the dominant cost first. Don't optimize a 20ms step next to a 400ms step. Note deferred
wins explicitly in a triage list so they aren't lost.

### 3. Fix at the highest rung on the ladder

1. **Don't do the work** — precompute (materialized summary table refreshed on data load),
   serve from cache, or don't fetch what the view doesn't show.
2. **Do it once and share** — memoize/`functools.lru_cache` the expensive scan; coalesce
   concurrent identical requests; key the cache on *data inputs only*, never on
   presentation params (sort/order/page), so six sort buttons share one computation.
3. **Do less** — aggregate in DuckDB, `SELECT` only needed columns (DuckDB is columnar —
   projection pruning is a real win), cap/paginate rows, downsample chart series to the
   pixel width actually rendered.
4. **Do it in the right place** — aggregation and sorting belong in SQL, not pandas, not JS.
   DuckDB aggregating 500k rows is almost always faster than shipping them to pandas or the
   browser. `GROUP BY` + window functions in DuckDB beat `df.groupby` on the same data.
5. **Do it faster** — rewrite the query (check `EXPLAIN ANALYZE` for row-count explosions in
   joins), convert row-wise pandas `.apply` to vectorized ops, use a dict/Set lookup instead
   of a list scan.
6. **Off the critical path** — load the visible tab's data first, lazy-fetch hidden tabs on
   focus, background-refresh stale caches.
7. **Send less / render less** — enable gzip on the API (FastAPI `GZipMiddleware` /
   Flask-Compress), return numbers not pre-formatted strings, virtualize long tables
   (`react-window`), `React.memo` heavy rows, don't render hidden charts.

DuckDB-specific notes (differs from Postgres advice you'll find online):
- DuckDB rarely needs manual indexes for analytics — it's a columnar vectorized engine; the
  usual wins are projection pruning, filter pushdown, and not round-tripping through pandas.
- Prefer one `conn.execute(...).arrow()` / `.pl()` / `.df()` returning the final shaped result
  over pulling raw rows and shaping in Python.
- For repeated dashboard aggregates, `CREATE TABLE summary AS SELECT ...` at ingest time beats
  caching in the API layer — the precompute lives with the data.

React / client-fetch notes:
- Derived data (filtered/sorted arrays) belongs in `useMemo`, not `useState` + effect.
- Sort/filter clicks that trigger network calls for data the client already has → sort/filter
  client-side on the cached result, or fix the cache key server-side.
- Dedup in-flight requests and cache across navigation (React Query / SWR, or a small
  in-flight map). Cancel stale requests with `AbortController` on fast re-clicks.

### 4. Verify with the SAME measurement
Re-run step 0's exact measurement, cold and warm. Confirm the number moved. Check a sibling
path didn't regress (a cache-key change, a memo gone stale, a downsample that dropped a
real spike).

### 5. Guard against regression
Add a test that **fails without the fix** — and prove it by reverting the fix once. A guard
test that passes either way (asserting on a field identical in both seed rows) is worse than
no test. For behavior-equality pins, feed both old and new paths the same reference inputs.

---

## Fast triage (symptom → first check)

| Symptom | Likely cause | First check |
|---|---|---|
| Sort/filter lags, no network call | Uncapped list re-render; derived state in state | React Profiler: what re-rendered? |
| Sort/filter is slow AND hits network | Presentation params in cache key, or client refetching data it has | Is the cache keyed on data inputs only? |
| Chart janky with many points | Thousands of SVG nodes; animations on | Point count vs pixel width; downsample |
| curl slow, CPU spikes | Shaping in pandas that belongs in DuckDB; row-wise `.apply` | Time query alone vs handler total |
| Slow cold, fine warm | No cache / no request coalescing | Add cache at rung 2; check concurrent-cold behavior |
| First load downloads MBs | No gzip; over-fetching columns; pre-formatted strings | curl size with/without `Accept-Encoding: gzip` |
| Same URL fires N× per load | No client dedup / cache-across-navigation | Count identical requests in Network panel |
| Aggregates recomputed per request | No precompute | Summary table at ingest time |

---

## Output Format

Finish every pass with a before/after note wherever the project records changes (PR body or
status doc):

```
| Interaction | Before (cold/warm) | After (cold/warm) | The lever |
|---|---|---|---|
```

Plus: the regression guard test added, and the deferred-wins triage list. For multi-file
changes, run a review pass (code-reviewer or python-reviewer agent) before committing.
