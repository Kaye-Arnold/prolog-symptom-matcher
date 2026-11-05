# Knowledge-Based Symptom-Matching System

An educational prototype for a Logic Programming course, developed in **SWI-Prolog**.

The project will represent a bounded collection of condition–symptom relationships and use logical inference to produce transparent symptom matches. The proposed conditions are **malaria, influenza, common cold, and measles**, subject to scope confirmation.

> **Educational use only:** This project does not diagnose illness, determine clinical urgency, recommend treatment, or replace professional medical assessment.

## Repository status

- Stage 1 proposal: **Needs team review**.
- Illness scope and console interface: **Proposed; pending confirmation**.
- Medical knowledge sourcing: **Not complete**.
- Prolog implementation: **Not started**.
- Application tests: **Not executed**.
- Assignment value: **100 points**.
- Submission deadline: **9 November 2026 at 11:59 PM EAT (Africa/Kampala)**.
- Separate marking rubric: **Not supplied**.

## Planned features

- Declarative condition–symptom knowledge with documented sources.
- Retrieval queries and inference rules.
- Candidate generation through unification and backtracking.
- Meaningful recursion and symptom-list processing.
- Transparent overlap calculations and ranked results, including ties.
- Matched, unmatched, and unknown symptom reporting.
- Explicit input validation and no-match handling.
- Console-based user interaction.
- Demonstration queries, executable tests, and technical documentation.

## Repository layout

```text
CLAUDE.md                         Persistent instructions for Claude
CONTRIBUTING.md                   Team and pull-request rules
docs/                             Brief, proposal, sources, plans, and report
src/                              Prolog application source (planned)
queries/                          Demonstration queries (planned)
tests/                            PLUnit tests and runner (planned)
presentation/                     Slides, demo, and oral-defense materials
.github/                          PR template and CI checks
```

## Documentation map

- [Authoritative assignment brief](docs/Project.pdf)
- [Assignment requirements](docs/assignment-requirements.md)
- [Stage 1 proposal](docs/stage-1-proposal.md)
- [Task board and schedule](docs/task-board.md)
- [Knowledge-representation design](docs/knowledge-representation.md)
- [Source register](docs/sources.md)
- [Traceability matrix](docs/traceability-matrix.md)
- [Test plan](docs/test-plan.md)
- [GitHub setup and enforcement](docs/github-setup.md)

## Technology

SWI-Prolog is required once implementation begins. Installation, execution, and verified testing instructions will be added with the corresponding code. No setup or test command is currently claimed to have been executed.
