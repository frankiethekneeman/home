---
description: "Four-agent documentation review system (Tanya, Lillian, Herb, Carla) for iteratively improving documentation through tension between completeness and conciseness. Use on any repository."
---

# THC: Documentation Review

A four-agent system for iteratively improving documentation through tension between completeness and conciseness.

## Usage

```bash
/thc --tasks="Add org, Add repo, Refactor code"
# OR
/thc  # reads tasks from .claude/carlas-tasks.txt
```

## Parameters

- `--tasks` (optional): Comma-separated list of tasks Carla should attempt
- `--max-iterations` (optional): Maximum cycles per task (default: 5)

If `--tasks` is not provided, reads from `.claude/carlas-tasks.txt` (one task per line).

## Before Starting

Look for a `DOCUMENTATION.md` file (check root, `docs/`, and common locations). If found, read it first — it defines the repo's documentation standards. Repo-specific standards take precedence over defaults in this skill.

## The Four Agents

Each agent has a detailed subagent prompt in `references/`. Read the appropriate file before launching each agent.

| Agent | Role | Prompt |
|-------|------|--------|
| **Tanya** | Aggressively trims documentation | `references/tanya-subagent.md` |
| **Lillian** | Moves docs into code where they belong | `references/lillian-subagent.md` |
| **Herb** | Adds what's needed for clarity | `references/herb-subagent.md` |
| **Carla** | Validates with zero memory | `references/carla-subagent.md` |

## The Cycle

```
1. Tanya aggressively trims documentation
2. Lillian scans ALL docs for file-specific content and colocates it
3. Carla attempts a task (NO context, fresh start)
4. If Carla struggles:
   a. Herb adds fixes based on feedback
   b. Tanya reviews and trims Herb's additions
   c. Lillian moves file-specific additions into code
5. Carla's code changes reset (docs + Lillian's docstrings persist), Carla tries again
6. Repeat until Carla says "That was easy"
```

Read `references/implementation.md` for details on code reset behavior and file organization rules.

## Tension Creates Quality

- **Herb ensures clarity** — adds what's needed
- **Tanya ensures brevity** — removes what's not
- **Lillian ensures colocation** — docs live with code
- **Carla validates** — fresh perspective every time
- **Result** — minimal docs that actually work, right where you need them

## Example Session

```
Task: "Set up the development environment"

Iteration 1:
  Carla: "README says 'install dependencies' but doesn't say how"
  Herb: Adds "Run: npm install" to README
  Tanya: Approves (3 words, minimal addition)
  Lillian: Leaves it (cross-cutting setup instruction)

Iteration 2:
  Carla: "That was easy!"
  → Move to next task

Task: "Understand how validation works"

Iteration 1:
  Carla: "docs/validation.md explains validator.py but I had to find it"
  Herb: Adds link from README
  Tanya: Approves link
  Lillian: Moves content into validator file's doc comments, deletes docs/validation.md

Iteration 2:
  Carla: "Found it in the code itself - that was easy!"
  → Move to next task
```

## Success Criteria

Task is "done" when:
- Carla says "That was easy!" OR
- Carla completes task without giving up OR
- Maximum iterations reached (report as "needs work")

## Output Report

```
=== THC Documentation Review ===

Task 1: Add an organization
  Iteration 1: Carla gave up (missing step)
  Iteration 2: Carla succeeded
  Status: Done

Task 2: Add a repository
  Iteration 1: Carla succeeded
  Status: Done

Task 3: Refactor Python
  Iteration 1-5: Carla gave up
  Status: Needs work

=== Metrics ===
Total line reduction: 154 lines (-35%)
README.md: 137 lines (under 200)
Tasks successful: 2/3 (67%)
Average iterations: 1.67

=== File Organization ===
Root docs: README.md, CHANGELOG.md
Other docs organized: Yes
Longest doc: 89 lines (under 5 min)
```

## Good Task Definitions

**Clear, specific tasks:**
- "Set up development environment and run tests"
- "Add a new feature to the application"
- "Deploy the application to staging"
- "Debug a failing test"
- "Update dependency versions"

**Poor task definitions:**
- "Make it better" (too vague)
- "Fix all the things" (too broad)
- "Read the code" (not actionable)

## Notes

- Carla's memory wipe between attempts is crucial for validity
- Tanya reviews EVERY Herb addition (no exceptions)
- Lillian reviews EVERY addition for colocation opportunities
- Code resets only affect Carla's changes; Lillian's doc comments persist
