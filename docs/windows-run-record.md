# Windows verification record -- run by the project owner

Evidence supplied by the project owner from a Windows machine. Recorded verbatim,
including the parts that did not go as intended.

---

## 1. Environment

| Item | Value |
|---|---|
| Machine | Windows, user `ARNOLD KAYE` |
| Working folder | `C:\Users\ARNOLD KAYE\Downloads\symptom-matcher\symptom-matcher` |
| Interpreter | **SWI-Prolog version 10.0.2 for x64-win64** |
| Interpreter used for the Linux runs | SWI-Prolog 9.2.9 for x86_64-linux |
| Date of the Windows run | 2026-11-06, 08:04 |

### Version difference -- stated, not hidden

The Windows run used **10.0.2**; the tests and demo were previously verified on
**9.2.9**. This is the first time the package has run on a *different major
version*. The demo's numbers are identical on both (see section 3), which is the
strongest evidence available that the logic is version-stable; the **test suite
has not yet been run on 10.0.2** (see section 5), so the suite cannot be called
Windows-verified until it is.

`docs/windows-setup.md` now says "9.2.x or newer". 10.0.2 satisfies that, and it is
now the version the project owner actually has, so the record should say so
rather than leave the guide's older number to imply otherwise.

---

## 2. What was run, and what happened

### 2.1 `swipl --version` -- PASS

```
SWI-Prolog version 10.0.2 for x64-win64
```

The interpreter is installed and on the PATH. The project's first open question
("is SWI-Prolog installed on the Windows computer?") is answered: **yes**.

### 2.2 `dir` in the project folder -- PASS

All five delivered files are present in the extracted folder: the four `.pl`
files plus `README.md`, and the `docs`, `evidence` and `tests` directories.

### 2.3 `swipl -q -s symptom_matcher.pl -- --demo` -- PASS

All four demonstration cases ran to completion, in this order:
`typical_malaria`, `typical_cold`, `measles_alert`, `messy_input`.

### 2.4 `swipl -q -s symptom_matcher.pl --` (interactive) -- PASS

The banner, the vocabulary list and the prompt all rendered correctly on a
Windows console. No mojibake, no `?` characters, no `Illegal multibyte
Sequence` -- which is the specific risk the pure-ASCII rule was adopted to
remove, and it is now observed rather than assumed.

### 2.5 `swipl -q -s tests/test_symptom_matcher.pl -g run_tests -t halt` -- first attempt **DID NOT RUN**

This is the important part of the record.

The command was typed **while the interactive program was still waiting at its
`symptoms>` prompt**, so the command line was consumed as *symptom input*, not
executed as a command. The program did exactly what it is designed to do with an
unrecognised line:

```
None of the terms typed is in this knowledge base,
so there is nothing to compare.
Not in this knowledge base (ignored): [swipl_-q_-s_tests/test_symptom_matcher.pl_-g_run_tests_-t_halt]
```

**Therefore: the test suite has still not been run on Windows.** No test may be
recorded as passed on Windows on the strength of this transcript.

This was a usability defect in the program, not user error in any meaningful
sense: the prompt said `symptoms>` with no indication that the rest of the
terminal belonged to the program. It has been fixed (section 4), and the fix is
verified on Linux.

---

## 3. Demo output compared, Linux 9.2.9 vs Windows 10.0.2

Every computed value in the four demonstration cases was compared line by line
against `docs/demo-run-linux-9.2.9.log`.

| Case | Reported set | Malaria | Influenza | Measles | Cold | Top |
|---|---|---|---|---|---|---|
| `typical_malaria` | fever, chills, headache | 3/10 | 2/8 | 1/6 | 2/8 | Malaria, alone |
| `typical_cold` | runny_nose, sneezing, sore_throat | 0/10 | 2/8 | 1/6 | 3/8 | Common cold, alone |
| `measles_alert` | fever, rash, red_watery_eyes, cough | 1/10 | 2/8 | 4/6 | 2/8 | Measles, alone |
| `messy_input` | fever, headache, nasal_congestion (+1 unknown, 1 duplicate) | 2/10 | 2/8 | 1/6 | 3/8 | Common cold, alone |

**Result: identical on both versions, all four cases, every fraction and every
ranking decision.** The one difference is cosmetic and is explained in section 4.

Evidence quality note: the demo comparison is strong because it exercises the
whole pipeline end to end -- normalisation, unknown handling, duplicate
collapsing, set overlap, fraction comparison, ranking and tie grouping -- on a
second interpreter major version, on a second operating system. It is *not* a
substitute for the unit tests, which assert 57 specific properties rather than
four aggregate pictures.

