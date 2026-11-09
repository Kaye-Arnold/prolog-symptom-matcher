# Knowledge-Representation Design

**Status:** Implemented on the review branch; the four-condition scope remains
proposed and has not been recorded as formally approved.

## 1. Entities and representation

- **Condition:** one of `malaria`, `influenza`, `measles`, or `common_cold`.
- **Canonical symptom:** one atom in a deliberately limited vocabulary.
- **Alias:** a typed synonym mapped to exactly one canonical symptom, e.g.
  `dry_cough -> cough`.
- **Condition-symptom association:** a limited source-linked fact plus a
  qualification and source ID.
- **Source:** a public-health page with title, organisation, URL, and page date.
- **Report:** a list of raw terms, normalized to known canonical features,
  deduplicated, and accompanied by separate unknown and duplicate lists.
- **Result:** `result(Condition, frac(Shared, Listed), Matched, Unmatched)`.
  `Unmatched` contains recognised report terms not listed for that result.

All facts and rule code are in `src/`. The detailed source-to-fact mapping is in
[`source-register.md`](source-register.md).

## 2. Implemented predicate catalogue

| Predicate | File | Meaning |
|---|---|---|
| `condition/1`, `condition_name/2` | `src/knowledge_base.pl` | Declares each bounded condition and display name. |
| `symptom/1`, `symptom_alias/2` | `src/knowledge_base.pl` | Canonical vocabulary and aliases. |
| `condition_symptom/4` | `src/knowledge_base.pl` | `condition_symptom(Condition, Symptom, Qualification, SourceId)`. |
| `source/5`, `source_date/2`, `source_url/2` | `src/knowledge_base.pl` | Machine-readable source metadata. |
| `normalise/2`, `normalise_all/2` | `src/inference.pl` | Converts typed terms to canonical atoms; processes a list recursively. |
| `unknown_terms/2` | `src/inference.pl` | Returns normalised, deduplicated terms not in the vocabulary. |
| `dedupe/2`, `dedupe_report/3` | `src/inference.pl` | First-seen list deduplication and extra-occurrence counts. |
| `symptoms_of/2` | `src/inference.pl` | Retrieves a condition's unique listed features. |
| `overlap/3`, `difference/3` | `src/inference.pl` | Set intersection and difference over lists. |
| `coverage_fraction/3` | `src/inference.pl` | Calculates exact `frac(N,D)` for one condition. |
| `compare_all/3` | `src/inference.pl` | Produces a result for every condition and a separate unknown list. |
| `candidate_matches/3` | `src/inference.pl` | Keeps only positive software matches; zero overlap is not a candidate. |
| `ranking/2`, `tied_top/2` | `src/inference.pl` | Groups eligible matches by exact ratio and returns all top ties. |
| Retrieval helpers and `run_query_examples/0` | `queries/demonstration_queries.pl` | Runnable examples for unification, backtracking, source facts, and ranking. |

## 3. Source qualifications and cough identity

The qualification remains attached to its source fact. Regression tests check
`usually_dry`, `sudden_onset`, `usually_low_grade`, `high`, and `small_white`.
For influenza there is one fact:

```prolog
condition_symptom(influenza, cough, usually_dry, who_influenza).
```

`dry_cough` is an alias for `cough`; it is not an additional canonical feature
or fact. Consequently, entering both `cough` and `dry cough` produces one
canonical cough in the report and one influenza denominator item.

The logic stores qualifiers but does not reason over the user's age, measured
temperature, onset, duration, or clinical history. The words therefore remain
source metadata, not an assessment of the user's condition.

## 4. Queries, unification, and backtracking

The query file is executable. For example:

```prolog
findall(Condition,
        condition_symptom(Condition, cough, _, _),
        Conditions).
```

The variable `Condition` unifies successively with every matching fact; `findall/3`
collects alternatives explored through backtracking. The input alias query
`conditions_for_symptom("dry cough", Conditions)` first normalises to `cough`,
then backtracks across each matching association. These are retrieval operations,
not predictions.

Run the query examples from the repository root:

```sh
swipl -q -s queries/demonstration_queries.pl \
  -g demonstration_queries:run_query_examples -t halt
```

## 5. Lists, recursion, validation, and negation

Reports, profiles, matches, unmatched terms, duplicates, and unknowns are lists.
`normalise_all/2`, the accumulator-based `dedupe_acc/3`, occurrence counting,
set operations, and the console word wrapper have recursive base and recursive
cases with practical list-processing work. A malformed non-list passed to the
console report is rejected with a message; unsupported list items do not throw
an exception and are reported as unknown.

Negation as failure (`\+ normalise(Term, _)`) is used narrowly to classify an
input term as not in this application's finite vocabulary. It is not used to
infer that a person does not have a condition. A cut in the interactive command
parser commits after selecting the `--demo=...` argument form; it is not used to
remove alternative condition matches.

## 6. Software overlap and exact tie behavior

For unique normalised report set `R` and condition feature set `S`:

- `Matched = R intersect S`.
- `Unmatched = R minus S`, for recognised terms only.
- `N = length(Matched)`.
- `D = length(S)`.
- The displayed software fraction is `N/D`.
- A result is eligible only when `N > 0`.

Fractions are ordered by cross multiplication (`N1*D2` versus `N2*D1`), not
floating point. Equal ratios are grouped and retained as ties. For the
`tied_example` input `[fever, cough, runny nose, nasal congestion]`, measles is
`3/6` and common cold is `4/8`; both are reported in one top tie. The fraction is
only a transparent programming rule and is not a probability, diagnosis,
severity, or urgency measure.

## 7. Scope and provenance boundary

The sources list symptoms; they do not provide the ranking rule. The fact base is
small, source-specific, and incomplete. No unsupported thresholds, diagnostic
rules, triage logic, or clinical advice are encoded. The scope and source mapping
remain subject to team/lecturer review.
