# Convention: `.claude/pr-verifications.md`

Consuming repos can opt into project-specific verification by committing a `.claude/pr-verifications.md` file. The skill reads it during Phase 3 (Execute) after each Apply group to confirm the change didn't break anything.

## Semantics

- **If the file exists:** run every fenced shell block in order. If any block exits non-zero, fix the issue and re-validate before committing.
- **If the file is absent:** fall back to running tests and linters appropriate for the project (use judgment based on the repo's stack).

The file lives in the consuming repo, not in this plugin. This plugin only defines the convention.

## Format

A markdown file containing one or more fenced ```` ```bash ```` blocks. Prose between blocks is ignored by the skill but useful for humans. Each block is run as-is from the repo root.

Keep it focused: the goal is fast feedback that catches regressions introduced by the applied change, not a full CI run.

## Template

A consuming repo would create `.claude/pr-verifications.md` with contents like:

````markdown
# PR Verification Commands

Run after applying review changes, before committing.

## Tests

```bash
pytest tests/ -x --ff
```

## Lint

```bash
ruff check .
```

## Typecheck

```bash
mypy src/
```
````

## Guidelines for Consuming Repos

- **Prefer fast commands.** Use `-x` / `--fail-fast` flags, scoped test paths, incremental type checkers. The skill runs this for every Apply group.
- **List only deterministic checks.** Skip flaky integration tests or anything requiring external services — those belong in CI, not per-commit verification.
- **Order matters.** Put the cheapest, most likely to fail commands first (lint before tests before type-check, usually).
- **No interactive commands.** Anything that prompts or pages will hang the skill.
