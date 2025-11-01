#!/bin/bash

# Terminal Work - Convenient Bash Aliases
# Add to ~/.bashrc: source ~/projects/terminal-work/config/bash-aliases.sh

# Quick commit aliases
alias qc='~/projects/terminal-work/scripts/quick-commit.sh'
alias commit='~/projects/terminal-work/scripts/quick-commit.sh'

# End of day workflow
alias eod='~/projects/terminal-work/scripts/end-of-day.sh'
alias endday='~/projects/terminal-work/scripts/end-of-day.sh'

# Context sync
alias sync-context='~/projects/terminal-work/scripts/context-sync.sh'
alias ctx='~/projects/terminal-work/scripts/context-sync.sh'

# Navigate to project
alias tw='cd ~/projects/terminal-work'
alias terminal-work='cd ~/projects/terminal-work'

# Quick git status in project
alias tws='cd ~/projects/terminal-work && git status'

# Quick push
alias qp='git push'

# Combined: add all, commit, push
alias acp='git add -A && git commit -m'

# Morning briefing (functions work better than aliases with command substitution)
morning() {
    # Use enhanced real-time morning briefing
    ~/projects/terminal-work/scripts/morning-briefing.sh
}

briefing() { morning; }
standup() { morning; }

# Dashboard aliases
alias dashboard='xdg-open http://localhost:8888/terminal-session-monitor-v1.html'
alias monitor='~/projects/terminal-work/scripts/session-monitor.sh'
alias watch-dash='~/projects/terminal-work/scripts/watch-dashboard.sh'
alias dash='dashboard'

# Project scan alias
alias scan='~/projects/terminal-work/scripts/scan-projects.sh'
alias status='~/projects/terminal-work/scripts/scan-projects.sh'

echo "Terminal Work aliases loaded!"
echo "Available: qc, commit, eod, endday, morning, briefing, standup, sync-context, ctx, tw, tws, qp, acp, dashboard, monitor, watch-dash, dash, scan, status"

# Add port management aliases to main bash aliases
source ~/projects/terminal-work/config/bash-aliases-ports.sh

# Docker management aliases
alias docker-show='~/projects/terminal-work/scripts/docker-monitor.sh show'
alias docker-status='~/projects/terminal-work/scripts/docker-monitor.sh show'
alias archon-status='~/projects/terminal-work/scripts/docker-monitor.sh archon'
alias archon-logs='~/projects/terminal-work/scripts/docker-monitor.sh logs'
alias archon-start='~/projects/terminal-work/scripts/docker-monitor.sh start archon'
alias archon-stop='~/projects/terminal-work/scripts/docker-monitor.sh stop archon'
alias archon-restart='~/projects/terminal-work/scripts/docker-monitor.sh restart archon'
alias open-archon='xdg-open http://localhost:3737'

echo "Docker aliases loaded: docker-show, docker-status, archon-status, archon-logs, archon-start, archon-stop, archon-restart, open-archon"

# Terminal title management
alias set-title='~/projects/terminal-work/scripts/set-terminal-title.sh'
alias title='~/projects/terminal-work/scripts/set-terminal-title.sh'

# Quick project context setters
set-master() {
    ~/projects/terminal-work/scripts/set-terminal-title.sh "🎯 MASTER"
    source ~/projects/terminal-work/config/bash-prompt-project.sh 2>/dev/null
    cd ~/projects/terminal-work
    echo "════════════════════════════════════════════════════════════════"
    echo "  MASTER TERMINAL - Cross-Project Command & Control"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "Location: terminal-work"
    echo "Purpose: General work, multi-project coordination, AI delegation"
    echo ""
    echo "Available AIs:"
    echo "  • Claude Code (this session)"
    echo "  • Gemini CLI (gemini)"
    echo "  • Codex (codex)"
    echo "  • Grok (opencode)"
    echo "  • Perplexity (ai)"
    echo ""
    echo "Quick commands: morning, scan, ports, docker-show, archon-status"
    echo "════════════════════════════════════════════════════════════════"
}

set-serp() {
    ~/projects/terminal-work/scripts/set-terminal-title.sh "SERP Master"
    cd ~/serp-master
    echo "✓ Context: SERP Master (SEO Platform)"
    echo "  Port: 3000 (frontend), 8000 (backend)"
    echo "  Start: start-serp or npm run dev"
}

set-erp() {
    ~/projects/terminal-work/scripts/set-terminal-title.sh "My-ERP-Plan"
    cd ~/projects/genesis-skills-test/my-erp-plan
    echo "✓ Context: My-ERP-Plan (Emergency Response)"
    echo "  Port: 3001"
    echo "  Start: start-erp or npm run dev"
}

set-rok() {
    ~/projects/terminal-work/scripts/set-terminal-title.sh "ROK Copilot"
    cd ~/projects/rok-copilot
    echo "✓ Context: ROK Copilot (AI Assistant)"
    echo "  Port: 3002"
    echo "  Start: start-rok or npm run dev"
}

set-prism() {
    ~/projects/terminal-work/scripts/set-terminal-title.sh "Prism Specialties"
    cd ~/prism-specialties-dmv-empire
    echo "✓ Context: Prism Specialties (Landing Pages)"
    echo "  Port: 3003"
    echo "  Start: start-prism"
}

set-commercial() {
    ~/projects/terminal-work/scripts/set-terminal-title.sh "Commercial Lead Gen"
    cd ~/Developer/projects/personal/commercial-lead-gen
    echo "✓ Context: Commercial Lead Gen (Restoration Platform)"
    echo "  Port: 3008"
    echo "  Start: npm run dev"
}

echo "Terminal title aliases loaded: set-title, title, set-master, set-serp, set-erp, set-rok, set-prism, set-commercial"

# Project State Snapshot System
alias snapshot='~/projects/terminal-work/scripts/snapshot-create.sh'
alias snapshot-create='~/projects/terminal-work/scripts/snapshot-create.sh'
alias snapshot-resume='~/projects/terminal-work/scripts/snapshot-resume.sh'
alias snapshot-list='~/projects/terminal-work/scripts/snapshot-resume.sh list'

# AI Session Handoff System
alias handoff-to-cc='~/projects/terminal-work/scripts/handoff-to-cc.sh'
alias handoff-from-cc='~/projects/terminal-work/scripts/handoff-from-cc.sh'

echo "Snapshot & Handoff aliases loaded: snapshot, snapshot-create, snapshot-resume, snapshot-list, handoff-to-cc, handoff-from-cc"

# Markdown to HTML Viewer
alias md2html='~/projects/terminal-work/scripts/md2html.sh'
alias view-md='~/projects/terminal-work/scripts/md2html.sh'
alias mdview='~/projects/terminal-work/scripts/md2html.sh'

echo "MD Viewer aliases loaded: md2html, view-md, mdview"

# AI Router - Smart LLM Selection
alias ai-router='~/projects/terminal-work/scripts/ai-router.sh'
alias ask-ai='~/projects/terminal-work/scripts/ai-router.sh'
alias ai-select='~/projects/terminal-work/scripts/ai-router.sh'
alias ai-stats='~/projects/terminal-work/scripts/ai-router.sh stats'

# Enhanced AI Router - Task Analysis & Smart Routing
alias ai-route='~/projects/terminal-work/scripts/ai-route-task.sh'
alias route-task='~/projects/terminal-work/scripts/ai-route-task.sh'
alias which-ai='~/projects/terminal-work/scripts/ai-route-task.sh'

echo "AI Router aliases loaded: ai-router, ask-ai, ai-select, ai-stats, ai-route, route-task, which-ai"
