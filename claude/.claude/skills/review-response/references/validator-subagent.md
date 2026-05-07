# Phase 2: Plan Validation (ADVERSARIAL)

After creating the plan, validate it by checking each of these criteria.

## 2.1 Response Quality Check

For EACH draft response, verify:

1. **Is it an actual answer?**
   - "Acknowledged" alone → FAIL (must provide substantive response)
   - "Noted" alone → FAIL
   - Any non-answer → FAIL

2. **Does the change match what was requested?**
   - More than requested → FAIL (scope creep)
   - Less than requested → FAIL (incomplete)

3. **Was the code actually read?**
   - If proposing a change without quoting actual code → FAIL
   - If quoted code doesn't match the file → FAIL

## 2.2 Safety Check

For EACH proposed change, verify:

1. **Does it follow repo conventions?** (from docs read in Phase 1)
2. **Does it delete infrastructure without approval?**
   - Removing dataclasses → Escalate to Plan
   - Removing DI parameters → Escalate to Plan
   - Removing exports → Escalate to Plan
3. **Is the scope risky?**
   - Multi-file changes with unclear scope → Escalate to Plan
   - Public API changes → Escalate to Plan
   - Changes conflicting with documented conventions → Escalate to Plan

## 2.3 Grouping Correctness Check

Top-level grouping is **per review** — verify each review is its own
processing unit. Within a review, sub-grouping is by concern. For EACH
sub-group with multiple comments, verify:

1. **Apply the commit message test:**
   - Can these changes be described in ONE commit message without "and" joining unrelated things?
   - "Improve variable naming" — one concern
   - "Remove dead code and add test" — two concerns → FAIL

2. **Grouping signals:**
   - "Same review" IS the primary grouping signal at the top level — each
     review is one processing unit, with its body + inline sub-groups.
   - Within a review, sub-grouping is by concern.
   - "Same file" alone is NOT sufficient to sub-group.
   - Across reviews, never merge sub-groups even if they touch the same code —
     each review's outcomes are summarized separately in Phase 3.

If sub-grouping is incorrect → split the sub-group and re-validate.

## 2.4 Escalation Rules

If any Apply should become a Plan, change it:

**Apply → Plan when:**
- Deleting dataclasses, removing parameters, removing exports
- Changes that affect public API
- Changes that conflict with documented conventions
- Multi-file changes with unclear scope
- "Remove X" where X is structural (not just a line)

**Making something private requires BOTH:**
- Remove from `__all__`
- Add underscore prefix to the name

## 2.5 Validation Loop

```
LOOP until all checks pass:
  1. Run checks 2.1, 2.2, 2.3, 2.4
  2. If issues found:
     - Fix the specific issue
     - Re-run validation
  3. If no issues:
     - Output: "VALIDATION PASSED"
     - Proceed to Phase 3
```
