---
description: Fast repo orientation — what it does, how it's structured, entry points, test strategy, and notable patterns. Designed to run in the background while the user is otherwise occupied.
---

# Orient

Silently explore the repo in parallel and produce a concise orientation brief. Output once at the end.

## Step 1: Launch Parallel Discovery Agents

Spawn all five of these as background agents simultaneously:

**Agent 1 — Identity:** Read `README.md`, `package.json`/`pyproject.toml`/`go.mod`/`Cargo.toml`/`pom.xml` (whichever exist). Extract: what the project is, why it exists, language and major dependencies.

**Agent 2 — Structure:** Run `find . -maxdepth 2 -not -path '*/.git/*'` to get the directory tree. Identify notable directories. Find entry points: `main.py`, `__main__.py`, `index.js`, `main.go`, `cmd/`, `src/main.*`, `app.*`, etc.

**Agent 3 — Tests:** Find the test directory. Identify the framework. Skim one or two test files for naming conventions and patterns. Note rough coverage impression.

**Agent 4 — CI:** Read `.github/workflows/`, `.travis.yml`, `.circleci/config.yml`, `Jenkinsfile`, `.gitlab-ci.yml` (whichever exist). Extract what gates run on push/PR.

**Agent 5 — Docs:** Read `CONTRIBUTING.md`, `TESTING.md`, `ARCHITECTURE.md`, `docs/`, `ADR*/`, `decisions/` (whichever exist). Surface anything non-obvious.

## Step 2: Synthesize and Output

Wait for all agents to complete. Merge their findings into a single brief:

```
## What It Is
[One or two sentences: what the project does and why it exists]

## Stack
[Languages, frameworks, major dependencies — notable ones only]

## Entry Points
[Where execution starts, main interfaces/APIs/CLIs]

## Structure
[Notable directories and what lives in them — skip obvious ones]

## Test Strategy
[Framework, where tests live, rough coverage impression]

## CI
[What runs on push/PR]

## Things to Know
[Anything surprising, non-obvious conventions, or gotchas visible from the surface]
```

Keep the whole output skimmable in under two minutes.
