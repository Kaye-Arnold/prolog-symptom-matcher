# Stage 1 Project Proposal and Problem Specification

> **Status:** Needs team review  
> **Scope and interface:** Proposed; pending confirmation  
> **Implementation and testing:** Not started

## 1. Project title

**Knowledge-Based Symptom-Matching System for Selected Infectious Illnesses — Educational Prototype**

## 2. Project details

- **Course:** Logic Programming
- **Language:** SWI-Prolog
- **Assignment value:** 100 points
- **Submission deadline:** 9 November 2026 at 11:59 PM EAT (Africa/Kampala)
- **Team:** Verified member details must be imported from the team’s records; do not infer names or registration numbers.
- **Team Lead and other roles:** Pending group confirmation unless documented otherwise.
- **Separate marking rubric:** Not supplied.

## 3. Background

Logic programming provides a declarative way to represent entities and relationships and derive conclusions from them. A bounded symptom-matching problem is suitable for demonstrating these ideas because condition–symptom relationships can be stored as facts, while candidate matches can be derived using rules and queries.

This project will build a small educational knowledge base covering four proposed infectious illnesses: malaria, influenza, common cold, and measles. The application will compare a user-supplied symptom collection with stored relationships and explain the resulting overlaps. It will not attempt to reproduce clinical diagnosis or decision-making.

## 4. Problem statement

A collection of condition–symptom relationships can be difficult to inspect systematically when several conditions share symptoms. Manual comparison can obscure which entries produced a match, which reported terms were unmatched, and whether more than one candidate has the same overlap.

The problem is to design and implement a Prolog knowledge-based application that stores a bounded, sourced set of condition–symptom relationships, accepts or queries symptom collections, derives all eligible matches, processes matched and unmatched terms, and presents transparent results that can be tested and explained.

The application addresses an educational information-retrieval and logical-reasoning problem only. Non-zero overlap is an application rule for candidate inclusion, not evidence of disease presence, diagnostic confidence, or clinical urgency.

## 5. Aim

To design, implement, test, document, and demonstrate an educational SWI-Prolog knowledge-based system that performs explainable symptom matching over a bounded set of selected infectious illnesses.

## 6. Specific objectives

1. Design a knowledge-representation scheme for conditions, symptoms, and their relationships.
2. Document reputable sources for encoded relationships and identify educational simplifications.
3. Represent the bounded knowledge using meaningful Prolog facts and predicates.
4. Provide retrieval queries for inspecting conditions, symptoms, and shared relationships.
5. Define rules that derive candidate matches using unification and backtracking.
6. Represent reported, matched, unmatched, and unknown symptom collections as lists and process them using meaningful recursion.
7. Calculate a transparent overlap measure and rank eligible candidates without discarding ties.
8. Validate empty, duplicate, unknown, malformed, and no-match inputs.
9. Integrate the components into a clear console application with appropriate input and output.
10. Execute and document normal, invalid, boundary, and edge-case tests.
11. Produce user instructions, technical documentation, a final report, a presentation, and an oral-defense explanation.
12. Record and submit the required project-explanation video link through Google Drive.

## 7. Scope

### Included

- Four proposed illness profiles: malaria, influenza, common cold, and measles.
- A deliberately bounded vocabulary of sourced symptom terms.
- Facts, retrieval queries, inference rules, recursion, lists, arithmetic, comparisons, and appropriate advanced rules.
- Transparent reporting of all eligible matches, including ties.
- Matched symptoms, reported symptoms not matched to a candidate, and terms unknown to the application vocabulary.
- Explicit no-match behavior and input validation.
- A proposed console interface.
- Demonstration queries, executable tests, documentation, and an oral defense.

### Excluded

- Confirming or excluding a medical diagnosis.
- Clinical triage, urgency classification, treatment, or medication advice.
- Medical probabilities derived from overlap counts.
- Claims of clinical validation or real-world reliability.
- Comprehensive coverage of infectious diseases or all possible symptoms.
- Real patient records or identifiable patient information.
- Laboratory-test interpretation or replacement of professional assessment.

## 8. Required knowledge

