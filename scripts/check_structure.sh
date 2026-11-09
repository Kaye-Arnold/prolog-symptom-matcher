#!/usr/bin/env bash
set -euo pipefail

required_files=(
  CLAUDE.md
  README.md
  CONTRIBUTING.md
  docs/Project.pdf
  docs/assignment-requirements.md
  docs/snapshot-assessment.md
  docs/stage-1-proposal.md
  docs/task-board.md
  docs/knowledge-representation.md
  docs/sources.md
  docs/traceability-matrix.md
  docs/test-plan.md
  docs/test-report.md
  docs/source-register.md
  docs/user-guide.md
  docs/final-report.md
  docs/submission-checklist.md
  docs/limitations.md
  docs/implementation-notes.md
  docs/windows-setup.md
  presentation/project-presentation.pptx
  presentation/demonstration-script.md
  presentation/oral-defense-notes.md
  presentation/presentation-outline.md
  scripts/build_presentation.py
  scripts/check_presentation.py
  scripts/requirements-presentation.txt
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
