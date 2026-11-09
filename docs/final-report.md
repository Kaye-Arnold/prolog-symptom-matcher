# Final Project Report

## Design and Implementation of a Knowledge-Based Problem-Solving System Using Logic Programming

- **Project title:** Knowledge-Based Symptom-Matching System for Selected Infectious Illnesses — Educational Prototype
- **Course:** Logic Programming
- **Primary language:** SWI-Prolog
- **Report status:** Implementation and local evidence are documented below; team and lecturer review, current Windows verification, video upload, and final course submission remain pending.

The assignment PDF supplies no project point value, criterion-level rubric,
deadline, presentation file type, or report word count. The user supplied the
deadline of 9 November 2026 at 23:59 EAT. Team members, registration numbers,
roles, and contributions are not inferred.

## Abstract

This project implements a small educational Prolog application that compares a
list of user-entered symptom terms with four source-linked condition profiles:
malaria, seasonal influenza, measles, and common cold. The profiles are a
proposed scope pending team/lecturer review. Prolog facts represent conditions,
canonical symptoms, aliases, qualifications, and source metadata. Rules
normalise terms, remove duplicates, report unknowns, compute list intersections
and differences, produce exact application-level fractions, and preserve tied
rankings. A console demonstrates input/output, and executable queries expose
unification and backtracking.

The current PLUnit suite contains 64 declarations and had 180 passing
executions on Linux x86_64 with SWI-Prolog 10.0.2. The test runner rejects an
empty suite and controlled fact mutations. A real console demo and query example
were also executed locally. These results establish software behavior only on
the recorded Linux environment. They do not establish medical validity, clinical
performance, formal scope approval, or completion of the required Google Drive
video and course submission.

The Repomix snapshot that preceded this integration was, as the user confirms,
executed locally on an actual Windows machine. Its preserved report records a
Windows SWI-Prolog 10.0.2 run with 57 test declarations and 179 passing
executions, plus demo and interactive runs. That is historical Windows evidence
for the earlier snapshot code, not evidence for this revision; the raw Windows
transcript is not in the recovered archive for independent re-inspection.

## 1. Problem specification and objectives

The assignment asks for a knowledge-based application that represents relevant
facts and relationships, derives answers with rules, provides working queries,
and demonstrates logic-programming concepts. A bounded symptom-list comparison
was selected as a teaching exercise because relationships can be stated as
facts and retrieved through unification and backtracking.

The implemented objectives are to:

1. represent a small controlled vocabulary and condition/symptom associations;
2. preserve source provenance and available symptom qualifications;
3. provide retrieval queries and inference rules;
4. demonstrate unification, alternative solutions, recursion, and list operations;
5. normalise input, remove duplicates, separate unknown terms, and validate
   malformed API input;
6. calculate and explain exact software overlap fractions while retaining ties;
7. provide a console interface, PLUnit tests, user documentation, report, and
   presentation materials.

### Scope and non-clinical boundary

The current knowledge base contains four proposed profiles and a hand-maintained
vocabulary. Scope and console approval are not recorded. The application is not
a health assessment: it does not provide diagnoses, probabilities, treatment,
urgency, emergency advice, or traffic-light recommendations. It does not infer
that a condition is present or absent, and does not claim clinical validation.

## 2. Knowledge representation and sources

The central fact has the form:

```prolog
condition_symptom(Condition, CanonicalSymptom, Qualification, SourceId).
```

For example, the influenza fact stores one canonical cough with its source
qualification:

```prolog
condition_symptom(influenza, cough, usually_dry, who_influenza).
```

The source's phrase "cough (usually dry)" is not represented as two features.
`dry_cough` is an alias for `cough`, preventing double counting while keeping
`usually_dry` attached to the fact. Other source qualifications include
`sudden_onset`, `high`, `small_white`, and `usually_low_grade`. The program stores
these terms but does not interpret degree, age, onset, or severity.

Four exact pages were retrieved and checked on 9 November 2026:

