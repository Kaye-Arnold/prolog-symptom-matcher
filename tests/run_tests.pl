/*
   PLUnit runner with positive evidence and non-empty-suite enforcement.
   Run from the repository root: swipl -q -s tests/run_tests.pl

   The summary reports declarations separately from passing executions because
   forall/1 tests can execute once for each generated solution. This runner does
   not assume that exit status 0 means a suite existed or ran.
*/

:- use_module(library(plunit)).
:- use_module(library(apply)).

:- initialization(run_test_suite, main).

run_test_suite :-
    (   catch(assess(Verdict), Error,
              ( print_message(error, Error), Verdict = error(Error) ))
    ->  true
    ;   Verdict = failed
    ),
    report_verdict(Verdict).

report_verdict(pass(Declarations, Executions)) :-
    !,
    format('RESULT: PASS - ~w declarations, ~w passing executions; ',
           [Declarations, Executions]),
    writeln('0 failed, 0 timed out, 0 blocked, 0 fixme.'),
    halt(0).
report_verdict(fail(Reason)) :-
    !,
    format('RESULT: FAIL - ~p~n', [Reason]),
    explain(Reason),
    halt(1).
report_verdict(error(Error)) :-
    !,
    writeln('RESULT: FAIL - test runner error.'),
    print_message(error, Error),
    halt(1).
report_verdict(failed) :-
    !,
    writeln('RESULT: FAIL - test runner did not complete.'),
    halt(1).

assess(Verdict) :-
    writeln('Loading PLUnit suites ...'),
    (   catch(load_test_files, LoadError,
              ( print_message(error, LoadError), fail ))
    ->  writeln('Test files loaded.'),
        assess_loaded_suites(Verdict)
    ;   Verdict = fail(load_failed)
    ).

load_test_files :-
    consult('tests/test_knowledge_base.pl'),
    consult('tests/test_inference.pl'),
    consult('tests/test_integration.pl').

assess_loaded_suites(Verdict) :-
    writeln('Running all PLUnit suites ...'),
    (   catch(run_tests(all, [summary(Summary)]), RunError,
              ( print_message(warning, RunError), fail ))
    ->  Route = summary
    ;   Summary = none,
        Route = fallback,
        writeln('The summary route did not complete; checking plunit reports.')
    ),
    numbers(Summary, Route, Counts),
    decide(Counts, Verdict),
    print_diagnostics(Summary, Counts, Verdict).

numbers(Summary, Route, Counts) :-
    (   is_dict(Summary)
    ->  pick(Summary, total, Total),
        pick(Summary, passed, Passed),
        pick(Summary, failed, Failed),
        pick(Summary, timeout, Timeout),
        pick(Summary, blocked, Blocked),
        pick(Summary, fixme, Fixme)
    ;   Total = unknown,
        Passed = unknown,
        Failed = unknown,
        Timeout = unknown,
        Blocked = unknown,
        Fixme = unknown
    ),
    (   all_integers([Total, Passed, Failed, Timeout, Blocked, Fixme])
    ->  Counts = counts{total:Total, passed:Passed, failed:Failed,
                        timeout:Timeout, blocked:Blocked, fixme:Fixme,
                        source:Route}
    ;   fallback_numbers(Counts, Timeout, Blocked, Fixme)
    ).

pick(Dict, Key, Value) :-
    (   get_dict(Key, Dict, Candidate), integer(Candidate)
    ->  Value = Candidate
    ;   Value = unknown
    ).

all_integers([]).
all_integers([Value|Rest]) :-
    integer(Value),
    all_integers(Rest).

fallback_numbers(Counts, Timeout, Blocked, Fixme) :-
    (   catch(plunit:test_report(Results), _, fail),
        is_list(Results)
    ->  count_report(Results, Passed, Failed, TimedOut),
        length(Results, Total),
        Counts = counts{total:Total, passed:Passed, failed:Failed,
                        timeout:TimedOut, blocked:Blocked, fixme:Fixme,
                        source:test_report}
    ;   catch(plunit:test_count(Total), _, fail),
        integer(Total)
    ->  Counts = counts{total:Total, passed:unknown, failed:unknown,
                        timeout:Timeout, blocked:Blocked, fixme:Fixme,
                        source:test_count}
    ;   Counts = counts{total:unknown, passed:unknown, failed:unknown,
                        timeout:Timeout, blocked:Blocked, fixme:Fixme,
                        source:none}
    ).

