# Claude Project Instructions

These instructions apply to the entire repository. Follow them for every issue, branch, commit, pull request, explanation, and generated artifact.

## 1. Authoritative context

Before changing the project, read:

1. `docs/Project.pdf` — authoritative assignment brief supplied by the lecturer.
2. `docs/assignment-requirements.md` — navigable requirements summary; the PDF controls if there is a conflict.
3. `docs/snapshot-assessment.md` — recovered snapshot, scaffold/PDF comparison, and historical evidence limits.
4. `docs/stage-1-proposal.md` — current proposal, still subject to team review.
5. `docs/task-board.md` — current status, dependencies, and schedule.
6. `docs/sources.md` — source register for medical knowledge.
7. `docs/traceability-matrix.md` — requirement-to-evidence mapping.

Do not invent requirements, approvals, team details, test results, contributions, references, or a marking rubric.

## 2. Fixed project context

- **Title:** Knowledge-Based Symptom-Matching System for Selected Infectious Illnesses — Educational Prototype.
- **Language:** SWI-Prolog.
- **Interface:** Console application implemented for review; formal team/lecturer approval is not recorded.
- **Proposed illnesses:** malaria, influenza, common cold, and measles; scope approval remains pending.
- **Deadline:** User-provided as 9 November 2026 at 23:59 EAT (Africa/Kampala); not stated in `docs/Project.pdf`.
- **Assignment value:** Not stated in the PDF; a prior scaffold claim of 100 points is unsupported. No separate criterion-level rubric was supplied.
- **Current stage:** Stages 2-7 have an implementation and Linux evidence in this branch. The Stage 1 proposal and scope still need human review; Stage 8 artifacts exist, while Windows re-verification and the Google Drive video remain pending.

Do not change the title, scope, illness set, deadline, interface, or approval status without explicit team confirmation recorded in the relevant documentation.

## 3. Medical and safety boundaries

This is an educational symptom-matching prototype, not a diagnostic or clinical triage system.

Do not introduce:

- diagnostic confirmation or claims of clinical reliability;
- emergency, urgency, traffic-light, or treatment recommendations;
- medical probabilities from simple overlap counts;
- arbitrary thresholds represented as medically supported;
- real patient information;
- unsourced medical claims presented as authoritative facts.

Use transparent application-level overlap measures and explain matched, unmatched, and unknown symptoms. Any minimum application rule must be described only as a software rule. Keep the educational-use disclaimer prominent.

Record external knowledge in `docs/sources.md`, including the specific facts each source supports. Distinguish sourced information from simplifications made for the assignment. Never invent a citation.

## 4. Engineering requirements

The completed application must demonstrate, where appropriate:

- facts and predicates;
- logical rules and inference;
- working queries;
- unification and backtracking;
- meaningful recursion;
- list processing;
- arithmetic and comparisons;
- knowledge-based reasoning;
- input and output;
- valid, invalid, boundary, and edge-case testing;
- clear documentation and an explanation of the reasoning process.

Additional rules:

- Provide complete, runnable Prolog instead of disconnected fragments.
- Organize and comment code clearly.
- Return all eligible matches, including ties.
- Handle empty, duplicate, unknown, malformed, and no-match inputs.
- Use negation as failure **or** cut only where appropriate, and justify the choice.
- Add or update tests for each implemented major predicate.
- Update documentation and the traceability matrix when implementation changes.
- Preserve the distinction between expected output and verified output.

Never claim code or tests were executed unless they were actually executed in the current environment. Record exact commands and honest results.

## 5. Git and pull-request workflow

1. Select or create a scoped GitHub issue before substantial work.
2. Create a descriptive branch such as `stage-2/knowledge-base` or `test/input-validation`.
3. Do not commit directly to `main`.
4. Make focused commits with clear messages.
5. Open a pull request using the supplied template.
6. Describe changes, requirement coverage, exact tests, limitations, and documentation updates.
7. Do not merge without the required team review.
8. Resolve failing checks and review comments before merge.
9. Never commit credentials, Slack tokens, GitHub tokens, `.env` files, or unnecessary personal information.

## 6. Stage discipline

- Do not mark a stage complete without its actual deliverable and evidence.
- Do not treat a planned file, placeholder, status update, or keyword check as a completed application feature.
- Keep Stage 1 as **Needs review** until the team explicitly approves the proposal content.
- Do not encode unsourced condition–symptom relationships as authoritative knowledge.
- Do not treat the review-branch implementation as team or lecturer approval. Do not expand or represent the proposed scope as approved until approval is recorded.

## 7. Definition of done

A development task is done only when:

- its code loads successfully;
- relevant tests have actually run and passed, or limitations are explicitly reported;
- test commands and results are recorded honestly;
- sources and documentation are updated;
- the requirement traceability remains accurate;
- a reviewer can understand and defend the reasoning;
- no unsupported approval or medical claim has been introduced.
