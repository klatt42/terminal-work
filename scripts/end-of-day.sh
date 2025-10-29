#!/bin/bash

# End-of-Day Terminal Capture & Context Save
# Captures all terminal states and pushes to GitHub for fresh start tomorrow

set -e

PROJECT_DIR="$HOME/projects/terminal-work"
DATE=$(date '+%Y-%m-%d')
TIME=$(date '+%H:%M:%S')
TIMESTAMP="${DATE}_${TIME//:/-}"
SESSION_DIR="$PROJECT_DIR/notes/daily-sessions"
TODAY_FILE="$SESSION_DIR/$DATE.md"

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

## Terminal States

### Current Directory
\`\`\`
$(pwd)
\`\`\`

### Git Status
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

# 4. Push to GitHub
echo -e "${YELLOW}4. Pushing to GitHub...${NC}"
if git push; then
    echo -e "${GREEN}✓ Pushed to GitHub${NC}"
else
    echo -e "${RED}✗ Push failed. Check your connection.${NC}"
fi
echo ""

# 5. Generate tomorrow's context
echo -e "${YELLOW}5. Generating tomorrow context...${NC}"
TOMORROW=$(date -d tomorrow '+%Y-%m-%d' 2>/dev/null || date -v+1d '+%Y-%m-%d' 2>/dev/null)
TOMORROW_FILE="$SESSION_DIR/$TOMORROW-plan.md"

cat > "$TOMORROW_FILE" << EOF
# Tomorrow's Plan - $TOMORROW

**Created**: $DATE $TIME

---

## Carry Over from Today

Review: $TODAY_FILE

---

## Priority Tasks

1. [ ]
2. [ ]
3. [ ]

---

## Terminal Setup

Starting directory: \`$(pwd)\`

### Recommended Layout

\`\`\`bash
# Tab 1: Main work
cd $PROJECT_DIR

# Tab 2: Claude Code (if needed)
claude

# Tab 3: Gemini CLI (if installed)
gemini

# Tab 4: Monitoring
watch -n 5 "git status"
\`\`\`

---

## Context Files to Review

- [ ] AI_CONTEXT.md
- [ ] WORKFLOW_STATE.md
- [ ] $TODAY_FILE

---

**Start fresh with**: \`./scripts/context-sync.sh\`
EOF

echo -e "${GREEN}✓ Tomorrow's plan created: $TOMORROW_FILE${NC}"
echo ""

# 6. Summary
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    END OF DAY COMPLETE ✓                     ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📁 Files Created:${NC}"
echo -e "   • $TODAY_FILE"
echo -e "   • $TOMORROW_FILE"
echo ""
echo -e "${BLUE}✅ Completed:${NC}"
echo -e "   • Terminal state captured"
echo -e "   • AI context synchronized"
echo -e "   • Changes committed & pushed"
echo -e "   • Tomorrow's plan created"
echo ""
echo -e "${YELLOW}🌙 Safe to close terminals. Tomorrow's context is saved!${NC}"
echo ""
echo -e "${BLUE}Tomorrow morning, run:${NC}"
echo -e "   cd $PROJECT_DIR"
echo -e "   cat $TOMORROW_FILE"
echo -e "   ./scripts/context-sync.sh"
echo ""
