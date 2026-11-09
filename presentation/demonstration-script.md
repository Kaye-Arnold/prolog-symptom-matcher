# Timed Demonstration and Video Script

**Recording status: PENDING.** No video was recorded or uploaded in this
workspace. The commands and output snippets below were executed locally on Linux
with SWI-Prolog 10.0.2 on 9 November 2026. They are examples for a live
recording; repeat the commands on the actual recording machine and show that
machine's output. A Linux run is not Windows verification.

**Target length:** about 4 minutes.

**Assignment requirement:** submit a project-explanation video link through
Google Drive. No Drive URL is available yet.

## Timed talk track

### 0:00-0:25 — Introduce the project and limits

**Say:** "This is a Logic Programming demonstration. It compares typed symptom
terms with a small, source-linked knowledge base. It does not determine whether
someone has or does not have an illness. It gives no diagnosis, probability,
treatment, urgency, emergency advice, or traffic-light recommendation."

**Show:** title slide and the disclaimer on screen.

### 0:25-0:55 — Show source-linked facts and one query

**Command:**

```sh
swipl -q -s queries/demonstration_queries.pl \
  -g demonstration_queries:run_query_examples -t halt
```

**Observed Linux output included:**

```text
Conditions matching dry cough after normalisation: [influenza,measles,common_cold]
Stored influenza cough qualification: [usually_dry]
```

**Say:** "The query unifies a variable with stored facts and backtracks to
collect all matching conditions. Dry cough is an alias for cough, and the
qualification is stored once with the influenza cough fact."

### 0:55-1:35 — Explain lists and exact ranking

**Say:** "The input is normalised, duplicate canonical terms are collapsed,
and unknown terms remain visible. A condition's fraction is unique shared
features divided by that condition's unique stored features. The program compares
fractions exactly using cross multiplication, so equal ratios stay tied."

**Show:** the tied example in the deck: measles `3/6`, common cold `4/8`.

### 1:35-2:40 — Run the application demonstration

**Command:**

```sh
swipl -q -s src/symptom_matcher.pl -- --demo
```

**Observed output from `messy_input` included:**

```text
Understood 3 unique feature(s): [fever,headache,nasal_congestion]
Unknown terms (not compared): [banana]
Duplicate reports collapsed (extra occurrences): [fever-2]
  3/8: [Common cold]
  2/7: [Seasonal influenza]
  2/10: [Malaria]
  1/6: [Measles]
```

**Observed output from `tied_example` included:**

```text
TIE at 3/6: [Measles,Common cold]
Highest software-overlap group is a tie: [Measles,Common cold]
```

**Say:** "This shows an alias, duplicates, an unknown term, matched/unmatched
lists, and a tie. The ranking is only a software comparison."

### 2:40-3:20 — Show the test runner

**Command:**

```sh
swipl -q -s tests/run_tests.pl
```

**Observed Linux summary:**

```text
plunit{blocked:0,failed:0,fixme:0,passed:180,timeout:0,total:64}
RESULT: PASS - 64 declarations, 180 passing executions; 0 failed, 0 timed out, 0 blocked, 0 fixme.
```

**Say:** "The runner reports declarations separately from executions because
`forall/2` can execute one declaration for several conditions. This is a local
Linux result; the current revision still needs a Windows run."

### 3:20-4:00 — Close with limitations and pending work

**Say:** "The profiles are incomplete, the sources do not define the ranking
rule, and the stored qualifiers are not interpreted against age, duration,
measurements, or other history. The branch needs team/lecturer review. Windows
re-verification, the oral defense, the required Google Drive video, and final
submission are still pending."

**Show:** the report's limitations and the submission checklist. End without
making a health recommendation.

## Recording and upload instructions

1. Before recording, use the official 64-bit SWI-Prolog installer on Windows if
   that is the team's submission machine. Follow `docs/windows-setup.md` and run
   the suite first. Record the exact Windows and interpreter versions.
2. Capture the actual terminal and narration. Keep text readable; do not paste
   expected snippets in place of live output. If a command fails, show and report
   the failure rather than editing it out of the evidence.
3. Use the exact source being submitted. Show the source qualifier query, messy
   input, tied ranking, test summary, and limitations in the sequence above.
4. Export/record to a common video format such as MP4, replay the file to check
   audio and screen readability, and include the agreed team members if required.
5. Upload to the team's Google Drive location. Apply the access policy agreed by
   the course/team, then test the link in a private/incognito browser or a
   separate account.
6. Replace the pending video line in `docs/final-report.md` and the checklist
   only after the real link and access test exist. Do not invent a URL or claim
   submission before it happens.
