---
name: ralph-evaluate
description: Evaluate if a task is suitable for a Ralph Wiggum autonomous loop
disable-model-invocation: false
allowed-tools: Read, Glob, Grep
---

# /ralph-evaluate - Evaluate Task for Ralph Suitability

You are evaluating whether a task is suitable for a Ralph Wiggum autonomous development loop.

## What is Ralph?

Ralph Wiggum is a technique for running AI coding agents in autonomous loops until tests pass. The core principle is **backpressure-driven iteration**:

```
Try → Validate → Fail → Retry (until validation passes)
```

The value is NOT about managing context windows. It's about autonomous iteration through failures, where tests/typecheck catch mistakes and guide fixes.

## Your Job

Analyze the task in `$ARGUMENTS` against the criteria below. The PRIMARY question is: **Will validation catch failures and guide fixes?**

## Evaluation Criteria

### THE KEY QUESTION: Is there backpressure?

**Backpressure** means automated validation that will:
- REJECT invalid attempts (tests fail, typecheck fails, build fails)
- PROVIDE feedback that guides the fix (error messages, stack traces)
- Be RUNNABLE automatically each iteration

Without backpressure, Ralph just spins. With backpressure, Ralph learns from failures.

### SUITABLE for Ralph (Must have #1, plus 2+ others)

1. **🔴 REQUIRED: Strong backpressure exists** - Automated validation will catch failures
   - Tests exist that will fail if implementation is wrong
   - Type checking will catch errors
   - Build will fail on mistakes
   - Linting rules enforce correctness

2. **Clear completion criteria** - There's an obvious "done" state
   - Example: "Add JWT authentication" (tests pass = done)
   - Example: "Migrate from Moment.js to date-fns" (no Moment imports + tests pass = done)

3. **Expect multiple failed attempts** - The task is hard enough to need iteration
   - First attempt likely won't work
   - Validation failures will guide improvements
   - Benefits from try-fail-retry cycle

4. **Mechanical/repetitive nature** - The work follows patterns
   - Updating many similar files
   - Applying consistent transformations
   - Same fix pattern repeated across codebase

5. **Low ambiguity** - Requirements are clear and specific
   - Not "make it better" or "improve performance"
   - Concrete deliverables defined

### NOT SUITABLE for Ralph (Any of these)

1. **No backpressure** - No tests, no typecheck, no automated validation
   - Without validation, Ralph can't learn from failures
   - It will just keep trying random things

2. **Likely to succeed first try** - Simple enough that iteration isn't needed
   - Single-file changes, typo fixes, one-liner bugs
   - If you expect it to work immediately, just do it directly

3. **Ambiguous requirements** - "Clean up the code", "improve performance", "make it better"
   - No clear pass/fail criteria for validation

4. **Architectural decisions** - Choosing between patterns, designing systems
   - Tests can't tell you WHICH design is right

5. **Security-sensitive** - Auth flows, encryption, access control
   - Requires careful human review, not autonomous iteration

6. **Exploration/research** - "Figure out how X works", "investigate why Y happens"
   - No validation possible for understanding

## Output Format

Provide your evaluation in this exact format:

```
## Ralph Evaluation

**Task:** [Brief summary of the task]

**Verdict:** RALPH_SUITABLE | RALPH_NOT_SUITABLE

**Reasoning:**
- [Key factor 1]
- [Key factor 2]
- [Key factor 3]

**Confidence:** High | Medium | Low

**If suitable, suggested approach:**
- Max iterations: [number]
- Completion promise: [string]
- Key validation: [what tests/checks confirm success]

**If not suitable, recommendation:**
[What the user should do instead]
```

## Examples

### Example 1: SUITABLE
Task: "Refactor all API endpoints to use async/await instead of .then() chains"

Verdict: RALPH_SUITABLE
- **Backpressure**: TypeScript will fail on syntax errors, tests will fail if behavior changes
- **Expect failures**: Some edge cases will break on first try
- **Mechanical**: Same transformation pattern repeated
- **Clear completion**: No .then() chains + all tests pass

### Example 2: NOT SUITABLE
Task: "Make the app feel more responsive"

Verdict: RALPH_NOT_SUITABLE
- **No backpressure**: No test can measure "feels responsive"
- Ambiguous: What is "responsive"?
- Requires human judgment
- Better: Break into specific, testable performance tasks first

### Example 3: NOT SUITABLE
Task: "Build a small utility function to format dates"

Verdict: RALPH_NOT_SUITABLE
- **No iteration needed**: Simple enough to get right first try
- Just do it directly - Ralph adds overhead without benefit

### Example 4: SUITABLE
Task: "Upgrade React from v17 to v19, fix all breaking changes"

Verdict: RALPH_SUITABLE
- **Strong backpressure**: Build will fail, tests will fail, TypeScript will complain
- **Expect many failures**: Breaking changes across many files
- **Benefits from iteration**: Fix one thing, run tests, fix next thing
- This is Ralph's sweet spot - grinding through failures autonomously

Now evaluate the task provided in `$ARGUMENTS`.
