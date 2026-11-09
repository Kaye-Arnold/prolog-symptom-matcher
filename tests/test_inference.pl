/* PLUnit tests for normalisation, recursion, sets, scoring, and inference. */

:- use_module('../src/knowledge_base').
:- use_module('../src/inference').
:- use_module(library(lists)).

:- begin_tests(normalisation).

test(canonical_passthrough) :-
    normalise(fever, fever).

test(case_and_whitespace_normalisation) :-
    normalise("  HIGH   TEMPERATURE  ", fever).

test(multiword_alias_normalisation) :-
    normalise("stuffy nose", nasal_congestion).

test(dry_cough_alias_normalises_to_single_cough) :-
    normalise("dry cough", cough),
    normalise(dry_cough, cough).

test(unknown_atom_fails) :-
    \+ normalise(banana, _).

test(unsupported_compound_fails_without_exception) :-
    \+ normalise(unknown(term), _).

test(number_is_not_a_known_symptom) :-
    \+ normalise(42, _).

test(empty_text_fails) :-
    \+ normalise("   ", _).

test(normalise_all_keeps_recognised_order) :-
    normalise_all(["fever", "banana", "dry cough", "cough"], Terms),
    Terms == [fever, cough, cough].

test(unknowns_are_reported_and_deduplicated) :-
    unknown_terms([fever, "Banana", "banana", "yellow banana"], Unknown),
    Unknown == [banana, yellow_banana].

test(malformed_unknown_terms_are_safe) :-
    unknown_terms([42, unknown(term), 42], Unknown),
    Unknown == ['42', 'unknown(term)'].

:- end_tests(normalisation).

:- begin_tests(list_processing).

test(dedupe_keeps_first_occurrence) :-
    dedupe([fever, headache, fever, cough], Unique),
    Unique == [fever, headache, cough].

test(dedupe_empty_list) :-
    dedupe([], []).

test(dedupe_report_counts_extra_occurrences) :-
    normalise_all(["fever", "High Temperature", "cough", "dry cough"], Raw),
    dedupe_report(Raw, Unique, Duplicates),
    Unique == [fever, cough],
    Duplicates == [fever-1, cough-1].

test(overlap_uses_set_semantics) :-
    overlap([a, b, a, c], [b, c, c], Shared),
    Shared == [b, c].

test(overlap_preserves_left_order) :-
    overlap([c, b, a], [a, b], Shared),
    Shared == [b, a].

test(difference_uses_set_semantics) :-
    difference([a, b, a, c], [b, b], OnlyLeft),
    OnlyLeft == [a, c].

test(normalise_all_is_recursive_over_empty_list) :-
    normalise_all([], []).

:- end_tests(list_processing).

:- begin_tests(scoring_and_inference).

test(profile_denominator_is_condition_specific, forall(condition(C))) :-
    symptoms_of(C, Symptoms),
    coverage_fraction([], C, frac(0, Denominator)),
    length(Symptoms, Denominator).

test(malaria_three_term_fraction) :-
    coverage_fraction([fever, chills, headache], malaria, frac(3, 10)).

test(influenza_denominator_has_no_dry_cough_duplicate) :-
    coverage_fraction(["cough", "dry cough"], influenza, frac(1, 7)).

test(compare_all_returns_each_condition) :-
    compare_all([fever], Results, []),
    length(Results, 4).

test(compare_all_separates_unknowns) :-
    compare_all([fever, banana], Results, Unknown),
    Unknown == [banana],
    memberchk(result(influenza, frac(1, 7), [fever], []), Results).

test(compare_all_reports_known_unmatched_terms) :-
    compare_all([fever, rash], Results, []),
    memberchk(result(influenza, frac(1, 7), [fever], [rash]), Results).

test(zero_overlap_is_not_an_eligible_candidate) :-
    compare_all(["banana"], AllResults, [banana]),
    length(AllResults, 4),
    candidate_matches(["banana"], [], [banana]).

test(candidate_matches_include_positive_results_only) :-
    candidate_matches([fever], Candidates, []),
    Candidates \== [],
    forall(member(result(_, frac(N, _), _, _), Candidates), N > 0).

test(equal_exact_fraction_preserves_tied_top) :-
    candidate_matches([fever, cough, "runny nose", "nasal congestion"],
                      Candidates, []),
    ranking(Candidates, [frac(3, 6)-Top|_]),
    msort(Top, Sorted),
    Sorted == [common_cold, measles].

test(tie_example_has_both_equal_fraction_forms) :-
    candidate_matches([fever, cough, "runny nose", "nasal congestion"],
                      Candidates, []),
    ranking(Candidates, Ranked),
    memberchk(frac(3, 6)-Group, Ranked),
    sort(Group, [common_cold, measles]).

test(smaller_denominator_ranks_higher_for_equal_numerator) :-
    candidate_matches([cough, "runny nose"], Candidates, []),
    ranking(Candidates, [frac(2, 6)-[measles]|_]).

test(ranking_orders_exact_fractions_without_float) :-
    ranking([ result(a, frac(1, 3), [], []),
              result(b, frac(2, 3), [], []),
              result(c, frac(1, 2), [], [])
            ], Ranked),
    Ranked == [frac(2, 3)-[b], frac(1, 2)-[c], frac(1, 3)-[a]].

test(ranking_groups_equivalent_fractions) :-
    ranking([ result(a, frac(3, 6), [], []),
              result(b, frac(4, 8), [], [])
            ], [frac(3, 6)-Group]),
    sort(Group, [a, b]).

test(ranking_empty_candidates_is_empty) :-
    ranking([], []).

test(tied_top_returns_all_tied_conditions) :-
    candidate_matches([fever, cough, "runny nose", "nasal congestion"],
                      Candidates, []),
    ranking(Candidates, Ranked),
    tied_top(Ranked, Top),
    sort(Top, [common_cold, measles]).

test(tied_top_fails_for_empty_ranking) :-
    \+ tied_top([], _).

:- end_tests(scoring_and_inference).
