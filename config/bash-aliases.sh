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
alias dashboard='xdg-open ~/projects/terminal-work/superdesign/design_iterations/terminal-session-monitor-v1.html'
alias monitor='~/projects/terminal-work/scripts/session-monitor.sh'
alias dash='dashboard'

# Project scan alias
alias scan='~/projects/terminal-work/scripts/scan-projects.sh'
alias status='~/projects/terminal-work/scripts/scan-projects.sh'

echo "Terminal Work aliases loaded!"
echo "Available: qc, commit, eod, endday, morning, briefing, standup, sync-context, ctx, tw, tws, qp, acp, dashboard, monitor, dash, scan, status"
