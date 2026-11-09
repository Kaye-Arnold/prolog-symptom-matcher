# User Guide

## 1. Prerequisite and startup

The application uses SWI-Prolog. On Windows, use the official 64-bit installer
linked from the [SWI-Prolog stable downloads page](https://www.swi-prolog.org/download/stable)
and follow [`windows-setup.md`](windows-setup.md). On Linux or macOS, use a
supported SWI-Prolog package for that platform.

From the repository root:

```sh
# All PLUnit suites; non-empty evidence is required for PASS.
swipl -q -s tests/run_tests.pl

# Demonstration cases, including unknowns, duplicates, and a tie.
swipl -q -s src/symptom_matcher.pl -- --demo

# Interactive session.
swipl -q -s src/symptom_matcher.pl --

# Retrieval and inference queries.
swipl -q -s queries/demonstration_queries.pl \
  -g demonstration_queries:run_query_examples -t halt
```

The batch launchers `run-tests.bat`, `run-demo.bat`, and `run-interactive.bat`
are provided for Windows. They change to the repository directory before running.

## 2. Interactive input

Enter comma-separated symptom terms, for example:

```text
fever, headache, chills
```

An empty line exits. Matching is case-insensitive; spaces and repeated
whitespace are normalised. Aliases include `high temperature` for `fever`,
`stuffy nose` for `nasal_congestion`, and `dry cough` for the single canonical
feature `cough`.

- Repeated canonical terms are collapsed and extra occurrences are shown.
- Unknown terms are listed and are not compared.
- Recognised terms not present in one source list are shown as unmatched for
  that limited list.
- A report with no recognised terms displays no comparison or ranking.
- Malformed non-list input to the `report/1` API returns a validation message;
  free-text console tokens are always strings and unsupported words are unknown.

## 3. Reading results

A line such as `shared 3 of 6 listed features` is an exact software overlap
fraction: three unique reported features are present in a six-feature source
list. The denominator is condition-specific. Fractions are ordered exactly by
cross multiplication, and equal fractions are displayed as ties. Only positive
overlap results are ranked.

Observed example from the local Linux demonstration on SWI-Prolog 10.0.2:

```text
TIE at 3/6: [Measles,Common cold]
Highest software-overlap group is a tie: [Measles,Common cold]
```

This is an application-level programming rule, not a probability, diagnosis,
severity measure, or urgency estimate. Absence from a stored list is not a
conclusion about health.

## 4. Demonstration queries

The query file provides `list_conditions/1`, `symptoms_for/2`,
`conditions_for_symptom/2`, and `explain_report/4`. The query examples retrieve
all conditions for a term with `findall/3`, show the stored `usually_dry`
qualification, and demonstrate a tied exact ratio. See
[`knowledge-representation.md`](knowledge-representation.md).

## 5. Tests and troubleshooting

Run `swipl -q -s tests/run_tests.pl`. The runner prints the number of test
**declarations** separately from passing **executions** and fails if the suite
cannot be loaded, has no declarations/executions, or reports failures, timeouts,
blocked tests, or fixme tests. See [`test-report.md`](test-report.md) for actual
local evidence and [`test-plan.md`](test-plan.md) for coverage.

If `swipl` is not recognised, install SWI-Prolog and open a new shell so PATH is
refreshed. Run commands from the project root. Verification of the current
revision on Windows is pending; the earlier snapshot's Windows run is historical
evidence only, and a Linux run is not evidence of a Windows run.

## 6. Safety and scope

This software is for demonstrating Logic Programming only. It compares text
against four limited, source-linked lists; it does not provide diagnoses,
probabilities, treatment, urgency, emergency advice, or traffic-light
recommendations. The scope and interface remain proposed pending human review.
