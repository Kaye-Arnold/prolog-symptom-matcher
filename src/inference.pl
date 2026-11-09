/*
   Pure inference and list-processing predicates for the symptom matcher.
   No predicate in this module performs input/output.
*/

:- module(symptom_logic,
          [ normalise/2,
            normalise_all/2,
            unknown_terms/2,
            dedupe/2,
            dedupe_report/3,
            symptoms_of/2,
            overlap/3,
            difference/3,
            coverage_fraction/3,
            compare_all/3,
            candidate_matches/3,
            ranking/2,
            tied_top/2
          ]).

:- use_module(knowledge_base).
:- use_module(library(lists)).
:- use_module(library(apply)).

/*
   normalise(+Typed, -Canonical)
   Accept an atom, string, number, str(String) wrapper, or a list of character
   codes. Convert case and whitespace, then consult the canonical vocabulary
   and alias facts. Unsupported terms fail without throwing an exception.
*/
normalise(Typed, Canonical) :-
    lowered_name(Typed, Name),
    (   symptom(Name)
    ->  Canonical = Name
    ;   symptom_alias(Name, Canonical)
    ).

lowered_name(Typed, Name) :-
    typed_text(Typed, Text0),
    string_lower(Text0, Lower),
    split_string(Lower, " \t\n\r", " \t\n\r", Parts),
    Parts \== [],
    atomic_list_concat(Parts, '_', Name).

typed_text(Term, Text) :-
    atom(Term),
    !,
    atom_string(Term, Text).
typed_text(Term, Term) :-
    string(Term),
    !.
typed_text(str(Term), Term) :-
    string(Term),
    !.
typed_text(Term, Text) :-
    number(Term),
    !,
    number_string(Term, Text).
typed_text(Codes, Text) :-
    is_list(Codes),
    maplist(integer, Codes),
    string_codes(Text, Codes).

/* Keep recognised terms in input order; unknown items are reported apart. */
normalise_all([], []).
normalise_all([Term|Terms], Normalised) :-
    (   normalise(Term, Canonical)
    ->  Normalised = [Canonical|Rest]
    ;   Normalised = Rest
    ),
    normalise_all(Terms, Rest).

/* Unknown labels are lower-cased and whitespace-normalised, then deduplicated. */
unknown_terms(Raw, Unknown) :-
    is_list(Raw),
    findall(Label,
            ( member(Term, Raw),
              \+ normalise(Term, _),
              unknown_label(Term, Label)
            ),
            Labels),
    dedupe(Labels, Unknown).

unknown_label(Term, Label) :-
    (   lowered_name(Term, Label)
    ->  true
    ;   term_to_atom(Term, Label)
    ).

/*
   dedupe(+List, -Unique) retains the first occurrence. The accumulator is
   reversed during recursion and restored once at the end.
*/
dedupe(List, Unique) :-
    is_list(List),
    dedupe_acc(List, [], Reversed),
    reverse(Reversed, Unique).

dedupe_acc([], Accumulator, Accumulator).
dedupe_acc([Head|Tail], Accumulator, Unique) :-
    (   memberchk(Head, Accumulator)
    ->  dedupe_acc(Tail, Accumulator, Unique)
    ;   dedupe_acc(Tail, [Head|Accumulator], Unique)
    ).

/* Duplicates are reported as Term-ExtraCount, not total occurrences. */
dedupe_report(List, Unique, Duplicates) :-
    dedupe(List, Unique),
    findall(Term-Extra,
            ( member(Term, Unique),
              count_occurrences(List, Term, Count),
              Extra is Count - 1,
              Extra > 0
            ),
            Duplicates).

count_occurrences([], _, 0).
count_occurrences([Head|Tail], Term, Count) :-
    count_occurrences(Tail, Term, TailCount),
    (   Head == Term
    ->  Count is TailCount + 1
    ;   Count = TailCount
    ).

/* Source-backed canonical symptom set for one condition. */
symptoms_of(Condition, Symptoms) :-
    condition(Condition),
    findall(Symptom,
            condition_symptom(Condition, Symptom, _, _),
            All),
    dedupe(All, Symptoms).

/* Set intersection and difference; duplicates in either input do not count. */
overlap(Left, Right, Shared) :-
    dedupe(Left, LeftSet),
    dedupe(Right, RightSet),
    include(in_set(RightSet), LeftSet, Shared).

difference(Left, Right, OnlyLeft) :-
    dedupe(Left, LeftSet),
    dedupe(Right, RightSet),
    exclude(in_set(RightSet), LeftSet, OnlyLeft).

in_set(Set, Element) :-
    memberchk(Element, Set).

/*
   coverage_fraction(+TypedReport, +Condition, -frac(N,D))
   N is the unique shared canonical feature count. D is that condition's own
   unique source-linked feature count. This is an application-level ratio,
   not a probability or a clinical measure.
*/
coverage_fraction(TypedReport, Condition, frac(N, D)) :-
    normalise_all(TypedReport, Normalised0),
    dedupe(Normalised0, Normalised),
    symptoms_of(Condition, ConditionSymptoms),
    length(ConditionSymptoms, D),
    overlap(Normalised, ConditionSymptoms, Shared),
    length(Shared, N).

/*
   compare_all(+TypedReport, -Results, -Unknown)
   Results contains one result(Condition, frac(N,D), Matched, Unmatched)
   for each declared condition. Unmatched means a recognised reported term
   absent from that limited source list; it does not mean the condition is
   absent. Unknown terms are returned separately.
*/
compare_all(TypedReport, Results, Unknown) :-
    is_list(TypedReport),
    normalise_all(TypedReport, Normalised0),
    dedupe(Normalised0, Normalised),
    unknown_terms(TypedReport, Unknown),
    findall(result(Condition, frac(N, D), Matched, Unmatched),
            ( condition(Condition),
              symptoms_of(Condition, ConditionSymptoms),
              overlap(Normalised, ConditionSymptoms, Matched),
              length(ConditionSymptoms, D),
              length(Matched, N),
              difference(Normalised, ConditionSymptoms, Unmatched)
            ),
            Results).

/* Only non-zero overlaps are eligible application-level matches. */
candidate_matches(TypedReport, Candidates, Unknown) :-
    compare_all(TypedReport, AllResults, Unknown),
    include(positive_overlap, AllResults, Candidates).

positive_overlap(result(_, frac(N, _), _, _)) :-
    N > 0.

/*
   ranking(+Results, -Ranked)
   Group positive results by exact fraction, highest first. Ratios are ordered
   by cross multiplication (no floating-point arithmetic); equivalent ratios
   stay in the same group. Zero-overlap results are not ranked as candidates.
*/
ranking(Results, Ranked) :-
    include(positive_overlap, Results, Candidates),
    findall(Fraction,
            member(result(_, Fraction, _, _), Candidates),
            Fractions),
    dedupe(Fractions, Distinct0),
    predsort(by_score, Distinct0, Ascending),
    reverse(Ascending, Distinct),
    findall(Fraction-Group,
            ( member(Fraction, Distinct),
              findall(Condition,
                      ( member(result(Condition, Score, _, _), Candidates),
                        same_score(Score, Fraction)
                      ),
                      Group0),
              dedupe(Group0, Group)
            ),
            Ranked).

by_score(Order, frac(N1, D1), frac(N2, D2)) :-
    Left is N1 * D2,
    Right is N2 * D1,
    compare(Order, Left, Right).

same_score(frac(N1, D1), frac(N2, D2)) :-
    N1 * D2 =:= N2 * D1.

/* Fails for an empty ranking; returns every condition in the top tie group. */
tied_top([_-Top|_], Top).
