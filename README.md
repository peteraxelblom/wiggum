# Wiggum - Ralph Wiggum Plugin for Claude Code

A custom implementation of the Ralph Wiggum autonomous loop technique for Claude Code.

## What is Ralph Wiggum?

The Ralph Wiggum technique runs AI coding agents in persistent loops until specifications are met. Progress persists in files and git history, not in the LLM's context window. Each iteration starts fresh, picking up where the last left off.

> "The filesystem IS the state. Git IS the memory." — Geoffrey Huntley

## Installation

### Global Installation (Recommended)

Install wiggum globally to make it available in ALL projects:

```bash
./install.sh
```

This:
- Copies the plugin to `~/.claude/plugins/wiggum/`
- Adds Ralph integration instructions to `~/.claude/CLAUDE.md`
- Makes all `/ralph-*` skills available everywhere

To uninstall:
```bash
~/.claude/plugins/wiggum/install.sh --uninstall
```

### Per-Project (Manual)

Symlink into a specific project:

```bash
# In your project directory
ln -s ~/.claude/plugins/wiggum .claude/plugins/wiggum
```

## Quick Start

### Using Skills (Inside Claude Code)

```bash
# Evaluate if a task is suitable for Ralph
/ralph-evaluate Migrate all API endpoints from callbacks to async/await

# Create a complete Ralph-ready plan with specs
/ralph-plan Refactor authentication to use JWT tokens

# Start an autonomous loop
/ralph-start Build a REST API with user CRUD operations. Tests must pass.

# Check loop status
/ralph-status

# Stop the loop
/ralph-stop
```

### Using External Script (CI/CD, Headless)

```bash
# Run 50 iterations max
./scripts/loop.sh 50 PROMPT.md

# With custom completion signal
./scripts/loop.sh 30 specs/feature.md --completion-promise "FEATURE_DONE"
```

## Architecture

```
wiggum/
├── install.sh                   # Global installation script
├── .claude-plugin/plugin.json   # Plugin manifest
├── hooks/hooks.json             # Stop hook configuration
├── scripts/
│   ├── stop-hook.sh             # Core loop logic (blocks exit)
│   ├── verify.sh                # Verification script
│   └── loop.sh                  # External orchestration
├── skills/
│   ├── ralph-start.md           # /ralph-start - Start a loop
│   ├── ralph-stop.md            # /ralph-stop - Stop a loop
│   ├── ralph-status.md          # /ralph-status - Check status
│   ├── ralph-evaluate.md        # /ralph-evaluate - Assess suitability
│   └── ralph-plan.md            # /ralph-plan - Create full plan
├── agents/
│   └── verifier.md              # Verification subagent
├── templates/
│   ├── PROMPT_plan.md           # Planning mode template
│   ├── PROMPT_build.md          # Building mode template
│   └── IMPLEMENTATION_PLAN.md   # Task list template
├── CLAUDE.md                    # Expert instructions
└── RALPH_WIGGUM_RESEARCH.md     # Methodology reference
```

## Skills Reference

| Skill | Purpose | AI-Invocable |
|-------|---------|--------------|
| `/ralph-start` | Start an autonomous development loop | No (user only) |
| `/ralph-stop` | Stop a running loop | No (user only) |
| `/ralph-status` | Check current loop status | No (user only) |
| `/ralph-evaluate` | Evaluate if a task is Ralph-worthy | Yes (AI can suggest) |
| `/ralph-plan` | Create specs + implementation plan | No (user only) |

### `/ralph-evaluate`

Analyzes a task against Ralph suitability criteria:
- Clear completion criteria?
- Automatic verification possible?
- Mechanical/repetitive nature?
- Multi-step scope?

Returns `RALPH_SUITABLE` or `RALPH_NOT_SUITABLE` with reasoning.

### `/ralph-plan`

Creates a complete Ralph-ready setup:
1. Analyzes task requirements
2. Creates `specs/` directory with focused spec files
3. Generates `IMPLEMENTATION_PLAN.md`
4. Suggests loop configuration
5. Asks for approval
6. Invokes `/ralph-start` if approved

## How It Works

1. **Start Loop**: `/ralph-start` creates `.ralph/` directory with state files
2. **Work**: Claude works on the task, makes changes, commits
3. **Exit Attempt**: Claude tries to exit when it thinks it's done
4. **Stop Hook**: `stop-hook.sh` intercepts the exit and checks:
   - Is the completion promise in the output?
   - Have we hit max iterations?
5. **Continue or Exit**: If not complete, re-feed prompt and continue

## Loop State

The `.ralph/` directory contains:
- `active` - Flag indicating loop is running
- `prompt` - The task prompt
- `iteration` - Current iteration count
- `max_iterations` - Safety limit
- `completion_promise` - Signal that marks completion
- `complete` - Created when loop finishes

## Verification

The loop includes comprehensive verification:

1. **Test Suite**: npm test, pytest, go test, etc.
2. **Type Checking**: tsc, mypy, pyright
3. **Linting**: eslint, ruff, golangci-lint
4. **Subagent Review**: Code quality and security review

Run manually: `./scripts/verify.sh`

## Best Practices

### Good Tasks for Ralph
- Large refactors
- Dependency updates
- Test coverage generation
- Migrations
- Documentation generation

### Bad Tasks for Ralph
- Ambiguous requirements
- Architectural decisions
- Security-sensitive code
- Open-ended exploration

### Exit Criteria

Always provide clear, verifiable completion criteria:

❌ "Build a good API"
✅ "Build a REST API with CRUD operations. Tests must pass with >80% coverage."

### Safety

- **Always set max iterations** (default: 50)
- **Run in sandboxed environments** for production use
- **Review changes** before merging

## Templates

Copy templates to your project:

```bash
cp templates/PROMPT_plan.md ./PROMPT_plan.md
cp templates/PROMPT_build.md ./PROMPT_build.md
cp templates/IMPLEMENTATION_PLAN.md ./IMPLEMENTATION_PLAN.md
```

## References

- [Geoffrey Huntley's Ralph Wiggum Guide](https://ghuntley.com/ralph/)
- [How to Ralph Wiggum (GitHub)](https://github.com/ghuntley/how-to-ralph-wiggum)
- [Awesome Ralph (Resources)](https://github.com/snwfdhmp/awesome-ralph)
- See `RALPH_WIGGUM_RESEARCH.md` for comprehensive methodology

## License

MIT
