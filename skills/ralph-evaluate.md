---
name: ralph-evaluate
description: Evaluate if a task is suitable for a Ralph Wiggum autonomous loop
disable-model-invocation: false
allowed-tools: Read, Glob, Grep
---

# /ralph-evaluate - Evaluate Task for Ralph Suitability

You are evaluating whether a task is suitable for a Ralph Wiggum autonomous development loop.

## What is Ralph?

Ralph Wiggum is a technique for running AI coding agents in autonomous loops until specifications are met. The AI works iteratively, with state persisting in the filesystem and git history (not context windows).

## Your Job

Analyze the task in `$ARGUMENTS` against the criteria below and provide a clear recommendation.

## Evaluation Criteria

### SUITABLE for Ralph (Score: 3+ of these)

1. **Clear completion criteria** - There's an obvious "done" state
   - Example: "Add JWT authentication" (auth works = done)
   - Example: "Migrate from Moment.js to date-fns" (no Moment imports = done)

2. **Automatic verification possible** - Tests, builds, or lints can validate success
   - Tests exist or can be added
   - Type checking catches errors
   - Build/lint rules enforce correctness

3. **Mechanical/repetitive nature** - The work follows patterns
   - Updating many similar files
   - Applying consistent transformations
   - Adding boilerplate to multiple locations

4. **Multi-step scope** - Would take multiple iterations
   - Affects more than 3-5 files
   - Involves sequential transformations
   - Benefits from incremental commits

5. **Low ambiguity** - Requirements are clear and specific
   - Not "make it better" or "improve performance"
   - Concrete deliverables defined

### NOT SUITABLE for Ralph (Any of these)

1. **Ambiguous requirements** - "Clean up the code", "improve performance", "make it better"
2. **Architectural decisions** - Choosing between patterns, designing systems
3. **Security-sensitive** - Auth flows, encryption, access control
4. **Exploration/research** - "Figure out how X works", "investigate why Y happens"
5. **Quick fixes** - Single-file changes, typo fixes, one-liner bugs
6. **Human judgment needed** - UX decisions, naming conventions, style choices

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
- Clear completion: No .then() chains in API files
- Verifiable: TypeScript + tests catch errors
- Mechanical: Same transformation repeated
- Multi-file: Affects all endpoint files

### Example 2: NOT SUITABLE
Task: "Make the app feel more responsive"

Verdict: RALPH_NOT_SUITABLE
- Ambiguous: What is "responsive"?
- No clear completion criteria
- Requires human judgment on UX
- Better: Break into specific performance tasks first

### Example 3: BORDERLINE
Task: "Add error handling to the payment flow"

Verdict: RALPH_NOT_SUITABLE (borderline)
- Security-sensitive code
- Requires judgment on what errors to handle
- Better: Have human design error strategy, then Ralph can implement

Now evaluate the task provided in `$ARGUMENTS`.
