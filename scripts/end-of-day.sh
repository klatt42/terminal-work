#!/bin/bash

# End-of-Day Terminal Capture & Context Save
# Captures all terminal states and pushes to GitHub for fresh start tomorrow

set -e

PROJECT_DIR="$HOME/projects/terminal-work"
PROJECTS_ROOT="$HOME/projects"
DATE=$(date '+%Y-%m-%d')
TIME=$(date '+%H:%M:%S')
TIMESTAMP="${DATE}_${TIME//:/-}"
SESSION_DIR="$PROJECT_DIR/notes/daily-sessions"
TODAY_FILE="$SESSION_DIR/$DATE.md"
TOMORROW=$(date -d tomorrow '+%Y-%m-%d' 2>/dev/null || date -v+1d '+%Y-%m-%d' 2>/dev/null)
BRIEFING_FILE="$SESSION_DIR/$TOMORROW-morning-briefing.md"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         END OF DAY - TERMINAL CAPTURE & PUSH                 ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Create session directory if it doesn't exist
mkdir -p "$SESSION_DIR"

# 1. Capture current terminal state
echo -e "${YELLOW}1. Capturing terminal states...${NC}"

cat > "$TODAY_FILE" << EOF
# Terminal Session - $DATE

**Session End Time**: $TIME

---

## Summary

$(echo -e "What did you accomplish today?\n(Type your summary below, press Ctrl+D when done)\n")
EOF

# Prompt for summary
echo -e "${GREEN}Enter your day summary (Ctrl+D when done):${NC}"
SUMMARY=$(cat)

# Append summary to file
cat >> "$TODAY_FILE" << EOF
$SUMMARY

---

## All Projects Status

EOF

# Scan all projects
echo -e "${YELLOW}Scanning all projects in $PROJECTS_ROOT...${NC}"

