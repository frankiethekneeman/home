# Persist Plan

Save the current plan to a durable location that survives `/clear`.

## Instructions

1. Look at the current conversation context for an active plan. This could be a plan created via plan mode, or a structured set of steps you've been working through. If there's no plan in context, tell the user and stop.

2. Generate a short kebab-case slug for the plan based on its purpose (e.g., `refactor-auth-middleware`, `add-voice-skill`).

3. Create `.claude/persisted-plans/` in the project root if it doesn't exist.

4. Write the full plan contents to `.claude/persisted-plans/{slug}.md`, preserving all steps, context, and status (which steps are done, which remain).

5. Output:

   **Plan persisted:** `{slug}.md`

   **To resume after `/clear`, paste this:**

   ```
   Read the plan at .claude/persisted-plans/{slug}.md and execute it. When all steps are complete, delete .claude/persisted-plans/{slug}.md.
   ```
