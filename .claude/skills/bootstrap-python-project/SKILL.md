---
name: bootstrap-python-project
description: Scaffold a new Python project with complete modern tooling, or harden an existing project that is missing standard setup. Creates pyproject.toml, ruff, mypy, pytest, pre-commit, and a clean directory structure.
argument-hint: "new <project-name> | harden"
allowed-tools: Read, Write, Edit, Glob, Bash
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: medium
  tags: [python, scaffold, tooling, setup]
---

# Bootstrap Python Project

Two modes: `new` (scaffold from scratch) or `harden` (add missing tooling to existing project).

---

## Mode: new `<project-name>`

### Step 1 — Create Directory Structure
```
<project-name>/
├── src/
│   └── <project_name>/
│       └── __init__.py
├── tests/
│   └── __init__.py
├── pyproject.toml
├── Makefile
├── .pre-commit-config.yaml
├── .env.example
├── .gitignore
└── README.md
```

### Step 2 — pyproject.toml
```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "<project-name>"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = []

[project.optional-dependencies]
dev = [
    "ruff>=0.4",
    "mypy>=1.10",
    "pytest>=8.0",
    "pytest-cov",
    "pre-commit",
]

[tool.ruff]
line-length = 88
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B", "SIM"]
ignore = []

[tool.mypy]
strict = true
python_version = "3.11"

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "--cov=src --cov-report=term-missing"
```

### Step 3 — Makefile
```makefile
.PHONY: install lint type-check test check clean

install:
	pip install -e ".[dev]"
	pre-commit install

lint:
	ruff check . --fix && ruff format .

type-check:
	mypy src/

test:
	pytest

check: lint type-check test

clean:
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
```

### Step 4 — .pre-commit-config.yaml
```yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.4.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.10.0
    hooks:
      - id: mypy
        additional_dependencies: []
```

### Step 5 — .gitignore
```
__pycache__/
*.pyc
.env
.venv/
dist/
.mypy_cache/
.ruff_cache/
.pytest_cache/
htmlcov/
*.egg-info/
```

### Step 6 — Verify
Run and confirm:
```bash
pip install -e ".[dev]"
pre-commit install
make check
```

---

## Mode: harden

### Step 1 — Audit
Check for missing components:
- [ ] `pyproject.toml` (vs setup.py / setup.cfg)
- [ ] `ruff` configured
- [ ] `mypy` configured
- [ ] `pytest` configured
- [ ] `pre-commit` installed
- [ ] `.gitignore` adequate

### Step 2 — Add What's Missing
Only add what is not present. Don't overwrite existing config.

### Migration Notes
- `setup.py` → `pyproject.toml`: extract name, version, dependencies
- `black` + `isort` → `ruff`: ruff handles both; remove black/isort from pre-commit and deps
- `flake8` → `ruff`: ruff is a superset; remove flake8

---

## Output: Summary Table

```
## Bootstrap Summary: <project-name>

| Component | Status |
|---|---|
| Directory structure | ✅ Created |
| pyproject.toml | ✅ Created |
| Makefile | ✅ Created |
| pre-commit config | ✅ Created |
| .gitignore | ✅ Created |
| make check | ✅ Passes |
```
