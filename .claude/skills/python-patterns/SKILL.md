---
name: python-patterns
description: Python best practice reference guide. Use when writing new Python code, reviewing patterns, or deciding between approaches. Covers naming, types, data structures, error handling, async, and API patterns.
argument-hint: "topic: types | async | error-handling | api | data-structures"
allowed-tools: Read
metadata:
  version: "1.0"
  tier: platform-knowledge
  freedom: low
  tags: [python, patterns, reference, best-practices]
---

# Python Patterns Reference

---

## Naming
```python
# Variables and functions: snake_case
user_count = 0
def get_active_users(): ...

# Classes: PascalCase
class UserRepository: ...

# Constants: UPPER_SNAKE_CASE
MAX_RETRY_COUNT = 3

# Private/internal: _leading_underscore
def _validate_input(value): ...
```

---

## Type Hints
```python
from __future__ import annotations

# Basic types
def greet(name: str) -> str: ...

# Optional (Python 3.10+)
def find_user(user_id: int) -> User | None: ...

# Collections
def process(items: list[str]) -> dict[str, int]: ...

# Callable
def apply(fn: Callable[[int], str], value: int) -> str: ...
```

---

## Data Structures

Prefer structured types over bare dicts:

```python
# Good: dataclass
from dataclasses import dataclass

@dataclass
class PipelineResult:
    rows_processed: int
    errors: list[str]
    duration_seconds: float

# Good: Pydantic for validation
from pydantic import BaseModel

class ApiResponse(BaseModel):
    status: str
    data: list[dict]
    total: int
```

---

## Error Handling

```python
import logging
logger = logging.getLogger(__name__)

# Good: specific exception, with context
try:
    response = client.get(url, timeout=10)
    response.raise_for_status()
except httpx.TimeoutException:
    logger.error("Timeout fetching %s", url)
    raise
except httpx.HTTPStatusError as e:
    logger.error("HTTP %d from %s", e.response.status_code, url)
    raise

# Bad: bare except
try:
    do_thing()
except:  # ❌ catches everything including KeyboardInterrupt
    pass
```

---

## Functional Patterns

```python
# List comprehension over map/filter for simple cases
evens = [x for x in numbers if x % 2 == 0]

# Generator for large sequences (lazy evaluation)
def read_chunks(file_path: Path) -> Generator[str, None, None]:
    with open(file_path) as f:
        for line in f:
            yield line.strip()

# functools.partial for partial application
from functools import partial
add_tax = partial(apply_rate, rate=0.08)
```

---

## Resource Management

```python
# Always use context managers for I/O
with open(path, "r") as f:
    content = f.read()

# For multiple resources
with open(input_path) as fin, open(output_path, "w") as fout:
    fout.write(fin.read())
```

---

## File Paths

```python
# Good: pathlib
from pathlib import Path

data_dir = Path("data")
output_file = data_dir / "results" / "output.json"
output_file.parent.mkdir(parents=True, exist_ok=True)

# Bad: string concatenation
path = "data" + "/" + "results" + "/" + "output.json"  # ❌
```

---

## Environment & Config

```python
import os
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.environ["API_KEY"]  # Raises if missing — good
DEBUG = os.getenv("DEBUG", "false").lower() == "true"  # With default
```

---

## Async Patterns

```python
import asyncio
import httpx

# Concurrent fetches
async def fetch_all(urls: list[str]) -> list[dict]:
    async with httpx.AsyncClient() as client:
        tasks = [client.get(url) for url in urls]
        responses = await asyncio.gather(*tasks)
        return [r.json() for r in responses]

# Don't block in async functions
async def bad_example():
    time.sleep(5)  # ❌ blocks the event loop
    await asyncio.sleep(5)  # ✅ async-friendly
```

---

## Imports
- Standard library → third-party → local (ruff handles ordering)
- No wildcard imports: `from module import *` ❌
- Import what you use — no unused imports
