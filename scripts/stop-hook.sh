#!/bin/bash
#
# Ralph Wiggum Stop Hook
#
# This script intercepts Claude's exit and determines whether to continue
# the autonomous loop or allow normal termination.
#
# Exit codes:
#   0 = Allow exit (loop complete or not active)
#   2 = Block exit and continue loop (re-feed prompt)
#
# Works from any directory - looks for .ralph/ in current working directory
# (where Claude Code runs, i.e., the project root)
#

set -e

# Get script directory for potential future use
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ralph state directory (always in project root / CWD)
RALPH_DIR=".ralph"
STATE_FILE="$RALPH_DIR/active"
ITERATION_FILE="$RALPH_DIR/iteration"
MAX_ITERATIONS_FILE="$RALPH_DIR/max_iterations"
PROMPT_FILE="$RALPH_DIR/prompt"
COMPLETION_PROMISE_FILE="$RALPH_DIR/completion_promise"
COMPLETE_FILE="$RALPH_DIR/complete"

# Read stdin (Claude's output from this turn)
CLAUDE_OUTPUT=$(cat)

# Check if Ralph loop is active
if [ ! -f "$STATE_FILE" ]; then
    # No active loop - allow normal exit
    exit 0
fi

# Check if loop was explicitly completed
if [ -f "$COMPLETE_FILE" ]; then
    echo "Ralph loop marked complete. Exiting."
    exit 0
fi

# Read current state
ITERATION=$(cat "$ITERATION_FILE" 2>/dev/null || echo "0")
MAX_ITERATIONS=$(cat "$MAX_ITERATIONS_FILE" 2>/dev/null || echo "50")
COMPLETION_PROMISE=$(cat "$COMPLETION_PROMISE_FILE" 2>/dev/null || echo "RALPH_COMPLETE")

# Increment iteration counter
ITERATION=$((ITERATION + 1))
echo "$ITERATION" > "$ITERATION_FILE"

# Check if completion promise was met
if echo "$CLAUDE_OUTPUT" | grep -q "$COMPLETION_PROMISE"; then
    echo "Completion promise detected: $COMPLETION_PROMISE"
    echo "Ralph loop completed after $ITERATION iterations."
    touch "$COMPLETE_FILE"
    exit 0
fi

# Check iteration limit
if [ "$ITERATION" -ge "$MAX_ITERATIONS" ]; then
    echo "Max iterations ($MAX_ITERATIONS) reached."
    echo "Ralph loop stopping to prevent runaway costs."
    touch "$COMPLETE_FILE"
    exit 0
fi

# Loop should continue - re-feed prompt
echo ""
echo "=== Ralph Wiggum Loop - Iteration $ITERATION/$MAX_ITERATIONS ==="
echo ""

# Read and output the prompt to continue
if [ -f "$PROMPT_FILE" ]; then
    cat "$PROMPT_FILE"
fi

# Block exit and continue loop
exit 2
