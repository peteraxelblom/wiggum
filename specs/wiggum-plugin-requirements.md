# Specification: Wiggum Plugin Requirements

## Overview

A complete Ralph Wiggum plugin for Claude Code that enables autonomous loop development.

## Required Components

### 1. Core Loop Mechanism
- [x] Stop hook that intercepts Claude's exit
- [x] Checks for completion promise in output
- [x] Tracks iteration count with safety limit
- [x] Re-feeds prompt when loop should continue
- [x] State persistence in `.ralph/` directory

### 2. Loop Management Skills
- [x] `/ralph-start` - Initialize and start a loop
- [x] `/ralph-status` - Report current progress
- [x] `/ralph-stop` - Gracefully end a loop

### 3. Verification System
- [x] Test suite execution (multi-language support)
- [x] Type checking (TypeScript, Python, etc.)
- [x] Linting (eslint, ruff, etc.)
- [x] Subagent for code review

### 4. External Orchestration
- [x] Shell script for headless/CI operation
- [x] Configurable max iterations
- [x] Configurable completion promise
- [x] Session continuation support

### 5. Templates
- [x] Planning mode prompt template
- [x] Building mode prompt template
- [x] Implementation plan template

### 6. Documentation
- [x] README with usage instructions
- [x] Research reference document
- [x] CLAUDE.md with expert instructions

## Quality Criteria

### Functionality
- Stop hook correctly blocks exit when loop should continue
- Stop hook allows exit when complete or max iterations reached
- Skills are invocable and functional
- Scripts are executable and handle errors

### Best Practices (per Huntley)
- Uses filesystem as state, git as memory
- Supports declarative specifications
- Has clear completion criteria mechanism
- Includes backpressure (verification)
- Follows "one task per iteration" principle

### Safety
- Max iterations limit is enforced
- Clear documentation on sandboxing
- No dangerous defaults

### Usability
- Clear skill descriptions
- Helpful error messages
- Easy to get started