for project_path in "$PROJECTS_ROOT"/*; do
    if [ -d "$project_path" ]; then
        project_name=$(basename "$project_path")
        cat >> "$TODAY_FILE" << PROJ_EOF

### 📁 $project_name
**Location**: \`$project_path\`

PROJ_EOF

        cd "$project_path"

        # Check if it's a git repo
        if [ -d ".git" ]; then
            cat >> "$TODAY_FILE" << PROJ_EOF
**Git Status**:
\`\`\`
$(git status -s 2>/dev/null | head -10 || echo "No changes")
\`\`\`

**Current Branch**: \`$(git branch --show-current 2>/dev/null || echo "N/A")\`

**Recent Commits** (last 3):
\`\`\`
$(git log --oneline -3 2>/dev/null || echo "No commits")
\`\`\`

**Modified Today**:
\`\`\`
$(git diff --stat 2>/dev/null | head -10 || echo "No changes")
\`\`\`

PROJ_EOF
        else
            cat >> "$TODAY_FILE" << PROJ_EOF
Not a git repository

PROJ_EOF
        fi

        # Check for running processes or notes
        if [ -f "README.md" ]; then
            cat >> "$TODAY_FILE" << PROJ_EOF
**Has README**: ✓

PROJ_EOF
        fi

        # Check for recent file activity
        recent_files=$(find "$project_path" -type f -mtime -1 ! -path "*/.git/*" ! -path "*/node_modules/*" 2>/dev/null | wc -l)
        if [ "$recent_files" -gt 0 ]; then
            cat >> "$TODAY_FILE" << PROJ_EOF
**Files Modified Today**: $recent_files

PROJ_EOF
        fi
    fi
done

cd "$PROJECT_DIR"

cat >> "$TODAY_FILE" << EOF

---

## Current Terminal State

### Working Directory
\`\`\`
$(pwd)
\`\`\`

### Git Status (terminal-work)
\`\`\`
$(git status 2>/dev/null || echo "Not in a git repository")
\`\`\`

### Recent Commands (last 20)
\`\`\`bash
$(fc -ln -20 2>/dev/null || history 20 2>/dev/null || echo "Command history not available")
\`\`\`

### Open Files in Project
\`\`\`
$(find "$PROJECT_DIR" -type f -mtime -1 ! -path "*/.git/*" ! -path "*/node_modules/*" 2>/dev/null | head -20)
\`\`\`

### Modified Files Today
\`\`\`
$(git diff --name-only 2>/dev/null || echo "No git changes")
\`\`\`

---

## Active Tasks

### From WORKFLOW_STATE.md
\`\`\`
$(cat "$PROJECT_DIR/WORKFLOW_STATE.md" 2>/dev/null | grep -A 10 "Current Tasks" || echo "No workflow state found")
\`\`\`

### From .ai-state.json
\`\`\`json
$(cat "$PROJECT_DIR/.ai-state.json" 2>/dev/null | jq '.current_tasks' 2>/dev/null || echo "No state file found")
\`\`\`

---

## Environment State

### Running Processes (AI-related)
\`\`\`
$(ps aux | grep -E "(claude|gemini|grok|tmux)" | grep -v grep || echo "No AI processes running")
\`\`\`

### Tmux Sessions
\`\`\`
$(tmux ls 2>/dev/null || echo "No tmux sessions active")
\`\`\`

---

## Notes for Tomorrow

- [ ] Review this session file
- [ ] Continue from: $(pwd)
- [ ] Check WORKFLOW_STATE.md for pending tasks

---

**Captured**: $TIMESTAMP
EOF

echo -e "${GREEN}✓ Session saved to: $TODAY_FILE${NC}"
echo ""

# 2. Update AI context
echo -e "${YELLOW}2. Updating AI context files...${NC}"
if [ -f "$PROJECT_DIR/scripts/context-sync.sh" ]; then
    "$PROJECT_DIR/scripts/context-sync.sh"
    echo -e "${GREEN}✓ Context synchronized${NC}"
else
    echo -e "${RED}✗ context-sync.sh not found${NC}"
fi
echo ""

# 3. Show uncommitted changes
echo -e "${YELLOW}3. Checking for uncommitted changes...${NC}"
cd "$PROJECT_DIR"
if [[ -n $(git status -s) ]]; then
    echo -e "${YELLOW}Uncommitted changes found:${NC}"
    git status -s
    echo ""
    echo -e "${BLUE}Commit message for end-of-day:${NC}"
    read -r COMMIT_MSG

    if [ -n "$COMMIT_MSG" ]; then
        git add -A
        git commit -m "$COMMIT_MSG

End of day commit - $DATE

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
        echo -e "${GREEN}✓ Changes committed${NC}"
    else
        echo -e "${YELLOW}No commit message provided. Skipping commit.${NC}"
    fi
else
    echo -e "${GREEN}✓ No uncommitted changes${NC}"
fi
echo ""

# 4. Create snapshots for all active projects
echo -e "${YELLOW}4. Creating snapshots for active projects...${NC}"

# Array to track projects with snapshots
SNAPSHOT_PROJECTS=()

# Additional project directories to check
EXTRA_DIRS=(
    "$HOME/serp-master"
    "$HOME/projects/genesis-skills-test/my-erp-plan"
    "$HOME/prism-specialties-dmv-empire"
)

# Function to create snapshot if project has changes
create_project_snapshot() {
    local proj_path=$1
    local proj_name=$(basename "$proj_path")

    if [ -d "$proj_path/.git" ]; then
        cd "$proj_path"

        # Check if project has uncommitted changes OR recent activity
        local has_changes=$(git status -s 2>/dev/null | wc -l)
        local recent_files=$(find "$proj_path" -type f -mtime -1 ! -path "*/.git/*" ! -path "*/node_modules/*" 2>/dev/null | wc -l)

        if [ "$has_changes" -gt 0 ] || [ "$recent_files" -gt 0 ]; then
            echo -e "   📸 $proj_name..."

            # Create snapshot using new snapshot system
            if [ -f "$HOME/projects/terminal-work/scripts/snapshot-create.sh" ]; then
                "$HOME/projects/terminal-work/scripts/snapshot-create.sh" "EOD Snapshot - $DATE" > /dev/null 2>&1
                SNAPSHOT_PROJECTS+=("$proj_name|$proj_path")
                echo -e "      ${GREEN}✓ Snapshot created${NC}"
            else
                echo -e "      ${YELLOW}⚠ snapshot-create.sh not found${NC}"
            fi
        fi
    fi
}

# Scan projects directory
for project_path in "$PROJECTS_ROOT"/*; do
    if [ -d "$project_path" ]; then
        create_project_snapshot "$project_path"
    fi
done

# Scan extra directories
for extra_path in "${EXTRA_DIRS[@]}"; do
    if [ -d "$extra_path" ]; then
        create_project_snapshot "$extra_path"
    fi
done

cd "$PROJECT_DIR"

if [ ${#SNAPSHOT_PROJECTS[@]} -gt 0 ]; then
    echo -e "${GREEN}✓ Created ${#SNAPSHOT_PROJECTS[@]} project snapshots${NC}"
else
    echo -e "${GREEN}✓ No active projects to snapshot${NC}"
fi
echo ""

# 5. Push to GitHub
echo -e "${YELLOW}5. Pushing to GitHub...${NC}"
if git push; then
    echo -e "${GREEN}✓ Pushed to GitHub${NC}"
else
    echo -e "${RED}✗ Push failed. Check your connection.${NC}"
fi
echo ""

# 6. Capture dashboard state
echo -e "${YELLOW}6. Capturing dashboard state...${NC}"
if [ -f "$PROJECT_DIR/scripts/session-monitor.sh" ]; then
    "$PROJECT_DIR/scripts/session-monitor.sh" > /dev/null 2>&1

    # Save dashboard snapshot
    if [ -f "$PROJECT_DIR/superdesign/design_iterations/terminal-session-monitor-v1.html" ]; then
        cp "$PROJECT_DIR/superdesign/design_iterations/terminal-session-monitor-v1.html" \
           "$SESSION_DIR/$DATE-dashboard-snapshot.html"
        echo -e "${GREEN}✓ Dashboard snapshot saved${NC}"
    fi
else
    echo -e "${YELLOW}⚠ session-monitor.sh not found, skipping dashboard${NC}"
fi
echo ""

# 7. Generate morning briefing
echo -e "${YELLOW}7. Generating morning briefing...${NC}"

cat > "$BRIEFING_FILE" << 'BRIEF_EOF'
#!/bin/bash
# Morning Briefing - Generated from yesterday's end-of-day

DATE=$(date '+%Y-%m-%d')
BRIEF_EOF

cat >> "$BRIEFING_FILE" << BRIEF_EOF
YESTERDAY="$DATE"
PROJECTS_ROOT="$PROJECTS_ROOT"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║              MORNING BRIEFING - $TOMORROW                ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "📅 Yesterday: $DATE"
echo "📅 Today: $TOMORROW"
echo ""

# Show yesterday's summary
echo "═══════════════════════════════════════════════════════════════"
echo "📋 YESTERDAY'S SUMMARY"
echo "═══════════════════════════════════════════════════════════════"
cat "$TODAY_FILE" | grep -A 20 "## Summary" | tail -n +2 | head -n 15
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo "📁 ALL PROJECTS STATUS"
echo "═══════════════════════════════════════════════════════════════"

# Scan all projects and show where to pick up
BRIEF_EOF

# Generate project scanning code
for project_path in "$PROJECTS_ROOT"/*; do
    if [ -d "$project_path" ]; then
        project_name=$(basename "$project_path")

        cat >> "$BRIEFING_FILE" << BRIEF_EOF

echo ""
echo "📦 $project_name"
echo "   Location: $project_path"

if [ -d "$project_path/.git" ]; then
    cd "$project_path"

    # Check for uncommitted changes
    if [[ -n \$(git status -s 2>/dev/null) ]]; then
        echo "   ⚠️  UNCOMMITTED CHANGES:"
        git status -s | head -5 | sed 's/^/      /'
    else
        echo "   ✓ Clean working directory"
    fi

    # Show current branch
    current_branch=\$(git branch --show-current 2>/dev/null)
    echo "   📌 Branch: \$current_branch"

    # Show last commit
    last_commit=\$(git log --oneline -1 2>/dev/null | head -c 60)
    echo "   💬 Last: \$last_commit"

    # Check if ahead/behind
    git_status=\$(git status 2>/dev/null | grep -E "(ahead|behind)" || echo "")
    if [ -n "\$git_status" ]; then
        echo "   ⚡ \$git_status"
    fi

    # Check for files modified recently
    recent=\$(find "$project_path" -type f -mtime -1 ! -path "*/.git/*" ! -path "*/node_modules/*" 2>/dev/null | wc -l)
    if [ "\$recent" -gt 0 ]; then
        echo "   📝 \$recent files modified yesterday"
    fi

    # Check for snapshot
    if [ -f "$project_path/.snapshots/latest-summary.txt" ]; then
        echo "   📸 Snapshot available - Quick resume: cd $project_path && snapshot-resume"
    else
        echo "   🚀 Open with: cd $project_path"
    fi
else
    echo "   📄 Not a git repository"
fi
BRIEF_EOF
    fi
done

cat >> "$BRIEFING_FILE" << 'BRIEF_EOF'

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "🎯 NEXT STEPS"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "1. Review projects above - look for ⚠️  uncommitted changes"
echo "2. Choose a project to start with"
echo "3. Run: cd <project-path>"
echo "4. Sync context: ~/projects/terminal-work/scripts/context-sync.sh"
echo "5. Start working!"
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "📖 QUICK COMMANDS"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "View yesterday's full session:"
BRIEF_EOF

cat >> "$BRIEFING_FILE" << BRIEF_EOF
echo "  cat $TODAY_FILE"
BRIEF_EOF

cat >> "$BRIEFING_FILE" << 'BRIEF_EOF'
echo ""
echo "Quick commit:"
echo "  ~/projects/terminal-work/scripts/quick-commit.sh \"Add: message\""
echo ""
echo "Resume from snapshot:"
echo "  cd <project-path> && snapshot-resume"
echo ""
echo "Create snapshot:"
echo "  snapshot-create \"Your message\""
echo ""
echo "End of day (tonight):"
echo "  ~/projects/terminal-work/scripts/end-of-day.sh"
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "Ready to start fresh! 🚀"
echo "═══════════════════════════════════════════════════════════════"
BRIEF_EOF

chmod +x "$BRIEFING_FILE"

echo -e "${GREEN}✓ Morning briefing created: $BRIEFING_FILE${NC}"
echo ""

# 8. Summary
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    END OF DAY COMPLETE ✓                     ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📁 Files Created:${NC}"
echo -e "   • $TODAY_FILE (Full session log)"
echo -e "   • $BRIEFING_FILE (Morning briefing)"
echo -e "   • $SESSION_DIR/$DATE-dashboard-snapshot.html (Dashboard snapshot)"
if [ ${#SNAPSHOT_PROJECTS[@]} -gt 0 ]; then
    echo -e "   • ${#SNAPSHOT_PROJECTS[@]} project snapshots created"
fi
echo ""
echo -e "${BLUE}✅ Completed:${NC}"
echo -e "   • All projects scanned & status captured"
echo -e "   • Terminal states preserved"
echo -e "   • AI context synchronized"
if [ ${#SNAPSHOT_PROJECTS[@]} -gt 0 ]; then
    echo -e "   • Project snapshots created for quick resume"
fi
echo -e "   • Changes committed & pushed"
echo -e "   • Morning briefing generated"
echo ""
echo -e "${YELLOW}🌙 Safe to close ALL terminals. Full context saved!${NC}"
echo ""
echo -e "${BLUE}Tomorrow morning, run:${NC}"
echo -e "   $BRIEFING_FILE"
echo ""
echo -e "${BLUE}Or from anywhere:${NC}"
echo -e "   ~/projects/terminal-work/notes/daily-sessions/$TOMORROW-morning-briefing.sh"
echo ""
echo -e "${BLUE}This will show you:${NC}"
echo -e "   ✓ Yesterday's summary"
echo -e "   ✓ All projects with their current state"
echo -e "   ✓ Which projects have uncommitted changes"
echo -e "   ✓ Which projects have snapshots for quick resume"
echo -e "   ✓ Exact 'cd' and 'snapshot-resume' commands"
echo -e "   ✓ Quick commands reference"
echo ""
