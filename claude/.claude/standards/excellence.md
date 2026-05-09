# Excellence

## CI is the Floor

A quality repo has strong CI: linting, testing, static analysis, all enforced before merge. Ideally enforced before push via pre-push hooks — you should know your shit is safe before it touches GitHub. This is non-negotiable. A repo without it is a repo that cannot be trusted.

## Functions Do One Thing

Small functions and methods with single responsibility are the clearest signal that the authors thought carefully. A 500-line `main` is a sign that people have been adding code wherever it fits. If a function needs a comment explaining what section does what, it should be multiple functions.

## Documentation Lives Close to the Code

The best defense against doc rot is proximity. Code documentation belongs as close to the code as possible — in docstrings, in the module, not in a wiki three clicks away.

## Repo-Level Documentation

A good README is brief: what is this, why does it exist, how do I get started. Nothing more.

Beyond that, well-organized markdown files for specific concerns: `TESTING.md`, `CONTRIBUTING.md`, etc. These are discoverable and specific — better than one bloated README.

Design docs and ADRs belong in the repo, not in Confluence or Notion. Use ISO8601 dates in filenames so they sort chronologically and stay interpretable years later.

## PRs

Every non-trivial PR needs a reviewer's guide: what changed, why it changed, and where to start reading to understand it. A linked ticket is the minimum. For small changes (one or two files) you can be brief. For anything larger, the author owes the reviewer an orientation.

Large PRs are a smell. If a PR is hard to review, it's usually too big. Break it up.

## Commit Messages

Write good commit messages. Explain why, not what. The diff already shows what.
