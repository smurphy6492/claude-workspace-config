---
name: systematic-debugging
description: Structured 4-phase debugging process. Use when facing a bug, unexpected behavior, or failed test. Works for Python, JavaScript, SQL, pipelines, and data issues.
argument-hint: "describe the bug or error message"
allowed-tools: Read, Glob, Grep, Bash, WebSearch
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: medium
  tags: [debugging, python, testing, quality]
---

# Systematic Debugging

A disciplined 4-phase process. Complete each phase before moving to the next — don't jump to fixes.

---

## Phase 1: Reproduce
**Gate: Can you make the bug happen reliably?**

- Get exact error message and stack trace
- Identify the minimal inputs that trigger the bug
- Confirm the bug exists on the current codebase (not a stale state)
- Document: environment, inputs, expected behavior, actual behavior

✅ Exit when: bug reproduces consistently with known inputs

---

## Phase 2: Isolate
**Gate: Have you narrowed the problem to a specific function, line, or data condition?**

- Remove irrelevant code paths
- Binary search through the call chain — where does behavior first diverge from expected?
- For data bugs: which column, row, or transformation produces the wrong value?
- Add temporary logging or assertions to narrow the location

✅ Exit when: you can point to the exact file, function, or condition causing the issue

---

## Phase 3: Root Cause
**Gate: Do you understand WHY the bug occurs?**

- Explain the bug in plain English before touching code
- Check for: off-by-one, null/undefined, type mismatch, race condition, stale cache, wrong assumption about data
- Search documentation if the behavior is from a library or API
- Identify whether this is a code bug, a data bug, or a design bug

✅ Exit when: you can predict exactly what will happen if you make a specific change

---

## Phase 4: Fix & Verify
**Gate: Does the fix resolve the root cause without breaking anything else?**

- Make the minimal change that addresses the root cause
- Re-run the reproduction case — confirm it passes
- Run the full test suite
- Check for similar bugs in nearby code (same pattern elsewhere?)
- Remove any temporary debugging code

✅ Exit when: bug is resolved, tests pass, debug code removed

---

## Special Patterns

### Data / Pipeline Bugs
1. Print the shape and sample of data at each transformation step
2. Check for nulls, unexpected types, and duplicate keys at each stage
3. Verify the source data matches what you assumed

### API / Network Bugs
1. Log the raw request and raw response
2. Check status codes and error response bodies
3. Test with curl or httpx directly before debugging application code

---

## Output: Debug Report

```
## Debug Report

**Bug:** [one sentence description]
**Reproduction:** [minimal steps to reproduce]
**Root Cause:** [plain English explanation of why]
**Fix:** [what was changed and why]
**Verification:** [how you confirmed it's fixed]
**Related Concerns:** [any similar issues spotted nearby]
```

---

## Anti-Patterns

| Don't | Do Instead |
|---|---|
| Change multiple things at once | One change at a time |
| Skip reproduction | Always reproduce first |
| Google the error before isolating | Isolate first, then research |
| Add print statements everywhere | Binary search — narrow first |
| Assume the obvious cause | Prove the root cause before fixing |
