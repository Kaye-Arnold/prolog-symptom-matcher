# Windows Setup and Verification Guide

**Current integrated code status:** Windows verification is pending. The
historical owner-supplied Windows records in
[`windows-run-record.md`](windows-run-record.md) describe the earlier snapshot
implementation, not this revision. Do not report the present tests or console as
Windows-verified until they are run again on Windows.

## 1. Install SWI-Prolog

1. Open the [official SWI-Prolog downloads page](https://www.swi-prolog.org/download/stable).
2. Select the **64-bit Windows (Intel/AMD x64)** self-installing executable for
   the stable distribution. Follow the official installer prompts.
3. If the installer offers to add SWI-Prolog to `PATH`, enable that option.
4. Open a new Command Prompt or PowerShell window and run:

   ```bat
   swipl --version
   ```

   Record the exact output and the Windows version. Do not copy an expected
   version number into a run record unless it was actually observed.

## 2. Verify the extracted project

Open a shell in the repository root (the directory containing `src`, `tests`,
and `run-tests.bat`). Run the suite and the demonstration:

```bat
run-tests.bat
run-demo.bat
```

Then test interactive input:

```bat
run-interactive.bat
```

Enter `fever, headache`, press Enter, then press Enter on an empty line to exit.
The launcher displays the program's exit code. For a direct shell run, the
following commands are also supported:

```bat
swipl -q -s tests/run_tests.pl
swipl -q -s src/symptom_matcher.pl -- --demo
swipl -q -s src/symptom_matcher.pl --
```

`run-tests.bat` runs the summary-checking PLUnit runner; it does not redirect or
overwrite a transcript file. Record the exact command, exit code, test summary,
SWI-Prolog version, Windows version, and date in a new verification note. Do not
edit the historical run record to imply it covers this revision.

## 3. Inputs to check during the Windows run

- `fever, headache` for an ordinary comparison.
- `fever, dry cough, cough` to verify that the cough aliases collapse to one
  canonical feature and that `usually_dry` is retained in the source fact.
- `fever, cough, runny nose, nasal congestion` to see the exact `3/6` and `4/8`
  top tie.
- `banana, banana` to see unknown-term reporting and no-match handling.
- An empty API list is covered by PLUnit; an empty interactive line exits the
  session.

These are test cases, not health recommendations.

## 4. Record and report limitations

- Linux success does not establish Windows compatibility.
- Historical 9.2.9/10.0.2 records refer to earlier snapshot files and are not a
  current Windows test result.
- Do not change source expectations simply to get a pass. If Windows exposes a
  difference, capture the exact output and interpreter version first.
- No video recording, Drive upload, or assignment submission is performed by
  this guide; those remain separate human actions.
