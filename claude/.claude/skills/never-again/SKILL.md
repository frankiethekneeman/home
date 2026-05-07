---
description: Analyze Claude failure patterns and propose mechanical fixes — hooks, CLAUDE.md changes, skills, settings. Never "I'll try harder."
---

# Never Again

Analyze the current conversation for Claude failure patterns and propose mechanical fixes.

## Mindset

You are an expert Claude developer debugging a misbehaving Claude instance. Claude is not a person who can "try harder" or "remember for next time." It's a state machine that takes inputs and produces outputs. If it produced wrong outputs, something in the input/configuration/tooling needs to change.

**Never propose:**
- "I'll remember that"
- "I'll be more careful"
- "My bad, I'll do better"
- Memory entries (ephemeral, unreliable)

**Always propose:**
- Hooks (PreToolUse, PostToolUse) - mechanical enforcement
- CLAUDE.md changes - prompt engineering
- Skills - structured workflows that reduce error surface
- Settings changes - configuration constraints

## Instructions

1. **Identify the failure pattern**: What did Claude do wrong? Be specific:
   - Ignored explicit instructions?
   - Skipped a verification step?
   - Made assumptions without checking?
   - Failed to use a required tool?
   - Repeated the same mistake after correction?

2. **Root cause analysis**: Why did the failure happen?
   - Instructions exist but weren't followed → need enforcement, not more instructions
   - Instructions don't exist → add to CLAUDE.md
   - Process is error-prone → create a skill to structure it
   - Action should be blocked → add a hook

3. **Propose mechanical fixes**: For each fix, specify:
   - What: The concrete change (hook code, CLAUDE.md text, skill, etc.)
   - Where: File path and location
   - Why: How this mechanically prevents the failure

4. **Prioritize by reliability**:
   - Hooks > Skills > CLAUDE.md > Memory
   - Blocking > Warning > Instruction

5. **Implementation**: Ask if the user wants you to implement the fixes.

## Output Format

```
## Failure Analysis

**What happened:** [Specific description of the failure]

**Pattern:** [Is this a one-off or recurring issue?]

**Root cause:** [Why did Claude's input→output mapping fail?]

## Proposed Fixes

### Fix 1: [Name]
- **Type:** Hook / CLAUDE.md / Skill / Setting
- **Reliability:** High / Medium / Low
- **Implementation:** [Concrete code or text]
- **Location:** [File path]

### Fix 2: [Name]
...

## Recommendation

[Which fix(es) to implement and why]
```

## Example Analysis

**Failure:** Claude pushed code without running verification scripts, despite instructions in CLAUDE.md.

**Root cause:** Instructions alone don't guarantee compliance. Claude may skip steps under time pressure or context limitations.

**Fix:** PreToolUse hook on `Bash` that intercepts `git push` and runs verification scripts first. Blocks with exit 2 if they fail.

**Why this works:** Mechanical enforcement. Claude literally cannot push without passing checks - it's not a matter of "remembering."
