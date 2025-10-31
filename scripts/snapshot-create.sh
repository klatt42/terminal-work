#!/bin/bash

# Project State Snapshot System
# Creates a comprehensive snapshot of the current project state for easy resume

# Usage:
#   snapshot-create                    # Create automatic snapshot
#   snapshot-create "Feature complete" # Create snapshot with message

PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename "$PROJECT_DIR")
SNAPSHOT_DIR="$PROJECT_DIR/.snapshots"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
SNAPSHOT_FILE="$SNAPSHOT_DIR/snapshot-$TIMESTAMP.json"
MESSAGE="${1:-Automatic snapshot}"

echo "════════════════════════════════════════════════════════════════"
echo "  PROJECT SNAPSHOT - $PROJECT_NAME"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Create snapshots directory if it doesn't exist
mkdir -p "$SNAPSHOT_DIR"

# Ensure .snapshots is in .gitignore
if [ -f "$PROJECT_DIR/.gitignore" ]; then
    if ! grep -q "^\.snapshots" "$PROJECT_DIR/.gitignore"; then
        echo ".snapshots/" >> "$PROJECT_DIR/.gitignore"
        echo "✓ Added .snapshots/ to .gitignore"
    fi
fi

# Collect git information
if [ -d "$PROJECT_DIR/.git" ]; then
    GIT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    GIT_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
    GIT_COMMIT_MSG=$(git log -1 --pretty=%B 2>/dev/null | head -1 || echo "No commit message")
    GIT_UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l)
    GIT_STASHES=$(git stash list 2>/dev/null | wc -l)

    # Get list of modified files
    MODIFIED_FILES="["
    first=true
    while IFS= read -r file; do
        if [ -n "$file" ]; then
            if [ "$first" = false ]; then
                MODIFIED_FILES+=","
            fi
            MODIFIED_FILES+="\"$(echo "$file" | sed 's/"/\\"/g')\""
            first=false
        fi
    done < <(git status --porcelain 2>/dev/null | awk '{print $2}')
    MODIFIED_FILES+="]"
else
    GIT_BRANCH="none"
    GIT_COMMIT="none"
    GIT_COMMIT_MSG="Not a git repository"
    GIT_UNCOMMITTED=0
    GIT_STASHES=0
    MODIFIED_FILES="[]"
fi

# Check for running dev server
DEV_SERVER_RUNNING="false"
DEV_SERVER_PORT=""
DEV_SERVER_PID=""
if lsof -i :3000-3010 2>/dev/null | grep -q "node.*$PROJECT_NAME"; then
    DEV_SERVER_RUNNING="true"
    DEV_SERVER_INFO=$(lsof -i :3000-3010 2>/dev/null | grep "node.*$PROJECT_NAME" | head -1)
    DEV_SERVER_PORT=$(echo "$DEV_SERVER_INFO" | awk -F: '{print $2}' | awk '{print $1}')
    DEV_SERVER_PID=$(echo "$DEV_SERVER_INFO" | awk '{print $2}')
fi

# Check for package.json and dependencies
if [ -f "$PROJECT_DIR/package.json" ]; then
    HAS_PACKAGE_JSON="true"
    NODE_MODULES_EXISTS=$([ -d "$PROJECT_DIR/node_modules" ] && echo "true" || echo "false")

    # Extract key package.json info
    PACKAGE_NAME=$(grep '"name"' package.json | head -1 | awk -F'"' '{print $4}' || echo "unknown")
    PACKAGE_VERSION=$(grep '"version"' package.json | head -1 | awk -F'"' '{print $4}' || echo "unknown")
else
    HAS_PACKAGE_JSON="false"
    NODE_MODULES_EXISTS="false"
    PACKAGE_NAME="none"
    PACKAGE_VERSION="none"
fi

# Check for environment files
ENV_FILES="["
first=true
for env_file in .env .env.local .env.development .env.production; do
    if [ -f "$PROJECT_DIR/$env_file" ]; then
        if [ "$first" = false ]; then
            ENV_FILES+=","
        fi
        ENV_FILES+="\"$env_file\""
        first=false
    fi
done
ENV_FILES+="]"

# Get recent terminal commands (if bash history exists)
RECENT_COMMANDS="["
if [ -f "$PROJECT_DIR/.bash_history" ]; then
    cmd_first=true
    while IFS= read -r cmd; do
        if [ "$cmd_first" = false ]; then
            RECENT_COMMANDS+=","
        fi
        RECENT_COMMANDS+="\"$(echo "$cmd" | sed 's/"/\\"/g' | head -c 100)\""
        cmd_first=false
    done < <(tail -10 "$PROJECT_DIR/.bash_history" 2>/dev/null)
fi
RECENT_COMMANDS+="]"

# Check for Claude session context
CLAUDE_SESSION_EXISTS="false"
CLAUDE_SESSION_PRD=""
if [ -f "$PROJECT_DIR/.claude-session" ]; then
    CLAUDE_SESSION_EXISTS="true"
    CLAUDE_SESSION_PRD=$(grep "prd_file:" "$PROJECT_DIR/.claude-session" 2>/dev/null | awk -F': ' '{print $2}' || echo "unknown")
