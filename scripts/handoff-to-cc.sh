#!/bin/bash

# AI Session Handoff: Claude.AI → Claude Code
# Captures PRD/requirements from Claude.AI and sets up Claude Code session context

# Usage:
#   handoff-to-cc <prd-file>           # Start from existing PRD file
#   handoff-to-cc                      # Prompt for PRD information

PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename "$PROJECT_DIR")
SESSION_FILE="$PROJECT_DIR/.claude-session"

echo "════════════════════════════════════════════════════════════════"
echo "  AI HANDOFF: Claude.AI → Claude Code"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "Project: $PROJECT_NAME"
echo ""

# Check if PRD file is provided
if [ -n "$1" ]; then
    PRD_FILE="$1"

    # Check if file exists
    if [ ! -f "$PRD_FILE" ]; then
        # Try as relative path from project root
        if [ -f "$PROJECT_DIR/$PRD_FILE" ]; then
            PRD_FILE="$PROJECT_DIR/$PRD_FILE"
        else
            echo "❌ PRD file not found: $PRD_FILE"
            exit 1
        fi
    fi

    echo "📄 PRD File: $PRD_FILE"
    echo ""

    # Extract goal from PRD (first heading or first line)
    if grep -q "^#" "$PRD_FILE"; then
        PRD_GOAL=$(grep "^#" "$PRD_FILE" | head -1 | sed 's/^#* *//')
    else
        PRD_GOAL=$(head -1 "$PRD_FILE")
    fi

    echo "🎯 Goal: $PRD_GOAL"
    echo ""

else
    # Interactive mode - prompt for information
    echo "No PRD file specified. Let's capture the context manually."
    echo ""

    read -p "📄 PRD/Doc filename (or press Enter to skip): " PRD_FILE
    if [ -z "$PRD_FILE" ]; then
        PRD_FILE="none"
    elif [ ! -f "$PRD_FILE" ] && [ ! -f "$PROJECT_DIR/$PRD_FILE" ]; then
        echo "⚠️  File not found, but will track filename for reference"
    fi

    echo ""
    read -p "🎯 What are you building? (brief description): " PRD_GOAL

    if [ -z "$PRD_GOAL" ]; then
        PRD_GOAL="General development work"
    fi

    echo ""
fi

# Optional: Claude.AI conversation URL
read -p "🔗 Claude.AI conversation URL (optional, press Enter to skip): " CLAUDE_URL
echo ""

# Create session file
cat > "$SESSION_FILE" <<EOF
# Claude Code Session Context
# Created: $(date '+%Y-%m-%d %H:%M:%S')
# Handoff from Claude.AI → Claude Code

project_name: $PROJECT_NAME
prd_file: $PRD_FILE
goal: $PRD_GOAL
claude_url: ${CLAUDE_URL:-none}
session_start: $(date -Iseconds)

# Session Notes
# Add any additional context or notes below:

EOF

# Create or update .gitignore to exclude session file (it's local context)
if [ -f "$PROJECT_DIR/.gitignore" ]; then
    if ! grep -q "^\.claude-session" "$PROJECT_DIR/.gitignore"; then
        echo ".claude-session" >> "$PROJECT_DIR/.gitignore"
        echo "✓ Added .claude-session to .gitignore"
    fi
else
    echo ".claude-session" > "$PROJECT_DIR/.gitignore"
    echo "✓ Created .gitignore with .claude-session"
fi

# Create initial snapshot
echo "📸 Creating initial project snapshot..."
if [ -f "$HOME/projects/terminal-work/scripts/snapshot-create.sh" ]; then
    "$HOME/projects/terminal-work/scripts/snapshot-create.sh" "Handoff from Claude.AI - $PRD_GOAL" > /dev/null 2>&1
    echo "✓ Snapshot created"
else
    echo "⚠️  Snapshot script not found (skipping)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SESSION READY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✓ Session context captured in .claude-session"
echo "✓ Initial snapshot created"
echo ""
echo "🚀 You can now start working with Claude Code!"
echo ""
echo "Quick commands:"
echo "  • snapshot-create \"message\"    - Save progress snapshot"
echo "  • snapshot-resume               - View current state"
echo "  • handoff-from-cc               - Generate summary for Claude.AI"
echo ""
echo "════════════════════════════════════════════════════════════════"

# Show PRD contents if it exists
if [ -f "$PRD_FILE" ] && [ "$PRD_FILE" != "none" ]; then
    echo ""
    echo "📋 PRD PREVIEW:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    head -30 "$PRD_FILE" | sed 's/^/  /'

    if [ $(wc -l < "$PRD_FILE") -gt 30 ]; then
        echo "  ..."
        echo "  ($(wc -l < "$PRD_FILE") lines total - use 'cat $PRD_FILE' to see full content)"
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi
