#!/bin/bash

# Project State Snapshot Resume System
# Restores project state and provides context for quick resumption

# Usage:
#   snapshot-resume                    # Resume latest snapshot
#   snapshot-resume 20250130-143022    # Resume specific snapshot by timestamp
#   snapshot-resume list               # List all available snapshots

PROJECT_DIR=$(pwd)
SNAPSHOT_DIR="$PROJECT_DIR/.snapshots"

# Check if snapshots directory exists
if [ ! -d "$SNAPSHOT_DIR" ]; then
    echo "❌ No snapshots found in this project"
    echo ""
    echo "Create a snapshot with: snapshot-create"
    exit 1
fi

# Handle listing snapshots
if [ "$1" = "list" ]; then
    echo "════════════════════════════════════════════════════════════════"
    echo "  AVAILABLE SNAPSHOTS"
    echo "════════════════════════════════════════════════════════════════"
    echo ""

    if [ -z "$(ls -A $SNAPSHOT_DIR/snapshot-*.json 2>/dev/null)" ]; then
        echo "No snapshots found."
        exit 0
    fi

    for snapshot in "$SNAPSHOT_DIR"/snapshot-*.json; do
        TIMESTAMP=$(basename "$snapshot" | sed 's/snapshot-//;s/.json//')
        MESSAGE=$(grep '"message"' "$snapshot" | head -1 | awk -F'"' '{print $4}')
        HUMAN_TIME=$(grep '"human_time"' "$snapshot" | head -1 | awk -F'"' '{print $4}')
        BRANCH=$(grep '"branch"' "$snapshot" | grep -v snapshot_meta | head -1 | awk -F'"' '{print $4}')

        echo "[$TIMESTAMP]"
        echo "  Time:    $HUMAN_TIME"
        echo "  Message: $MESSAGE"
        echo "  Branch:  $BRANCH"
        echo ""
    done

    echo "To resume: snapshot-resume <timestamp>"
    echo "════════════════════════════════════════════════════════════════"
    exit 0
fi

# Determine which snapshot to load
if [ -z "$1" ]; then
    # Load latest snapshot
    SNAPSHOT_FILE="$SNAPSHOT_DIR/latest.json"
    if [ ! -f "$SNAPSHOT_FILE" ]; then
        echo "❌ No snapshots found"
        echo "Create one with: snapshot-create"
        exit 1
    fi
    echo "Loading latest snapshot..."
else
    # Load specific snapshot
    SNAPSHOT_FILE="$SNAPSHOT_DIR/snapshot-$1.json"
    if [ ! -f "$SNAPSHOT_FILE" ]; then
        echo "❌ Snapshot not found: $1"
        echo ""
        echo "Available snapshots:"
        ls -1 "$SNAPSHOT_DIR"/snapshot-*.json 2>/dev/null | sed 's/.*snapshot-//;s/.json//' | sed 's/^/  /'
        exit 1
    fi
    echo "Loading snapshot: $1..."
fi

echo ""

# Parse snapshot JSON (using grep/awk for portability)
PROJECT_NAME=$(grep '"project_name"' "$SNAPSHOT_FILE" | awk -F'"' '{print $4}')
PROJECT_TYPE=$(grep '"project_type"' "$SNAPSHOT_FILE" | awk -F'"' '{print $4}')
SNAPSHOT_TIME=$(grep '"human_time"' "$SNAPSHOT_FILE" | awk -F'"' '{print $4}')
SNAPSHOT_MSG=$(grep '"message"' "$SNAPSHOT_FILE" | head -1 | awk -F'"' '{print $4}')

GIT_BRANCH=$(grep '"branch"' "$SNAPSHOT_FILE" | grep -v snapshot_meta | head -1 | awk -F'"' '{print $4}')
GIT_COMMIT=$(grep '"commit"' "$SNAPSHOT_FILE" | grep -v snapshot_meta | awk -F'"' '{print $4}')
GIT_COMMIT_MSG=$(grep '"commit_message"' "$SNAPSHOT_FILE" | awk -F'"' '{print $4}')
UNCOMMITTED=$(grep '"uncommitted_changes"' "$SNAPSHOT_FILE" | awk -F': ' '{print $2}' | tr -d ',' )

DEV_SERVER_WAS_RUNNING=$(grep '"dev_server_running"' "$SNAPSHOT_FILE" | awk -F': ' '{print $2}' | tr -d ',' )
DEV_SERVER_PORT=$(grep '"dev_server_port"' "$SNAPSHOT_FILE" | awk -F'"' '{print $4}')

NODE_MODULES=$(grep '"node_modules_installed"' "$SNAPSHOT_FILE" | awk -F': ' '{print $2}' | tr -d ',' )
TASKS_FILE=$(grep '"tasks_file"' "$SNAPSHOT_FILE" | awk -F'"' '{print $4}')
CLAUDE_SESSION=$(grep '"claude_session_active"' "$SNAPSHOT_FILE" | awk -F': ' '{print $2}' | tr -d ',' )
PRD_REFERENCE=$(grep '"prd_reference"' "$SNAPSHOT_FILE" | awk -F'"' '{print $4}')

