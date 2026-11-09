/* PLUnit tests for vocabulary, provenance, facts, and retained qualifiers. */

:- use_module('../src/knowledge_base').
:- use_module('../src/inference').
:- use_module(library(lists)).
:- use_module(library(apply)).

:- begin_tests(kb_integrity).

test(four_conditions_declared) :-
    findall(C, condition(C), Conditions),
    Conditions == [malaria, influenza, measles, common_cold].

test(all_conditions_have_profile, forall(condition(C))) :-
    symptoms_of(C, Symptoms),
    Symptoms \== [].

test(profile_sizes_reflect_unique_canonical_features) :-
    symptoms_of(malaria, Malaria), length(Malaria, 10),
    symptoms_of(influenza, Influenza), length(Influenza, 7),
    symptoms_of(measles, Measles), length(Measles, 6),
    symptoms_of(common_cold, Cold), length(Cold, 8).

test(all_facts_reference_declared_terms,
     forall(condition_symptom(C, S, _, Source))) :-
    condition(C),
    symptom(S),
    source(Source, _, _, _, _).

test(each_fact_has_a_qualification,
     forall(condition_symptom(_, _, Qualification, _))) :-
    atom(Qualification),
    Qualification \== ''.

test(no_duplicate_condition_symptom_facts, forall(condition(C))) :-
    findall(S, condition_symptom(C, S, _, _), All),
    sort(All, Unique),
    length(All, Count),
    length(Unique, Count).

test(no_alias_is_also_canonical) :-
    \+ ( symptom_alias(Alias, _), symptom(Alias) ).

test(all_alias_targets_are_canonical,
     forall(symptom_alias(_, Canonical))) :-
    symptom(Canonical).

test(source_register_has_four_entries) :-
    findall(Id, source(Id, _, _, _, _), Ids),
    sort(Ids, [cdc_cold, who_influenza, who_malaria, who_measles]).

test(source_metadata_is_complete,
     forall(source(_, Org, Title, Url, Date))) :-
    atom(Org), Org \== '',
    atom(Title), Title \== '',
    atom(Url), sub_atom(Url, 0, 8, _, 'https://'),
    atom(Date), atom_length(Date, 10).

test(source_dates_match_checked_pages) :-
    source_date(who_malaria, '2025-12-04'),
    source_date(who_influenza, '2025-02-28'),
    source_date(who_measles, '2026-07-15'),
    source_date(cdc_cold, '2026-02-19').

test(each_condition_uses_one_recorded_source, forall(condition(C))) :-
    findall(Source, condition_symptom(C, _, _, Source), Sources),
    sort(Sources, [_]).

test(dry_cough_is_an_alias_for_cough) :-
    symptom_alias(dry_cough, cough),
    normalise("dry cough", cough),
    \+ symptom(dry_cough).

test(influenza_has_one_cough_feature_with_usually_dry) :-
    findall(Q, condition_symptom(influenza, cough, Q, who_influenza), Qualifiers),
    Qualifiers == [usually_dry],
    \+ condition_symptom(influenza, dry_cough, _, _),
    symptoms_of(influenza, Symptoms),
    include(=(cough), Symptoms, CoughFeatures),
    CoughFeatures == [cough].

test(influenza_fever_retains_sudden_onset) :-
    findall(Q, condition_symptom(influenza, fever, Q, who_influenza), Qs),
    Qs == [sudden_onset].

test(measles_fever_retains_high_qualification) :-
    findall(Q, condition_symptom(measles, fever, Q, who_measles), Qs),
    Qs == [high].

test(measles_white_spots_retain_small_white_qualification) :-
    condition_symptom(measles, white_spots_mouth, small_white, who_measles).

test(cold_fever_retains_usually_low_grade) :-
    condition_symptom(common_cold, fever, usually_low_grade, cdc_cold).

test(cold_body_aches_retain_mild_qualification) :-
    condition_symptom(common_cold, body_aches, mild, cdc_cold).

:- end_tests(kb_integrity).
