# Test report

Status of this package: **passing on Linux with SWI-Prolog 9.2.9 and on Windows
with SWI-Prolog 10.0.2.** Demonstration, interactive mode and the full PLUnit
suite have all been run on both interpreters, and the suite reports identical
counts on each: 57 declarations, 179 executions, 0 failed.

A dedicated runner, `run_tests.pl`, now exists because exit status alone is not
evidence -- see section 7.

Windows evidence, verbatim and including the command that did not run:
[`docs/windows-run-record.md`](windows-run-record.md).

That sentence is the whole point of this document. The previous draft of the
package said "runtime test pending" because no interpreter was available. An
interpreter was available for this build, so the run happened, and the numbers
below are copied from the run, not estimated.

---

## 1. Environment actually used

| Item | Value |
|---|---|
| Operating system | Linux 6.1.189+ x86_64 |
| Interpreter | `SWI-Prolog version 9.2.9 for x86_64-linux` |
| `version_data` | `swi(9,2,9,[])` |
| Install method | distribution package (`swi-prolog-nox`), not a custom build |
| Date of run | the day this package was built |
| Re-run | re-executed on a clean sandbox on 2026-11-06: `179 passed, 0 failed, 0 warnings, exit 0` |

**Note on reproducibility:** the interpreter is *not* part of the delivery. This
sandbox drops installed packages between sessions, so `swipl` has to be
re-installed before any command in this package will run. That is why the run was
repeated before writing this line, rather than quoting an earlier log: every
number below comes from an execution, not from memory of one.

**Not yet done:** any run on Windows. `docs/windows-setup.md` gives the exact
commands; section 5 below says what must be recorded when someone does it.

---

## 2. Command and result

```
$ swipl -q -s tests/test_symptom_matcher.pl -g run_tests -t halt
...
% [57/57] console:messy_cas..xercises_robustness .... passed (0.000 sec)
$ echo $?
0
```

| Measure | Value |
|---|---|
| Test declarations | **57** |
| Executions (declarations with `forall`) | **179** |
| Passed | **179 of 179** |
| Failed | 0 |
| Warnings | 0 |
| Exit status | 0 |
| Full transcript | `docs/plunit-run-linux-9.2.9.log` |

The difference between 57 and 179 is `forall/2`: a test such as
`test(every_condition_has_symptoms, forall(condition(C)))` is one declaration and
four executions, one per condition. Both numbers are given because quoting only
one of them would misrepresent the coverage.

### Coverage by suite

| Suite | Executions | What it defends |
|---|---|---|
| `kb_integrity` | 82 | the knowledge base is internally consistent and complete |
| `normalisation` | 13 | rule R2 -- matching after normalisation, unknowns reported |
| `dedupe` | 6 | rule R3 -- duplicates collapse, first occurrence wins |
| `sets` | 11 | rule R4 -- overlap, difference, exact fractions |
| `ranking` | 5 | rule R5 -- ties preserved, fractions compared exactly |
| `comparison` | 8 | the comparison as a whole, including zero-overlap cases |
| `danger` | 8 | the deliberate departure from set comparison (D4) |
| `sources` | 40 | rule R1 -- every fact source-linked and qualified |
| `console` | 6 | the demonstration cases the console layer depends on |

---

## 3. Defects found by running it

These were found by executing the code, not by reading it. Each one is fixed in
the delivered files; each is listed so that the fix is auditable and so that the
same mistake is not repeated.

| # | Defect | Effect | Cause | Fix |
|---|---|---|---|---|
| D1 | `split_string/4` arguments in the wrong slots | a typed phrase with a space ("high temperature") never split, so the synonym was never matched | the pad character occupied the separator position | `split_string(Lower, ' \t\n\r', ' \t\n\r', Parts)` |
| D2 | `dedupe/2` tested membership in the **tail** | the function returned the **last** occurrence of each term, the opposite of its documented contract | `\+ memberchk(H, T)` asks "is H absent from the rest", not "have we seen H" | accumulator-based `dedupe_acc/3`, first occurrence wins |
| D3 | `normalise_all/2` cut on the first **success** | terms after an unknown term were silently dropped | a cut placed after the recursive clause | if-then-else so both branches continue the same tail |
| D4 | `frac(N,D)` where `Frac` was a **variable** | `Frac(N, D)` in a clause head is a syntax error in SWI-Prolog | a capitalised functor name | lower-case `frac/2`, documented at its definition |
| D5 | `symptom/1` not exported from the knowledge-base module | `Unknown procedure: symptom_logic:symptom/1` at the first query | module export list was empty | explicit export list on `symptom_kb` |
| D6 | UTF-8 em dashes and curly quotes inside string literals | `Illegal multibyte Sequence` warnings on a UTF-8 locale, and a garbled console on a Windows code page | typography copied from a document | all four `.pl` files are now pure ASCII, comments included |
| D7 | `format("Understood ~w symptom(s): ~w~n", [Reported])` | `Format error: not enough arguments` mid-report | `symptom(s)` read as two directives | arguments reordered and the count bound first |
| D8 | `Arg == "--demo"` compared an **atom** to a **string** | every command-line switch fell through to the usage text | argv elements are atoms in SWI-Prolog | `Arg == '--demo'` |
| D9 | `demo_case/1` and `demo_terms/2` unexported | the console tests failed for a module reason, not a logic reason | export list written before those predicates existed | both exported |
| D10 | two `initialization/2` directives competing | the interactive prompt started before the command line was read, so `--demo` was ignored | module-level `initialization(run, main)` plus entry-point `initialization(main, main)` | single entry point: `initialization(symptom_console:run, main)` in `symptom_matcher.pl` |
| D11 | `halt/1` called inside `catch/3` in `run_tests.pl` | on SWI-Prolog 10.0.2 the halt was intercepted; the runner printed PASS then FAIL and exited 1 | verdict computed as a term inside `catch/3`, `halt/1` called only afterwards, outside every catcher |
| D12 | `run_tests.pl` defined `main/0` in module `user`, colliding with `symptom_console:main/0` | `Warning: Local definition of user:main/0 overrides weak import` on every run | entry point renamed `run_test_suite/0` |

