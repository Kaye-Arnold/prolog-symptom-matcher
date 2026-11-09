# Test Report

**Scope:** Current review-branch implementation and tests; historical snapshot
evidence is kept separate.
**Run date:** 9 November 2026 (UTC; user timezone UTC).
**Verified source/test commit:** `849496339bb36d8c2860bc4b98ad19e9d66bf068`.
The full clean suite, workflow-equivalent loads, demo, queries, interactive
smoke, structure check, launcher-format check, and PPTX package check were
re-run on this clean commit on 9 November 2026. The report-only update after that
run does not change source or tests; any further code change requires a new run.
**Windows:** not run for this revision.

## Environment

- SWI-Prolog: `10.0.2`.
- Runtime executable: `/tmp/arena-swipl-runtime/node_modules/kibi-swipl-linux-x64-gnu/bin/swipl`.
- Operating system: Debian GNU/Linux 12 (bookworm), Linux x86_64, kernel
  `Linux 6.1.158+` (sandbox); this is not Windows evidence.
- Architecture: x86_64.
- Python used for optional presentation tooling: 3.11.2; `python-pptx` 1.0.2.
- Historical snapshot result (57 declarations / 179 executions) is not included
  in the integrated totals below.

## Clean integrated suite

Command (from repository root; `swipl` below refers to the executable above):

```sh
swipl -q -s tests/run_tests.pl
```

**Observed:** exit code 0; no choicepoint warnings.

```text
summary dict                    : plunit{blocked:0,failed:0,fixme:0,passed:180,timeout:0,total:64}
declarations                    : 64
passing executions              : 180
failed / timeout / blocked      : 0 / 0 / 0
fixme                           : 0
evaluation result               : pass
RESULT: PASS - 64 declarations, 180 passing executions; 0 failed, 0 timed out, 0 blocked, 0 fixme.
```

The difference between 64 declarations and 180 executions is expected: some
PLUnit declarations use `forall/2` to exercise multiple records.

## Load, application, and deliverable checks

The exact commands below were run from the repository root. `$SWI` was set to
the runtime executable listed in the environment section.

```sh
for f in src/*.pl queries/*.pl tests/test_*.pl; do
  "$SWI" -q -g "load_files(['$f']), halt"
done
bash scripts/check_structure.sh
"$SWI" -q -s src/symptom_matcher.pl -- --demo
"$SWI" -q -s queries/demonstration_queries.pl \
  -g demonstration_queries:run_query_examples -t halt
printf 'fever, headache\n\n' | "$SWI" -q -s src/symptom_matcher.pl --
PYTHONPATH=/tmp/prolog-pptx-libs python3 scripts/build_presentation.py
PYTHONPATH=/tmp/prolog-pptx-libs python3 scripts/check_presentation.py
```

| Check | Observed result |
|---|---|
| CI-equivalent module loads | exit 0; every application, query, and PLUnit source file loaded individually, matching the workflow loop |
| Repository structure | exit 0; required files present; structural evidence only |
| Full demo | exit 0; five cases; messy-input duplicate and unknown output; top tie `TIE at 3/6: [Measles,Common cold]` |
| Query examples | exit 0; retrieved four conditions; dry-cough query returned `[influenza,measles,common_cold]`; influenza qualification `[usually_dry]` |
| Interactive smoke | exit 0; parsed two unique terms, printed rankings and disclaimer, exited on empty line |
| Presentation build | exit 0; 10-slide `presentation/project-presentation.pptx` generated with `python-pptx 1.0.2` |
| Presentation package check | exit 0; XML well-formed, four external source links, required content present, all shapes within slide bounds. No office renderer was available for an independent visual-render/fit check. |

The shell variable resolves to the recorded runtime path:
`/tmp/arena-swipl-runtime/node_modules/kibi-swipl-linux-x64-gnu/bin/swipl`.

## Disposable mutation and runner-control checks

**Method:** Four fresh copies of the committed source tree at
`849496339bb36d8c2860bc4b98ad19e9d66bf068` were made under
`/tmp/prolog-ci-controls-849/`, excluding `.git` and generated/cache directories.
All edits below occurred only in these disposable copies. For data mutations,
the changed source line and pre/post SHA-256 were checked before running the
same `swipl -q -s tests/run_tests.pl` runner. The source tree in this repository
was not changed. Each command exited nonzero as required.