echo "════════════════════════════════════════════════════════════════"
echo "  RESUMING: $PROJECT_NAME"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "📸 Snapshot from: $SNAPSHOT_TIME"
echo "💬 Message: $SNAPSHOT_MSG"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "GIT STATUS AT SNAPSHOT TIME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Branch:              $GIT_BRANCH"
echo "Last Commit:         $(echo $GIT_COMMIT_MSG | head -c 60)"
echo "Uncommitted Changes: $UNCOMMITTED files"
echo ""

# Show current git status comparison
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CURRENT GIT STATUS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ -d "$PROJECT_DIR/.git" ]; then
    CURRENT_BRANCH=$(git branch --show-current)
    CURRENT_UNCOMMITTED=$(git status --porcelain | wc -l)

    echo "Branch:              $CURRENT_BRANCH"
    echo "Uncommitted Changes: $CURRENT_UNCOMMITTED files"

    if [ "$GIT_BRANCH" != "$CURRENT_BRANCH" ]; then
        echo ""
        echo "⚠️  WARNING: You're on a different branch!"
        echo "   Snapshot was on: $GIT_BRANCH"
        echo "   You're now on:   $CURRENT_BRANCH"
    fi
else
    echo "Not a git repository"
fi
echo ""

# Development environment checks
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "DEVELOPMENT ENVIRONMENT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Project Type:        $PROJECT_TYPE"

# Check if dependencies need installation
if [ "$NODE_MODULES" = "true" ] && [ ! -d "$PROJECT_DIR/node_modules" ]; then
    echo "Dependencies:        ⚠️  MISSING (were installed at snapshot time)"
    echo ""
    echo "  Run: npm install"
    NEEDS_INSTALL=true
elif [ "$NODE_MODULES" = "false" ] && [ -d "$PROJECT_DIR/node_modules" ]; then
    echo "Dependencies:        ✓ Installed (weren't at snapshot time)"
    NEEDS_INSTALL=false
elif [ "$NODE_MODULES" = "true" ] && [ -d "$PROJECT_DIR/node_modules" ]; then
    echo "Dependencies:        ✓ Installed"
    NEEDS_INSTALL=false
else
    echo "Dependencies:        ⚠️  Not installed"
    NEEDS_INSTALL=true
fi

# Check dev server status
if lsof -i :"$DEV_SERVER_PORT" >/dev/null 2>&1; then
    echo "Dev Server:          ✓ Running on port $DEV_SERVER_PORT"
    SERVER_RUNNING=true
else
    if [ "$DEV_SERVER_WAS_RUNNING" = "true" ]; then
        echo "Dev Server:          ❌ Not running (was on port $DEV_SERVER_PORT)"
        SERVER_RUNNING=false
    else
        echo "Dev Server:          Not running"
        SERVER_RUNNING=false
    fi
fi
echo ""

# Context information
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CONTEXT & NEXT STEPS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$CLAUDE_SESSION" = "true" ]; then
    echo "Claude Session:      ✓ Active"
    echo "PRD Reference:       $PRD_REFERENCE"
else
    echo "Claude Session:      None"
fi

if [ -n "$TASKS_FILE" ] && [ -f "$PROJECT_DIR/$TASKS_FILE" ]; then
    echo "Tasks File:          ✓ $TASKS_FILE"
    echo ""
    echo "📋 Recent tasks:"
    head -20 "$PROJECT_DIR/$TASKS_FILE" | grep -E "^##|^-|^[0-9]" | head -10 | sed 's/^/   /'
else
    echo "Tasks File:          None"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "QUICK ACTIONS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

ACTION_COUNT=1

if [ "$NEEDS_INSTALL" = true ]; then
    echo "$ACTION_COUNT. Install dependencies:"
    echo "   npm install"
    echo ""
    ((ACTION_COUNT++))
fi

if [ "$SERVER_RUNNING" = false ] && [ "$DEV_SERVER_WAS_RUNNING" = "true" ]; then
    echo "$ACTION_COUNT. Start dev server:"
    echo "   npm run dev"
    echo ""
    ((ACTION_COUNT++))
fi

if [ "$UNCOMMITTED" -gt 0 ]; then
    echo "$ACTION_COUNT. Review uncommitted changes:"
    echo "   git status"
    echo "   git diff"
    echo ""
    ((ACTION_COUNT++))
fi

if [ -n "$TASKS_FILE" ] && [ -f "$PROJECT_DIR/$TASKS_FILE" ]; then
    echo "$ACTION_COUNT. Review tasks:"
    echo "   cat $TASKS_FILE"
    echo ""
    ((ACTION_COUNT++))
fi

echo "$ACTION_COUNT. Create a new snapshot when done:"
echo "   snapshot-create \"Your message here\""
echo ""

echo "════════════════════════════════════════════════════════════════"
echo "Ready to resume! 🚀"
echo "════════════════════════════════════════════════════════════════"
