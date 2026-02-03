---
name: ralph-status
description: Check the status of the current Ralph Wiggum loop
disable-model-invocation: true
allowed-tools: Bash, Read
---

# /ralph-status - Check Loop Status

You are checking the status of an active Ralph Wiggum loop.

## Your Job

1. **Check if a loop is active** by looking for `.ralph/active`

2. **If no loop is active**, inform the user:
   - "No Ralph loop is currently active."
   - Suggest using `/ralph-start` to begin one

3. **If a loop is active**, report:
   - Current iteration number (from `.ralph/iteration`)
   - Maximum iterations allowed (from `.ralph/max_iterations`)
   - The task/prompt (from `.ralph/prompt`)
   - When the loop started (from `.ralph/started_at`)
   - Completion promise (from `.ralph/completion_promise`)

4. **Show recent progress** by running:
   - `git log --oneline -10` to show recent commits
   - `git diff --stat HEAD~5..HEAD` to show files changed

5. **Estimate progress** if possible:
   - Check if IMPLEMENTATION_PLAN.md exists
   - Count completed vs remaining tasks
   - Report percentage complete if calculable

## Output Format

```
## Ralph Loop Status

**Status:** Active / Inactive
**Iteration:** X / Y (Z% of max)
**Started:** [timestamp]
**Task:** [first line of prompt]
**Completion Promise:** [promise string]

### Recent Commits
[git log output]

### Files Changed (last 5 commits)
[git diff stat]

### Progress
[IMPLEMENTATION_PLAN.md task status if available]
```

Now check the loop status and report to the user.
