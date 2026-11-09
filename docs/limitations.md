# Limitations and Safety Boundary

## 1. Intended use

This is an educational Prolog demonstration of source-linked facts, unification,
backtracking, recursion, lists, arithmetic, and transparent set comparison. It
compares typed terms with a small fixed list of symptom associations.

## 2. Explicit exclusions

The application does **not** provide:

- a diagnosis or a conclusion that a condition is present or absent;
- a probability, confidence estimate, or clinical likelihood;
- a treatment or medication recommendation;
- an urgency classification, emergency advice, or traffic-light output;
- a claim that an unlisted term or zero overlap excludes a condition.

The console disclaimer is intentionally limited to describing these boundaries;
it does not direct a user to take a health action.

## 3. Knowledge limitations

1. Only four proposed condition profiles are represented: malaria, seasonal
   influenza, measles, and common cold. Formal team/lecturer approval of this
   scope is not recorded.
2. Each profile is a limited selection from one cited source page, not an
   exhaustive or reconciled clinical reference.
3. The sources differ in how terms are grouped and qualified. Canonical aliases
   such as `dry_cough -> cough` are educational normalisation decisions.
4. Source qualifiers are stored, but the program does not receive age, measured
   temperature, onset, duration, severity, history, examination, or test results.
5. Unknown terms are not compared. Known terms absent from a source list are
   shown as unmatched for that list; neither result is a clinical statement.
6. The exact fraction is an application-defined ordering rule. A small profile
   can rank highly on fewer shared items; denominators and ties are printed, but
   the number is not a probability or medical measure.
7. The knowledge base has no clinical review, validation study, prevalence data,
   decision threshold, or clinical-performance evidence.

## 4. Engineering limitations

- The alias vocabulary is hand-maintained and not a natural-language parser.
- The current local verification was on Linux x86_64 with SWI-Prolog 10.0.2.
  The current integrated version has not been run on Windows.
- Historical Windows records refer to the earlier snapshot implementation and
  are preserved separately; they do not validate this revision.
- The required Google Drive video has not been recorded or uploaded.
- Team member details, roles, and formal scope approval still require human
  confirmation.

## 5. Possible educational improvements

Future work can add more unit tests for rendered reports, expand retrieval
queries, and improve the presentation of provenance without changing the
non-clinical scope. Any change to the illness set, source material, or report
format should be reviewed by the team and checked against the assignment brief.
