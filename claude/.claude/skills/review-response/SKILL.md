---
description: "Three-phase adversarial process to address PR review comments. Phases: planning (read-only), validation (adversarial), execution (group-by-group). Use when asked to respond to PR review comments."
---

# Respond to PR Review Comments

Addresses review comments on a PR using a three-phase adversarial process to prevent common failures.

## Arguments
- `$PR_NUMBER` - PR number to respond to (required)

## Banned Patterns

**NEVER do any of the following:**
- Use "Acknowledged" as a response (this is a non-answer)
- Post "Applied" without an actual commit SHA
- Remove DI/testability infrastructure without explicit author approval
- Make changes beyond what was explicitly requested
- Propose changes to code without first reading the actual file

---

## Workflow Overview

### Phase 1: Planning (READ-ONLY)

Read `references/planner-subagent.md` and execute it.

Checkout the PR, fetch unresponded reviews (each review's body + its inline-comment threads) and PR-level issue comments, read repo documentation, group **per review** then sub-group by concern, and produce a structured plan with draft responses. Consult `references/triage-guide.md` for how to categorize each comment (Apply or Plan — triage patterns like "decline" or "no change needed" are Plan-type responses that make no code change).

**Do NOT proceed to Phase 2 until the plan is complete.**

### Phase 2: Validation (ADVERSARIAL)

Read `references/validator-subagent.md` and execute it.

Check every draft response and proposed change against quality, safety, grouping, and escalation criteria. Loop until all checks pass.

### Phase 3: Execution (REVIEW-BY-REVIEW)

Read `references/executor-subagent.md` and execute it.

Process each review sequentially. Within a review, each Apply sub-group gets its own commit. Push once at the end, then post threaded replies and one per-review summary issue comment per review that had any action. PR issue comments are processed independently.

---

## Two Valid Response Types Only

### Type 1: Apply

Make the change, commit, push, then respond:

```
🤖 Claude responding on behalf of @<user> [ID: x1y2]

Applied in commit abc1234.
```

**Must include commit SHA.** "Applied" without SHA is banned.

### Type 2: Plan

Provide explanation + concrete steps:

```
🤖 Claude responding on behalf of @<user> [ID: x1y2]

Plan [ID: a1b2]:
<why not applying directly - pick one:>
- "This affects multiple files, want to confirm scope"
- "This conflicts with X, need author decision"
- "Uncertain about intent - here are the options"
- "I recommend against this because X, but here's how if you disagree"

Steps if approved:
1. <concrete executable step>
2. <concrete executable step>
3. <concrete executable step>
```

**Even when recommending against a change, provide executable steps.** This lets the author override your judgment.

---

## Critical Rules

### Comments Are State

**NEVER post a comment claiming a change was made until you have committed AND pushed.**

The workflow is always:
1. Make changes
2. Run tests
3. Commit and push
4. ONLY THEN post comments

### NO Amend, NO Force Push

**NEVER use `--amend` or `--force` when responding to reviews.** This breaks GitHub's review comment tracking.

Each response round = new commit(s).

### Every Comment Gets a Response

Even if addressed by another comment's change:
```
🤖 Claude responding on behalf of @<user> [ID: x1y2]

Applied in commit abc1234 (same fix as comment ID: y2z3).
```

### "Remove X" Means X Only

If asked to "remove the mock" - remove ONLY the mock, not the entire test infrastructure it was part of.

Scope your changes precisely to what was requested.

---

## Executing a Deferred Plan

When the user approves a plan (e.g., "run plan k7m2"):

1. Find the original comment with that ID
2. Implement the plan exactly as written
3. Follow Phase 3 execution process
4. Reply confirming completion with commit SHA
