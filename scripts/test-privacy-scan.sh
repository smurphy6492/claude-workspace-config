#!/usr/bin/env bash
# Regression tests for the privacy-scan patterns.
#
# The patterns are read out of privacy-scan.sh rather than re-typed, so this file
# cannot drift from the thing it tests. Run it directly, or let CI run it:
#
#   bash scripts/test-privacy-scan.sh
#
# Exit 0 all pass, 1 on any failure.
#
# Note: this file necessarily contains strings shaped like leaks, so privacy-scan.sh
# excludes it from scanning. Every fixture below is synthetic — never paste a real
# credential, path, or address here.

set -uo pipefail
cd "$(dirname "$0")/.."

# Read the authoritative pattern definitions. Nothing is re-typed.
eval "$(grep -E '^(KNOWN|STRUCTURAL)=' scripts/privacy-scan.sh)"
PATTERN="$KNOWN|$STRUCTURAL"

# Must be caught. A miss here means a real leak would reach the public repo.
MUST_BLOCK=(
  'sk-ant-api03-abcdefghijklmnop'
  'sk-proj-abc123def456ghi789'
  'ghp_abcdefghijklmnopqrstuvwxyz0123'
  'write to someone@example.com for access'
  'stored under C:\Users\jdoe\project'
  'lives in /home/alice/notes'
  'lives in /Users/bob/notes'
  'set ANTHROPIC_API_KEY before running'
  'the api-key goes in the env file'
  'keep this secret'
  'refresh token expired'
  'reset your password'
  'geo-lift readout for the quarter'
  'the investment tracker dashboard'
  'chess coach opening drills'
  'parsed the IBKR statement'
)

# Must pass. A hit here is a false positive that blocks legitimate content —
# how the sk-/Flask- bug was found.
MUST_PASS=(
  'enable Flask-Compress on the API'
  'the analyst-desk frontend'
  'task-runner configuration'
  'risk-adjusted returns by cohort'
  'a disk-based cache layer'
  'sit at the desk-height default'
  'npm run build && npm run lint'
  'ruff check . && mypy src/'
  'sk-ab'
  'DuckDB projection pruning and filter pushdown'
)

pass=0; fail=0

for s in "${MUST_BLOCK[@]}"; do
  if printf '%s\n' "$s" | grep -qiE "$PATTERN"; then
    pass=$((pass+1))
  else
    echo "  FAIL  not caught, but should be:  $s"
    fail=$((fail+1))
  fi
done

for s in "${MUST_PASS[@]}"; do
  if printf '%s\n' "$s" | grep -qiE "$PATTERN"; then
    echo "  FAIL  false positive, should pass:  $s"
    fail=$((fail+1))
  else
    pass=$((pass+1))
  fi
done

if [ "$fail" -gt 0 ]; then
  echo
  echo "privacy-scan pattern tests: $fail failed, $pass passed"
  echo "A pattern change broke detection or started blocking real content. Fix the"
  echo "pattern in scripts/privacy-scan.sh — do not delete the failing fixture."
  exit 1
fi

echo "privacy-scan pattern tests: $pass passed"
