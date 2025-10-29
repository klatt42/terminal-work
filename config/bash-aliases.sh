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
    local briefing_file=$(ls -t ~/projects/terminal-work/notes/daily-sessions/*-morning-briefing.sh 2>/dev/null | head -1)
    if [ -n "$briefing_file" ]; then
        bash "$briefing_file"
    else
        echo "No morning briefing found. Run 'eod' tonight to generate one!"
    fi
}

briefing() { morning; }
standup() { morning; }

echo "Terminal Work aliases loaded!"
echo "Available: qc, commit, eod, endday, morning, briefing, standup, sync-context, ctx, tw, tws, qp, acp"
