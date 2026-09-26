---
name: systematic-debugging
description: Structured debugging — reproduce, find the root cause, fix minimally, verify. Use when facing a bug, unexpected behavior, or failed test. Works for Python, JavaScript, SQL, pipelines, and data issues.
argument-hint: "describe the bug or error message"
allowed-tools: Read, Glob, Grep, Bash, WebSearch
metadata:
  version: "1.1"
  tier: guided-workflow
  freedom: medium
  tags: [debugging, python, testing, quality]
---

# Systematic Debugging

Reproduce the bug first, fix its root cause with the minimal change, and prove the fix.

**Done when** the reproduction case passes, the full test suite passes, and any temporary
debugging code is removed. Report it in the Debug Report format below.

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
