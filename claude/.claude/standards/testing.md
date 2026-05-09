# Testing

## Philosophy

Tests are a form of communication. A test suite tells you the **contract** of a function or class. Each test communicates one specific piece of that contract. When a test fails, it should tell you exactly which piece of the contract is violated — nothing more, nothing less.

## Test Names

A test name must convey — on its own, without reading the body:

1. **What** is being tested (function name, or class + method)
2. **The conditions** under which it is being tested
3. **The single expectation** being asserted

`test_array_list()` is unacceptable — it says nothing about contract.
`test_array_list_pop_returns_none_when_called_on_empty_list()` is correct.

Use `describe` blocks or test class grouping to avoid redundant prefixes where the framework supports it.

## Single Responsibility per Test

Each test asserts **one thing**. It is sometimes necessary to write 2–3 `assert` statements to express a single cogent assertion — that is fine. What is not acceptable is calling a function and then asserting everything about the output in one test. One piece of contract per test.

Kernighan's Law applies doubly to tests. Cleverness belongs in the solution. Tests must be dead simple so they can be trusted when debugging.

## Mocking

Mock by default. Unit tests should not touch real I/O, databases, or external services. If mocking is onerous, that is a signal that the abstraction boundaries are not clean — fix the design.

Supplement with integration tests that wire real objects together, to validate that mocked expectations actually hold. Live the testing pyramid: many unit tests, fewer integration tests, minimal end-to-end.

## TDD (By Lying)

The interface often isn't clear until you've played with the solution. The actual workflow:

1. Solve the core problem
2. Nail down the real contract with tests
3. Refactor through what the tests expose

By the time you commit, it should look like TDD was done from the start. The tests define the contract; the implementation serves the tests.

## Coverage

Coverage numbers are vanity metrics. However, they are a useful gut-check for whether an agent has done its job — set high minimums and enforce them in CI, because full coverage is literally one prompt away. Don't accept untested code from an agent.

In the age of AI-generated code, coverage requirements, linting, and static analysis should be **stricter** than they were before. These tools are no longer curtailing creativity — they are forcing a tool to do its job properly.

## Tests as Review

Read tests, not implementations. A well-written test suite tells you everything you need to know about what the code is supposed to do. When reviewing code, validate that the tests assert the things you expect them to assert, and that they actually do what their names claim.