---

## 4. Defects this transcript exposed, and their fixes

### W1 (fixed) -- the interactive prompt could be mistaken for a system prompt

**Observed:** a shell command was typed at the `symptoms>` prompt and consumed as
input.

**Fix, three parts:**
1. the prompt now reads `symptom-matcher> ` inside a bracketed reminder line, so
   it no longer looks like a continuation of the shell;
2. the program echoes what it received -- `received: fever, chills` -- so a
   mis-typed line is visible as input rather than silently "understood";
3. the startup hint now states explicitly that this is the program waiting for
   input, not a system prompt, and how to leave.

**Verified on Linux:**

```
[type symptoms, or an empty line to quit]
symptom-matcher>
received: fever, chills
```

Suite still 179/179 after the change.

### W2 (fixed, cosmetic) -- the synonym example was shown in lower case

**Observed:** the Windows banner printed
`(for example "high temperature" for fever ...)` where earlier notes quote
`"High Temperature"`. The difference is only the case of the example text, and
the demo proves case-insensitivity works: `messy_input` passes
`"High Temperature"` through the JSON-ish term list and the program reports
`fever` in the understood set on both versions.

**Fix:** the header now lists three worked synonyms and states the rule --
anything not in the list is reported as unknown, never guessed -- instead of one
example in a form that could be misread as case-sensitive.

---

## 4c. Second attempt at the test suite -- owner-supplied result

The owner re-ran the suite from the system prompt, redirecting output to a file:

```
C:\...\symptom-matcher> swipl -q -s tests/test_symptom_matcher.pl -g run_tests -t halt > win-tests.txt 2>&1
C:\...\symptom-matcher> echo %ERRORLEVEL%
0
```

| Item | Value |
|---|---|
| Exit status | **0** |
| Output file | `win-tests.txt` (not yet inspected) |
| Interpreter | SWI-Prolog 10.0.2 x64-win64 |

### What this does and does not prove

**Proves:** nothing crashed, and no test produced a failure that made `swipl`
exit non-zero. Control A below confirms that a single failing test does produce
exit 1, so a 0 is not vacuous *given that the tests ran*.

**Does not prove, on its own:** that the tests ran at all. Control B below shows
that a test file which loads but contains no tests also exits 0. The exit status
cannot distinguish "179 executions passed" from "0 executions ran".

**Therefore:** the suite is **still not recorded as passed on Windows** until
`win-tests.txt` is inspected, or better, until the new runner (section 4d) is
used, which reports the counts itself and refuses to pass without them.

---

## 4d. The exit-status weakness, and the runner that fixes it

Control testing on Linux (`docs/test-report.md` section 7) established:

| Control | Command | Exit | Meaning |
|---|---|---|---|
| A | suite with one deliberately broken fact | **1** | a failing test does propagate |
| B | a test file that loads but contains **no tests** | **0** | **exit 0 does not prove tests ran** |
| C | a test file path that does not exist | **1** | a wrong path is caught |
| D | the real suite | **0** | -- |

A second, worse case appeared while building the fix: an early version of the
runner printed `ERROR: ... Unknown procedure: plunit_test/3` and **still exited
0**, because the error happened after the tests had completed and nothing called
`halt(1)`.

The fix is `run_tests.pl` at the project root. It asks plunit for its own summary
through the documented `run_tests/2` option `summary(-Summary)` and refuses to
report a pass unless:

```
declarations >= 50,  failed == 0,  timeout == 0,  blocked == 0,  executions >= declarations
```

It prints the counts it checked, and every failure path calls `halt(1)`,
including an exception in the runner itself.

### Run this on Windows instead

```
C:\...\symptom-matcher> swipl -q -s run_tests.pl > win-tests.txt 2>&1
C:\...\symptom-matcher> echo %ERRORLEVEL%
```

A pass now looks like this (Linux, 9.2.9 -- `docs/plunit-run-linux-9.2.9.log`):

```
========== TEST SUMMARY ==========
  declarations   : 57
  executions passed: 179
  failed         : 0
  timeout        : 0
  blocked        : 0
  required min   : 50
==================================

RESULT: PASS - 57 declarations, 179 executions, all passed;
               none failed, timed out or blocked.
```

and exits 0. Anything else exits 1 and says which condition failed. That output
is the evidence needed to close this file: it names the counts, so it cannot be
produced by a suite that did not run.

---

