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
passing executions on Linux SWI-Prolog 10.0.2. It is historical, predates the
integrated application, and must not be conflated with the current run.

**No Windows execution of the current revision has occurred.** The official
64-bit Windows installer is the target environment. The `.bat` launchers were
checked for ASCII and CRLF formatting on Linux, which is file-format evidence,
not evidence they run in Windows. GitHub Actions status is not inferred here.

## Remaining validation

- Linux source/test verification on commit
  `849496339bb36d8c2860bc4b98ad19e9d66bf068` passed; rerun if Prolog or test
  sources change after that commit.
- Run on Windows using the official installer and record OS/build, SWI-Prolog
  version, command, result, and commit.
- Observe and record GitHub Actions only if a run is actually available.
- Perform team/lecturer scope review, oral defense, video upload/link test, and
  final course submission.