fi

# Check for active tasks/todos
ACTIVE_TASKS="[]"
if [ -f "$PROJECT_DIR/NEXT_SESSION_TASKS.md" ]; then
    ACTIVE_TASKS_FILE="NEXT_SESSION_TASKS.md"
elif [ -f "$PROJECT_DIR/TODO.md" ]; then
    ACTIVE_TASKS_FILE="TODO.md"
else
    ACTIVE_TASKS_FILE=""
fi

# Detect framework/project type
PROJECT_TYPE="unknown"
if [ -f "next.config.js" ] || [ -f "next.config.ts" ]; then
    PROJECT_TYPE="Next.js"
elif [ -f "vite.config.js" ] || [ -f "vite.config.ts" ]; then
    PROJECT_TYPE="Vite"
elif [ -f "angular.json" ]; then
    PROJECT_TYPE="Angular"
elif [ -f "vue.config.js" ]; then
    PROJECT_TYPE="Vue"
elif grep -q '"react"' package.json 2>/dev/null; then
    PROJECT_TYPE="React"
fi

# Build snapshot JSON
cat > "$SNAPSHOT_FILE" <<EOF
{
    "snapshot_meta": {
        "timestamp": "$TIMESTAMP",
        "human_time": "$(date '+%Y-%m-%d %H:%M:%S')",
        "message": "$MESSAGE",
        "project_name": "$PROJECT_NAME",
        "project_path": "$PROJECT_DIR",
        "project_type": "$PROJECT_TYPE"
    },
    "git": {
        "branch": "$GIT_BRANCH",
        "commit": "$GIT_COMMIT",
        "commit_message": "$GIT_COMMIT_MSG",
        "uncommitted_changes": $GIT_UNCOMMITTED,
        "stashes": $GIT_STASHES,
        "modified_files": $MODIFIED_FILES
    },
    "development": {
        "has_package_json": $HAS_PACKAGE_JSON,
        "package_name": "$PACKAGE_NAME",
        "package_version": "$PACKAGE_VERSION",
        "node_modules_installed": $NODE_MODULES_EXISTS,
        "env_files": $ENV_FILES,
        "dev_server_running": $DEV_SERVER_RUNNING,
        "dev_server_port": "$DEV_SERVER_PORT",
        "dev_server_pid": "$DEV_SERVER_PID"
    },
    "context": {
        "claude_session_active": $CLAUDE_SESSION_EXISTS,
        "prd_reference": "$CLAUDE_SESSION_PRD",
        "tasks_file": "$ACTIVE_TASKS_FILE",
        "recent_commands": $RECENT_COMMANDS
    }
}
EOF

# Create a human-readable summary
SUMMARY_FILE="$SNAPSHOT_DIR/latest-summary.txt"
cat > "$SUMMARY_FILE" <<EOF
═══════════════════════════════════════════════════════════════
PROJECT SNAPSHOT: $PROJECT_NAME
═══════════════════════════════════════════════════════════════
Created: $(date '+%Y-%m-%d %H:%M:%S')
Message: $MESSAGE

GIT STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Branch:              $GIT_BRANCH
Last Commit:         $GIT_COMMIT_MSG
Uncommitted Changes: $GIT_UNCOMMITTED files
Stashes:             $GIT_STASHES

DEVELOPMENT ENVIRONMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project Type:        $PROJECT_TYPE
Package:             $PACKAGE_NAME@$PACKAGE_VERSION
Dependencies:        $([ "$NODE_MODULES_EXISTS" = "true" ] && echo "Installed" || echo "Missing")
Dev Server:          $([ "$DEV_SERVER_RUNNING" = "true" ] && echo "Running on port $DEV_SERVER_PORT" || echo "Not running")

CONTEXT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Claude Session:      $([ "$CLAUDE_SESSION_EXISTS" = "true" ] && echo "Active ($CLAUDE_SESSION_PRD)" || echo "None")
Tasks File:          $ACTIVE_TASKS_FILE

QUICK RESUME
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
To resume this snapshot:
  snapshot-resume $TIMESTAMP

To resume latest:
  snapshot-resume
═══════════════════════════════════════════════════════════════
EOF

# Create symlink to latest snapshot
ln -sf "snapshot-$TIMESTAMP.json" "$SNAPSHOT_DIR/latest.json"

echo "✓ Snapshot created: snapshot-$TIMESTAMP.json"
echo "✓ Summary saved: latest-summary.txt"
echo ""
echo "Details:"
echo "  Project:     $PROJECT_NAME ($PROJECT_TYPE)"
echo "  Git Branch:  $GIT_BRANCH"
echo "  Uncommitted: $GIT_UNCOMMITTED files"
echo "  Dev Server:  $([ "$DEV_SERVER_RUNNING" = "true" ] && echo "Running (port $DEV_SERVER_PORT)" || echo "Stopped")"
echo ""
echo "To resume: snapshot-resume $TIMESTAMP"
echo "════════════════════════════════════════════════════════════════"
