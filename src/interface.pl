/*
   Console interface for the educational symptom matcher.
   Input/output is kept outside the pure inference module.
*/

:- module(symptom_console,
          [ main/0,
            demo/0,
            demo_case/1,
            demo_terms/2,
            report/1,
            run/0,
            run/1,
            usage/0
          ]).

:- use_module(knowledge_base).
:- use_module(inference).
:- use_module(library(lists)).
:- use_module(library(apply)).

banner :-
    nl,
    writeln('=========================================================='),
    writeln('  SYMPTOM MATCHER -- an educational Prolog set comparison'),
    writeln('  Four limited, source-linked condition profiles.'),
    writeln('  No diagnosis, probability, treatment or urgency output.'),
    writeln('=========================================================='),
    nl.

rule :-
    writeln('----------------------------------------------------------').

main :-
    banner,
    show_supported_terms,
    nl,
    writeln('Type symptoms separated by commas, then press Enter.'),
    writeln('Example: fever, headache, chills'),
    writeln('An empty line exits. Other terms are reported as unknown.'),
    prompt_loop.

prompt_loop :-
    format("~n[type symptoms, or an empty line to quit]~nsymptom-matcher> "),
    flush_output,
    read_line_to_string(user_input, Line),
    (   Line == end_of_file
    ->  nl,
        writeln('End of input.')
    ;   trim_line(Line, Trimmed),
        (   Trimmed == ""
        ->  nl,
            writeln('Finished.')
        ;   format("~nreceived: ~w~n", [Trimmed]),
            split_string(Trimmed, ",", " \t", Parts),
            exclude(==(""), Parts, Terms),
            report(Terms),
            prompt_loop
        )
    ).

trim_line(Input, Trimmed) :-
    split_string(Input, " \t\r\n", " \t\r\n", Parts),
    atomic_list_concat(Parts, ' ', Atom),
    atom_string(Atom, Trimmed).

show_supported_terms :-
    rule,
    writeln('Canonical symptom terms in this limited knowledge base:'),
    findall(Symptom, symptom(Symptom), Symptoms),
    print_columns(Symptoms),
    nl,
    writeln('Aliases are accepted; for example "dry cough" maps to cough.'),
    writeln('Repeated aliases of one feature count once.'),
    writeln('Unrecognised terms are shown separately and are not matched.'),
    rule.

print_columns([]).
print_columns([Symptom|Rest]) :-
    format("  ~w~n", [Symptom]),
    print_columns(Rest).

/*
   report(+TypedTerms) prints one bounded comparison. Invalid API input is
   handled as a validation message rather than an uncaught Prolog exception.
*/
report(TypedTerms) :-
    (   is_list(TypedTerms)
    ->  report_list(TypedTerms)
    ;   rule,
        writeln('Invalid input: expected a proper list of symptom terms.'),
        print_disclaimer,
        rule
    ).

report_list(TypedTerms) :-
    normalise_all(TypedTerms, Normalised0),
    dedupe_report(Normalised0, Reported, Duplicates),
    unknown_terms(TypedTerms, Unknown),
    rule,
    (   Reported == []
    ->  writeln('No recognised symptom terms; nothing was compared.'),
        report_unknown(Unknown),
        print_disclaimer,
        rule
    ;   length(Reported, Count),
        format("Understood ~w unique feature(s): ~w~n", [Count, Reported]),
        report_unknown(Unknown),
        report_duplicates(Duplicates),
        nl,
        candidate_matches(Reported, Candidates, _),
        (   Candidates == []
        ->  writeln('No non-zero matches in this limited knowledge base.'),
            writeln('No condition is selected or ruled out.'),
            print_disclaimer,
            rule
        ;   print_results(Candidates),
            ranking(Candidates, Ranked),
            print_ranking(Ranked),
            report_top(Ranked),
            writeln('The ordering is a software comparison rule, not a clinical measure.'),
            print_disclaimer,
            rule
        )
    ).

report_unknown([]) :- !.
report_unknown(Unknown) :-
    format("Unknown terms (not compared): ~w~n", [Unknown]).

report_duplicates([]) :- !.
report_duplicates(Duplicates) :-
    format("Duplicate reports collapsed (extra occurrences): ~w~n", [Duplicates]).

print_results(Results) :-
    writeln('Non-zero matches against the stored lists:'),
    forall(member(result(Condition, Fraction, Matched, Unmatched), Results),
           print_one(Condition, Fraction, Matched, Unmatched)).

