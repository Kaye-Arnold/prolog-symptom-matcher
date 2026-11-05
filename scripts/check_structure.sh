#!/usr/bin/env bash
set -euo pipefail

required_files=(
  CLAUDE.md
  README.md
  CONTRIBUTING.md
  docs/Project.pdf
  docs/assignment-requirements.md
  docs/stage-1-proposal.md
  docs/task-board.md
  docs/knowledge-representation.md
  docs/sources.md
  docs/traceability-matrix.md
  docs/test-plan.md
  docs/user-guide.md
  docs/final-report.md
  .github/PULL_REQUEST_TEMPLATE.md
)

for file in "${required_files[@]}"; do
  if [[ ! -s "$file" ]]; then
    echo "Missing or empty required file: $file" >&2
    exit 1
  fi
done

if git ls-files | grep -E '(^|/)\.env(\..*)?$' | grep -Ev '(^|/)\.env\.example$'; then
  echo "Potential environment-secret file is tracked. Remove it before pushing." >&2
  exit 1
fi

echo "Repository structure checks passed. This does not verify application functionality or medical validity."
