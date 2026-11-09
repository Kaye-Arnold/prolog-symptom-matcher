# GitHub Repository and Review Workflow

## Observed repository state

Checked with GitHub CLI on 9 November 2026:

- Repository: <https://github.com/Kaye-Arnold/prolog-symptom-matcher>
- Default branch: `main`.
- Visibility: public.
- Issues enabled.
- The scaffold's earlier instructions to create a new private repository are
  obsolete; this repository and `origin` already exist.
- An assignment-completion issue is tracked as
  [#1](https://github.com/Kaye-Arnold/prolog-symptom-matcher/issues/1).

Branch protection settings were not changed or inferred. The repository's
`main` branch must only be updated by a reviewed pull request. Never force-push,
rewrite history, or merge a PR without the required human review.

## Branch and pull-request workflow

1. Link substantial work to a scoped issue.
2. Use a feature branch and keep commits focused. In managed sessions, follow
   the branch supplied by the coding environment rather than renaming it.
3. Open a pull request against `main`; describe changes, exact verification,
   pending Windows/video/review work, and risks.
4. Obtain the agreed team review before merge. No merge is performed by this
   workflow.
5. Never include tokens, `.env` values, passwords, or unnecessary personal data.

## Continuous integration

`.github/workflows/prolog-checks.yml` is the scaffold version: it checks
repository structure, installs SWI-Prolog on Ubuntu, loads application/query/test
source files, and runs `tests/run_tests.pl` when suites are declared. The runner
requires positive evidence of test declarations and executions and halts nonzero
otherwise, so a failing suite fails the job. The remaining gap is that removing
all suites would let the scaffold step skip and pass.

A hardened step that runs the runner unconditionally is written and locally
validated, but it could not be pushed: the connected GitHub App lacks the
`workflows` permission, so GitHub refuses any ref update touching that file.
Apply it after the app is granted that permission. A successful GitHub Actions
result would establish only that the recorded checks passed on the runner image,
not Windows compatibility or medical validity.

Local CI-equivalent commands are recorded in `docs/test-report.md`. GitHub
Actions status is reported separately from local test output.

## Open human/external actions

- Team/lecturer review of the proposed scope, source mappings, and scoring rule.
- Windows re-verification with the official 64-bit SWI-Prolog installer.
- Record the required project video, upload to Google Drive, test link access,
  and insert the actual URL.
- Perform and record the final assignment submission.