Two of these (D1, D3) were caught by the test suite after it was written; the
other eight were caught by running the program by hand first. That order is
deliberate: a test suite written before the code runs tends to encode the
author's assumptions instead of the program's behaviour.

---

## 4. Deviation register -- expectations that were changed

The rule for this package is that a failing test is either a program defect or a
test defect, and the answer must be stated, never smoothed over by editing the
expectation until it is green.

| Test | Original expectation | Final expectation | Why it changed |
|---|---|---|---|
| `ranking:tie` (first draft) | with `[runny_nose, cough]`, the top group is `[influenza, common_cold]` | top group is `[measles]` at 2/6; the tie test uses a six-symptom query | **the test was wrong.** 2 of 6 is a larger fraction than 2 of 8, so measles does outrank the other two. The program was right and the expectation was naive. This forced the ranking rule (D2 in the implementation notes) to be written down instead of assumed. |
| `ranking:tie` (six-symptom query) | top group `[influenza, common_cold]` at 6/8 | unchanged | this is the case that genuinely ties, and it confirms tie preservation |

No expectation was changed to make a **program** defect disappear. The one
change above is documented as a test defect, and the program's behaviour in that
case is now specified in `docs/implementation-notes.md` D2.

---

## 4b. Windows run (2026-11-06) -- suite verified PASSED, exit 0

plunit's own summary, produced on the owner's Windows machine with SWI-Prolog
10.0.2:

```
SUMMARY: plunit{blocked:0,failed:0,fixme:0,passed:179,timeout:0,total:57}
```

Identical to Linux 9.2.9 in every field: 57 declarations, 179 executions,
0 failed, 0 timeout, 0 blocked.

An earlier `%ERRORLEVEL%` of 1 was traced to `script_file ... does not exist` --
the filename had been mangled by a message editor into
`run_[tests.pl](http://tests.pl)`. No test ran in that invocation, so the status
was never describing a test outcome. Reproduced exactly on Linux and recorded in
`docs/windows-run-record.md` section 4e.

### Final run, after the D11/D12 fixes

The owner re-ran all three batch files. `run-tests.bat` gave:

```
RESULT: PASS - 57 declarations, 179 executions, none failed,
               none timed out, none blocked.

---------------------------------------------------------------
 Exit code: 0
 RESULT: the suite ran and passed on this machine.
---------------------------------------------------------------
```

Three independent statements agree: the runner's verdict, the process exit
status, and the batch file's own sentence. `swipl version_data: swi(10,0,2,[])`.

Demo and interactive modes both exited 0 in the same session. Prior text follows
as the record of how the earlier failures were traced.


| Item | Result |
|---|---|
| Interpreter | SWI-Prolog **10.0.2** for x64-win64 (Linux runs used 9.2.9) |
| `--demo`, four cases | **PASS** -- every fraction and every ranking decision identical to the 9.2.9 run |
| Interactive mode | **PASS** -- banner, vocabulary and prompt render correctly; no encoding faults |
| PLUnit suite | **NOT RUN** -- the command was typed at the program's own `symptoms>` prompt and consumed as input |
| Defects exposed | 2 (W1 misleading prompt, W2 synonym example) -- both fixed, fix verified on Linux |

The suite has therefore *still* not been executed on Windows. See
`docs/windows-run-record.md` section 5 for the exact command sequence and
`docs/windows-setup.md` section 5 for what to record.

## 5. What is still not tested, and why

| Not tested | Reason | Risk |
|---|---|---|
| Windows **test-suite** execution | the one Windows attempt invoked the suite from inside the interactive program, so it never ran | low for the logic (the demo matches 9.2.9 exactly), non-zero for the suite itself: PLUnit is version-sensitive and 10.0.2 has not been exercised |
| Windows, after the W1/W2 fixes | fixes were verified on Linux only | the changed code is the console layer, which is the layer Windows just exercised, so a fresh Windows demo run is worth doing |
| Interactive typing beyond piped input | input was piped (`printf ... | swipl`) rather than typed at a keyboard | low: the same `read_line_to_string/2` path is used |
| Very long symptom lists (>100 terms) | out of scope for a teaching program | low |
| Behaviour under a non-ASCII console code page | cannot be simulated faithfully here | low, because output is ASCII |
| Medical correctness | **out of scope by design** -- the program does not diagnose | n/a; the program is not presented as a diagnostic tool |