The knowledge base will require:

- canonical identifiers for the four proposed conditions;
- a controlled vocabulary of educational symptom terms;
- condition–symptom relationships supported by recorded sources;
- identification of relationships shared by multiple conditions;
- source provenance for each relationship or documented group of relationships;
- a clear distinction between source-backed knowledge and simplifications introduced for the assignment;
- an explicit policy for unknown terms and duplicate input;
- a documented, explainable overlap or coverage calculation approved before implementation.

Symptoms will not be described as necessary, sufficient, or clinically definitive unless a reliable source supports that exact claim and the design appropriately represents it. The default representation will be a limited educational association, not a complete clinical profile.

## 9. Intended users

- Students demonstrating logic-programming concepts.
- The lecturer or evaluator inspecting the knowledge base, queries, inference, and tests.
- Team members preparing the project demonstration and oral defense.

The prototype is not intended for patients, clinicians, emergency use, or real healthcare decision-making.

## 10. Inputs and expected outputs

### Inputs

- Demonstration queries over the knowledge base.
- A symptom list supplied through the proposed console interface or an application predicate.
- Validation-related inputs, including empty, duplicate, malformed, and unknown terms.

### Outputs

- All eligible candidate matches under the documented application rule.
- Transparent overlap counts and, if approved, a clearly defined coverage calculation.
- Matched symptoms supporting each result.
- Reported symptoms not associated with a candidate.
- Unknown terms not present in the controlled vocabulary.
- Tied rankings where applicable.
- An explicit no-match response.
- Validation messages for invalid input.
- A prominent educational-use disclaimer and concise reasoning explanation.

## 11. Why logic programming is suitable

Prolog suits this problem because its operational model directly supports the required reasoning:

- **Facts** declaratively represent condition–symptom relationships.
- **Rules** combine those relationships with reported symptoms to derive candidate matches.
- **Queries** retrieve stored knowledge and inspect derived results.
- **Unification** binds variables and matches symptom terms against stored facts.
- **Backtracking** explores alternative conditions and returns multiple solutions rather than prematurely selecting one.
- **Lists** represent reported, matched, unmatched, and unknown symptom collections.
- **Recursion** provides meaningful traversal and processing of those collections.
- **Arithmetic and comparisons** calculate and rank transparent overlap measures.
- **Negation as failure or cut**, if used, can address a narrowly justified logical or search-control need without replacing careful rule design.

The suitability therefore comes from the structure of the problem, not merely from the assignment’s requirement to use Prolog.

## 12. Methodology

The project will follow the assignment’s eight stages: proposal; facts and retrieval queries; inference rules; unification and backtracking demonstrations; recursion and list processing; arithmetic and advanced rules; application integration and testing; and final reporting, presentation, demonstration, and defense.

Development will use scoped branches and reviewed pull requests. Sources, tests, and traceability documentation will evolve with the implementation. Expected output will remain clearly separate from output verified by execution.

## 13. Limitations and educational disclaimer

The prototype will use a small knowledge base and controlled vocabulary. Symptom overlap does not establish disease presence, absence, severity, contagiousness, or urgency. Similar symptom terms may have different clinical meanings, and real assessment can require history, examination, and laboratory testing.

**This software is solely an educational demonstration of logic programming. It must not be used to diagnose illness, determine urgency, select treatment, or replace professional medical assessment.**

## 14. Expected deliverables

The team will submit the proposal, knowledge-representation design, Prolog facts and rules, demonstration queries, required logic-programming implementations, complete source code, test cases and results, technical documentation and user instructions, final report, presentation/oral defense, and the required Google Drive video link.

## 15. Pending decisions

- Team content review and approval of this proposal.
- Verified team-member details and agreed roles.
- Lecturer confirmation of the illness set and console interface.
- Reputable sources and source-backed condition–symptom relationships.
- Final overlap/coverage definition.
- Any separately prescribed report or presentation format.

## 16. References

The authoritative assignment brief is `docs/Project.pdf`. External medical references have not yet been verified for encoding and must be recorded in `docs/sources.md` before the corresponding facts are treated as sourced.
