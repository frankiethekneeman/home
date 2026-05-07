# Phase 3: Execution (REVIEW-BY-REVIEW)

Process each review sequentially. Within a review, each sub-group that
makes changes gets its own commit. PR issue comments are processed
independently of reviews.

## 3.1 For Apply Sub-Groups (within each review)

```
FOR EACH review:
  FOR EACH Apply sub-group within the review:

    1. Make the approved changes

    2. Run verification:
       - If `.claude/pr-verifications.md` exists in the repo, read it and run
         every fenced shell block in order. See
         `references/pr-verifications-convention.md` for the file format.
       - Otherwise, run tests and linters appropriate for the project.

    3. Execution validation:
       - Does actual change match the approved plan?
       - Is scope exactly what was planned?
       - No new issues introduced?

       If validation fails → fix and re-validate

    4. Commit with message:
       ```
       fix: <description>

       Addresses review comments: <ID1>, <ID2>, <ID3>

       Co-Authored-By: Claude <noreply@anthropic.com>
       ```

    5. Record commit SHA + sub-group ref + one-line outcome (DO NOT push yet)
```

PR issue comments follow the same Apply loop, recorded against the issue
comment instead of a review.

## 3.2 Push and Post Threaded Replies

**After ALL Apply sub-groups (across all reviews and PR issue comments) are committed:**

```
1. Push all commits at once:
   git push

2. Post threaded reply to EACH inline comment in EACH Apply or Plan sub-group:
   gh api repos/{owner}/{repo}/pulls/$PR_NUMBER/comments/<GH_COMMENT_ID>/replies \
     -X POST -f body="🤖 Claude responding on behalf of @<user> [ID: <REF_ID>]

   ✅ Applied in commit <SHA>." (or Plan body, see §3.3)
```

**Placeholder legend:**
- `<GH_COMMENT_ID>` — numeric GitHub comment ID from `gh api .../pulls/$PR_NUMBER/comments` (goes in the API URL).
- `<REF_ID>` — the 4-character reference ID assigned per comment in Phase 1 (goes in the reply body so the author can say "run plan a1b2").
- `<SHA>` — commit SHA from the Apply sub-group.
- `<REVIEW_ID>` / `<ORIG_ID>` — for review summaries / PR issue comments: the original review or issue-comment numeric ID. See §3.5.

**Why push at the end:** if something fails midway, you haven't pushed partial work. One push is also more efficient than N pushes.

## 3.3 For Plan Sub-Groups (response template)

```
FOR EACH Plan sub-group:

  Post response to EACH comment:
  gh api repos/{owner}/{repo}/pulls/$PR_NUMBER/comments/<GH_COMMENT_ID>/replies \
    -X POST -f body="🤖 Claude responding on behalf of @<user> [ID: <REF_ID>]

  📋 Plan [ID: <REF_ID>]:
  <explanation of why not applying directly>

  Steps if approved:
  1. ...
  2. ...
  3. ..."
```

## 3.4 PR Issue Comments

PR issue comments are processed independently of reviews (no parent review).
Apply/Plan triage is the same as inline comments. Replies go to the
issue-comments endpoint with the `(in reply to comment <ORIG_ID>)` token:

```bash
gh api repos/{owner}/{repo}/issues/$PR_NUMBER/comments \
  -X POST -f body="🤖 Claude responding on behalf of @<user> [ID: <REF_ID>] (in reply to comment <ORIG_ID>)

<Apply or Plan body — same templates as §3.2 / §3.3>"
```

The `(in reply to comment <ORIG_ID>)` token MUST be present and exact —
Phase 1's response-detection logic looks for it verbatim.

## 3.5 Per-Review Summary Issue Comment

After §3.2 has pushed and posted threaded replies, post **one summary issue
comment per review that had any action** (body response or any Apply/Plan
sub-group). This consolidates the review's outcomes into one place and marks
the review body as responded for future Phase 1 runs.

```bash
gh api repos/{owner}/{repo}/issues/$PR_NUMBER/comments \
  -X POST -f body="🤖 Claude responding on behalf of @<user> [ID: <REVIEW_REF_ID>] (in reply to review <REVIEW_ID>)

<If review body needed response: the body response — Apply/Plan/decline content>

Inline outcomes:
- [<sub-group ref>] applied in commit <SHA> — <one-line>
- [<sub-group ref>] plan posted (see thread)
- [<sub-group ref>] declined (see thread)"
```

The `(in reply to review <REVIEW_ID>)` token MUST be present and exact —
Phase 1's body-response detection looks for it verbatim.

**Skip this step** for reviews where no sub-group was processed AND the body
did not need response.

**One summary per review per run.** Multiple runs over time will produce
multiple summary issue comments on the same review — that's expected and
acceptable; each summary reflects the actions taken in that run.

## Executing a Deferred Plan

When the user approves a plan (e.g., "run plan k7m2"):

1. Find the original comment with that ID
2. Implement the plan exactly as written
3. Follow the Apply sub-group execution process above
4. Reply confirming completion with commit SHA (threaded reply, plus the
   per-review summary if the comment was inline)