- WHO, [Malaria](https://www.who.int/news-room/fact-sheets/detail/malaria),
  page date 4 December 2025.
- WHO, [Influenza (seasonal)](https://www.who.int/news-room/fact-sheets/detail/influenza-(seasonal)),
  page date 28 February 2025.
- WHO, [Measles](https://www.who.int/news-room/fact-sheets/detail/measles),
  page date 15 July 2026.
- CDC, [About Common Cold](https://www.cdc.gov/common-cold/about/index.html),
  updated and reviewed 19 February 2026.

The detailed phrases and term mappings are in `docs/source-register.md` and the
machine-readable metadata is in `source/5` facts. These pages describe symptoms;
they do not provide the software's comparison rule. Vocabulary mappings such as
`dry_cough -> cough` and the selection of four profiles are documented
simplifications, not authoritative medical classifications.

## 3. Rules, queries, and Prolog reasoning

### Facts and rules

`src/knowledge_base.pl` declares the vocabulary, aliases, four conditions,
condition names, source-linked facts, source metadata, and the disclaimer.
`src/inference.pl` exports the normalisation, list, comparison, and ranking
predicates. In particular:

- `normalise/2` lowercases and normalises whitespace, then checks the canonical
  symptom and alias tables.
- `normalise_all/2` recursively processes a list and retains recognised terms.
- `unknown_terms/2` uses negation as failure narrowly to classify terms outside
  the finite application vocabulary.
- `dedupe/2` and `dedupe_report/3` preserve first occurrence and count extras.
- `symptoms_of/2`, `overlap/3`, and `difference/3` implement list-set retrieval.
- `compare_all/3` returns `result(Condition, frac(N,D), Matched, Unmatched)` for
  each profile plus a separate unknown list.
- `candidate_matches/3` filters zero-overlap results; zero is not presented as a
  positive match.
- `ranking/2` groups equal fractions and `tied_top/2` returns the complete top
  group rather than selecting one member.

### Unification and backtracking

`queries/demonstration_queries.pl` contains executable retrieval predicates. A
query such as

```prolog
findall(Condition,
        condition_symptom(Condition, cough, _, _),
        Conditions).
```

unifies `Condition` with each fact that matches `cough`. Prolog backtracks to
find the alternatives, and `findall/3` collects them. The query helper
`conditions_for_symptom/2` first normalises the input alias and then retrieves
all matching conditions. This demonstrates variable binding and alternative
search without presenting a health inference as a diagnosis.

### Recursion and lists

Reports, profiles, matched terms, unmatched terms, unknowns, and duplicate
counts are lists. Recursive predicates include `normalise_all/2`,
`dedupe_acc/3`, `count_occurrences/3`, and the interface's console word wrapping.
Their base and recursive cases perform actual list work. Set helpers deduplicate
inputs so repeated raw list entries cannot increase the overlap numerator.

### Arithmetic, comparison, and ties

For unique recognised report set `R` and condition feature list `S`:

```text
Matched = R intersect S
Unmatched = R minus S
N = length(Matched)
D = length(S)
software fraction = N / D
```

The denominator is condition-specific. The ranking compares `N1*D2` with
`N2*D1`, using integer arithmetic rather than floating point. Equivalent
fractions are grouped. In the executed tie example, measles has `3/6` and common
cold has `4/8`; both appear in the same top tie. The number is an application
rule for the programming exercise, not a probability or clinical measure.

### Input/output

`src/interface.pl` reads comma-separated strings, displays supported canonical
terms, normalises aliases, reports duplicates and unknowns, lists non-zero
matches and unmatched known input terms, prints all ranking groups, and displays
the educational disclaimer. Empty and unknown-only reports do not produce a
ranking. A malformed non-list API input receives a validation message. No
persistent patient data or dynamic session facts are used.

## 4. Test and demonstration evidence

The current test report records exact commands, platform, SWI-Prolog version,
summary, and mutation controls. In brief, the observed local result was:

- **Interpreter:** SWI-Prolog 10.0.2, native x86_64 Linux runtime.
- **Operating system:** Debian GNU/Linux 12 (bookworm), Linux x86_64.
- **Command:** `swipl -q -s tests/run_tests.pl` (using the recorded local SWI
  binary path in this environment).
- **PLUnit summary:** 64 declarations, 180 passing executions, 0 failed, 0
  timeout, 0 blocked, 0 fixme; exit 0.
- **Source-load check:** all `src/*.pl`, `queries/*.pl`, and `tests/test_*.pl`
  files loaded with the CI-equivalent `load_files/2` command.
- **Demo:** `swipl -q -s src/symptom_matcher.pl -- --demo` exited 0 and printed
  five cases. Observed snippets included `Unknown terms (not compared):
  [banana]`, `Duplicate reports collapsed (extra occurrences): [fever-2]`, and
  `TIE at 3/6: [Measles,Common cold]`.
- **Interactive check:** `printf 'fever, headache\n\n' | swipl -q -s
  src/symptom_matcher.pl --` exited 0, displayed a report, and exited on the
  empty line.
- **Query check:** `swipl -q -s queries/demonstration_queries.pl -g
  demonstration_queries:run_query_examples -t halt` exited 0 and showed the
  stored `[usually_dry]` qualification.
- **Controls:** changing the qualification to `plain`, adding a separate
  `dry_cough` fact, removing a required test file, and removing all test
  declarations each caused the test command to exit nonzero in disposable
  copies. Exact failure counts and messages are in `docs/test-report.md`.

One initial test-writing expectation for set intersection was corrected before
the clean run: `[c,b,a] intersect [a,b]` is `[b,a]`, in left-input order. The
original mistaken expected value `[c,b]` included `c`, which is not in the right
set. The corrected assertion now tests the intended intersection; no application
behavior or coverage goal was weakened.

The source commit for the test run and any later documentation-only commit are
listed in `docs/test-report.md`. The earlier snapshot code ran on Windows, as
recorded in the preserved historical evidence, but the current integrated source
has **not** been re-run on Windows. GitHub Actions results are not inferred from
local commands.

## 5. Limitations and future work

- Four small profiles and a controlled vocabulary are not comprehensive.
- Source pages list symptoms, not a differential-diagnosis rule.
- Alias mappings and canonical feature selection are hand-maintained.
- Age, onset, duration, measured degree, history, examination, and tests are not
  inputs; stored qualifications are not interpreted.
- No clinical review, validation study, prevalence data, or performance estimate
  exists. The ranking may favor shorter lists and has no clinical meaning.
- Formal team/lecturer approval of scope and scoring remains pending.
- The current code needs a fresh Windows run using the official 64-bit SWI-Prolog
  installer; the historical Windows run applies only to the earlier snapshot.
  The required oral presentation, Google Drive video upload, link permission
  check, and final course submission remain human actions.

Feasible educational extensions include further tests for captured console
formats, an expanded set of source-retrieval queries, and clearer presentation of
fact provenance. Any scope change requires review and a new evidence record.

## 6. Conclusion

The current review-branch implementation demonstrates facts, rules, queries,
unification, backtracking, recursion, lists, arithmetic, comparisons, input and
output, and executable tests in SWI-Prolog. Local execution and mutation controls
provide evidence that the suite runs and detects the targeted regressions on the
recorded Linux environment. The report and PPTX are prepared, but the assignment
is not yet fully submitted: human review, Windows re-verification, oral defense,
the Google Drive video, and final submission remain pending.

## References

1. Course assignment brief supplied with the project: `docs/Project.pdf`.
2. World Health Organization. [Malaria](https://www.who.int/news-room/fact-sheets/detail/malaria),
   4 December 2025.
3. World Health Organization. [Influenza (seasonal)](https://www.who.int/news-room/fact-sheets/detail/influenza-(seasonal)),
   28 February 2025.
4. World Health Organization. [Measles](https://www.who.int/news-room/fact-sheets/detail/measles),
   15 July 2026.
5. Centers for Disease Control and Prevention. [About Common Cold](https://www.cdc.gov/common-cold/about/index.html),
   updated/reviewed 19 February 2026.

Access dates and the exact phrases used are listed in
[`docs/source-register.md`](source-register.md).

## Submission record

- **Report:** this file.
- **Presentation:** `presentation/project-presentation.pptx`.
- **Demonstration script:** `presentation/demonstration-script.md`.
- **Video:** pending; no Google Drive URL has been created or supplied.
- **Sharing permission test:** pending.
- **Formal scope/team review:** pending.
- **Current Windows re-verification:** pending. The earlier snapshot did run on
  Windows (user-confirmed; see the historical evidence index).
- **Final assignment submission:** pending.
