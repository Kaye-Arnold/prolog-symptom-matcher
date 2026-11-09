# Diagnosing a Windows test failure

> **CLOSED on 2026-11-06.** The failure this file was written for turned out to
> be a mangled filename (`run_[tests.pl](http://tests.pl)`), not a test failure.
> The suite passes on Windows 10.0.2 with `failed:0, passed:179, total:57`.
> See `docs/windows-run-record.md` section 4e.
>
> This file is kept because the procedure is still correct for any future
> failure, and because the diagnostic habits in it are worth having.

On Linux 9.2.9 the suite passes: 57 declarations, 179 executions, 0 failed.

This file exists because the author cannot log into that machine. Everything
below produces output that identifies the cause.

---

## Step 0 -- you already have useful evidence

`win-tests.txt` was written by the run that failed. Its **first** lines say which
stage failed:

```
C:\Users\ARNOLD KAYE\Downloads\symptom-matcher\symptom-matcher> type win-tests.txt
```

Read the first 30 lines and match them here:

| First lines look like | Meaning | Go to |
|---|---|---|
| `loading tests/test_symptom_matcher.pl ...` then `loaded.` then test lines, then a DIAGNOSTICS block | the suite **ran** and the summary check failed | Step 2 |
| `loading ... ` then `RESULT: FAIL - load_failed` | the test file did not load | Step 1 |
| `RESULT: FAIL - runner error.` with an exception | the runner crashed before deciding | Step 3 |
| Only `**FAILED` lines and no DIAGNOSTICS block | the **old** runner was used, not the new one | Step 4 |
| Nothing at all / file is empty | the command never reached the runner | Step 5 |

---

## Step 1 -- does the test file load at all?

```
swipl -q -g "consult('tests/test_symptom_matcher.pl'), writeln(loaded_ok)" -t halt
```

- `loaded_ok` -> the file loads; the problem is later.
- An `ERROR:` line -> **send it to me verbatim.** Likely causes: you are not in
  the project folder, or the extraction is incomplete.

---

## Step 2 -- what does plunit itself report?

This bypasses my runner entirely and asks plunit directly:

```
swipl -q -s tests/test_symptom_matcher.pl -g "run_tests(all,[summary(S)]),print_message(error,format('SUMMARY: ~p~n',[S]))" -t halt
```

The important line starts with `SUMMARY:` and looks like this on 9.2.9:

```
SUMMARY: plunit{blocked:0,failed:0,fixme:0,passed:179,timeout:0,total:57}
```

**Send me that line.** Two things matter:

- if `failed` is **not 0**, the suite genuinely fails on 10.0.2 and the
  `**FAILED` lines above it name the tests -- send those instead;
- if the keys are **different** (`tests:` instead of `total:`, `succeeded:`
  instead of `passed:`), that is a plunit rename in 10.x, and my runner is what
  needs fixing, not your code.

---

## Step 3 -- run the suite with no runner at all

The original command, which produces one line per test:

```
swipl -q -s tests/test_symptom_matcher.pl -g run_tests -t halt > raw.txt 2>&1
type raw.txt
```

Count the lines ending in `passed` and look for any ending in `**FAILED`.
This output is the ground truth. If it shows 57 tests passing and no failures,
the suite is fine on Windows and only my runner's checks are wrong.

---

## Step 4 -- make sure the new runner is the one running

If `win-tests.txt` had no `DIAGNOSTICS` block, the ZIP on that machine is older
than the current one. Check:

```
findstr /C:"DIAGNOSTICS" run_tests.pl
```

- prints the line -> new runner present;
- prints nothing -> extract the current `symptom-matcher.zip` and try again.

---

## Step 5 -- the exact failing command

The command you ran was typed as:

```
swipl -q -s run_[tests.pl](http://tests.pl)
```

That is an artefact of the message editor auto-linking the filename -- in the
actual console it was `run_tests.pl`, which exists (Step 4 proves that, because
a missing file would have printed `does not exist` rather than running).

---

## What I have already changed, without being able to reproduce your failure

The **previous** runner had a real defect, which is the most likely cause of a
Windows-only failure. It read the summary dict by direct unification:

```prolog
Total   = Summary.total,
Passed  = Summary.passed,
Failed  = Summary.failed,
Timeout = Summary.timeout,      % <-- throws if this key is absent or renamed
Blocked = Summary.blocked,      % <-- same
```

Any structural difference in the dict on 10.0.2 -- a renamed key, a dropped
`timeout`/`blocked`, an unbound summary -- made that clause **throw**, which
surfaced as a generic exit 1 with no explanation. That is precisely the class of
bug the diagnostics were added to expose.

The current runner:

- reads each key with `get_dict/3` guarded by `integer/1`, so a missing or
  renamed key becomes the atom `unknown` instead of an exception;
- falls back to `test_report/1` and `test_count/1` if the summary is unusable;
- **fails loudly** when it cannot count, rather than assuming a pass;
- prints the dict it received, the route it used, and the version, every time.

Verified on 9.2.9, including against synthetic dicts with the keys removed and
renamed:

| Simulated summary | Runner's reading |
|---|---|
| `plunit{total:57,passed:179,failed:0,timeout:0,blocked:0}` | timeout=0, passed=179 |
| `plunit{total:57,passed:179,failed:0}` (no timeout/blocked) | timeout=**unknown**, passed=179 |
| `plunit{tests:57,succeeded:179}` (renamed) | timeout=**unknown**, passed=**unknown** -> FAIL, with reason |

Controls on the current runner, Linux 9.2.9:

| Control | Exit | Message |
|---|---|---|
| broken fact | 1 | `FAIL - failed_tests(1)` |
| empty suite | 1 | `FAIL - too_few_executions(0,50)` |
| missing test file | 1 | `FAIL - load_failed` |
| real suite | 0 | `PASS - 57 declarations, 179 executions` |

---

## The one thing I will not do

I will not record a suite as passed on the strength of an exit status alone.
In this case the status was 1 and the suite had in fact passed -- the status was
describing SWI-Prolog's failure to find a file, not the outcome of any test.
That is exactly why the counts, not the status, are the evidence.

Send me, in order of usefulness:

1. the `SUMMARY:` line from Step 2;
2. the first 30 lines of `win-tests.txt` from Step 0;
3. the output of Step 3, if the first two do not settle it.
