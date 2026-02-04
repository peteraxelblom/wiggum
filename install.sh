#!/bin/bash
#
# Wiggum Global Installation Script
#
# Installs the wiggum plugin to ~/.claude/plugins/wiggum
# making Ralph Wiggum skills available in ALL projects.
#
# Usage:
#   ./install.sh           # Install or update
#   ./install.sh --uninstall  # Remove installation
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$HOME/.claude/plugins/wiggum"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[-]${NC} $1"
}

uninstall() {
    echo "Uninstalling wiggum..."

    if [ -d "$PLUGIN_DIR" ] || [ -L "$PLUGIN_DIR" ]; then
        rm -rf "$PLUGIN_DIR"
        print_status "Removed $PLUGIN_DIR"
    else
        print_warning "Wiggum not installed at $PLUGIN_DIR"
    fi

    # Remove Ralph section from CLAUDE.md if present
    if [ -f "$CLAUDE_MD" ] && grep -q "## Ralph Wiggum Integration" "$CLAUDE_MD"; then
        # Create backup
        cp "$CLAUDE_MD" "$CLAUDE_MD.backup"
        # Remove the Ralph section: delete from "## Ralph Wiggum Integration" line
        # up to (but not including) the next "## " header that doesn't start with R
        # The pattern /^## [^R]/ matches headers like "## Sandbox" but not "## Ralph"
        sed -i.tmp '/^## Ralph Wiggum Integration$/,/^## [^R]/{ /^## [^R]/!d; }' "$CLAUDE_MD"
        # Clean up trailing empty lines at end of file
        sed -i.tmp -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$CLAUDE_MD"
        rm -f "$CLAUDE_MD.tmp"
        print_status "Removed Ralph section from $CLAUDE_MD (backup at $CLAUDE_MD.backup)"
    fi

    echo ""
    print_status "Wiggum uninstalled successfully."
    exit 0
}

install() {
    echo ""
    echo "=========================================="
    echo "  Wiggum - Ralph Wiggum Loop Plugin"
    echo "=========================================="
    echo ""

    # Check for uninstall flag
    if [ "$1" == "--uninstall" ]; then
        uninstall
    fi

    # Create plugins directory
    print_status "Creating plugins directory..."
    mkdir -p "$HOME/.claude/plugins"

    # Remove existing installation
    if [ -L "$PLUGIN_DIR" ]; then
        print_warning "Removing existing symlink at $PLUGIN_DIR"
        rm "$PLUGIN_DIR"
    elif [ -d "$PLUGIN_DIR" ]; then
        print_warning "Updating existing installation at $PLUGIN_DIR"
        rm -rf "$PLUGIN_DIR"
    fi

    # Copy plugin to global location
    print_status "Installing wiggum to $PLUGIN_DIR..."
    cp -r "$SCRIPT_DIR" "$PLUGIN_DIR"

    # Make scripts executable
    print_status "Setting script permissions..."
    chmod +x "$PLUGIN_DIR/scripts/"*.sh 2>/dev/null || true
    chmod +x "$PLUGIN_DIR/install.sh"

    # Add Ralph integration to global CLAUDE.md
    if [ ! -f "$CLAUDE_MD" ]; then
        print_status "Creating $CLAUDE_MD..."
        touch "$CLAUDE_MD"
    fi

    if ! grep -q "## Ralph Wiggum Integration" "$CLAUDE_MD" 2>/dev/null; then
        print_status "Adding Ralph integration to $CLAUDE_MD..."
        cat >> "$CLAUDE_MD" << 'EOF'

## Ralph Wiggum Integration

The wiggum plugin is installed globally. It provides autonomous loop capabilities for suitable tasks.

### Core Principle: Backpressure-Driven Iteration

Ralph's value is **NOT** about managing context windows. It's about autonomous iteration through failures:

```
Try → Validate (tests/typecheck) → Fail → Retry (until validation passes)
```

Tests and typechecks create "backpressure" that rejects invalid work and guides fixes.

### Available Skills

- `/ralph-start` - Start an autonomous development loop
- `/ralph-stop` - Stop a running loop
- `/ralph-status` - Check loop status
- `/ralph-evaluate` - Evaluate if a task is suitable for Ralph
- `/ralph-plan` - Create a complete Ralph-ready plan for a task

### When to Suggest Ralph

The KEY question: **Does the task have strong backpressure (tests/typecheck that will catch failures)?**

**Good for Ralph:**
- Migrations where builds/tests will fail and guide fixes (e.g., React upgrade)
- Large refactors with existing test coverage
- Tasks where you EXPECT multiple failed attempts before success
- Grinding through many errors autonomously

**Not suitable:**
- No tests or validation to catch failures (Ralph can't learn)
- Simple tasks likely to succeed first try (no iteration needed)
- Ambiguous requirements with no pass/fail criteria
- Architectural decisions (tests can't tell you which design is right)

### Suggesting Ralph

If a task has strong backpressure and will benefit from try-fail-retry cycles:

"This task has good backpressure (tests will catch failures and guide fixes).
Ralph can iterate autonomously until tests pass.
Would you like me to start a Ralph loop? [Yes/No]"

If they agree, use `/ralph-start` with a clear task description, or use `/ralph-plan` first for complex tasks.

### After User Approves

**IMPORTANT: Do NOT tell the user to open a new terminal or run commands manually.**

When the user approves a Ralph loop:
1. Use `/ralph-start` with a clear task description and appropriate `--max-iterations`
2. **Immediately begin working** on the task in this session
3. The stop hook will automatically continue the loop when this session ends

The user just says "yes" and you handle everything. That's the point of autonomous loops.
EOF
        print_status "Added Ralph integration instructions."
    else
        print_warning "Ralph integration already present in $CLAUDE_MD"
    fi

    echo ""
    echo "=========================================="
    print_status "Wiggum installed successfully!"
    echo "=========================================="
    echo ""
    echo "The plugin is now available in ALL projects."
    echo ""
    echo "Available commands:"
    echo "  /ralph-start    - Start an autonomous loop"
    echo "  /ralph-stop     - Stop a running loop"
    echo "  /ralph-status   - Check loop status"
    echo "  /ralph-evaluate - Evaluate task suitability"
    echo "  /ralph-plan     - Create a Ralph-ready plan"
    echo ""
    echo "To uninstall:"
    echo "  $PLUGIN_DIR/install.sh --uninstall"
    echo ""
}

install "$@"
