# Requirements Traceability Matrix

Statuses describe artifacts present in this branch and evidence actually observed.
Implementation on a review branch is not formal team/lecturer approval. Test
counts and environment are recorded in [`test-report.md`](test-report.md).

| Assignment requirement / deliverable | Artifact and evidence | Status / caveat |
|---|---|---|
| Repomix recovery and assessment against scaffold/PDF | `docs/snapshot-assessment.md`; historical evidence index | 18-file snapshot path-validated in a new temporary directory; PDF/scaffold comparison and excluded unsafe behavior recorded. Snapshot and temp files are not committed. |
| Stage 1: problem, objectives, scope, required knowledge, users, outputs, Prolog suitability | `docs/stage-1-proposal.md` | Draft present; team/scope review pending. |
| Stage 2: entities, predicates, facts, knowledge base | `src/knowledge_base.pl`; `docs/knowledge-representation.md` | Implemented with source-linked facts; scope approval pending. |
| Stage 2: working retrieval queries | `queries/demonstration_queries.pl` | Executed locally with SWI-Prolog 10.0.2; see test report. |
| External sources acknowledged | `docs/sources.md`, `docs/source-register.md`, `source/5` | Four official pages retrieved and checked on 2026-11-09; mappings and limits recorded. |
| Stage 3: rules and inference from facts | `src/inference.pl`; tests | Implemented and tested locally; not clinical inference. |
| Stage 4: unification and multiple solutions/backtracking | `queries/demonstration_queries.pl`; `list_conditions/1`, `conditions_for_symptom/2` | Executed query examples; `findall/3` collects alternative unifications. |
| Stage 5: recursion and list operations | `normalise_all/2`, `dedupe_acc/3`, `count_occurrences/3`, set operations | Implemented and covered by PLUnit tests. |
| Stage 6: arithmetic and comparison | `coverage_fraction/3`, `ranking/2`, `by_score/3` | Exact cross-multiplication; no floating-point ranking and no medical interpretation. |
| Stage 6: negation as failure or cut where appropriate | `unknown_terms/2`; CLI argument parser | NAF is limited to finite-vocabulary membership; cut only commits explicit CLI form. |
| Stage 7: validation and interaction | `src/interface.pl` | Console, empty/unknown/no-match/invalid API input behavior, duplicates, ties, disclaimer. |
| Stage 7: integration and major-predicate tests | `tests/test_knowledge_base.pl`, `tests/test_inference.pl`, `tests/test_integration.pl` | Linux SWI-Prolog 10.0.2: 64 declarations, 180 passing executions, zero failed/timeouts/blocked/fixme, exit 0. This revision not reverified on Windows; the earlier snapshot's Windows run is historical evidence only. |
| CI executes tests and rejects empty suite | `.github/workflows/prolog-checks.yml`, `tests/run_tests.pl` | CI runs the positive-evidence runner when suites are declared; local mutation, missing-suite, and empty-suite controls are recorded in the test report. **Gap:** the scaffold step would skip if all suites were removed; the hardening patch needs GitHub App `workflows` permission. GitHub Actions run `42581411921` on head `f7d860f` was observed as success (step-level conclusions; PR #2). |
| Stage 8: complete final report | `docs/final-report.md` | Substantive report included; no word count or report format is stated in the PDF. |
| Stage 8: presentation deliverable | `presentation/project-presentation.pptx`; outline and notes | PPTX generated and structurally validated; no live presentation is claimed. |
| Feature demonstration and timed script | `presentation/demonstration-script.md` | Real commands/observed Linux snippets and recording instructions included. No recording exists. |
| Test cases and results | `docs/test-plan.md`, `docs/test-report.md` | Current run and negative controls recorded. Historical snapshot reports are labelled and separated. |
| Technical documentation and user instructions | `docs/knowledge-representation.md`, `docs/implementation-notes.md`, `docs/user-guide.md`, `docs/windows-setup.md` | Present and aligned to current code. |
| Limitations and future improvements | `docs/limitations.md`, report | Bounded scope, no clinical validity, no advice outputs, and platform gaps documented. |
| Oral defense | `presentation/oral-defense-notes.md` | Slide-by-slide notes and preparation prompts provided; human defense pending. |
| Google Drive video link | `presentation/demonstration-script.md`, submission checklist | **Pending:** no recording, upload, permissions check, or link is claimed. |
| Team details, roles, approval | Proposal and task board | **Pending human confirmation**; not inferred from commit identity. |
| Final course submission | Task board/checklist | **Pending**; no submission confirmation is recorded. |

## Evidence-quality rule

A planned artifact, a successful structure check, a historical record, or a
zero-test process exit is not proof of current application behavior. The report
identifies exact current commands, interpreter, platform, source commit, observed
results, and unverified work separately.
