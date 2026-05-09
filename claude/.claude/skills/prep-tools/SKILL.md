---
description: Examine a repo, discover required runtimes and tools, install ASDF plugins and versions, and create/update .tool-versions files so the local environment is ready to work.
---

# Prep Tools

Prepare the local environment by discovering required tool versions and ensuring ASDF has them installed.

## Step 1: Launch Parallel Discovery Agents

Spawn all four simultaneously:

**Agent 1 — ASDF and language manifests:** Find all `.tool-versions` files (full tree walk). Read `package.json` (engines), `.nvmrc`, `.node-version`, `pyproject.toml`, `.python-version`, `runtime.txt`, `Pipfile`, `go.mod`, `Gemfile`, `.ruby-version`, `Cargo.toml`, `pom.xml`, `build.gradle`, `*.tf`. Return: tool → version signals with source.

**Agent 2 — CI config:** Read `.github/workflows/*.yml`, `.travis.yml`, `.circleci/config.yml`, `Jenkinsfile`, `.gitlab-ci.yml`. Extract any explicit version pins (`python-version`, `node-version`, `go-version`, `java-version`, etc.). Return: tool → version signals with source.

**Agent 3 — Container hints:** Read all `Dockerfile`s. Extract `FROM` statements. Return: tool → version signals with source.

**Agent 4 — Installed ASDF plugins:** Run `asdf plugin list`. Return the list of already-installed plugins.

## Step 2: Reconcile

Wait for all agents. Merge signals by tool. If sources agree, proceed. If they disagree, surface the discrepancy and ask before continuing:

```
DISCREPANCY: Node.js
  .nvmrc:               18.12.0
  .github/workflows:    20.x
  package.json engines: >=16

Proceeding with .nvmrc (most explicit) — confirm or choose a version.
```

If no version can be determined, use latest stable and flag it:

```
GUESSED: Python → 3.13.x (latest stable) — no version pinned in repo
```

## Step 3: Install Plugins and Versions in Parallel

For each required tool not yet in `asdf plugin list`, find the best match from the registry:

```bash
asdf plugin list all | grep -i <tool>
```

Prefer the most specific/official name. Then spawn one background agent per tool to install plugin + version simultaneously:

```bash
asdf plugin add <tool>
asdf install <tool> <version>
```

If version is a range or partial, resolve it first:

```bash
asdf list all <tool> | grep <major> | tail -1
```

## Step 4: Write .tool-versions

Wait for all install agents. Then:

- Monorepo with per-directory `.tool-versions`: update each in place
- Single root `.tool-versions`: write or update it
- No `.tool-versions` anywhere: create one at root

Format:
```
python 3.12.3
nodejs 20.11.0
```

## Step 4b: Post-install Node.js Wiring

If you ran `asdf install nodejs` during this skill run, run after all installs complete, using the version you just installed:

```bash
ASDF_NODEJS_VERSION=<version> corepack enable
asdf reshim nodejs
```

This installs yarn/pnpm shims into the ASDF shims directory. Without it, `yarn` won't be in PATH even though Node is installed. The env var on `corepack enable` ensures it writes into the correct Node install's bin directory regardless of where `.tool-versions` lives.

## Step 5: Report

```
## Environment Ready

Installed:
  python  3.12.3   (from pyproject.toml)
  nodejs  20.11.0  (from .nvmrc)

Guessed (no pin found):
  terraform  1.7.4  ← verify this is correct

Discrepancies resolved:
  [any that required user input]

.tool-versions written: /path/to/.tool-versions
```
