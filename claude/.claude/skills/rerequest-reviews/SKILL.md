---
description: Re-request reviews from all teams that had on-behalf-of reviews on a PR
---

# Re-request Reviews from On-Behalf-Of Teams

Re-requests reviews from all teams that had "on behalf of" reviews on a PR.

## Usage

```
/rerequest-reviews:rerequest-reviews <pr>
```

Where `<pr>` is either:
- `org/repo#123`
- A full GitHub URL like `https://github.com/org/repo/pull/123`

Works against any GitHub host as long as `gh` is authenticated for it.

## Instructions

1. Parse the PR argument to extract org, repo, and PR number.

2. Query all reviews with onBehalfOf teams using GraphQL:
```bash
gh api graphql -f query='
{
  repository(owner: "<ORG>", name: "<REPO>") {
    pullRequest(number: <NUMBER>) {
      reviews(first: 100) {
        nodes {
          author { login }
          state
          onBehalfOf(first: 10) {
            nodes { slug }
          }
        }
      }
    }
  }
}'
```

   This fetches only the first 100 reviews. For PRs that may exceed this,
   add cursor-based pagination using `pageInfo.endCursor` and `hasNextPage`.

3. Extract all unique team slugs from reviews that have onBehalfOf teams (any state - APPROVED, DISMISSED, COMMENTED, etc.).

   All internal comparisons (between onBehalfOf teams and current reviewRequests)
   use raw slugs (e.g. `team-a`). The `<ORG>/` prefix is added only when
   displaying results and when invoking `gh pr edit --add-reviewer`.

4. Get current review requests:
```bash
gh pr view <NUMBER> --repo <ORG>/<REPO> --json reviewRequests --jq '[.reviewRequests[] | .slug // .login]'
```

5. Find teams that are in onBehalfOf but NOT in current reviewRequests.

6. If there are missing teams, request them:
```bash
gh pr edit <NUMBER> --repo <ORG>/<REPO> --add-reviewer <ORG>/<TEAM1>,<ORG>/<TEAM2>,...
```

7. Output a table of all teams found with their status:

```
| Team | Reviewer | State | Status |
|------|----------|-------|--------|
| org/team-a | reviewer1 | DISMISSED | already requested |
| org/team-b | reviewer2 | DISMISSED | already requested |
| org/team-c | reviewer3 | COMMENTED | re-added |
| org/team-d | reviewer4 | COMMENTED | re-added |
```

Status values:
- `already requested` — team was already in review requests
- `re-added` — team was missing and has been added
