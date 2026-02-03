#!/bin/bash
#
# Integration Test for Ralph Wiggum Plugin
#
# Tests that the stop hook correctly:
# 1. Detects when no loop is active (allows exit)
# 2. Increments iteration counter
# 3. Detects completion promise
# 4. Respects max iterations
#

# Note: Not using set -e to ensure all tests run and report

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEST_DIR="/tmp/wiggum-test-$$"
PASSED=0
FAILED=0

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

setup() {
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    cp "$SCRIPT_DIR/stop-hook.sh" ./stop-hook.sh
    chmod +x ./stop-hook.sh
}

teardown() {
    rm -rf "$TEST_DIR"
}

pass() {
    echo -e "${GREEN}✓ PASS${NC}: $1"
    ((PASSED++))
}

fail() {
    echo -e "${RED}✗ FAIL${NC}: $1"
    ((FAILED++))
}

# Test 1: No active loop should allow exit (exit 0)
test_no_active_loop() {
    echo "Test 1: No active loop"
    rm -rf .ralph

    EXIT_CODE=0
    echo "test output" | ./stop-hook.sh || EXIT_CODE=$?

    if [ $EXIT_CODE -eq 0 ]; then
        pass "No active loop allows exit"
    else
        fail "Expected exit 0, got $EXIT_CODE"
    fi
}

# Test 2: Active loop should increment iteration and block exit (exit 2)
test_active_loop_continues() {
    echo "Test 2: Active loop continues"
    mkdir -p .ralph
    touch .ralph/active
    echo "0" > .ralph/iteration
    echo "50" > .ralph/max_iterations
    echo "DONE" > .ralph/completion_promise
    echo "Continue working" > .ralph/prompt

    EXIT_CODE=0
    echo "still working..." | ./stop-hook.sh > /dev/null || EXIT_CODE=$?

    if [ $EXIT_CODE -eq 2 ]; then
        ITER=$(cat .ralph/iteration)
        if [ "$ITER" -eq 1 ]; then
            pass "Loop continues and increments iteration"
        else
            fail "Iteration should be 1, got $ITER"
        fi
    else
        fail "Expected exit 2 (continue), got $EXIT_CODE"
    fi
}

# Test 3: Completion promise should allow exit
test_completion_promise() {
    echo "Test 3: Completion promise exits"
    mkdir -p .ralph
    touch .ralph/active
    echo "0" > .ralph/iteration
    echo "50" > .ralph/max_iterations
    echo "TASK_DONE" > .ralph/completion_promise
    echo "prompt" > .ralph/prompt

    EXIT_CODE=0
    echo "All done! TASK_DONE" | ./stop-hook.sh > /dev/null || EXIT_CODE=$?

    if [ $EXIT_CODE -eq 0 ]; then
        if [ -f .ralph/complete ]; then
            pass "Completion promise triggers exit"
        else
            fail "Complete file not created"
        fi
    else
        fail "Expected exit 0, got $EXIT_CODE"
    fi
}

# Test 4: Max iterations should stop loop
test_max_iterations() {
    echo "Test 4: Max iterations stops loop"
    mkdir -p .ralph
    touch .ralph/active
    echo "49" > .ralph/iteration  # Will become 50 after increment
    echo "50" > .ralph/max_iterations
    echo "NEVER_MATCH" > .ralph/completion_promise
    echo "prompt" > .ralph/prompt
    rm -f .ralph/complete

    EXIT_CODE=0
    echo "still going..." | ./stop-hook.sh > /dev/null || EXIT_CODE=$?

    if [ $EXIT_CODE -eq 0 ]; then
        if [ -f .ralph/complete ]; then
            pass "Max iterations stops loop"
        else
            fail "Complete file not created at max iterations"
        fi
    else
        fail "Expected exit 0 at max iterations, got $EXIT_CODE"
    fi
}

# Test 5: Explicit complete file should exit
test_explicit_complete() {
    echo "Test 5: Explicit complete file"
    mkdir -p .ralph
    touch .ralph/active
    touch .ralph/complete
    echo "0" > .ralph/iteration

    EXIT_CODE=0
    echo "ignored" | ./stop-hook.sh > /dev/null || EXIT_CODE=$?

    if [ $EXIT_CODE -eq 0 ]; then
        pass "Explicit complete file triggers exit"
    else
        fail "Expected exit 0, got $EXIT_CODE"
    fi
}

# Run tests
echo ""
echo "=== Ralph Wiggum Integration Tests ==="
echo ""

setup

test_no_active_loop
test_active_loop_continues
test_completion_promise
test_max_iterations
test_explicit_complete

teardown

# Summary
echo ""
echo "=== Results ==="
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}ALL TESTS PASSED${NC}"
    exit 0
else
    echo -e "${RED}SOME TESTS FAILED${NC}"
    exit 1
fi
