# Repomix Snapshot Recovery and Assessment

**Purpose:** Record what was recovered from
`/tmp/arena-coding-uploads/repomix-output.xml`, how it was checked against the
repository scaffold and authoritative `docs/Project.pdf`, and which historic
claims are kept separate from current verification.

**Snapshot SHA-256:** `6b0cb75000ca898e7a8e0793ec124d5cf9fd30a008741c74ac8b698cbd6971df`

**Assignment PDF SHA-256:** `2a19423500688dfeb95a1e07463009b54ce6df3edef95af41cff8982010f93e9`
(the upload copy and `docs/Project.pdf` are byte-identical).

## 1. Recovery and integrity checks

The Repomix text was reconstructed in the new temporary directory
`/tmp/repomix-reconstructed-5p0wwrg4/`; the snapshot itself and reconstructed
files are not added to Git. The extraction was a data-recovery step, not an
execution of its code. The reconstructed tree and path metadata were checked:

- 18 file entries, all unique and relative;
- no absolute paths, `.`/`..` traversal components, duplicate paths, missing or
  extra reconstructed files, or symlinks;
- Repomix itself notes that binaries, Git metadata/history, ignored files, and
  some other paths are not represented. The PDF is therefore kept from the
  separate upload/repository copy, not recovered from the XML.

The historic Prolog suite was run only after extraction, as a separate
verification action, with SWI-Prolog 10.0.2 on Linux. That historical run had 57
declarations and 179 passing executions. It is not a test of the current `src/`
application and does not constitute a current Windows run.

## 2. Recovered snapshot inventory

The snapshot holds a root-level Prolog package: `knowledge_base.pl`,
`symptom_logic.pl`, `symptom_console.pl`, `symptom_matcher.pl`, `run_tests.pl`,
`tests/test_symptom_matcher.pl`, and three Windows batch launchers. Documentation
includes a README and source, implementation, limitations, Windows, and test
records. The source/test design has meaningful facts, rules, retrieval, list
processing, exact fractions, tie handling, CLI, and PLUnit coverage; this was a
substantive prototype, not merely empty scaffold files.

Not recovered as part of the 18-file snapshot: the scaffold's `.github` workflow
and templates, `CLAUDE.md`, `CONTRIBUTING.md`, the authoritative `Project.pdf`,
Git history, raw demo/test transcripts linked by the README, and a separate Stage
1 proposal, final report, presentation deck, or Google Drive video link. The
README links to three Linux `.log` files that are absent from the packed and
reconstructed tree.

`evidence/source-register.md` duplicated `docs/source-register.md`; the current
repository maintains a single editable register at `docs/source-register.md`.

## 3. Assessment against the scaffold and assignment PDF

The PDF is authoritative. Its assessed concepts and submission expectations are
summarised in [`assignment-requirements.md`](assignment-requirements.md); the
base scaffold commit is `cd57a3dae79845b04f996deba72ecdbb8a976353`. The PDF does
not state a 100-point value, a deadline, a fixed illness set, or a required
console interface. The 9 November 2026, 23:59 EAT deadline is user-provided.
The four-condition domain and console remain proposed pending human review.

