# GitHub Setup and Enforcement

The local repository contains the project scaffold and Git history. A private GitHub remote still needs to be created by an authenticated repository owner.

## 1. Create the remote repository

Use these values:

- **Name:** `prolog-symptom-matcher`
- **Description:** `Educational SWI-Prolog knowledge-based system for transparent symptom matching across selected infectious illnesses, with queries, tests, and documentation.`
- **Visibility:** Private
- **Default branch:** `main`
- **License:** None while private coursework
- **Issues:** Enabled
- **Projects:** Enabled

Because the local repository already contains a README and initial commit, do not initialize the GitHub remote with another README, `.gitignore`, or license.

### Option A: GitHub web interface

Create the empty private repository, then run from the local repository root:

```bash
git remote add origin https://github.com/YOUR-USERNAME/prolog-symptom-matcher.git
git push -u origin main
```

Replace `YOUR-USERNAME` with the actual owner or organization.

### Option B: Authenticated GitHub CLI

```bash
gh repo create prolog-symptom-matcher \
  --private \
  --description "Educational SWI-Prolog knowledge-based system for transparent symptom matching across selected infectious illnesses, with queries, tests, and documentation." \
  --source=. \
  --remote=origin \
  --push
```

## 2. Apply branch protection

In **Settings → Branches**, protect `main` and enable:

1. Require a pull request before merging.
2. Require at least one approval.
3. Dismiss stale approvals when new commits are pushed.
4. Require branches to be up to date before merging.
5. Require the `Prolog Checks / check` status check after the workflow has run at least once.
6. Block force pushes.
7. Do not allow branch deletion.
8. Apply the rules to administrators where the team’s GitHub plan permits it.

Do not add a `CODEOWNERS` entry until verified GitHub usernames are available.

## 3. Connect Claude safely

1. Authorize only this repository, not every repository owned by the account.
2. Ensure the integration reads `CLAUDE.md`.
3. Require feature branches and pull requests; do not allow direct commits to `main`.
4. Grant only the permissions needed for the intended workflow.
5. Never paste GitHub tokens, Slack tokens, passwords, or `.env` values into Slack, issues, commits, or pull requests.
6. Have a teammate review every generated change before merging.

Initial Claude instruction:

```text
Work only in prolog-symptom-matcher. Read CLAUDE.md and the documents under docs/ before proposing changes. Summarize the current stage, approved facts, pending decisions, and missing prerequisites. Do not implement code or claim approvals. Create a branch and pull request for any approved change; never commit directly to main.
```

## 4. Required content reconciliation

The actual revised Slack Canvas text and recorded team-member details were not available when this local scaffold was created. Before treating the repository proposal as the team’s approved copy:

1. Compare `docs/stage-1-proposal.md` with the revised Slack Canvas.
2. Import only verified team details and role agreements.
3. Resolve any content difference deliberately; do not silently overwrite one version.
4. Record team approval only after it actually occurs.

## 5. CI interpretation

The included workflow checks repository structure and whether Prolog files load. It runs PLUnit only when real test suites are defined. A successful scaffold check is not evidence of complete functionality, medical validity, or executed application tests.
