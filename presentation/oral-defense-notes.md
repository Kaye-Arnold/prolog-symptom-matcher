# Oral-Defense Speaker Notes

**Status:** Preparation material. A live defense has not been performed.
Use with `project-presentation.pptx`; adapt the wording to match the actual
live run. Do not state that the proposed scope was approved.

## Suggested 6-7 minute talk track

### Slide 1 — Title and boundary (30 seconds)

Introduce the project as an educational Logic Programming exercise that compares
reported text with a limited, source-linked list. State clearly that it does not
produce diagnoses, probabilities, treatment, urgency, emergency guidance, or
traffic-light recommendations. The result is an explanation of list overlap, not
an assessment of a person.

### Slide 2 — Problem and scope (35 seconds)

Explain the assignment's problem: represent relationships declaratively and
retrieve alternatives. The current demonstration uses four proposed profiles
(malaria, seasonal influenza, measles, and common cold), but the repository has
no record of formal team/lecturer approval. The brief itself does not prescribe
the illness set or console interface.

### Slide 3 — Knowledge and sources (40 seconds)

Show `condition_symptom(Condition, Symptom, Qualification, SourceId)`. Mention
that each encoded relationship points to a page in `docs/source-register.md`.
Use the influenza cough example: WHO says "cough (usually dry)"; the system stores
one canonical `cough` feature with qualification `usually_dry`. `dry_cough` is
an alias, so entering both forms cannot count twice.

### Slide 4 — Representation and modules (35 seconds)

Walk through `src/knowledge_base.pl`, `src/inference.pl`, `src/interface.pl`, and
`src/symptom_matcher.pl`. Emphasize that facts, pure reasoning, and console I/O
are separated. `queries/demonstration_queries.pl` contains executable retrieval
queries; it is not just a list of comments.

### Slide 5 — Logic Programming concepts (45 seconds)

Demonstrate unification with `condition_symptom(Condition, cough, Q, Source)`.
Prolog binds variables to each matching fact; `findall/3` collects alternatives
while backtracking explores them. `normalise_all/2`, `dedupe_acc/3`, and
`count_occurrences/3` recursively process lists. `\+ normalise(Term, _)` is used
only to classify a term outside the finite vocabulary, never to infer that a
condition is absent.

### Slide 6 — Input processing (35 seconds)

Show case/whitespace normalisation, aliases, duplicate collapse, and the separate
unknown list. Explain that an unmatched known term is one absent from a particular
limited source list; an unknown term is outside the controlled vocabulary. An
empty or unknown-only report produces no ranked candidate.

### Slide 7 — Exact scoring and ties (45 seconds)

Define `N` as the number of unique recognised terms shared with a source list and
`D` as the number of unique terms in that list. Fractions are compared by cross
multiplication, not floating point. In the tied example, measles is `3/6` and
common cold is `4/8`; both equal one half and remain tied. The denominator makes
the software rule visible. It is not a probability or clinical measure.

### Slide 8 — Console demonstration (45 seconds)

Run the demonstration command live. Point to the messy-input example to show a
synonym, a duplicate, and an unknown term, then the tie example. Use the actual
output generated on the machine being recorded. The verified Linux output is
quoted in `docs/test-report.md`; it is not a Windows verification.

### Slide 9 — Verification (40 seconds)

State the exact local environment from `docs/test-report.md`: Linux x86_64,
Debian 12, SWI-Prolog 10.0.2. The observed suite has 64 declarations and 180
passing executions, with zero failed, timeout, blocked, or fixme results. Explain
that `forall/2` means executions may outnumber declarations. Show the clean test
runner and distinguish local results from any GitHub Actions result.

### Slide 10 — Limitations and next steps (35 seconds)

Summarise that the profiles are small, sources describe lists rather than a
ranking rule, qualifiers are stored but not interpreted, and there is no clinical
validation. State the remaining human work: scope/team review, Windows re-run
with the official 64-bit installer, live oral defense, recording and Google Drive
upload, link-permission check, and actual submission.

## Likely questions and defensible answers

**Does the highest fraction mean this condition is most likely?**

No. It is an application-defined ratio of shared terms to the length of one
limited source list. No probability model or clinical validation exists.

**Why use the denominator of each condition's list?**

It gives a transparent, condition-specific coverage fraction and creates a useful
exact-arithmetic exercise. It also has limitations: short lists can rank highly
on fewer shared terms. The denominator is shown and the result is explicitly not
clinical.

**Why does `dry_cough` not add another point?**

It aliases to canonical `cough`; the influenza fact stores the qualifier
`usually_dry` once. The test suite checks the alias, single fact, and denominator.

**How is backtracking visible?**

A query such as `findall(C, condition_symptom(C, cough, _, _), Cs)` asks Prolog to
unify `C` with each matching condition. Backtracking finds alternatives;
`findall/3` collects them.

**Why is negation as failure safe here?**

It is used only for membership in a finite, declared vocabulary to classify an
unknown input. It is not used to infer absence of illness.

**What remains unverified?**

The current code has local Linux evidence. Current Windows execution, the live
presentation/defense, video recording/upload, formal scope approval, and final
assignment submission remain pending unless a later record says otherwise.