print_one(Condition, frac(Shared, Total), Matched, Unmatched) :-
    condition_name(Condition, Name),
    format("  ~w~n", [Name]),
    format("      shared ~w of ~w listed features~n", [Shared, Total]),
    format("      matched: ~w~n", [Matched]),
    format("      recognised report terms not in this list: ~w~n", [Unmatched]).

print_ranking(Ranked) :-
    nl,
    writeln('Software ranking by exact shared/listed fraction (ties retained):'),
    forall(member(Fraction-Group, Ranked), print_rank_group(Fraction, Group)).

print_rank_group(frac(Shared, Total), Group) :-
    findall(Name,
            ( member(Condition, Group), condition_name(Condition, Name) ),
            Names),
    (   length(Group, Count),
        Count > 1
    ->  format("  TIE at ~w/~w: ~w~n", [Shared, Total, Names])
    ;   format("  ~w/~w: ~w~n", [Shared, Total, Names])
    ).

report_top(Ranked) :-
    tied_top(Ranked, Top),
    findall(Name,
            ( member(Condition, Top), condition_name(Condition, Name) ),
            Names),
    (   length(Top, Count),
        Count > 1
    ->  format("Highest software-overlap group is a tie: ~w~n", [Names])
    ;   format("Highest software-overlap group: ~w~n", [Names])
    ).

print_disclaimer :-
    disclaimer(Text),
    wrap_paragraph(Text, 76, Lines),
    forall(member(Line, Lines), format("~w~n", [Line])),
    nl.

/* Recursive word wrapping keeps the ASCII disclaimer readable in a console. */
wrap_paragraph(Text, Width, Lines) :-
    split_string(Text, " ", " ", Words),
    wrap_words(Words, Width, Lines).

wrap_words([], _, []).
wrap_words(Words, Width, [Line|Rest]) :-
    take_line(Words, Width, Taken, Left),
    atomic_list_concat(Taken, ' ', Line),
    wrap_words(Left, Width, Rest).

take_line([Word|Words], Width, [Word|Taken], Left) :-
    string_length(Word, Length),
    Length =< Width,
    take_more(Words, Width, Length, Taken, Left).

take_more([], _, _, [], []).
take_more([Word|Words], Width, Used, Taken, Left) :-
    string_length(Word, Length),
    Next is Used + 1 + Length,
    (   Next =< Width
    ->  Taken = [Word|Rest],
        take_more(Words, Width, Next, Rest, Left)
    ;   Taken = [],
        Left = [Word|Words]
    ).

demo_case(typical_malaria).
demo_case(typical_cold).
demo_case(measles_example).
demo_case(messy_input).
demo_case(tied_example).

demo_terms(typical_malaria, ["fever", "chills", "headache"]).
demo_terms(typical_cold, ["runny nose", "sneezing", "sore throat"]).
demo_terms(measles_example, ["fever", "rash", "red eyes", "cough"]).
demo_terms(messy_input,
           ["High Temperature", "fever", "headache", "banana",
            "stuffy nose", "fever"]).
demo_terms(tied_example,
           ["fever", "cough", "runny nose", "nasal congestion"]).

demo :-
    banner,
    forall(demo_case(Case),
           ( format("### demonstration case: ~w~n", [Case]),
             demo_terms(Case, Terms),
             format("terms: ~w~n", [Terms]),
             report(Terms),
             nl
           )).

run_demo(Case) :-
    demo_case(Case),
    demo_terms(Case, Terms),
    banner,
    format("### demonstration case: ~w~n", [Case]),
    report(Terms).

run :-
    current_prolog_flag(argv, Argv),
    run(Argv).

run([]) :-
    !,
    main.
run([Arg|_]) :-
    (   Arg == '--demo'
    ->  demo
    ;   Arg == '--help'
    ->  usage
    ;   atom(Arg),
        sub_atom(Arg, 0, _, _, '--demo='),
        !,
        atom_concat('--demo=', CaseText, Arg),
        (   atom_to_term(CaseText, Case, _),
            demo_case(Case)
        ->  run_demo(Case)
        ;   format("unknown demonstration case: ~w~n", [CaseText]),
            usage
        )
    ;   usage
    ).

usage :-
    writeln('Usage:'),
    writeln('  swipl -q -s src/symptom_matcher.pl --                 interactive'),
    writeln('  swipl -q -s src/symptom_matcher.pl -- --demo          all cases'),
    writeln('  swipl -q -s src/symptom_matcher.pl -- --demo=tied_example'),
    nl,
    writeln('Cases: typical_malaria, typical_cold, measles_example,'),
    writeln('       messy_input, tied_example.').
