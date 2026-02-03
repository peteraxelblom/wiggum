---
name: ralph-start
description: Start a Ralph Wiggum autonomous loop for a task
disable-model-invocation: true
allowed-tools: Bash, Read, Write
---

# /ralph-start - Start an Autonomous Loop

You are starting a Ralph Wiggum autonomous development loop. This will run Claude in a persistent loop until the task is complete or max iterations are reached.

## Arguments

The user will provide:
- **Task description**: What needs to be accomplished
- **Completion promise** (optional): A string that signals completion (default: "RALPH_COMPLETE")
- **Max iterations** (optional): Safety limit (default: 50)

## Your Job

1. **Parse the arguments** from `$ARGUMENTS`
2. **Create the `.ralph/` directory** with state files:
   ```
   .ralph/
   ├── active          # Empty file indicating loop is active
   ├── prompt          # The task prompt to re-feed each iteration
   ├── iteration       # Current iteration count (starts at 0)
   ├── max_iterations  # Maximum iterations allowed
   ├── completion_promise  # String that signals completion
   └── started_at      # Timestamp when loop started
   ```

3. **Write the prompt file** with clear instructions including:
   - The task description
   - Instructions to output the completion promise when done
   - Reminder to commit work and run tests

4. **Inform the user** that the loop is starting

## Prompt Template

Write this to `.ralph/prompt`:

```
## Ralph Wiggum Loop - Autonomous Task

### Task
[USER'S TASK DESCRIPTION]

### Instructions
1. Study the current state of the codebase and .ralph/ directory
2. Check IMPLEMENTATION_PLAN.md if it exists for remaining tasks
3. Work on the next logical step toward completing the task
4. Run tests and verification after making changes
5. Commit your changes with a descriptive message
6. If all tasks are complete and tests pass, output: [COMPLETION_PROMISE]

### Completion Signal
When the task is fully complete (all requirements met, tests passing), output exactly:
[COMPLETION_PROMISE]

### Current State
- Iteration: Check .ralph/iteration
- Study git log for previous work
- Read modified files to understand progress
```

## Example Usage

```
/ralph-start Build a REST API with CRUD operations for users. Tests must pass. --max-iterations 30 --completion-promise "API_COMPLETE"
```

Now parse the user's input and initialize the loop.
