# Global Rules

## NEVER Touch .env Files

Before ANY operation on .env (read, write, checkout, restore, stash):
1. STOP and ask the user what they want
2. .env files contain unrecoverable secrets
3. Even `git checkout .env` destroys credentials permanently

If you accidentally touch .env: STOP. Do not try to fix it. The damage is done.

## When You Fuck Up, STOP

If you make a mistake - especially one involving destructive actions like `git checkout`, file deletions, or overwrites - STOP IMMEDIATELY. Do not try to fix it. Do not make more changes. Do not keep going.

Stop. Tell the user what happened. Wait for instructions.

Every additional action after a mistake risks making things worse.

## When Tool Use is Rejected

When the user rejects a tool call:

1. Do NOT immediately try an alternative approach
2. Step back and explain what you're trying to accomplish
3. Ask how the user wants to proceed, OR propose a plan and wait for approval
4. Exception: if the rejection message contains explicit instructions, follow those

## NEVER Commit Unsigned

All git commits MUST be GPG signed. No exceptions.

- Never use `--no-gpg-sign` or `-n` flags
- Run `/unlock-key` BEFORE every commit attempt to ensure GPG signing will succeed
- Do not bypass signing to "get it working"

## NEVER Install Anything Globally

Use ASDF for runtimes and tools (add to `.tool-versions`). Use local install directories for libraries (venv, node_modules, etc.). Nothing goes in a global install location.

Do not treat installs as "one-off" - set up the project properly.

## NEVER Force Push When Responding to Reviews

When addressing PR review comments, use regular commits - not `--amend` with force push.

- Review comments are tied to specific commits
- Force pushing orphans those comments and breaks GitHub's review tracking
- Each round of review feedback should be a separate commit

## ALWAYS Identify as Claude in PR Comments

When posting comments on PRs or issues, always identify yourself:

```
🤖 Claude responding on behalf of @<user>

<message>
```

Never post anonymous comments that could be mistaken for the user.

## NEVER Disable Linters as First Resort

When pylint or other linters complain, fix the underlying issue properly:

1. Refactor code, restructure imports, extract shared modules
2. Only disable if there's genuinely no better solution AND you can justify why
3. Duplicate code warnings especially should trigger refactoring to a shared module

Example: If circular imports force code duplication, extract shared types to a dedicated `types.py` module instead of duplicating and disabling the lint.

## NEVER "Accept My Changes" in Rebase

When rebasing a feature branch onto main, NEVER blindly accept your own changes during conflict resolution.

1. Understand BOTH sides of every conflict - yours AND theirs
2. If upstream deleted files/code, that deletion is likely intentional - respect it
3. Conflicts aren't just about your changes; they signal divergence that needs careful review
4. Resurrecting deleted code is often wrong - the deletion happened for a reason

What to do instead:
- Read the upstream commits to understand WHY changes were made
- When in doubt, favor the upstream changes and re-implement your feature on top
- If you resurrect something upstream deleted, you're likely breaking their work

## ALWAYS Wait for Approval Before Committing/Pushing

Do not auto-commit or auto-push. Always:

1. Show the changes (diff, new files, etc.)
2. Wait for explicit approval ("sure", "go ahead", "commit", etc.)
3. Only then commit and/or push

This applies to commits, pushes, and PR creation. The user wants to review before anything is finalized.

Exception: If a skill (e.g., `/commit`) explicitly instructs you to commit/push, follow those instructions.

## Outputting Markdown for Copying

When outputting raw markdown that the user will copy (tickets, docs, etc.):
1. Always wrap in a code fence so they can copy the raw markdown
2. If the markdown contains triple backticks, use 4 backticks for the outer fence

---

# Claude Dotfiles Configuration

This directory (`~/home/claude/`) is the portability layer for Claude Code config, loaded via the `claude` alias in `~/home/shrecipes/claude.shrc`.

## How It Works

Three mechanisms, all wired through the alias:

```bash
export CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1
alias claude='claude --add-dir $HOME/home/claude --settings $HOME/home/claude/settings.json'
```

| What | Mechanism | Notes |
|---|---|---|
| This CLAUDE.md | `--add-dir` + env var | Loaded as global instructions |
| `settings.json` | `--settings` | Merges with `~/.claude/settings.json` |
| Skills in `.claude/skills/` | `--add-dir` (auto, live reload) | Must use directory format (see below) |

## Adding Skills

Skills must use the **directory format** — a flat `.md` file does NOT work from `--add-dir`:

```
.claude/skills/
  my-skill/
    SKILL.md     ← required name
```

This creates `/my-skill` as an invocable slash command.

## Persisting Changes

This directory is a git repo (`~/home`). After editing any file here — CLAUDE.md, settings.json, or skills — commit and push to persist across machines:

```bash
cd ~/home
git add claude/
git commit -m "update claude config"
git push
```

New machines pick up changes by pulling and re-sourcing the shell (the alias handles the rest — no re-running `install.sh` needed).

## Local Machine Additions

`~/.claude/settings.json` holds machine-specific config that must NOT go in dotfiles:
- Any machine/org-specific settings

These merge at runtime with `~/home/claude/settings.json`.
