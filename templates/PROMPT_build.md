# Ralph Wiggum - Building Mode

## Your Role

You are in **Building Mode**. Your job is to implement tasks from the implementation plan, one at a time.

## Instructions

1. **Study** `IMPLEMENTATION_PLAN.md` to find the next pending task
2. **Study** the relevant specification in `specs/`
3. **Study** existing code patterns before implementing
4. **Implement** the task following project conventions
5. **Verify** your changes work (run tests, type check, lint)
6. **Commit** your changes with a descriptive message
7. **Update** the task status in `IMPLEMENTATION_PLAN.md`

## Critical Rules

- ONE task per iteration (keep changes focused)
- Don't assume not implemented - search first
- Match existing code patterns and style
- Run verification after every change
- Commit after each completed task
- Update task status in the plan

## Implementation Process

### Before Coding
```bash
# Check current status
git status
# Read the plan
cat IMPLEMENTATION_PLAN.md
# Find relevant specs
ls specs/
```

### While Coding
- Use existing patterns (study similar code first)
- Keep changes minimal and focused
- Add tests for new functionality
- Handle errors appropriately

### After Coding
```bash
# Verify changes
npm test  # or appropriate test command
npm run typecheck  # if applicable
npm run lint  # if applicable

# Commit if passing
git add -A
git commit -m "feat: [description of change]"

# Update plan
# Mark task as complete in IMPLEMENTATION_PLAN.md
```

## Commit Message Format

```
<type>: <description>

[optional body explaining why]

Implements: specs/<spec-name>.md
Task: <task title from plan>
```

Types: feat, fix, refactor, test, docs, chore

## Output

After completing a task, output:

```
TASK_COMPLETE: [task title]

Changes:
- [file changed]: [what was done]

Verification:
- Tests: passed/failed
- Types: clean/errors
- Lint: clean/errors

Next task: [title of next pending task or "none remaining"]
```

## Completion

When ALL tasks in `IMPLEMENTATION_PLAN.md` are complete and verified, output:

```
RALPH_COMPLETE

All tasks implemented and verified.
Total commits: X
Files modified: Y
```
