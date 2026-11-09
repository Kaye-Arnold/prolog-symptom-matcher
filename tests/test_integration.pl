/* PLUnit tests for user-visible reports and demonstration inputs. */

:- use_module('../src/interface').
:- use_module('../src/inference').
:- use_module(library(lists)).

output_contains(Output, Fragment) :-
    once(sub_string(Output, _, _, _, Fragment)).

:- begin_tests(console_integration).

test(all_demonstration_cases_are_defined) :-
    findall(Case, demo_case(Case), Cases),
    sort(Cases, [measles_example, messy_input, tied_example,
                 typical_cold, typical_malaria]),
    length(Cases, 5).

test(each_demonstration_case_normalises, forall(demo_case(Case))) :-
    demo_terms(Case, Terms),
    normalise_all(Terms, Normalised),
    Normalised \== [].

test(messy_demo_exercises_alias_duplicate_and_unknown) :-
    demo_terms(messy_input, Terms),
    normalise_all(Terms, Normalised),
    dedupe_report(Normalised, Unique, Duplicates),
    unknown_terms(Terms, Unknown),
    Unique == [fever, headache, nasal_congestion],
    Duplicates == [fever-2],
    Unknown == [banana].

test(tied_demo_case_produces_equal_top_group) :-
    demo_terms(tied_example, Terms),
    candidate_matches(Terms, Matches, []),
    ranking(Matches, Ranked),
    tied_top(Ranked, Top),
    sort(Top, [common_cold, measles]).

test(empty_input_prints_no_match_and_disclaimer) :-
    with_output_to(string(Output), report([])),
    output_contains(Output, "No recognised symptom terms"),
    output_contains(Output, "Educational comparison only"),
    output_contains(Output, "does not provide diagnoses").

test(unknown_only_input_prints_unknowns_and_no_candidate) :-
    with_output_to(string(Output), report(["banana", "BANANA"])),
    output_contains(Output, "Unknown terms (not compared): [banana]"),
    output_contains(Output, "No recognised symptom terms"),
    \+ output_contains(Output, "Highest software-overlap group").

test(duplicates_aliases_and_unknowns_are_visible) :-
    with_output_to(string(Output),
                   report(["fever", "HIGH TEMPERATURE", "banana"])),
    output_contains(Output, "Understood 1 unique feature(s): [fever]"),
    output_contains(Output, "Duplicate reports collapsed"),
    output_contains(Output, "Unknown terms (not compared): [banana]").

test(tied_report_prints_tie_and_exact_fraction) :-
    with_output_to(string(Output),
                   report(["fever", "cough", "runny nose", "nasal congestion"])),
    output_contains(Output, "TIE at 3/6"),
    output_contains(Output, "Highest software-overlap group is a tie"),
    output_contains(Output, "not a clinical measure").

test(improper_input_is_rejected_without_exception) :-
    with_output_to(string(Output), report([fever|not_a_list])),
    output_contains(Output, "Invalid input"),
    output_contains(Output, "Educational comparison only").

test(non_list_input_is_rejected_without_exception) :-
    with_output_to(string(Output), report(not_a_list)),
    output_contains(Output, "expected a proper list").

test(no_emergency_or_urgency_instruction_is_printed) :-
    with_output_to(string(Output), report([fever])),
    \+ output_contains(Output, "Seek care"),
    \+ output_contains(Output, "Call emergency"),
    \+ output_contains(Output, "DANGER SIGNS").

:- end_tests(console_integration).