**The Windows run is the one open item.** Until it is recorded in section 5 of this
file, the correct description of this package is "passing on Linux, untested on
Windows", not "tested".

---

## 6. Mutation check -- are the tests actually load-bearing?

Four deliberate breakages, introduced one at a time, suite run after each:

A green suite proves nothing if the tests cannot fail. Three deliberate breakages
were introduced, one at a time, and the suite was run after each:

| Breakage | Rule attacked | Result |
|---|---|---|
| replace `usually_low_grade` with `plain` on the cold's fever | R1 (qualifications preserved) | **caught**, 1 test failed |
| change the measles fever qualifier from `high` to `low` | R1 (fact fidelity) | **caught**, 1 test failed |
| make `dedupe/2` keep the last occurrence | R3 (duplicates) | **caught**, 1 test failed |
| make `tied_top/2` return a single winner | R5 (ties preserved) | **caught**, 1 test failed |

Each source file was restored afterwards and the suite re-run to 179/179, which
is the run recorded in section 2.

## 6b. Defects in the harness, found by the owner's Windows run

Two defects (D11, D12) were in `run_tests.pl`, not in the program. Both were
invisible on Linux 9.2.9 and both were found by the owner running the batch
files on 10.0.2.

**D11. `halt/1` inside `catch/3`.** On 10.0.2 the halt was intercepted, so the
runner printed `RESULT: PASS` and then printed `RESULT: FAIL - runner error` and
exited 1. On 9.2.9 halt is not catchable and the same code was correct. Fixed by
computing the verdict as a term inside `catch/3` and calling halt only after,
outside every catcher.

**D12. `user:main/0` collision.** The runner defined `main/0` in module `user`;
`symptom_console` exports `main/0`, so loading the suite produced a warning on
every run, on both interpreters:

```
Warning: Local definition of user:main/0 overrides weak import from symptom_console
```

An earlier draft of this report described the suite as running with **0
warnings**. That was true of the raw command but **false of the runner**, which
had emitted this warning since its introduction. Corrected: the raw command and
the runner now both run warning-free, and that has been re-checked rather than
assumed.

### Correction to an earlier claim in this report

Wherever this file previously said "0 warnings" without specifying which command
produced it, the claim is now read as applying to
`swipl -q -s tests/test_symptom_matcher.pl -g run_tests -t halt`. The runner was
emitting one warning during that period. Both are clean as of this revision.

## 7. Exit-status control tests -- why `run_tests.pl` exists

An exit status of 0 is not proof that tests ran. Four controls were run to find
out exactly what a zero status does and does not mean:

| Control | Setup | Exit | Conclusion |
|---|---|---|---|
| A | suite with one deliberately broken fact (`high` -> `low` for measles fever) | **1** | a failing test does propagate to the shell |
| B | a file that loads cleanly but declares **no tests** | **0** | **0 does not prove the suite ran** |
| C | a test path that does not exist | **1** | a wrong path is detected |
| D | the real suite | **0** | -- |

A worse case surfaced while writing the fix: an early `run_tests.pl` printed
`ERROR: ... Unknown procedure: plunit_test/3` **and exited 0**, because the error
occurred after the tests finished and nothing called `halt(1)`. That is precisely
the failure mode the owner's `%ERRORLEVEL% = 0` could hide.

### The fix: `run_tests.pl`

It asks plunit for its own summary via the documented
`run_tests(all, [summary(Summary)])` option, and passes only if:

```
declarations >= 50  AND  failed == 0  AND  timeout == 0
                    AND  blocked == 0  AND  executions >= declarations
```

Every other path -- including an exception in the runner -- calls `halt(1)` and
says which condition failed.

### The controls that matter for the runner

| Control | Setup | Exit | Message |
|---|---|---|---|
| A' | broken fact | **1** | `RESULT: FAIL - at least one test failed` |
| B' | empty test file | **1** | `RESULT: FAIL - only 0 test executions ran, expected at least 50.` |
| C' | missing test file | **1** | `RESULT: FAIL - the test file did not load` |
| D' | real suite | **0** | `RESULT: PASS - 57 declarations, 179 executions, all passed;` |

A runner that can only ever say PASS would be worthless; this one was made to
fail four different ways before it was trusted.

### A units subtlety worth recording

plunit's `total` counts test **declarations** (57); its `passed` counter counts
**executions** (179), because a declaration using `forall/2` runs more than once.
The first draft of the runner compared `passed =:= total` and reported FAIL on a
perfectly good suite. The check is now `executions >= declarations`, and the
summary prints both numbers under labels that say which is which.
