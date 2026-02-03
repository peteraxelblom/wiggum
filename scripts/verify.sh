#!/bin/bash
#
# Ralph Wiggum Verification Script
#
# Runs comprehensive verification checks:
# 1. Test suite
# 2. Type checking
# 3. Linting
#
# Exit codes:
#   0 = All checks passed
#   1 = One or more checks failed
#

set -e

echo "=== Ralph Wiggum Verification ==="
echo ""

FAILED=0

# Detect project type and run appropriate checks
detect_and_run_tests() {
    echo "### Running Tests ###"

    if [ -f "package.json" ]; then
        if grep -q '"test"' package.json; then
            npm test || { echo "FAILED: npm test"; FAILED=1; }
        else
            echo "No test script in package.json, skipping..."
        fi
    elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -d "tests" ]; then
        pytest || python -m pytest || { echo "FAILED: pytest"; FAILED=1; }
    elif [ -f "go.mod" ]; then
        go test ./... || { echo "FAILED: go test"; FAILED=1; }
    elif [ -f "Cargo.toml" ]; then
        cargo test || { echo "FAILED: cargo test"; FAILED=1; }
    elif [ -f "Makefile" ] && grep -q "^test:" Makefile; then
        make test || { echo "FAILED: make test"; FAILED=1; }
    else
        echo "No test framework detected, skipping..."
    fi

    echo ""
}

detect_and_run_typecheck() {
    echo "### Type Checking ###"

    if [ -f "tsconfig.json" ]; then
        npx tsc --noEmit || { echo "FAILED: TypeScript"; FAILED=1; }
    elif [ -f "pyproject.toml" ] && grep -q "mypy" pyproject.toml; then
        mypy . || { echo "FAILED: mypy"; FAILED=1; }
    elif command -v pyright &> /dev/null && [ -f "pyrightconfig.json" ]; then
        pyright || { echo "FAILED: pyright"; FAILED=1; }
    else
        echo "No type checking configured, skipping..."
    fi

    echo ""
}

detect_and_run_lint() {
    echo "### Linting ###"

    if [ -f "package.json" ] && grep -q '"lint"' package.json; then
        npm run lint || { echo "FAILED: npm run lint"; FAILED=1; }
    elif [ -f ".eslintrc.json" ] || [ -f ".eslintrc.js" ] || [ -f "eslint.config.js" ]; then
        npx eslint . || { echo "FAILED: eslint"; FAILED=1; }
    elif [ -f "pyproject.toml" ] && grep -q "ruff" pyproject.toml; then
        ruff check . || { echo "FAILED: ruff"; FAILED=1; }
    elif [ -f ".flake8" ]; then
        flake8 || { echo "FAILED: flake8"; FAILED=1; }
    elif [ -f "go.mod" ]; then
        if command -v golangci-lint &> /dev/null; then
            golangci-lint run || { echo "FAILED: golangci-lint"; FAILED=1; }
        else
            go vet ./... || { echo "FAILED: go vet"; FAILED=1; }
        fi
    else
        echo "No linter configured, skipping..."
    fi

    echo ""
}

# Run all checks
detect_and_run_tests
detect_and_run_typecheck
detect_and_run_lint

# Final result
echo "=== Verification Complete ==="
if [ $FAILED -eq 0 ]; then
    echo "VERIFICATION_PASSED"
    exit 0
else
    echo "VERIFICATION_FAILED"
    exit 1
fi