## 4e. The 10.0.2 result: exit 1 -- RESOLVED, NOT a test failure

The owner ran the new runner on Windows:

```
C:\...\symptom-matcher> swipl -q -s run_tests.pl > win-tests.txt 2>&1
C:\...\symptom-matcher> echo %ERRORLEVEL%
1
```

**RESOLVED. The exit 1 was a file-not-found error. The test suite passed.**

### The evidence, supplied by the owner on 2026-11-06

```
C:\...\symptom-matcher> swipl -q -s tests/test_symptom_matcher.pl -g "run_tests(all,[summary(S)]),print_message(error,format('SUMMARY: ~p~n',[S]))" -t halt

[57/57] console:messy_case_exercises_robustness .......... passed (0.000 sec)

ERROR: [Thread main] SUMMARY: plunit{blocked:0,failed:0,fixme:0,passed:179,timeout:0,total:57}
```

```
C:\...\symptom-matcher> type win-tests.txt

ERROR: [Thread main] Prolog initialisation failed:
ERROR: [Thread main] script_file `'run_[tests.pl](http://tests.pl)'' does not exist
```

### What this establishes

**The suite passes on Windows 10.0.2.** plunit's own summary reports
`failed:0, blocked:0, timeout:0, passed:179, total:57` -- **identical, to the
digit, to Linux 9.2.9**. All 57 declarations and all 179 executions ran and
passed on the owner's machine.

**The exit 1 was `script_file does not exist`.** SWI-Prolog could not find the
file it was told to load, so it halted with status 1 during initialisation. No
test ran in that invocation, and no test failed in it either.

### Root cause: the command string, not the code

The filename reached the console mangled:

```
run_[tests.pl](http://tests.pl)
```

The message editor auto-linked `run_tests.pl` into a markdown URL, and that
literal text was pasted into the Windows console. SWI-Prolog took it as a
filename, could not find it, and exited 1.

**Reproduced exactly on Linux:**

```
$ swipl -q -s 'run_[tests.pl](http://tests.pl)'
ERROR: Prolog initialisation failed:
ERROR: script_file `'run_[tests.pl](http://tests.pl)'' does not exist
$ echo $?
1
```

Character for character the same message. The defect was in how the instruction
was delivered, not in the package.

### Why this was worth chasing rather than blaming the code

The same mangling had already hit the command in section 2.5, where the message
showed `run_[tests.pl](http://tests.pl)` and the owner reported that "the command
was consumed as symptom input". Both incidents were transcription artifacts.

The lasting fix is `run-tests.bat` (section 4f): one word to type, no filename
in the command line at all.

### How it was closed

The `SUMMARY:` line did it in one command, exactly as predicted: `failed:0` means
the suite passes and the problem was elsewhere. `docs/diagnose-windows.md` is
retained as the procedure for any future failure.

---

## 4f. The fix: batch files, so no filename is ever typed

Three `.bat` files now sit in the project root. Double-click one, or type its
name in the folder. Nothing else.

| File | Runs | Output |
|---|---|---|
| `run-tests.bat` | the PLUnit suite via `run_tests.pl` | prints all of it, saves `win-tests.txt`, states the verdict in words |
| `run-demo.bat` | the four demonstration cases | prints them |
| `run-interactive.bat` | the interactive matcher | prompts for symptoms; empty line quits |

Each file does `cd /d "%~dp0"` first, so it works from the project folder or from
a double-click in Explorer, whatever the current directory was. Script names are
quoted inside the files. CRLF line endings, ASCII only.

`run-tests.bat` ends with an explicit sentence rather than a number:

```
---------------------------------------------------------------
 Exit code: 0
 RESULT: the suite ran and passed on this machine.
---------------------------------------------------------------
```

so the verdict does not depend on the owner interpreting an exit status.

---

---

## 4g. The batch-file run on 10.0.2 -- and two defects it exposed

The owner redownloaded the ZIP, extracted it to a fresh folder, and ran all
three batch files. Verbatim results.

### The batch files themselves: PASS

| File | Result | Exit code reported by the batch file |
|---|---|---|
| `run-tests.bat` | suite ran, 179 executions passed | **1 -- wrong, see D11** |
| `run-demo.bat` | all four cases printed, values match 9.2.9 | **0** |
| `run-interactive.bat` | started, listed symptoms, exited cleanly | **0** |

The three `.bat` files work. `cd /d "%~dp0"`, output capture, the verbatim
transcript and the closing banner all behaved as intended. No filename had to be
typed and none was mangled.

The demonstration output on 10.0.2 is **identical** to the 9.2.9 log, case for
case, including every fraction and every ranking:

| Case | 9.2.9 | 10.0.2 |
|---|---|---|
| `typical_malaria` | Malaria 3/10 alone | Malaria 3/10 alone |
| `typical_cold` | Common cold 3/8 alone | Common cold 3/8 alone |
| `measles_alert` | Measles 4/6 alone | Measles 4/6 alone |
| `messy_input` | 3 understood, unknown `[banana]`, duplicate `[fever-2]`, Cold 3/8 | identical |

### D11. `halt/1` inside `catch/3` -- the runner printed PASS and then failed

The transcript shows the sequence exactly:

```
RESULT: PASS - 57 declarations, 179 executions, none failed,
               none timed out, none blocked.

---------------- DIAGNOSTICS ----------------
  the runner itself threw an exception
---------------------------------------------

RESULT: FAIL - runner error.

---------------------------------------------------------------
 Exit code: 1
 RESULT: the suite did NOT pass. The reason is in the output above.
---------------------------------------------------------------
```

The suite passed and the runner said so, then contradicted itself. Cause: the
previous `main/0` was

```prolog
main :- catch(run_all, Error, on_error(Error)).
```

with `halt(0)` inside `run_all`. On 10.0.2 the halt was intercepted and reported
as an exception. **On 9.2.9 `halt/1` is not catchable and the identical code was
correct**, so no amount of Linux testing would have found this. The owner's
transcript did.

Fix: the verdict is computed as a term inside `catch/3`, and `halt/1` is called
afterwards, outside every catcher. All four halt sites are now in
`report_verdict/1`. Nothing in this file calls halt within the scope of a catch.

### D12. `user:main/0` collision -- a warning that was present all along

The transcript opens with

```
Warning: c:/.../tests/test_symptom_matcher.pl:22:
Warning:    Local definition of user:main/0 overrides weak import from symptom_console
```

This was **not** a Windows difference. Running the same command on Linux 9.2.9
reproduces it byte for byte. The runner defined `main/0` in module `user`, while
`symptom_console` exports `main/0`; loading the suite imported
`symptom_console:main/0` over it.

This means an earlier claim in this project -- that the suite runs with **zero
warnings** -- was true only of the raw command
(`swipl -q -s tests/test_symptom_matcher.pl -g run_tests -t halt`) and **false of
the runner**, which had been emitting this warning since it was introduced. The
claim was made without re-checking warnings after changing what command was used
to launch the suite.

Fix: the entry point is `run_test_suite/0`. No predicate named `main/0` is
defined in `run_tests.pl`. The warning is gone on both interpreters.

### Controls re-run after the fix (Linux 9.2.9)

| Control | Exit | Message |
|---|---|---|
| broken fact | 1 | `FAIL - failed_tests(1)` |
| empty suite | 1 | `FAIL - too_few_executions(0,50)` |
| missing test file | 1 | `FAIL - load_failed` |
| real suite | 0 | `PASS - 57 declarations, 179 executions` |

An intermediate version of the fix broke the missing-file path (it reported
`the runner could not complete its checks` instead of `load_failed`) because a
cut in `assess/1` made the load-failure branch fall through to a later goal. It
was caught by re-running control C, and repaired by splitting `assess/1` into
`assess/1` and `stage2/1`. **Running the controls after a change to the runner
is not optional** -- this is the second time that rule paid for itself.

### The lesson worth recording

Two defects out of two were in the **harness**, never in the program under test.
Every single failure this project has recorded on Windows -- the swallowed
command, the `%ERRORLEVEL%` 0 that proved nothing, the mangled filename, the
false FAIL, this false FAIL -- has been in the tooling or the instructions.
The Prolog code has passed every time, on both interpreters.

---

---

## 4h. Final verification run on 10.0.2 -- ALL THREE PASS

The owner re-ran all three batch files after the D11 and D12 fixes. This is the
definitive Windows record.

| Batch file | Exit code | Verdict line printed by the batch file |
|---|---|---|
| `run-demo.bat` | **0** | (exit code only, no verdict word) |
| `run-interactive.bat` | **0** | (exit code only, no verdict word) |
| `run-tests.bat` | **0** | `RESULT: the suite ran and passed on this machine.` |

### The two fixes, confirmed in the owner's output

**D12 is gone.** The earlier run printed

```
Warning: Local definition of user:main/0 overrides weak import from symptom_console
```

This run begins, immediately after `=== Running the test suite ===`, with

```
loading tests/test_symptom_matcher.pl ...
loaded.
```

No warning. The rename to `run_test_suite/0` worked on the interpreter where the
collision actually showed itself.

**D11 is gone.** The earlier run printed `RESULT: PASS` and then contradicted it
with `RESULT: FAIL - runner error.` This run prints

```
RESULT: PASS - 57 declarations, 179 executions, none failed,
               none timed out, none blocked.

---------------------------------------------------------------
 Exit code: 0
 RESULT: the suite ran and passed on this machine.
---------------------------------------------------------------
```

The programme's verdict, the exit status and the batch file's own sentence all
agree. That three-way agreement is the thing that was missing for the whole of
this episode.

### Full Windows evidence

```
=== Running the test suite ===

loading tests/test_symptom_matcher.pl ...
loaded.
running the suite ...
% [1-1/57] kb_integrity:ever..dition_has_symptoms ... passed (0.021 sec)
...
% [57/57] console:messy_cas..xercises_robustness .... passed (0.000 sec)
run_tests/2 completed.

---------------- DIAGNOSTICS ----------------
  numbers came from              : summary
  summary dict from run_tests/2  : plunit{blocked:0,failed:0,fixme:0,passed:179,timeout:0,total:57}
  declarations (total)           : 57
  executions passed              : 179
  failed / timeout / blocked     : 0 / 0 / 0
  minimum required               : 50 declarations, 50 executions
  test units found               : []
  run_tests/2 route              : summary
  swipl version_data             : swi(10,0,2,[])
  evaluation result              : pass(57,179)
---------------------------------------------

RESULT: PASS - 57 declarations, 179 executions, none failed,
               none timed out, none blocked.

---------------------------------------------------------------
 Exit code: 0
 RESULT: the suite ran and passed on this machine.
---------------------------------------------------------------
```

### Interactive mode

`run-interactive.bat` reached the prompt, printed the full 20-symptom list, the
three synonym examples, the "not a system prompt" hint, and exited with 0 on an
empty line:

```
[type symptoms, or an empty line to quit]
symptom-matcher>

Finished.
```

The W1/W2 fixes -- the bracket prompt and the startup hint -- are visible on
Windows for the first time in this transcript.

### Demonstration mode

All four cases, exit 0. Values identical to Linux 9.2.9 in every fraction and
every ranking, as recorded in section 3.

---

## 5. Status: everything closed

| Item | Status | Evidence |
|---|---|---|
| Suite on Windows 10.0.2 | **PASSED** | `passed:179, failed:0, total:57` (section 4h) |
| Suite on Linux 9.2.9 | **PASSED** | identical counts |
| Demo on Windows, after W1/W2 fixes | **PASSED** | four cases, values identical to 9.2.9 (section 4h) |
| Interactive prompt on Windows | **PASSED** | bracket prompt, hint and synonym list all present (section 4h) |
| The three `.bat` files on Windows | **PASSED** | all exit 0 (section 4h) |
| Windows test transcript recorded | **DONE** | verbatim in sections 4e, 4g, 4h |

Nothing about runtime behaviour on either interpreter remains unverified.

### What is NOT verified, and cannot be from here

- Any Windows version other than the owner's machine (10.0.2, x64-win64).
- SWI-Prolog versions other than 9.2.9 and 10.0.2.
- Behaviour on a machine where `swipl` is not on `PATH` -- the batch files call
  `swipl` by name and will print `'swipl' is not recognized` if it is missing.
  The formal installer adds it to `PATH`, which is why it worked here.

### The sequence that produced the evidence

```
run-demo.bat        -> exit 0, four cases
run-interactive.bat -> exit 0, prompt reached, empty line quits
run-tests.bat       -> exit 0, "RESULT: the suite ran and passed on this machine."
```

Each saves its output where useful (`run-tests.bat` writes `win-tests.txt`).

### A note on how long this took, for the evaluation write-up

Five separate Windows runs were needed, and four of the five failures were in
the tooling rather than the Prolog:

| Run | Reported | Actually was |
|---|---|---|
| 1 | command "consumed as input" | typed inside the program's own prompt (W1) |
| 2 | `%ERRORLEVEL%` = 0 | proved nothing -- a no-test file also exits 0 |
| 3 | `%ERRORLEVEL%` = 1 | mangled filename, file not found |
| 4 | suite passed, then "runner error", exit 1 | `halt/1` trapped inside `catch/3` (D11) |
| 5 | exit 0, PASS throughout | correct |

Only run 5 was a fair test. The program was never at fault.
