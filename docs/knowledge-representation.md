# Knowledge-Representation Design

**Status:** Preliminary design for Stage 2; no medical facts have been encoded or verified.

## 1. Entities

- **Condition:** One of the four proposed illness identifiers, subject to scope confirmation.
- **Symptom term:** A canonical atom in a bounded educational vocabulary.
- **Condition–symptom association:** A limited relationship supported by the source register.
- **Source:** A documented external reference and the relationships it supports.
- **Symptom report:** A user-supplied collection after validation and duplicate handling.
- **Candidate result:** A condition with non-zero overlap under the application rule, together with its explanation.

## 2. Representation principles

1. Use valid, consistent Prolog atoms for identifiers.
2. Separate vocabulary facts from condition associations and source metadata.
3. Do not encode associations as necessary, sufficient, or definitive by default.
4. Preserve source provenance and educational simplifications.
5. Normalize duplicate reported terms before counting overlap.
6. Distinguish unknown terms from known terms absent from a particular condition profile.
7. Do not silently discard tied candidates.
8. Keep application scoring separate from medical meaning.

## 3. Proposed predicate catalogue

These predicates are a design proposal, not implemented functionality.

| Predicate | Status | Intended meaning |
|---|---|---|
| `condition/1` | Planned | Declares a condition in the bounded scope. |
| `symptom/1` | Planned | Declares a canonical term in the application vocabulary. |
| `condition_symptom/2` | Planned | Represents a sourced educational association. |
| `association_source/3` | Planned | Links an association or grouped knowledge entry to its source record. |
| `reported_symptoms/2` | Planned | Represents or derives a normalized report for a query/session. |
| `known_symptom/1` | Planned | Checks membership in the controlled vocabulary. |
| `candidate/2` | Planned | Derives a condition with non-zero overlap for a report. |
| `matched_symptoms/3` | Planned | Derives the intersection between a report and a condition profile. |
| `unmatched_for_condition/3` | Planned | Derives known reported terms absent from a candidate profile. |
| `unknown_symptoms/2` | Planned | Derives reported terms outside the controlled vocabulary. |
| `overlap_count/3` | Planned | Calculates the number of unique matched terms. |
| `ranked_matches/2` | Planned | Collects and orders all eligible candidates while retaining ties. |
| `validate_report/2` | Planned | Validates input and produces a normalized report or explanatory error. |

Names and arities must be reviewed against the final input model before coding. Avoid adding a predicate merely to satisfy a keyword checklist.

## 4. Transparent overlap design

For a normalized report `R` and condition `C`:

- `Matched(C,R)` is the intersection of unique known reported terms and the condition’s stored associations.
- `Overlap(C,R)` is the number of terms in `Matched(C,R)`.
- A candidate is eligible when `Overlap(C,R) > 0` under the proposed application rule.
- `Unknown(R)` contains reported terms outside the controlled vocabulary.
- `Unmatched(C,R)` contains known reported terms not associated with `C`.

An optional coverage measure may be considered only after its denominator and interpretation are documented. Neither overlap nor coverage is a probability, diagnosis, severity score, or urgency measure.

## 5. Required Stage 2 evidence

- Completed and reviewed predicate catalogue.
- Source-backed fact set with no duplicate or contradictory entries.
- Queries for all conditions, condition symptoms, conditions sharing a symptom, shared symptoms, and vocabulary lookup.
- Expected query results clearly labelled until executed.
- Actual SWI-Prolog commands and outputs after execution.
- Updated source register and traceability matrix.
