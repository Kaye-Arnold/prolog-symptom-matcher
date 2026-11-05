# Requirements Traceability Matrix

This matrix maps assignment requirements to intended evidence. “Planned” is not completion. Update the evidence and status only when the artifact actually exists and its claims are supported.

| Requirement / deliverable | Planned or current evidence | Status |
|---|---|---|
| Problem statement, objectives, scope, knowledge, users, outputs, Prolog suitability | `docs/stage-1-proposal.md` | Draft present; needs team review |
| Knowledge-representation design | `docs/knowledge-representation.md` | Preliminary; Stage 2 not complete |
| External knowledge acknowledged | `docs/sources.md` and final report references | Source research not complete |
| Meaningful facts and predicates | `src/knowledge_base.pl` | Planned; no facts encoded |
| Retrieval queries | `queries/demonstration_queries.pl` | Planned; not executed |
| Rules and logical inference | `src/inference.pl` and demonstration queries | Planned |
| Unification and variable binding explanation | Stage 4 queries and `presentation/oral-defense-notes.md` | Planned |
| Backtracking and multiple solutions | Stage 4 multi-solution queries and results | Planned |
| Meaningful recursion | Recursive list predicates in application source and tests | Planned |
| List processing | Reported, matched, unmatched, and unknown symptom lists | Planned |
| Arithmetic and comparisons | Transparent overlap calculations and ranking | Planned; formula requires review |
| Negation as failure or cut where appropriate | Narrowly justified advanced rule, if needed | Not mandatory to use both; not implemented |
| Knowledge-based reasoning | Candidate derivation from facts, rules, and reports | Planned |
| Input and output | `src/interface.pl` | Proposed console interface; not implemented |
| Invalid and edge-case handling | Validation predicates and test suite | Planned |
| Major predicates tested | `tests/` and recorded commands/results | Not started; no execution claimed |
| Integrated application | `src/symptom_matcher.pl` and supporting modules | Planned |
| Technical documentation | Relevant documents under `docs/` | Structure present; technical content incomplete |
| User instructions | `docs/user-guide.md` | Awaits implementation |
| Final report | `docs/final-report.md` | Outline only |
| Presentation and feature demonstration | `presentation/` | Planning materials only |
| Test cases and results | `docs/test-plan.md` plus executed results section | Plan present; no results yet |
| Limitations and future improvements | Proposal and final report | Initial limitations present; final evaluation pending |
| Oral defense | `presentation/oral-defense-notes.md` | Preparation required |
| Google Drive video link | Submission record in `docs/final-report.md` | Not recorded or uploaded |
| Team details and roles | Proposal and final submission | Outstanding verified details |
| Submission by deadline | Final repository and submission confirmation | Not submitted |

## Evidence-quality rule

A link, placeholder, task-board status, successful repository-structure check, or expected result is not evidence that an application requirement works. Completion requires the actual artifact and appropriate verification.
