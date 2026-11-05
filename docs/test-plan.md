# Test Plan and Results

**Execution status:** No Prolog application tests have been executed. SWI-Prolog was unavailable in the scaffolding environment.

## 1. Testing principles

- Test every major predicate with suitable examples.
- Separate expected results from verified results.
- Record the exact SWI-Prolog version, command, input, expected result, actual result, and pass/fail status.
- Add regression coverage for corrected defects.
- Do not use the repository-structure CI check as evidence of application correctness.
- Use PLUnit for executable predicates where appropriate and demonstration queries for oral-defense evidence.

## 2. Planned test categories

| ID | Category | Example test purpose | Expected outcome | Actual result |
|---|---|---|---|---|
| KB-01 | Knowledge retrieval | Retrieve all declared conditions | Exactly the approved bounded condition set | Not run |
| KB-02 | Knowledge retrieval | Retrieve associations for one condition | Only stored associations, without duplicates | Not run |
| KB-03 | Shared relationships | Query conditions associated with a shared symptom | All and only matching conditions | Not run |
| INF-01 | Inference | Derive candidates for a mixed symptom report | All eligible candidates; no premature first-result commit | Not run |
| INF-02 | No match | Supply known terms with no eligible association | Explicit no-match result | Not run |
| UB-01 | Unification | Inspect variable binding in a query | Bindings match the relevant terms | Not run |
| UB-02 | Backtracking | Request alternative solutions | Alternatives appear in the expected logical order or documented ranking | Not run |
| LIST-01 | Empty list | Supply `[]` | Validation response; no fabricated candidate | Not run |
| LIST-02 | Duplicates | Repeat a symptom in the input | Duplicate handled according to the documented normalization rule | Not run |
| LIST-03 | Unknown terms | Include a term outside the vocabulary | Unknown term reported separately | Not run |
| LIST-04 | Malformed input | Supply an invalid term or malformed console input | Controlled validation message; no unexpected crash | Not run |
| LIST-05 | Recursion | Process collections of different lengths | Base and recursive cases behave correctly | Not run |
| ARITH-01 | Overlap | Calculate overlap for a known report | Count equals unique matched terms | Not run |
| ARITH-02 | Boundary | Zero overlap | Candidate excluded and no-match behavior preserved | Not run |
| ARITH-03 | Ranking | Two candidates with equal overlap | Both retained as tied | Not run |
| ARITH-04 | Ordering | Candidates with different overlaps | Ordering follows the approved calculation | Not run |
| IO-01 | Console interaction | Complete a normal console session | Clear prompts, results, explanation, and disclaimer | Not run |
| IO-02 | Repeated sessions | Run more than one report | No unintended dynamic-fact leakage between sessions | Not run |
| REG-01 | Requirements | Run the complete suite after integration | All applicable tests pass; failures documented honestly | Not run |

## 3. Execution record template

For each verified run, add:

```text
Date:
SWI-Prolog version:
Command:
Input / query:
Expected:
Actual:
Result: PASS / FAIL
Commit:
Notes:
```

## 4. Final verification

Before submission, run the exact submitted source from a clean directory, record the results, and confirm that the report’s output matches the verified application behavior.
