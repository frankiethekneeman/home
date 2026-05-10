---
description: Install project-level dependencies — Python venv + pip, npm/yarn/pnpm install, bundle install, go mod download, etc. Assumes runtimes are already available (run /prep-tools first if not).
---

# Prep Local Environment

Install all project-level dependencies so the repo is ready to run and test.

## Step 1: Discover What Needs Installing

Spawn parallel agents to find dependency manifests:

**Agent 1 — Python:** Find `requirements*.txt`, `pyproject.toml`, `setup.py`, `setup.cfg`, `Pipfile`, `poetry.lock`. Note the presence of an existing `venv/`, `.venv/`, or `env/` directory.

**Agent 2 — Node:** Find `package.json` files (note their locations for monorepo awareness). Check for `package-lock.json` (npm), `yarn.lock` (yarn), `pnpm-lock.yaml` (pnpm).

**Agent 3 — Other ecosystems:** Find `Gemfile` (Ruby), `go.mod` (Go), `Cargo.toml` (Rust), `composer.json` (PHP), `build.gradle` / `pom.xml` (JVM).

## Step 2: Install Dependencies

Run installs in parallel where independent. Sequential within the same ecosystem only if needed.

### Python

If no venv exists, create one:
```bash
python -m venv .venv
```

Then install using whichever manifest is present (in priority order):
```bash
# poetry
poetry install

# pipenv
pipenv install --dev

# pip with extras
.venv/bin/pip install -e ".[dev]"

# plain requirements files
.venv/bin/pip install -r requirements.txt
.venv/bin/pip install -r requirements-dev.txt   # if present
```

Note the activation path for the report: `.venv/bin/activate`.

### Node

Use the lockfile to pick the package manager, then install from the correct directory:
```bash
# npm
npm install

# yarn
yarn install

# pnpm
pnpm install
```

For monorepos with multiple `package.json` files, install from each directory that has one (unless a root-level workspace install covers them).

### Ruby
```bash
bundle install
```

### Go
```bash
go mod download
```

### Rust
```bash
cargo fetch
```

### JVM (Maven / Gradle)
```bash
# Maven
mvn dependency:resolve -q

# Gradle
./gradlew dependencies --quiet
```

## Step 3: Report

```
## Environment Ready

Installed:
  python  .venv created, pip install -r requirements.txt  (42 packages)
  nodejs  npm install  (317 packages)

To activate Python venv:
  source .venv/bin/activate

Nothing to do:
  [any ecosystem with no manifest found]

Warnings:
  [any install errors or skipped steps]
```

If any install fails, surface the error and stop — do not silently continue.
