---
description: Write tests for the current work — reads recent changes and existing test patterns, then produces tests that meet the project's contract and coverage standards.
---

# Test

Write tests for what has been worked on.

## Step 1: Launch Parallel Read Agents

Spawn both simultaneously:

**Agent 1 — Current Work:** Run `git diff HEAD` and `git diff --staged`. Identify the public interface: functions, methods, and classes that form the contract to be tested.

**Agent 2 — Test Patterns:** Find existing test files for this module or adjacent ones. Extract: framework, file naming convention, directory structure, function/method naming, mock and fixture setup, use of describe blocks or test classes.

If no git changes exist, ask the user what to test before proceeding.

## Step 2: Write Tests

Wait for both agents. Then write tests that match the existing patterns exactly and follow `standards/testing.md`:

- Each test covers one piece of the contract
- Test name states: what, conditions, single expectation
- One cogent assertion per test
- Mock by default — no real I/O, network, or database
- Dead simple test bodies

Cover:
- Happy path
- Edge cases (empty, None, zero, boundaries)
- Error conditions

## Step 3: Run Them

Run the new tests. Fix any that fail due to setup issues (not contract issues). Report results.
