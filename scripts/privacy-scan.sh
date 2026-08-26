#!/usr/bin/env bash
# Privacy scan for the public config mirror.
#
# The authoritative copy of the patterns. The pre-commit hook, CI, and /sync-config all
# call this — do not re-type the patterns anywhere else, or they will drift.
#
#   scripts/privacy-scan.sh                 scan staged changes (pre-commit)
#   scripts/privacy-scan.sh <base>..<head>  scan a commit range (CI)
#
# Exit 0 clean, 1 on any hit.

set -uo pipefail

# Enumeration: known private subjects. Extend when a new private project starts.
KNOWN='geo-lift|IBKR|vanguard|robinhood|layoff|laid off|job.search|investment.?tracker|ecommerce-churn|chess.?coach|senra|true.?class|anduril|deepgram'

# Structural: identity, machine paths, credentials — matched by shape, not by name.
# This is what catches leaks nobody thought to enumerate.
STRUCTURAL='Sean Murphy|smurphy|[A-Za-z]:.Users|/home/[a-z]|/Users/[a-z]|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}|api[_-]?key|secret|token|password|ghp_|\bsk-[A-Za-z0-9_-]{8,}'

# This script and its workflow quote the patterns literally, so scanning them always hits.
EXCLUDE=(':(exclude)scripts/privacy-scan.sh' ':(exclude).github/workflows/privacy-scan.yml')

if [ $# -gt 0 ]; then
  DIFF=$(git diff "$1" -- . "${EXCLUDE[@]}")
  WHAT="$1"
else
  DIFF=$(git diff --cached -- . "${EXCLUDE[@]}")
  WHAT="staged changes"
fi

# Only added lines can leak; removals are the fix, not the problem.
ADDED=$(printf '%s\n' "$DIFF" | grep -E '^\+' | grep -vE '^\+\+\+')

fail=0
for spec in "known private subjects:$KNOWN" "structural (identity / paths / credentials):$STRUCTURAL"; do
  label=${spec%%:*}
  pattern=${spec#*:}
  hits=$(printf '%s\n' "$ADDED" | grep -inE "$pattern" || true)
  if [ -n "$hits" ]; then
    echo "PRIVACY SCAN — $label"
    printf '%s\n' "$hits" | sed 's/^/    /'
    echo
    fail=1
  fi
done

if [ "$fail" -eq 1 ]; then
  cat <<'MSG'
Blocked: the added lines above look like private content for a PUBLIC repo.

  - A private project name that leaked into otherwise-generic tooling → genericize it.
  - An absolute path carrying a username → replace with <workspace-root> or similar.
  - A real credential → remove it and rotate.

If the local content is load-bearing and cannot be genericized, sanitize this copy only
and note the divergence in the PR body so the next sync re-sanitizes.

Override only with a deliberate `git commit --no-verify`, and know why.
MSG
  exit 1
fi

echo "privacy scan: clean ($WHAT)"
