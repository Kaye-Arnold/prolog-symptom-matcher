# Knowledge-Based Symptom-Matching System

An educational Logic Programming project implemented in SWI-Prolog. It compares a
user-supplied set of symptom terms with a small, source-linked knowledge base and
explains the resulting list overlaps.

> **Educational use only.** The program compares terms against limited lists. It
> does not provide diagnoses, probabilities, treatment, urgency, emergency
> advice, or traffic-light recommendations, and it cannot determine whether a
> condition is present or absent.

## Current status

- Implementation for the proposed four-condition scope is present in this review
  branch. The proposal, illness scope, and console interface still need formal
  team/lecturer review; the code is not evidence of approval.
- Current local Linux verification: **SWI-Prolog 10.0.2, 64 test declarations,
  180 passing executions, 0 failures/timeouts/blocked/fixme, exit 0**. The exact
  platform, command, controls, and commit are recorded in
  [`docs/test-report.md`](docs/test-report.md).
- **Windows verification of this integrated revision is pending.** Historical
  owner-supplied Windows records apply to earlier snapshot code only; see
  [`docs/historical-evidence-index.md`](docs/historical-evidence-index.md).
- Stage 8 report and PowerPoint presentation are included. A recording, Google
  Drive upload/link, sharing-permission check, team review, and final assignment
  submission remain pending.
- The assignment brief does not state a project point value or deadline. The
  deadline 9 November 2026 at 23:59 EAT is user-provided; it is not in the PDF.

## Quick start

Run these commands from the repository root with SWI-Prolog on `PATH`:

```sh
# Run the PLUnit suites. The runner rejects load errors and an empty suite.
swipl -q -s tests/run_tests.pl

# Run all five demonstration cases, including a real tied ranking.
swipl -q -s src/symptom_matcher.pl -- --demo

# Start the interactive console; an empty line exits.
swipl -q -s src/symptom_matcher.pl --

# Execute the knowledge-retrieval and inference query examples.
swipl -q -s queries/demonstration_queries.pl \
  -g demonstration_queries:run_query_examples -t halt
```

On Windows, install the official 64-bit SWI-Prolog distribution from
[the SWI-Prolog downloads page](https://www.swi-prolog.org/download/stable),
open a new Command Prompt, then run `run-tests.bat`, `run-demo.bat`, or
`run-interactive.bat` from the project directory. The current application has
not been re-verified on Windows; see [`docs/windows-setup.md`](docs/windows-setup.md).

## What the application does

1. Normalises case and whitespace and maps aliases such as `"high temperature"`
   to `fever` and `"dry cough"` to the single canonical feature `cough`.
2. Removes duplicate canonical reports and reports extra occurrences.
3. Reports unknown terms separately; unknowns are not silently compared.
4. Derives all positive matches from source-linked facts and reports matched
   terms plus recognised report terms absent from each limited list.
5. Calculates exact application fractions `shared / listed` and orders them by
   cross multiplication. Equal fractions remain tied; zero-overlap conditions
   are not promoted as candidate matches.
6. Shows the limitations with every report, including empty and invalid inputs.

Qualifications are preserved in the knowledge base: for example,
`usually_dry`, `sudden_onset`, `high`, `small_white`, and `usually_low_grade`.
These qualifications are not interpreted as severity, likelihood, or a user
measurement. The scoring rule is a programming exercise, not a clinical measure.

## Repository map

```text
src/knowledge_base.pl              Source-linked vocabulary and facts
src/inference.pl                   Normalisation, lists, inference, exact ranking
src/interface.pl                   Console, validation, demonstrations
src/symptom_matcher.pl              Application entry point
queries/demonstration_queries.pl   Executable retrieval and inference queries
tests/                             PLUnit suites and positive-evidence runner
run-tests.bat                      Windows test launcher
run-demo.bat                       Windows demonstration launcher
run-interactive.bat                Windows interactive launcher
docs/Project.pdf                  Authoritative assignment brief
docs/assignment-requirements.md    Requirements transcribed from the brief
docs/snapshot-assessment.md        Repomix recovery, scaffold/PDF assessment, safety corrections
docs/stage-1-proposal.md            Proposed scope and problem specification
docs/knowledge-representation.md   Implemented representation and query design
docs/source-register.md             Verified source pages and fact provenance
docs/test-plan.md                  Test coverage plan
docs/test-report.md                Current observed verification record
docs/final-report.md               Substantive assignment report
docs/submission-checklist.md       Pending human/external actions
docs/traceability-matrix.md        Requirement-to-artifact evidence map
presentation/project-presentation.pptx  Presentation deliverable
presentation/demonstration-script.md     Timed demo and recording instructions
presentation/oral-defense-notes.md       Slide notes and oral-defense prep
scripts/build_presentation.py            Rebuild the deck (optional python-pptx dependency)
scripts/check_presentation.py            Validate PPTX package, slide bounds, and links
```

## Sources, scope, and review

The four public-health pages and the associations they support are documented in
[`docs/source-register.md`](docs/source-register.md). Their page dates were
checked against the live pages on 9 November 2026. The source register describes
only what is encoded; it is not a clinical reference or a complete symptom set.

A separate criterion-level marking rubric was not supplied. Team member names,
roles, scope approval, and contributions are not inferred. The submission
checklist marks human and external actions that still need completion.