| Requirement / concern | Snapshot evidence | Assessment and treatment in current branch |
|---|---|---|
| Stage 1: problem, objectives, scope and suitability | README describes a bounded four-profile set comparison; no standalone proposal is in the 18-file tree. | A separate Stage 1 proposal is documented; scope, illness set, and console interface remain pending review. |
| Stages 2-3: facts, predicates, knowledge base, rules and retrieval | Root-level `knowledge_base.pl` and `symptom_logic.pl` contain a source-linked knowledge base and inference logic. | Reorganised into `src/knowledge_base.pl` and `src/inference.pl`; executable retrieval examples are in `queries/demonstration_queries.pl`. |
| Stage 4: unification and backtracking | Retrieval and Prolog predicates use unification and alternative solutions. | Demonstrated by runnable query examples and mapped to assignment requirements. |
| Stage 5: recursion and lists | The snapshot processes and compares symptom lists. | Current recursive list predicates and edge cases are covered by integrated PLUnit tests. |
| Stage 6: arithmetic and comparison | Snapshot compares exact fractions, preserves ties, and has a detailed explanation of denominator trade-offs. | Retained as an application-only rule, using exact cross multiplication and explicit limits; not a probability or clinical measure. |
| Stage 7: integrated application, input/output and testing | Snapshot has a console, batch launchers, a test runner, and 57 declarations. | Current modules and runner are integrated under `src/`; local Linux run and negative controls are recorded in `test-report.md`. |
| Qualification and duplicate identity | Snapshot stores influenza `cough` and separate `dry_cough` feature facts, despite the WHO phrase “cough (usually dry)”; its README reports eight influenza features. | Current code stores one canonical `cough` with `usually_dry`; `dry_cough` is an alias. Tests ensure entering both cannot double-count. |
| Safety boundary | Snapshot has `danger_sign/1`, `danger_reported/2`, a dedicated danger block, and the text “Seek care now.” | Those instructions were not carried forward: they are emergency/urgency advice and violate the user's explicit boundary. Current tests prohibit emergency/urgency output. Source qualifications remain data only. |
| Medical source qualifications | Snapshot keeps several qualifiers, but some severe malaria terms are listed without a `severe` qualification. | Current source facts preserve source-supported qualifiers, with provenance recorded in `docs/source-register.md`; no triage behavior is inferred from them. |
| Stage 8: report, presentation, demonstration and oral defense | Snapshot includes implementation/test documentation and demo commands, but no separate final report/deck or video link was recovered. | A substantive report, 10-slide PPTX, timed demo script, oral-defense preparation, and checklist are now present. No presentation, recording, upload, or defense is claimed to have occurred. |
| Google Drive video and human approval | No actual link, permission test, team approval, or contribution record is in the snapshot. | All remain explicitly pending; no names, roles, approvals, recording, or link have been invented. |

## 4. Historical claims and evidence limits

The user confirms that the code represented by the Repomix snapshot was run
locally on an actual Windows machine before this integration. The preserved
historical test report describes SWI-Prolog 10.0.2 on Windows, with 57 test
declarations and 179 passing executions, and records demo, interactive, and
batch-launcher runs. This is historical Windows execution for the earlier
root-level snapshot, not for the current `src/` implementation.

The linked raw Linux logs and `win-tests.txt` are absent from the recovered tree;
Git history is also absent. The preserved report also contradicts itself in
places: earlier status text says the suite had not run on Windows, while later
sections record the resolved result (an exit-1 invocation caused by a mangled
filename, then a clean `RESULT: PASS`, exit 0, with 57 declarations and 179
passing executions). The user's confirmation that the snapshot codebase ran on a
real Windows machine matches the later sections. Thus the historical record is
preserved, and the user-confirmed fact of local Windows execution is
acknowledged, but the raw Windows transcript cannot be independently
re-inspected here. The detailed snapshot documents are preserved byte-for-byte as
`docs/historical-test-report.md`, `docs/windows-run-record.md`, and
`docs/diagnose-windows.md`, indexed with hashes in
[`historical-evidence-index.md`](historical-evidence-index.md). The separately
rerun historic Linux suite is not conflated with the current integrated suite.

The old README also contains scope and medical-safety choices that are not
requirements merely because they appear in the snapshot. In particular, the
instruction “Seek care now” was removed, and the separate dry-cough fact was
replaced with a single source-qualified cough feature. The current test report
and source register describe the resulting code and its actual evidence.

## 5. Current evidence and open work

Current integrated local testing and demo/query evidence are in
[`test-report.md`](test-report.md). The present revision has Linux x86_64
SWI-Prolog 10.0.2 evidence; the current integrated source has not been run on
Windows. Formal scope/team review, oral defense, recording and uploading the
required Google Drive video, permission testing, and final course submission
remain pending. See [`submission-checklist.md`](submission-checklist.md).
