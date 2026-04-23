---
name: python-testing
description: pytest guide and testing patterns for Python projects. Use when writing tests, setting up test infrastructure, or deciding how to test a specific piece of logic.
argument-hint: "describe what you need to test"
allowed-tools: Read, Write, Edit, Bash
metadata:
  version: "1.0"
  tier: platform-knowledge
  freedom: medium
  tags: [python, testing, pytest, quality]
---

# Python Testing Guide

---

## Test Structure

Follow **Arrange-Act-Assert**:

```python
def test_calculate_revenue():
    # Arrange
    orders = [{"amount": 100}, {"amount": 50}, {"amount": 25}]

    # Act
    result = calculate_revenue(orders)

    # Assert
    assert result == 175
```

---

## Naming Conventions

```python
# File: tests/test_<module>.py
# Class: Test<Feature> (optional grouping)
# Function: test_<what>_<when>_<expected>

def test_get_user_when_not_found_returns_none(): ...
def test_calculate_revenue_with_empty_list_returns_zero(): ...
def test_fetch_data_when_api_fails_raises_error(): ...
```

---

## Fixtures

```python
import pytest

@pytest.fixture
def sample_orders():
    return [
        {"order_id": 1, "amount": 100, "status": "complete"},
        {"order_id": 2, "amount": 50,  "status": "complete"},
    ]

@pytest.fixture
def api_client():
    from myapp.client import ApiClient
    return ApiClient(base_url="http://test-server")

# Fixtures can use other fixtures
@pytest.fixture
def processed_orders(sample_orders):
    return [o for o in sample_orders if o["status"] == "complete"]
```

---

## Parametrize

```python
@pytest.mark.parametrize("input,expected", [
    (0, "zero"),
    (1, "one"),
    (-1, "negative"),
    (100, "large"),
])
def test_classify_number(input, expected):
    assert classify_number(input) == expected
```

---

## Mocking

```python
from unittest.mock import patch, MagicMock

# Mock an HTTP call
@patch("myapp.client.httpx.get")
def test_fetch_data(mock_get):
    mock_get.return_value = MagicMock(
        status_code=200,
        json=lambda: {"data": [1, 2, 3]}
    )
    result = fetch_data("http://api.example.com/data")
    assert result == [1, 2, 3]

# Mock environment variables
@patch.dict(os.environ, {"API_KEY": "test-key"})
def test_uses_env_key():
    client = ApiClient()
    assert client.api_key == "test-key"
```

---

## Exception Testing

```python
import pytest

def test_raises_on_invalid_input():
    with pytest.raises(ValueError, match="must be positive"):
        calculate_revenue(amount=-1)

def test_raises_on_api_failure():
    with pytest.raises(ApiError):
        fetch_data_with_bad_url("not-a-url")
```

---

## Markers

```python
@pytest.mark.slow          # skip in quick runs: pytest -m "not slow"
@pytest.mark.integration   # requires external services
@pytest.mark.unit          # pure unit tests, no I/O
```

Register in `pyproject.toml`:
```toml
[tool.pytest.ini_options]
markers = [
    "slow: marks tests as slow",
    "integration: requires external services",
    "unit: pure unit tests",
]
```

---

## Coverage Targets

| Code Type | Target |
|---|---|
| Utility functions | 90%+ |
| Data transformations | 85%+ |
| API endpoints | 80%+ |
| Orchestration / scripts | 60%+ |

---

## What NOT to Test
- Third-party library behavior (trust the library's tests)
- Simple getters/setters with no logic
- Framework boilerplate
- Private implementation details (test the public interface)

---

## TDD Workflow

1. **Red** — Write a failing test for the new behavior
2. **Green** — Write the minimum code to make it pass
3. **Refactor** — Clean up without breaking the test
4. **Repeat**

---

## Running Tests

```bash
pytest                          # all tests
pytest tests/test_pipeline.py   # specific file
pytest -k "revenue"             # tests matching keyword
pytest -m unit                  # by marker
pytest --tb=short               # shorter tracebacks
pytest -x                       # stop on first failure
pytest --cov=src                # with coverage
```
