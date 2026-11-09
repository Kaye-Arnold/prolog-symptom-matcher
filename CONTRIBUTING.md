# Contributing

## Required workflow

1. Read `CLAUDE.md` and the authoritative documents under `docs/`.
2. Use a GitHub issue for substantial work and identify the relevant project stage.
3. Create a focused branch; never commit directly to `main`.
4. Keep changes scoped to the issue.
5. Run the relevant checks locally when SWI-Prolog is available.
6. Complete the pull-request template, including exact commands and honest results.
7. Obtain at least one team review before merging.
8. Update project documentation and traceability with the same change.

## Branch names

Use `stage-N/short-description`, `fix/short-description`, `test/short-description`, or `docs/short-description`.

## Commit names

Use concise messages such as:

- `docs: clarify Stage 1 scope`
- `feat: add condition-symptom facts`
- `test: cover unknown symptom input`
- `fix: preserve tied candidate matches`

## Review requirements

A reviewer must check:

- correctness and completeness of the Prolog;
- alignment with `docs/Project.pdf` and the approved scope;
- meaningful use of required logic-programming concepts;
- source provenance for medical knowledge;
- absence of diagnostic, triage, treatment, or probability claims;
- valid handling of invalid and boundary inputs;
- actual test evidence rather than expected output presented as fact;
- updated documentation and traceability;
- absence of secrets and unnecessary personal information.

## Evidence rules

- “Expected” means reasoned about but not executed.
- “Verified” means actually executed, with the command and result recorded.
- A CI badge or successful scaffold check is not evidence of medical validity or complete application functionality.
- Do not fabricate execution, citations, approvals, or team contributions.

## Project stage

The repository now contains a review-branch Prolog implementation, executable PLUnit suites, source documentation, a report, and a presentation deck. Its four-condition scope and console interface remain proposed pending team/lecturer review. Local Linux evidence is recorded in `docs/test-report.md`; Windows re-verification of this revision, the required Google Drive video, human review, and final submission remain pending. The earlier snapshot code did run on Windows (user-confirmed; see `docs/historical-evidence-index.md`), but do not apply those historical records to the current source. Application completion must be judged from executable behavior and the requirement traceability, not from file names alone.