| Control | Confirmed mutation | Observed runner result |
|---|---|---|
| Remove source qualification | Replaced the only `condition_symptom(influenza, cough, usually_dry, who_influenza).` with qualification `plain`; SHA-256 changed from `acddc3d96077fdbd6f921505977b5fcae26df1ee878cc01c2bcc7ab076cbd2c7` to `8d5f822c30b37854479e8962c09aa189eb13b0f0db916367b0acb0e7c1fcac61`; changed line was printed before test. | exit 1; `influenza_has_one_cough_feature_with_usually_dry` failed; summary 64 declarations, 179 passing, 1 failed; `RESULT: FAIL - failed_tests(1)`. |
| Add duplicate alias feature | Added `condition_symptom(influenza, dry_cough, usually_dry, who_influenza).`; SHA-256 changed from `acddc3d96077fdbd6f921505977b5fcae26df1ee878cc01c2bcc7ab076cbd2c7` to `0c91fde4b48fbebc09c2ff96f1c2fe860e47f5b5f36221802f5b2633dccd27ac`; both cough lines were printed. | exit 1; 6 failed, 176 passed; failures included canonical feature integrity, all-facts integrity, cough qualification, duplicate alias, unknown/unmatched separation, and unmatched-term reporting; `RESULT: FAIL - failed_tests(6)`. |
| Remove required suite | Deleted `tests/test_integration.pl` from the disposable copy and confirmed the path was absent. | exit 1; source-sink load error; `RESULT: FAIL - load_failed`. |
| Remove all PLUnit suites | Replaced all three disposable `tests/test_*.pl` files with comments; confirmed no `begin_tests` declaration remained. | exit 1; summary had 0 declarations and 0 passing; `RESULT: FAIL - empty_suite`. |

These controls establish sensitivity to the targeted data invariants and runner
failure modes. They do not establish that every possible defect is detected.

## Historical and platform boundaries

A separately preserved snapshot test report records 57 declarations and 179
passing executions on Linux SWI-Prolog 10.0.2. The user confirms that the
Repomix snapshot codebase was also run locally on an actual Windows machine;
the preserved historical report records a Windows SWI-Prolog 10.0.2 run with
57 declarations and 179 passing executions. This is historical evidence for the
older root-level snapshot, not the current integrated revision. The raw
`win-tests.txt` output is absent from the recovered archive, so the narrative
record cannot be independently re-inspected here. See
[`snapshot-assessment.md`](snapshot-assessment.md) and
[`historical-evidence-index.md`](historical-evidence-index.md).

**No Windows execution of the current revision has occurred.** The official
64-bit Windows installer remains the target for re-verifying the integrated
code. The current `.bat` launchers were checked for ASCII and CRLF formatting on
Linux; that is file-format evidence, not a current Windows run.

## Continuous integration state

The committed workflow is the scaffold version: structure check, SWI-Prolog
install and source loads, then `tests/run_tests.pl` executed only when
`begin_tests` declarations exist. Because the runner halts nonzero itself, a
failing suite fails the job. Removing every suite would let that step skip and
pass — the documented gap.

A hardened step calling `swipl -q -s tests/run_tests.pl` unconditionally was
written and validated locally, but could not be pushed: the connected GitHub App
lacks `workflows` permission and GitHub rejects any ref update touching
`.github/workflows/prolog-checks.yml`. The repository workflow therefore remains
unchanged from the scaffold, and the hardening is recorded as pending rather
than as delivered.

### Observed GitHub Actions run

| Field | Observed value |
|---|---|
| Run | `42581411921`, job `129040753634` |
| URL | https://github.com/Kaye-Arnold/prolog-symptom-matcher/actions/runs/42581411921 |
| Trigger | `pull_request` (PR #2), branch `arena/a080307d-prolog-symptom-matcher` |
| Head SHA | `f7d860f154f42ffe6f1ebbd5341a1b344a61b183` — source and tests identical to `849496339bb36d8c2860bc4b98ad19e9d66bf068`; later commits touch docs and the workflow only |
| Started / completed | 2026-11-09T07:46:15Z / 07:46:38Z (job 07:46:19–07:46:37Z) |
| Conclusion | `success`; every step succeeded, including "Check that Prolog files load" and "Run PLUnit suites when defined" |

The step-level conclusions were read from the Actions API. The job's console log
could not be downloaded in this sandbox (the log endpoint was unreachable), so
the run is recorded by run/job identity and step conclusions, not by quoting
output text. The `pull_request` trigger means the workflow ran on this branch's
merge ref; it does not establish a `main`-only push run, Windows behavior, or CI
coverage of an empty suite.

## Remaining validation

- Linux source/test verification on commit
  `849496339bb36d8c2860bc4b98ad19e9d66bf068` passed; rerun if Prolog or test
  sources change after that commit.
- Re-run this revision on Windows using the official installer and record
  OS/build, SWI-Prolog version, command, result, and commit. The earlier
  snapshot's Windows run is historical evidence and does not substitute for it.
- GitHub Actions run `42581411921` was observed as `success` on this branch; a
  later docs-only commit starts a new run, so read the current check state on
  PR #2 rather than assuming this record still describes the tip.
- Re-apply the hardened workflow step once the GitHub App has `workflows`
  permission, and re-run CI to confirm it still passes.
- Perform team/lecturer scope review, oral defense, video upload/link test, and
  final course submission.
