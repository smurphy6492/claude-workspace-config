---
paths:
  - "**/*.py"
---

# Python Style Guide

Conventions for Python code in this workspace.

---

## Formatting & Tooling
- **ruff** for linting and formatting (replaces black + isort + flake8)
- **mypy** for static type checking
- **pytest** for tests
- Line length: 88 characters (ruff default)
- Run `ruff check . --fix && ruff format .` before committing

---

## Type Hints
- Required on all function signatures
- Use `from __future__ import annotations` for forward references
- Prefer `str | None` over `Optional[str]` (Python 3.10+ union syntax)
- Use `TypeAlias` for complex repeated types

```python
# Good
def get_user(user_id: int) -> dict[str, str] | None:
    ...

# Bad
def get_user(user_id, user_name):
    ...
```

---

## Naming
- `snake_case` for functions, variables, modules
- `PascalCase` for classes
- `UPPER_SNAKE_CASE` for module-level constants
- `_leading_underscore` for private/internal
- Be descriptive — `user_count` not `n`, `order_date` not `dt`

---

## Functions & Structure
- Functions do one thing
- Keep functions short — if it needs a comment to explain what it does, consider splitting
- No mutable default arguments:
  ```python
  # Bad
  def add_item(items=[]):

  # Good
  def add_item(items: list | None = None):
      if items is None:
          items = []
  ```
- Use `pathlib.Path` for file paths (not `os.path` string manipulation)
- Use f-strings for string formatting (not `.format()` or `%`)

---

## Data Structures
- Use dataclasses or Pydantic models for structured data (not bare dicts)
- Use `TypedDict` when a dict interface is required
- Prefer named tuples over plain tuples for returned pairs/triples

---

## Error Handling
- Be explicit — catch specific exceptions, not bare `except:`
- Include context in error messages
- Use `logging` not `print` for operational output

```python
# Good
try:
    response = client.get(url, timeout=10)
    response.raise_for_status()
except httpx.TimeoutException:
    logger.error("Request to %s timed out", url)
    raise
```

---

## Imports
- Standard library → third-party → local (ruff handles this automatically)
- No wildcard imports (`from module import *`)
- Avoid circular imports — restructure if needed

---

## Environment & Config
- All configuration via environment variables
- Use `python-dotenv` for local development
- Never hardcode API keys, secrets, or environment-specific values

---

## Testing
- Tests live in `tests/` mirroring the `src/` structure
- Test file naming: `test_<module>.py`
- Follow Arrange-Act-Assert pattern
- See `/python-testing` skill for full testing guide
