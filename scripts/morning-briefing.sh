#!/bin/bash
# Enhanced Morning Briefing with Real-Time Project Scan

PROJECT_DIR="$HOME/projects/terminal-work"
DATE=$(date '+%Y-%m-%d')
YESTERDAY=$(date -d yesterday '+%Y-%m-%d' 2>/dev/null || date -v-1d '+%Y-%m-%d' 2>/dev/null)
SESSION_DIR="$PROJECT_DIR/notes/daily-sessions"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║              MORNING BRIEFING - $DATE                ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}📅 Yesterday: $YESTERDAY${NC}"
echo -e "${CYAN}📅 Today: $DATE${NC}"
echo ""

# Check if yesterday's session file exists
YESTERDAY_FILE="$SESSION_DIR/$YESTERDAY.md"
if [ -f "$YESTERDAY_FILE" ]; then
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📋 YESTERDAY'S SUMMARY${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"

    # Extract summary section
    sed -n '/## Summary/,/---/p' "$YESTERDAY_FILE" | grep -v "^---" | grep -v "## Summary" | head -20
    echo ""
fi

# Run real-time project scan
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}🔍 REAL-TIME PROJECT STATUS${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""

has_issues=0
PROJECTS_DIR="$HOME/projects"

for project_dir in "$PROJECTS_DIR"/*; do
    if [ -d "$project_dir/.git" ]; then
        cd "$project_dir"
        project_name=$(basename "$project_dir")
        branch=$(git branch --show-current 2>/dev/null)

        # Check uncommitted changes
        uncommitted_count=$(git status -s 2>/dev/null | wc -l)

        # Check unpushed commits
        unpushed_count=$(git log origin/$branch..$branch --oneline 2>/dev/null | wc -l)

        # Check if branch exists on remote
        if ! git rev-parse origin/$branch >/dev/null 2>&1; then
            unpushed_status="no_remote"
        else
            unpushed_status="$unpushed_count"
        fi

        # Only show if there are issues
        if [ "$uncommitted_count" -gt 0 ] || [ "$unpushed_status" != "0" ]; then
            has_issues=1
            echo -e "${RED}⚠️  $project_name${NC}"
            echo -e "   ${CYAN}📌 Branch: $branch${NC}"

            if [ "$uncommitted_count" -gt 0 ]; then
                echo -e "   ${YELLOW}📝 Uncommitted: $uncommitted_count files${NC}"
                git status -s | head -5 | sed 's/^/      /'
                if [ "$uncommitted_count" -gt 5 ]; then
                    echo "      ... and $((uncommitted_count - 5)) more"
                fi
            fi

            if [ "$unpushed_status" = "no_remote" ]; then
                echo -e "   ${YELLOW}⬆️  Unpushed: Branch not on remote (needs first push)${NC}"
            elif [ "$unpushed_status" != "0" ]; then
                echo -e "   ${YELLOW}⬆️  Unpushed: $unpushed_status commits${NC}"
                git log origin/$branch..$branch --oneline 2>/dev/null | head -3 | sed 's/^/      /'
                if [ "$unpushed_status" -gt 3 ]; then
                    echo "      ... and $((unpushed_status - 3)) more"
                fi
            fi

            echo -e "   ${GREEN}🚀 Open with: cd $project_dir${NC}"
            echo ""
        fi
    fi
done

if [ "$has_issues" -eq 0 ]; then
    echo -e "${GREEN}✅ All projects are clean and pushed!${NC}"
    echo ""
fi

# Active terminal sessions
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}🖥️  ACTIVE TERMINAL SESSIONS${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Check tmux sessions
tmux_sessions=$(tmux ls 2>/dev/null)
if [ -n "$tmux_sessions" ]; then
    echo -e "${CYAN}📺 Tmux Sessions:${NC}"
    echo "$tmux_sessions" | sed 's/^/   /'
    echo ""
else
    echo "   No tmux sessions active"
    echo ""
fi

# Check for running AI processes
ai_count=$(ps aux | grep -E "(claude|gemini|grok)" | grep -v grep | wc -l)
if [ "$ai_count" -gt 0 ]; then
    echo -e "${CYAN}🤖 AI Processes: $ai_count active${NC}"
    echo ""
else
    echo "   No AI processes detected"
    echo ""
fi

# Today's priorities
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}🎯 TODAY'S PRIORITIES${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""

if [ "$has_issues" -gt 0 ]; then
    echo -e "${RED}⚠️  ATTENTION NEEDED:${NC}"
    echo "   1. Review projects above with uncommitted/unpushed changes"
    echo "   2. Decide: commit now or continue work?"
    echo ""
fi

echo "Quick Actions:"
echo "   • View interactive dashboard: ${GREEN}dashboard${NC}"
echo "   • Quick commit: ${GREEN}qc \"message\"${NC}"
echo "   • Sync context: ${GREEN}sync-context${NC}"
echo "   • End of day: ${GREEN}eod${NC}"
echo ""

# SuperDesign reminder if Claude Code is detected
if ps aux | grep -q "code.*claude" | grep -v grep; then
    echo -e "${CYAN}💡 SuperDesign Tools Ready:${NC}"
    echo "   Try: 'Generate 3 dashboard UI variations'"
    echo ""
fi

echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}📖 QUICK REFERENCES${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Dashboard:"
echo "  ${GREEN}dashboard${NC}       - Open live terminal monitor"
echo "  ${GREEN}monitor${NC}         - Update dashboard data"
echo ""
echo "Git:"
echo "  ${GREEN}qc \"msg\"${NC}       - Quick commit with message"
echo "  ${GREEN}qp${NC}              - Quick push"
echo ""
echo "Context:"
echo "  ${GREEN}sync-context${NC}    - Sync AI context files"
echo "  ${GREEN}morning${NC}         - This briefing"
echo "  ${GREEN}eod${NC}             - End of day capture"
echo ""

# Yesterday's files
if [ -f "$YESTERDAY_FILE" ]; then
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📁 YESTERDAY'S FILES${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Session log:"
    echo "  cat $YESTERDAY_FILE"
    echo ""

    if [ -f "$SESSION_DIR/$YESTERDAY-dashboard-snapshot.html" ]; then
        echo "Dashboard snapshot:"
        echo "  xdg-open $SESSION_DIR/$YESTERDAY-dashboard-snapshot.html"
        echo ""
    fi
fi

echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                  Ready to start fresh! 🚀                    ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
