# Test Plan and Results

**Current local test status:** 64 PLUnit declarations, 180 passing executions,
0 failed, 0 timed out, 0 blocked, 0 fixme; runner exit 0 on Linux x86_64 with
SWI-Prolog 10.0.2. The current revision has not been rerun on Windows. Exact
commands and negative controls are in [`test-report.md`](test-report.md).

## 1. Testing principles

- Distinguish source declarations from executions (including `forall/2`
  executions).
- Record the interpreter, platform, exact command, exit status, and commit for
  each verification.
- A passing test is evidence for its asserted software property only; it is not
  evidence of medical validity.
- Run destructive test mutations only in disposable copies, confirm the
  mutation, and discard the copy.
- GitHub Actions status is separate from a local CI-equivalent run.

## 2. Coverage matrix

| ID | Category | Required behavior | PLUnit evidence | Current result |
|---|---|---|---|---|
| KB-01 | Knowledge retrieval | Four declared profiles and source metadata | `kb_integrity:four_conditions_declared`, source metadata tests | Pass in local run |
| KB-02 | Fact integrity | Every relation refers to a declared condition, symptom, and source | `kb_integrity:all_facts_reference_declared_terms` | Pass in local run |
| KB-03 | Qualifications | Preserve `usually_dry`, `sudden_onset`, `high`, `small_white`, `usually_low_grade` | `kb_integrity:*qualification*` and cough-alias tests | Pass in local run |
| KB-04 | Duplicate feature | `cough` and `dry_cough` map to one feature; influenza has one cough fact | `kb_integrity:influenza_has_one_cough_feature_with_usually_dry` | Pass in local run |
| INF-01 | Normalisation | Case, whitespace, phrases, aliases, malformed and unknown terms | `normalisation:*` | Pass in local run |
| LIST-01 | Lists/recursion | Empty lists, stable first occurrence, duplicates counted | `list_processing:*`, `normalise_all` tests | Pass in local run |
| SET-01 | Set relations | Intersection/difference deduplicate and preserve left order | `list_processing:overlap_*`, `difference_*` | Pass in local run |
| ARITH-01 | Fraction | Condition-specific denominator; exact shared count | `scoring_and_inference:profile_denominator*`, `malaria_three_term_fraction` | Pass in local run |
| ARITH-02 | Exact ranking | Cross multiplication, equivalent fractions, tied top group | `scoring_and_inference:*fraction*`, `*tie*` | Pass in local run |
| INF-02 | No match | Zero-overlap results are not candidate matches | `scoring_and_inference:zero_overlap_is_not_an_eligible_candidate` | Pass in local run |
| INF-03 | Unknown/unmatched | Unknown terms and per-list unmatched terms are distinct | `compare_all_*` tests | Pass in local run |
| IO-01 | Empty/unknown | No false ranking, terms visible, disclaimer shown | `console_integration:empty_input*`, `unknown_only_input*` | Pass in local run |
| IO-02 | Duplicate/tie | Duplicate aliases collapse; exact tie printed | `console_integration:duplicates_aliases*`, `tied_report*` | Pass in local run |
| IO-03 | Invalid input | Improper/non-list report is rejected without exception | `console_integration:*input_is_rejected*` | Pass in local run |
| SAFE-01 | Output boundary | No emergency or urgency instruction appears | `console_integration:no_emergency_or_urgency_instruction_is_printed` | Pass in local run |
| DEMO-01 | Demonstration | Five demo cases defined; tie and messy input runnable | `console_integration:*demonstration*`, `*tied_demo*`, `*messy_demo*` | Pass in local run; commands also run directly |

## 3. CI and runner controls

The workflow now loads application, query, and test source files and always runs
`tests/run_tests.pl`. The runner fails when required test files cannot load, when
there are no declarations/executions, or when reported test outcomes cannot be
counted. In a disposable copy, controls must confirm:

1. Mutating the influenza cough qualification causes its regression test and
   test command to fail.
2. A missing required test file causes a load failure.
3. Test files with all PLUnit suites removed cause the empty-suite guard to fail.
4. Each control uses its own isolated copy; verify the untouched working-tree baseline independently.

Observed control outputs and mutation checks are recorded in
[`test-report.md`](test-report.md). The GitHub Actions run is recorded only if
actually observed after push.

## 4. Remaining platform and submission verification

- Windows: not verified for this integrated revision; use the official 64-bit
  SWI-Prolog installer and follow `windows-setup.md`.
- Human oral defense: pending.
- Google Drive recording/upload and permission check: pending.
- Final assignment submission: pending.
