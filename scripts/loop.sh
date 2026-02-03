#!/bin/bash
#
# Ralph Wiggum External Loop Script
#
# Runs Claude Code in a loop for autonomous development.
# Use this for CI/CD, cron jobs, or headless operation.
#
# Usage:
#   ./loop.sh [max_iterations] [prompt_file] [options]
#
# Examples:
#   ./loop.sh 50 PROMPT.md
#   ./loop.sh 20 specs/feature.md --completion-promise "FEATURE_DONE"
#

set -e

# Configuration
MAX_ITERATIONS=${1:-50}
PROMPT_FILE=${2:-PROMPT.md}
COMPLETION_PROMISE=${3:-RALPH_COMPLETE}
RALPH_DIR=".ralph"

# Parse additional options
shift 2 2>/dev/null || true
while [[ $# -gt 0 ]]; do
    case $1 in
        --completion-promise)
            COMPLETION_PROMISE="$2"
            shift 2
            ;;
        --tools)
            ALLOWED_TOOLS="$2"
            shift 2
            ;;
        --max-turns)
            MAX_TURNS="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Defaults
ALLOWED_TOOLS=${ALLOWED_TOOLS:-"Bash,Edit,Read,Write,Glob,Grep"}
MAX_TURNS=${MAX_TURNS:-30}

echo "=== Ralph Wiggum External Loop ==="
echo "Max iterations: $MAX_ITERATIONS"
echo "Prompt file: $PROMPT_FILE"
echo "Completion promise: $COMPLETION_PROMISE"
echo "Allowed tools: $ALLOWED_TOOLS"
echo ""

# Validate prompt file exists
if [ ! -f "$PROMPT_FILE" ]; then
    echo "ERROR: Prompt file not found: $PROMPT_FILE"
    exit 1
fi

# Initialize state
mkdir -p "$RALPH_DIR"
echo "true" > "$RALPH_DIR/active"
echo "0" > "$RALPH_DIR/iteration"
echo "$MAX_ITERATIONS" > "$RALPH_DIR/max_iterations"
echo "$COMPLETION_PROMISE" > "$RALPH_DIR/completion_promise"
cp "$PROMPT_FILE" "$RALPH_DIR/prompt"
date -u +"%Y-%m-%dT%H:%M:%SZ" > "$RALPH_DIR/started_at"

# Main loop
for i in $(seq 1 $MAX_ITERATIONS); do
    echo ""
    echo "=========================================="
    echo "=== Iteration $i / $MAX_ITERATIONS ==="
    echo "=========================================="
    echo ""

    # Update iteration counter
    echo "$i" > "$RALPH_DIR/iteration"

    # Run Claude with the prompt
    OUTPUT=$(claude -p "$(cat $PROMPT_FILE)" \
        --allowedTools "$ALLOWED_TOOLS" \
        --max-turns $MAX_TURNS \
        --continue \
        2>&1) || true

    echo "$OUTPUT"

    # Check for completion promise
    if echo "$OUTPUT" | grep -q "$COMPLETION_PROMISE"; then
        echo ""
        echo "=== Completion Promise Detected ==="
        echo "Loop completed successfully after $i iterations!"
        touch "$RALPH_DIR/complete"
        break
    fi

    # Check if explicitly marked complete
    if [ -f "$RALPH_DIR/complete" ]; then
        echo ""
        echo "=== Loop Marked Complete ==="
        echo "Exiting after $i iterations."
        break
    fi

    # Brief pause between iterations
    sleep 2
done

# Final summary
echo ""
echo "=== Ralph Loop Summary ==="
echo "Total iterations: $(cat $RALPH_DIR/iteration)"
echo "Started: $(cat $RALPH_DIR/started_at)"
echo "Ended: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
echo ""

# Show recent git activity
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Recent commits:"
    git log --oneline -10 2>/dev/null || echo "(no commits)"
fi
