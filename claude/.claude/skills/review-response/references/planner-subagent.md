# Phase 1: Planning (READ-ONLY)

This phase is read-only. Do not modify any files.

## 1.1 Checkout and Fetch Comments

The skill organizes reviewer feedback **per review**. A review is the unit of
processing: it may contain (a) a body and (b) inline comments. PR issue
comments live outside any review and are handled independently.

Inline comments have native threading (`in_reply_to_id`). A thread "needs
response" when its latest comment is from a non-bot — this catches both
brand-new comments and threaded follow-ups (plan approvals, pushback). A
review body or PR issue comment "needs response" when no bot-authored issue
comment carries the `(in reply to review <id>)` or `(in reply to comment <id>)`
token. Per-review summary replies and PR-issue-comment replies (Phase 3) both
go to the issue-comments endpoint with the appropriate token.

```bash
gh pr checkout $PR_NUMBER

# Cache once. Use temp files (not bash vars) so embedded control characters
# in comment bodies don't break --argjson handling.
TMP=$(mktemp -d)
gh api repos/{owner}/{repo}/issues/$PR_NUMBER/comments --paginate > $TMP/issue_comments.json
gh api repos/{owner}/{repo}/pulls/$PR_NUMBER/comments --paginate > $TMP/inline.json
gh api repos/{owner}/{repo}/pulls/$PR_NUMBER/reviews --paginate > $TMP/reviews.json

# Inline threads needing response: group by thread root and surface threads
# whose most recent comment is from a non-bot.
jq '
  group_by(.in_reply_to_id // .id) |
  map(sort_by(.created_at) | last | select(.body | startswith("🤖") | not))
' $TMP/inline.json > $TMP/threads.json

# Per-review surfacing: a review appears if its body needs response OR any
# of its inline threads needs response.
echo "=== UNRESPONDED REVIEWS ==="
jq -r \
  --slurpfile threads $TMP/threads.json \
  --slurpfile issue_comments $TMP/issue_comments.json '
  ([$issue_comments[0][] | select(.body | startswith("🤖"))]) as $bot_replies |
  ($threads[0]) as $unresponded_threads |
  [.[] |
    . as $r |
    {
      id: .id, author: .user.login, state: .state, body: .body,
      body_needs_response: (
        (.body | length > 0)
        and ((.body | startswith("🤖")) | not)
        and (($bot_replies | map(select(.body | contains("(in reply to review \($r.id))"))) | length) == 0)
      ),
      threads: [$unresponded_threads[] | select(.pull_request_review_id == $r.id)]
    } | select(.body_needs_response or (.threads | length > 0))
  ] |
  if length == 0 then "None" else
    .[] | "REVIEW \(.id) by \(.author) (\(.state)):\n  Body: \(if .body_needs_response then "NEEDS RESPONSE — \(.body)" else "(responded or empty)" end)\n  Inline threads needing response:\n\(if (.threads | length) == 0 then "    (none)" else (.threads | map("    - ID: \(.id), File: \(.path):\(.line // .original_line)\n      Comment: \(.body)") | join("\n")) end)\n---"
  end
' $TMP/reviews.json

echo ""
echo "=== PR ISSUE COMMENTS NEEDING RESPONSE ==="
jq -r '
  [.[] | select(.body | startswith("🤖") | not)] as $reviewer |
  [.[] | select(.body | startswith("🤖"))] as $bot_replies |
  [$reviewer[] | select(. as $c |
    ($bot_replies | map(select(.body | contains("(in reply to comment \($c.id))"))) | length) == 0
  )] |
  if length == 0 then "None" else .[] | "ID: \(.id) (issue-comment)\nAuthor: \(.user.login)\nBody: \(.body)\n---" end
' $TMP/issue_comments.json
```

## 1.2 Read Documentation First

**Before planning any response, read the repository's documentation:**
- `CLAUDE.md` or `.claude/CLAUDE.md` (project rules)
- `.claude.md` (alternative location)
- `README.md` (project overview)
- `CONTRIBUTING.md` (contribution guidelines)

These documents define the project's conventions. Proposed changes must not violate them.

## 1.3 Group by Review, then by Concern

Top-level grouping is **per review** — each review is one processing unit
(its body plus its inline comments). PR issue comments are processed
independently (no parent review).

Within a review, sub-group inline comments by concern. Each sub-group gets
ONE change (if any), but EACH comment in the sub-group gets its own response.

**Sub-group together** (same underlying issue):
- Multiple comments about naming conventions in the same area
- Multiple comments pointing out the same bug in different places
- Comments that request the same change

**Never sub-group** (independent issues):
- "Remove X" + "Add test for Y"
- "Fix bug A" + "Add docs for B"
- Changes that would require "and" to join unrelated things in a commit message

**The commit message test** (within a sub-group): can these changes be
described in a single commit message without joining unrelated things with
"and"?

For each comment:
1. **Read the actual file** at the referenced line number
2. **Quote the actual code** you see
3. Only then decide what action to take

## 1.4 Create Structured Plan

Consult `references/triage-guide.md` to categorize each comment, then output:

```
=== PLAN ===

## REVIEW <id> by <author> (<state>)

### Body action
Type: Apply | Plan | None
<the body content if it needed response, else "no body action">
<exact change or plan>
Draft body response: <text>

### Sub-group 1: <description of concern>
Comments: ID1, ID2
Type: Apply | Plan
Files: <file paths and line numbers>

Actual code at referenced locations:
"""
<quoted code>
"""

Proposed action: <exact change or plan>

Draft responses:
- ID1: <text>
- ID2: <text>

### Sub-group 2: ...

### Per-review summary (posted as one issue comment to the review)
- Body: <one-line outcome>
- [<sub-group ref>] <one-line outcome>

---

## REVIEW <id> ...

---

## PR ISSUE COMMENT <id>
(processed independently, same Apply/Plan triage)
```

**Critical:** Do NOT proceed to Phase 2 until the plan is complete.
