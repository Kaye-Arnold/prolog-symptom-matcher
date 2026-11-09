# Historical snapshot evidence index

The Repomix handoff contains records written before this integration. The user
confirms that the codebase represented by the snapshot was run locally on an
actual Windows machine before this integration. That is user-confirmed historical
Windows execution for the earlier snapshot, not verification of the current
`src/` implementation. The accompanying records are preserved as historical
project data.

| Preserved file | Snapshot SHA-256 | Scope and limitation |
|---|---|---|
| `docs/historical-test-report.md` | `a2f9574ca8078d7f6398407322ea31594645f306d88e835c202f78b10a107b8b` | Byte-for-byte copy of the snapshot report. Its Linux 9.2.9 and Windows 10.0.2 results (57 declarations, 179 executions) describe the earlier root-level implementation and must not be applied to current code. |
| `docs/windows-run-record.md` | `c95743b1389b91b825dc94b1db833fb1670d75a6101bc1ec2da35de5d586ca9f` | Byte-for-byte historical Windows run record for the older snapshot; the user confirms that snapshot code was executed on an actual local Windows machine. Its claims do not cover the current integrated revision. |
| `docs/diagnose-windows.md` | `4301f0bd0711b78608973788a1d2f0cf0311f8ac39a82cd9ea428a3740b6101f` | Byte-for-byte troubleshooting note for the earlier package. |

## What the preserved Windows record shows

The preserved report is internally uneven and is reproduced without alteration.
Its earlier status text says the suite had not run on Windows, while later
sections record the resolved outcome: an initial exit code 1 came from an
unexecutable command (a mangled `run_[tests.pl](http://tests.pl)` filename) —
not from a test failure — and the final run reported
`plunit{blocked:0,failed:0,fixme:0,passed:179,timeout:0,total:57}` with
`RESULT: PASS`, exit 0, on SWI-Prolog 10.0.2 for x64-win64, followed by demo and
interactive runs. The user's confirmation that the snapshot codebase was run on
an actual local Windows machine matches the later sections. Recorded disposition:

- **User-confirmed:** the snapshot codebase was executed on a real Windows
  machine, with the preserved record documenting a passing suite, demo, and
  interactive session.
- **Verified here:** the snapshot's Linux suite and metadata only.
- **Not established here:** independent re-inspection of the raw Windows
  transcript (`win-tests.txt` is absent), and any Windows result for the current
  integrated revision.

## Missing or unavailable historical artifacts

- The snapshot README links to `docs/plunit-run-linux-9.2.9.log`,
  `docs/demo-run-linux-9.2.9.log`, and `docs/interactive-run-linux-9.2.9.log`.
  These files are absent from the snapshot directory tree and packed contents;
  their raw output was not recovered or inspected.
- `win-tests.txt` and other raw Windows output files are not present in the
  snapshot. The preserved run record describes the earlier local Windows run,
  which the user confirms occurred; the missing raw files limit independent
  reinspection of the transcript, not the user's confirmation of execution.
- Repomix excludes binary files, ignored files, Git metadata/history, permissions,
  and some paths. The handoff is not a complete filesystem or commit archive.

The recovered older PLUnit suite was run separately during this integration
with SWI-Prolog 10.0.2 on Linux: `swipl -q -s run_tests.pl` exited 0 and reported
57 declarations, 179 passing executions, and no failed/timeout/blocked tests.
That run verifies only the extracted snapshot files, not the current application
or Windows behavior. Current verification is in [`test-report.md`](test-report.md).

The snapshot also contained `evidence/source-register.md`, which was byte-for-byte
identical to `docs/source-register.md`. To avoid two editable copies diverging,
the current source evidence is maintained once in `docs/source-register.md`.