count_report(Results, Passed, Failed, TimedOut) :-
    include(is_passed, Results, PassedResults),
    length(PassedResults, Passed),
    include(is_failed, Results, FailedResults),
    length(FailedResults, Failed),
    include(is_timeout, Results, TimeoutResults),
    length(TimeoutResults, TimedOut).

is_passed(passed(_, _, _, _, _)).
is_failed(failed(_, _, _, _, _)).
is_timeout(timeout(_, _, _, _, _)).

decide(Counts, Verdict) :-
    Total = Counts.total,
    Passed = Counts.passed,
    Failed = Counts.failed,
    Timeout = Counts.timeout,
    Blocked = Counts.blocked,
    Fixme = Counts.fixme,
    (   integer(Failed), Failed > 0
    ->  Verdict = fail(failed_tests(Failed))
    ;   integer(Timeout), Timeout > 0
    ->  Verdict = fail(timeouts(Timeout))
    ;   integer(Blocked), Blocked > 0
    ->  Verdict = fail(blocked_tests(Blocked))
    ;   integer(Fixme), Fixme > 0
    ->  Verdict = fail(fixme_tests(Fixme))
    ;   \+ all_integers([Failed, Timeout, Blocked, Fixme])
    ->  Verdict = fail(incomplete_failure_counts)
    ;   \+ integer(Total)
    ->  Verdict = fail(no_declaration_count_available)
    ;   Total =:= 0
    ->  Verdict = fail(empty_suite)
    ;   \+ integer(Passed)
    ->  Verdict = fail(no_execution_count_available)
    ;   Passed =:= 0
    ->  Verdict = fail(no_test_executions)
    ;   Verdict = pass(Total, Passed)
    ).

print_diagnostics(Summary, Counts, Verdict) :-
    nl,
    writeln('---------------- DIAGNOSTICS ----------------'),
    format('  count source                    : ~w~n', [Counts.source]),
    format('  summary dict                    : ~p~n', [Summary]),
    format('  declarations                    : ~p~n', [Counts.total]),
    format('  passing executions              : ~p~n', [Counts.passed]),
    format('  failed / timeout / blocked      : ~p / ~p / ~p~n',
           [Counts.failed, Counts.timeout, Counts.blocked]),
    format('  fixme                           : ~p~n', [Counts.fixme]),
    format('  SWI-Prolog version_data         : '),
    (   current_prolog_flag(version_data, Version)
    ->  format('~p~n', [Version])
    ;   writeln(unknown)
    ),
    format('  evaluation result               : ~p~n', [Verdict]),
    writeln('---------------------------------------------'),
    nl.

explain(load_failed) :-
    writeln('At least one required test file could not be loaded.').
explain(empty_suite) :-
    writeln('No PLUnit declarations were found; an empty suite is not a pass.').
explain(no_test_executions) :-
    writeln('No passing test executions were observed; this is not a pass.').
explain(no_execution_count_available) :-
    writeln('The runner could not establish how many tests executed.').
explain(no_declaration_count_available) :-
    writeln('The runner could not establish how many tests were declared.').
explain(incomplete_failure_counts) :-
    writeln('The runner could not establish every failure, timeout, blocked, and fixme count.').
explain(failed_tests(Count)) :-
    format('~w test execution(s) failed. Review the PLUnit failures above.~n',
           [Count]).
explain(timeouts(Count)) :-
    format('~w test execution(s) timed out.~n', [Count]).
explain(blocked_tests(Count)) :-
    format('~w test execution(s) were blocked.~n', [Count]).
explain(fixme_tests(Count)) :-
    format('~w test execution(s) were marked fixme and cannot be certified.~n',
           [Count]).
explain(Other) :-
    format('Reason: ~p~n', [Other]).
