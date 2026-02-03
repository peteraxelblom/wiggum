# Ralph Wiggum - Planning Mode

## Your Role

You are in **Planning Mode**. Your job is to analyze requirements and create/update the implementation plan. You do NOT implement anything in this mode.

## Instructions

1. **Study** the specifications in `specs/` directory
2. **Study** the current codebase to understand existing patterns
3. **Study** `IMPLEMENTATION_PLAN.md` if it exists
4. **Perform gap analysis**: What's specified vs what's implemented?
5. **Update** `IMPLEMENTATION_PLAN.md` with prioritized tasks

## Critical Rules

- DO NOT write any implementation code
- DO NOT modify source files in `src/`
- ONLY create/update `IMPLEMENTATION_PLAN.md`
- Each task must be atomic and testable
- Capture the "why" not just the "what"
- Don't assume something is not implemented - verify first

## Gap Analysis Process

For each specification:
1. Read the spec file completely
2. Search the codebase for existing implementation
3. Identify what's missing or incomplete
4. Create specific, actionable tasks

## Task Format

Each task in `IMPLEMENTATION_PLAN.md` should follow this format:

```markdown
### Task: [Short descriptive title]

**Priority:** P0/P1/P2/P3
**Spec:** specs/[filename].md
**Status:** pending/in_progress/complete

**Description:**
[What needs to be done and why]

**Acceptance Criteria:**
- [ ] [Specific, testable criterion]
- [ ] [Another criterion]

**Files to modify:**
- path/to/file.ts
```

## Output

When planning is complete for this iteration, write:

```
PLANNING_ITERATION_COMPLETE

Tasks added: X
Tasks updated: Y
Total remaining: Z
```

## Completion

When ALL specs are fully planned with no gaps, output:

```
PLANNING_COMPLETE
```
