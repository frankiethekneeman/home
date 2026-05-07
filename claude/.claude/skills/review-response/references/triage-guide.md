# Triage Guide: Categorizing Review Comments

Not all review comments should be blindly applied. Consider both size AND value.

## Understand the PR's Intent First

Before accepting any change, understand what the PR is trying to accomplish. A reviewer might request changes that conflict with the PR's goals. You work for the author, not the reviewer.

**Bias toward action.** Value determines permitted scope — the more valuable a change, the larger it's allowed to be. Each applied change lands as its own commit, so the author can roll back any individual piece cheaply.

- **Clear value:** apply regardless of size.
- **Unclear value:** size matters — small is cheap to try, large goes through a Plan.
- **Negative value or misaligned with PR intent:** always Plan, regardless of size. The author decides whether to expand scope.

## Decision Matrix

### High value → Do them (regardless of size)
- Simplifications, deletions, reducing complexity
- Bug fixes, correctness improvements, clear quality wins
- When value is clear, size alone is not a reason to defer — each change is its own commit, so rollback is cheap.
- When value is unclear, size matters: small uncertain changes are still cheap to try; large uncertain changes go through a Plan.
- When a change is misaligned or would make things worse, always Plan — no matter how small. See "Misaligned changes" below.

### Low effort → Do them (unless they conflict with lint)

### High effort / uncertain value → Comment back with an executable plan
```
🤖 Claude responding on behalf of @<user> [ID: a1b2]

Current: <what it does now>
Proposed: <what reviewer wants>

Plan if approved:
1. <concrete step>
2. <concrete step>
3. <concrete step>

Trade-off: <why this is a decision, not obvious>
```

### Positive comments ("Nice!", "Good catch") → Brief, non-thanking reply
```
🤖 Claude responding on behalf of @<user> [ID: b2c3]

No change needed — positive feedback.
```
Don't say "Thanks!" - it implies Claude wrote the code. Don't reply with just "Acknowledged." or "Noted." — those are banned as standalone responses. Keep it short and substantive.

### Questions from reviewers → Answer first, then decide
```
🤖 Claude responding on behalf of @<user> [ID: c3d4]

<direct answer with brief justification>

<if change warranted: "Applied." or plan>
<if no change: "No change needed.">
```

**If a question can be answered by running a command** (coverage, tests, git log, etc.), run it and provide actual data. Don't speculate when you can measure.

**Leading questions** ("Why not use X here?", "Wouldn't it be cleaner to...?") deserve an answer, not automatic compliance. Explain the reasoning behind the current approach. If the answer reveals the current approach is wrong, then apply the change or propose a plan. But leading questions should clear a higher bar than direct requests — the reviewer is asking, not telling.

### Architectural questions → Always answer substantively

When a reviewer asks "why X but not Y?" or "why here but not there?", they're pointing out a potential inconsistency. These are NOT rhetorical.

1. If there's a good reason for the inconsistency, explain it
2. If there's no good reason, acknowledge the inconsistency and either:
   - Fix it (if low effort)
   - Propose a plan to fix it (if high effort)
   - Propose options if uncertain (never just "flag" without a plan)

### Misaligned changes → Comment back with justification
```
🤖 Claude responding on behalf of @<user> [ID: e5f6]

Declining this change:
- <reason>
```

### Out-of-scope suggestions → Post a plan, let author decide
```
🤖 Claude responding on behalf of @<user> [ID: f6g7]

This seems like follow-up work rather than this PR.

Suggestion: <what reviewer wants>
Current PR scope: <what this PR is doing>

Plan if author wants to expand scope:
1. <concrete step>
2. <concrete step>
```

### Optional ("Opt:") comments → Still evaluate them
- If you agree and it aligns with PR intent → apply
- If it conflicts with PR intent → post a plan explaining the conflict
- If uncertain → post a plan with options for author to choose

## Additional Rules

**Parse multi-part requests:** A single comment may contain multiple requests. List ALL requests explicitly and address EACH ONE — even if declining or deferring.

**Recognize prior decisions:** When a reviewer says "we stopped doing X" or "there's a reason we do Z", they're citing a prior codebase decision. Either revert to match the prior decision, OR provide a plan with options.

**Before accepting ANY change:** Verify factual claims. Reviewers can be wrong.

**When uncertain, do NOT ask the reviewer.** Post a plan with options for the author instead.

**Each comment gets a unique 4-character ID** (not per-thread). The user can say "proceed with c3d4" or "run plan a1b2" to reference specific comments.

**Every comment gets a response.** Never leave a comment without acknowledgment.
