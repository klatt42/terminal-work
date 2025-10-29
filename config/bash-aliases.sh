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

echo "Terminal Work aliases loaded!"
echo "Available: qc, commit, eod, endday, sync-context, ctx, tw, tws, qp, acp"
