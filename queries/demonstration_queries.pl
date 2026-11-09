/*
   Executable queries for knowledge retrieval and inference demonstrations.
   Run from the repository root with:
     swipl -q -s queries/demonstration_queries.pl \
       -g demonstration_queries:run_query_examples -t halt
*/

:- module(demonstration_queries,
          [ list_conditions/1,
            symptoms_for/2,
            conditions_for_symptom/2,
            explain_report/4,
            run_query_examples/0
          ]).

:- use_module('../src/knowledge_base').
:- use_module('../src/inference').

/* Backtracking over condition/1 retrieves each declared condition. */
list_conditions(Conditions) :-
    findall(Condition, condition(Condition), Conditions).

/* Backtracking over condition_symptom/4 retrieves one source list. */
symptoms_for(Condition, Symptoms) :-
    condition(Condition),
    findall(Symptom,
            condition_symptom(Condition, Symptom, _, _),
            All),
    dedupe(All, Symptoms).

/* Unification and backtracking return every condition for a known term. */
conditions_for_symptom(TypedTerm, Conditions) :-
    normalise(TypedTerm, Symptom),
    findall(Condition,
            condition_symptom(Condition, Symptom, _, _),
            All),
    dedupe(All, Conditions).

/* Query helper returns all non-zero candidates, exact ranking, and unknowns. */
explain_report(TypedTerms, Matches, Ranked, Unknown) :-
    candidate_matches(TypedTerms, Matches, Unknown),
    ranking(Matches, Ranked).

run_query_examples :-
    list_conditions(Conditions),
    format('All conditions (findall over condition/1): ~q~n', [Conditions]),
    conditions_for_symptom("dry cough", CoughConditions),
    format('Conditions matching dry cough after normalisation: ~q~n',
           [CoughConditions]),
    findall(Qualification,
            condition_symptom(influenza, cough, Qualification, who_influenza),
            CoughQualifications),
    format('Stored influenza cough qualification: ~q~n',
           [CoughQualifications]),
    explain_report(["fever", "cough", "runny nose", "nasal congestion"],
                   Matches, Ranked, Unknown),
    format('Tied-example matches: ~q~n', [Matches]),
    format('Exact ranked groups: ~q~n', [Ranked]),
    format('Unknown terms: ~q~n', [Unknown]).
