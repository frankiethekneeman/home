---
description: Read existing tests for a function, class, or module and enumerate the contract they define in plain language.
---

# Contract

Read the tests for the target and enumerate what they collectively assert.

## Usage

`/contract` — infer target from recent work (git diff, conversation context)
`/contract <function or class name>` — target a specific symbol
`/contract <file path>` — target a specific file

## Step 1: Find the Tests

Locate all test files covering the target. If none exist, say so and stop.

## Step 2: Launch Parallel Read Agents

Spawn one background agent per test file, all simultaneously. Each agent reads its file and returns a list of (condition, action, expectation) tuples — one per test. Agents ignore test infrastructure (fixtures, helpers, mocks) unless it reveals something about the contract.

## Step 3: Synthesize and Output

Wait for all agents. Merge and group by method or behavior:

```
## Contract: <TargetName>

### <method or behavior>
- Returns X when given Y
- Raises <ErrorType> when Z
- Returns None when called on empty input
- Does not mutate the input

### Edge Cases Covered
- [list]

### Gaps
- [Behaviors that appear untested — inferred from the interface, not the implementation]
```

Only state what the tests actually assert. If a test name says one thing but asserts another, flag the discrepancy. Gaps are valuable: an untested behavior is an unspecified contract.
