# Project Task Board and Submission Status

**Status date:** 9 November 2026. The deadline **23:59 EAT** was supplied by the
user and is not stated in `docs/Project.pdf`. Verify the current local time and
course submission availability before hand-off; no course submission is recorded.

**Project value:** Not stated in the authoritative PDF.

**Separate criterion-level rubric:** Not supplied.

**Team members and owners:** Not recorded; do not infer.

| ID | Task / assignment stage | Status | Evidence / remaining action |
|---|---|---|---|
| 1 | Read the brief and establish requirements; recover/assess the Repomix handoff | Done | `docs/Project.pdf`, `docs/assignment-requirements.md`, and `docs/snapshot-assessment.md`; the 18-file archive was path-validated and compared with scaffold/PDF requirements. |
| 2 | Stage 1 proposal, problem and scope | Needs human review | `docs/stage-1-proposal.md`; four conditions and console remain proposed, not approved. Confirm team details and scope. |
| 3 | Stage 2 facts and retrieval queries | Implemented; review pending | `src/knowledge_base.pl`, `queries/demonstration_queries.pl`, `docs/source-register.md`; source pages checked 2026-11-09. |
| 4 | Stage 3 rules and inference | Implemented; locally tested | `src/inference.pl`, query file, and PLUnit suites. |
| 5 | Stage 4 unification/backtracking and Stage 5 recursion/lists | Implemented; locally tested | `findall/3` retrieval queries; recursive list processing; tests in `tests/`. |
| 6 | Stage 6 arithmetic and advanced rules | Implemented; locally tested | Exact rational ranking, tie preservation, and narrowly justified negation-as-failure; no clinical threshold. |
| 7 | Stage 7 integration and testing | Linux verified; Windows pending | Console, validation, CI runner, 64 declarations / 180 passing executions on Linux SWI-Prolog 10.0.2. Re-run with official 64-bit Windows installer. |
| 8 | Stage 8 report and presentation | Report/deck prepared; video pending | `docs/final-report.md`, `presentation/project-presentation.pptx`, speaker notes, timed script. Record and upload the required video. |
| 9 | Oral demonstration/defense | Preparation materials ready; human delivery pending | `presentation/oral-defense-notes.md`; no live presentation or recording is claimed. |
| 10 | Final checks and submission | Pending | Confirm names/roles and scope, reverify Windows, record and upload video, test Drive permissions, submit to the course platform, and record confirmation. |

## Known blockers and pending human actions

1. Obtain team/lecturer review of the proposal, four-condition scope, source
   mappings, and scoring design. No approval is recorded in this repository.
2. Verify team member names, registration numbers, roles, and contributions from
   the team's own records.
3. Run the current integrated revision on Windows with the official 64-bit
   SWI-Prolog installer and record actual Windows/interpreter output.
4. Record the required project-explanation video, upload it to Google Drive,
   test its sharing permissions, and add the actual link.
5. Perform the final course submission and record confirmation.

## Historic schedule note

The date-by-date plan from 4-9 November in the original scaffold is a planning
artifact, not evidence that a task was performed. Current status is the table
above; historical test records are indexed separately in
[`historical-evidence-index.md`](historical-evidence-index.md).
