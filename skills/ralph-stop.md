---
name: ralph-stop
description: Stop the current Ralph Wiggum loop and mark it complete
disable-model-invocation: true
allowed-tools: Bash, Read, Write
---

# /ralph-stop - Stop the Loop

You are stopping an active Ralph Wiggum loop.

## Arguments (optional)

- **--force**: Stop even if task appears incomplete
- **--cleanup**: Remove .ralph/ directory after stopping

## Your Job

1. **Check if a loop is active** by looking for `.ralph/active`

2. **If no loop is active**, inform the user:
   - "No Ralph loop is currently active. Nothing to stop."

3. **If a loop is active**:
   - Read the current state (iteration, prompt, etc.)
   - Create `.ralph/complete` file to signal stop
   - Report final statistics

4. **Generate summary report**:
   - Total iterations completed
   - Duration (started_at to now)
   - List of commits made during the loop
   - Files modified

5. **Optionally cleanup** if `--cleanup` flag:
   - Remove the `.ralph/` directory
   - Keep a log in `.ralph-history/` for reference

## Output Format

```
## Ralph Loop Stopped

**Final Iteration:** X / Y
**Duration:** [time elapsed]
**Status:** Stopped by user / Completed / Max iterations reached

### Work Completed
[git log of commits during loop]

### Files Modified
[list of changed files]

### Next Steps
- Review the changes with `git diff [start-commit]..HEAD`
- Run tests to verify: `npm test` or appropriate command
- Use `/ralph-start` to begin a new loop if needed
```

Now stop the loop and report to the user.
