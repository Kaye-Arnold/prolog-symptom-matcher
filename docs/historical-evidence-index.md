# Historical snapshot evidence index

The Repomix handoff contains records written before this integration. They are
preserved as historical project data, not presented as verification of the
current `src/` implementation.

| Preserved file | Snapshot SHA-256 | Scope and limitation |
|---|---|---|
| `docs/historical-test-report.md` | `a2f9574ca8078d7f6398407322ea31594645f306d88e835c202f78b10a107b8b` | Byte-for-byte copy of the snapshot report. Its Linux 9.2.9 / Windows 10.0.2 claims refer to the earlier root-level implementation and must not be applied to current code. |
| `docs/windows-run-record.md` | `c95743b1389b91b825dc94b1db833fb1670d75a6101bc1ec2da35de5d586ca9f` | Byte-for-byte, owner-supplied narrative record for the older snapshot. It is not an independently observed Windows run in this environment. |
| `docs/diagnose-windows.md` | `4301f0bd0711b78608973788a1d2f0cf0311f8ac39a82cd9ea428a3740b6101f` | Byte-for-byte troubleshooting note for the earlier package. |

## Missing or unavailable historical artifacts

- The snapshot README links to `docs/plunit-run-linux-9.2.9.log`,
  `docs/demo-run-linux-9.2.9.log`, and `docs/interactive-run-linux-9.2.9.log`.
  These files are absent from the snapshot directory tree and packed contents;
  their raw output was not recovered or inspected.
- `win-tests.txt` and other raw Windows output files are not present in the
  snapshot. The Windows record itself says some owner-provided output was not
  inspected at the time.
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
