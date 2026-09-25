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
│   ├── __init__.py
│   └── test_smoke.py
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
    # These are the ONLY tool versions in the project: the pre-commit hooks run
    # the installed ruff/mypy (language: system), so there is no hook rev to drift.
    "ruff>=0.15",
    "mypy>=1.10",
    "pytest>=8.0",
    "pytest-cov",
    "pre-commit",
]

[tool.ruff]
line-length = 88
target-version = "py311"

[tool.ruff.lint]
# E/F pycodestyle+pyflakes, I import order, UP pyupgrade, B bugbear, SIM simplify,
# N pep8-naming, PTH use-pathlib, T20 no-print. This set makes the conventions in
# rules/python-style.md machine-enforced rather than prose.
select = ["E", "F", "I", "UP", "B", "SIM", "N", "PTH", "T20"]
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
.PHONY: install format lint type-check test check clean

install:
	pip install -e ".[dev]"
	pre-commit install

# `check` must never modify files, or CI and local runs disagree. Fixing lives here.
format:
	ruff check . --fix && ruff format .

lint:
	ruff check . && ruff format --check .

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
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
  # ruff and mypy run from the project's own environment, not pinned hook repos.
  # Pinned revs (ruff-pre-commit, mirrors-mypy) drifted from what `make check`
  # installs three separate times; version mismatch made the two gate layers fight
  # (I001 import-sort loops, contradictory mypy errors). One version source: pyproject.
  - repo: local
    hooks:
      - id: ruff-check
        name: ruff check
        entry: ruff check --fix
        language: system
        types: [python]
      - id: ruff-format
        name: ruff format
        entry: ruff format
        language: system
        types: [python]
      # Same scope as `make type-check` (src/ only). A per-file mypy hook would also
      # type-check tests/, silently widening enforcement past what CI checks.
      - id: mypy
        name: mypy (src)
        entry: mypy src/
        language: system
        pass_filenames: false
        files: ^src/
```

The hooks need the dev tools installed, so run `make install` (inside the project's venv)
before the first commit. That is also what arms the hook.

For markdown and SQL linting on top of this base, run `/add-gates` — it deploys the
`markdownlint` + straight-quotes + `sqlfluff` hooks and their configs (kept out of the Python
scaffold so pure-Python repos don't pull in a Node/SQL toolchain they don't need).

### Step 4b — tests/test_smoke.py
pytest exits 5 when it collects no tests, which fails `make check` on a brand-new project.
Ship one real test so the gate starts green:

```python
import <project_name>


def test_package_imports() -> None:
    assert <project_name>.__name__ == "<project_name>"
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
.coverage
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
- Pinned `ruff-pre-commit` / `mirrors-mypy` hooks → the `repo: local` hooks above. Check the
  pinned revs against the installed versions first and say which drifted. Arming mypy on a repo
  that ran unarmed can surface real errors; scope it to `src/` like `make type-check` rather
  than silently widening it to `tests/`.

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
