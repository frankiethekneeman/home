---
description: Run all applicable static analysis, type checking, linting, and tests for the current repo and surface a clean summary of what's broken.
---

# Check

Detect all available quality gates, run them in parallel, and surface a single clean summary.

## Step 1: Detect Available Tools

Before spawning anything, scan the repo to determine what's runnable:

- Config files: `pytest.ini`, `mypy.ini`, `.pylintrc`, `ruff.toml`, `pyproject.toml`, `.eslintrc*`, `tsconfig.json`, `.golangci.yml`
- `package.json` scripts: `test`, `lint`, `typecheck`, `check`
- `Makefile` targets: `test`, `lint`, `check`
- CI config: use as ground truth for what the project considers its quality gates

## Step 2: Launch Parallel Check Agents

Spawn one background agent per quality gate, all simultaneously. Common breakdown:

- **Tests agent**: run pytest / jest / go test / etc.
- **Type check agent**: run mypy / tsc / etc.
- **Lint agent**: run ruff / eslint / pylint / golangci-lint / etc.

Prefer project-defined scripts (e.g. `npm run lint`, `make test`) over raw tool invocations — they encode project-specific flags. If a Makefile or package.json script bundles multiple gates together, run it as one agent instead of splitting.

Each agent captures stdout and stderr. Do not stop on failure — all agents run to completion regardless.

## Step 3: Synthesize and Output

Wait for all agents. Merge results:

```
## Check Results

### Tests        [PASS | FAIL | ERROR]
[If FAIL: failing test names and assertion messages — no stack traces unless essential]

### Type Check   [PASS | FAIL | SKIP]
[If FAIL: file:line errors, grouped by file]

### Lint         [PASS | FAIL | SKIP]
[If FAIL: file:line errors, grouped by file]

### Summary
[Actionable list of what needs fixing, ordered by severity]
```

Omit sections that passed cleanly. Only surface failures and warnings.
