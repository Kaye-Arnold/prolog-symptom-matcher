# Implementation Notes

This page records the design choices that matter for review and oral defense.
The application is a small SWI-Prolog project; none of these choices is a
clinical decision rule.

## 1. Modules

| File | Responsibility |
|---|---|
| `src/knowledge_base.pl` | Canonical vocabulary, aliases, condition facts, source qualifications, source metadata, and disclaimer. |
| `src/inference.pl` | Pure normalisation, list processing, source-list retrieval, comparison, candidate filtering, and ranking. |
| `src/interface.pl` | Console input/output, validation messages, demonstration cases, and CLI flags. |
| `src/symptom_matcher.pl` | Loads the modules and starts the console/demo entry point. |
| `queries/demonstration_queries.pl` | Executable knowledge retrieval and inference examples. |

Keeping I/O outside the inference predicates lets PLUnit test the logic without
using the console as its oracle. Integration tests separately capture selected
reports.

## 2. Decisions

### D1: Source facts carry their own qualification

`condition_symptom/4` stores the condition, canonical term, qualifier, and source
ID. It retains `sudden_onset`, `usually_dry`, `high`, `small_white`, and
`usually_low_grade` where the cited pages support them. `plain` means that the
individual term is not qualified in the recorded source phrase. These fields
are not applied to user measurements.

### D2: Cough and dry cough are one canonical feature

WHO describes influenza cough as "usually dry". The user may type `dry cough`,
but `symptom_alias(dry_cough, cough)` maps it to the same feature as `cough`.
There is exactly one influenza cough association with `usually_dry`. This avoids
double counting and preserves the qualifier.

### D3: Unknowns are visible rather than silently discarded

The normaliser maps only declared canonical atoms and aliases. `normalise_all/2`
keeps known terms; `unknown_terms/2` returns other inputs separately. If every
term is unknown, the interface says nothing was compared and shows no ranking.
Malformed non-list reports are rejected; unsupported list elements are handled
without an exception.

### D4: Duplicate handling is set-based

The first occurrence of each canonical feature is retained. The extra count is
reported, including duplicates created by aliases (for example, `fever` plus
`high temperature`). Set operations deduplicate their operands so raw duplicate
list entries cannot inflate the intersection.

### D5: Application scoring is exact and tie-preserving

A condition's denominator is the number of its unique source-linked canonical
features. The numerator is the unique recognised report terms shared with that
list. Fractions are compared by integer cross multiplication. Equivalent ratios
share a ranking group; no arbitrary tie-breaker is used. Zero-overlap profiles
are not called matches. The denominator is printed so the software rule is
visible rather than hidden in a percentage.

### D6: Unknown and unmatched are different

An unknown term is outside the application's canonical vocabulary. An unmatched
term is known but absent from one particular limited source list. Neither state
is evidence for or against a real-world condition.

### D7: Negation and cut are narrow

Negation as failure classifies terms against the finite vocabulary. It is not
used to conclude absence of a condition. A cut in CLI argument parsing commits
only after detecting the explicit `--demo=` form. No cut removes condition
alternatives from candidate generation or ranking.

### D8: The console is intentionally non-clinical

The interface displays list overlap and explanatory terms, but not a diagnosis,
probability, treatment, urgency, emergency advice, or traffic-light result.
Every branch (including invalid, empty, and unknown-only input) prints the
educational-use disclaimer. Source qualifiers are data only; the interface does
not judge their degree or importance.

## 3. Testable properties

The PLUnit suites cover:

- vocabulary, source IDs, source dates, profile sizes, and uniqueness;
- canonical input, aliases, case/whitespace handling, malformed/unknown input;
- recursive list processing, duplicate counts, intersection and difference;
- exact denominators, exact rational comparison, and equivalent-fraction ties;
- cough/dry-cough aliasing and preservation of `usually_dry`;
- required source qualifiers and separate unknown/unmatched outputs;
- zero-overlap filtering, top ties, demo cases, and selected output boundaries.

`tests/run_tests.pl` requires a non-empty suite and verifies declaration and
execution counts as well as failed, timeout, blocked, and fixme fields. The CI
workflow always invokes it; an empty suite is not treated as a passing scaffold.

## 4. Known limitations

- Four profiles and a controlled vocabulary are deliberately small and proposed;
  they do not cover all possible conditions or symptoms.
- Alias mappings and canonicalisation are hand-authored.
- Age, onset, duration, measurement, history, examination, and test results are
  not inputs.
- Stored source qualifications are not interpreted by the matching rule.
- A high fraction can result from a small denominator; this does not mean higher
  clinical probability. No medical interpretation is assigned to the ranking.
- The current integration has Linux evidence only. Windows verification must be
  repeated using the official 64-bit SWI-Prolog installer.
