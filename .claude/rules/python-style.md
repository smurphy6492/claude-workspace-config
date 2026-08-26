---
paths:
  - "**/*.py"
---

# Python Style Guide

Conventions for Python code in this workspace.

---

## Enforcement is the source of truth

Formatting and mechanical style are enforced by ruff + mypy, not by this document. The canonical
config is what `/bootstrap-python-project` and `/add-gates` deploy: ruff `select` covers
`E, F, I, UP, B, SIM, N, PTH, T20`, mypy runs `strict`, line length 88. Run `make check` before
committing. If a rule can be enforced by the linter, it lives in the config, not here.

The linter already enforces, so don't restate them: line length and formatting, import order,
`str | None` over `Optional`, no mutable default arguments, f-strings over `.format()`/`%`, `pathlib`
over `os.path`, snake_case / PascalCase / UPPER_SNAKE_CASE naming, no wildcard imports, no bare
`except`, no stray `print`. Let `make check` catch these.

---

## Conventions the linter can't enforce

- **Types carry meaning.** Use dataclasses or Pydantic models for structured data, not bare dicts.
  Use `TypedDict` when a dict interface is required, named tuples over plain tuples for returned
  pairs, and `TypeAlias` for complex repeated types.
- **Names describe.** `user_count` not `n`, `order_date` not `dt`. The linter enforces case, not
  meaning.
- **Functions do one thing.** If a function needs a comment to explain what it does, consider
  splitting it.
- **Errors carry context.** Catch specific exceptions and say what failed in the message; use
  `logging`, not `print`, for operational output.

```python
# Good
try:
    response = client.get(url, timeout=10)
    response.raise_for_status()
except httpx.TimeoutException:
    logger.error("Request to %s timed out", url)
    raise
```

- **Config comes from the environment.** No hardcoded keys or environment-specific values; use
  `python-dotenv` locally.

---

## Testing

Tests live in `tests/` mirroring `src/`, named `test_<module>.py`, following Arrange-Act-Assert.
