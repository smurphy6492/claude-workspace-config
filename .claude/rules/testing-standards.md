# Testing Standards

What a test must check to be worth keeping. `mechanical-gates.md` makes tests run;
this rule is about which tests to write. A test that only restates the code costs
maintenance and catches nothing.

> Partly a model-weakness patch: agents over-produce tests written after the code,
> one assertion per trivial property. Re-test this rule when the model changes; if
> generated suites stop looking like the bad example below, cut the last two sections.

---

## The expected value must come from outside the code

A test earns its place only if its expected value has a source other than running
the code under test:
- a hand calculation or an independent reference (a source system's own report,
  a known dataset answer),
- a spec or business rule,
- a real bug that happened,
- a failure-mode list written before the code.

If the only way you know the expected value is that the code produced it, the test
locks in whatever the code does, bugs included.

Good: the expected values were computed by hand before the code existed
```python
def test_monthly_revenue_matches_hand_calculation(sample_orders):
    result = monthly_revenue(sample_orders)
    assert result["2025-03"] == pytest.approx(EXPECTED["revenue_2025_03"])  # hand-computed fixture
```

Bad: restates a template, one test per substring
```python
def test_summary_contains_customer_name():
    assert "Acme" in render_summary(_facts(customer="Acme"))

def test_summary_contains_total():
    assert "120.00" in render_summary(_facts(total="120.00"))
```

---

## Prefer end-to-end tests on fixtures with known answers

The default test runs the real path, from input file or request to output number or
response, on a small fixture whose correct answers are recorded next to it. One such
test replaces dozens of unit tests and survives refactors. Its output (a row count, a
reconciled total, a snapshot) is the repeatable artifact that proves the feature works.

Write a unit test only for logic that is hard to reach end to end: edge cases in a
parser, rounding, date boundaries, concurrency.

---

## Testing in isolation: write the failure modes first

Before writing code for a component tested on its own, list the specific ways it
could be wrong: which input, which wrong output. Then write tests for those. The list
is the spec, as in a fault catalog of injected mutations the check must catch.

---

## What not to write

- Tests that assert a constant, a template string, or a default equals itself
- One test per field or substring where one assertion on the whole output would do
- Tests whose only assertion is that the function returns without raising
- A test updated to match new output without asking whether the old output was right

---

## Existing suites

Don't mass-delete existing tests. When a test that restates the code breaks during a
change, delete it or fold it into a known-answer test instead of updating its
assertion, and say so in the commit body.
