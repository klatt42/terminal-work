#!/bin/bash
# Set Terminal Tab Title - For Visual Project Identification
# Usage: set-terminal-title.sh [title]
#        set-terminal-title.sh          (auto-detect from directory)

# Function to detect project name from current directory
detect_project_name() {
    local current_dir=$(pwd)

    # Check if we're in a git repository
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Get the repository root
        local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
        if [ -n "$git_root" ]; then
            basename "$git_root"
            return 0
        fi
    fi

    # Fallback to current directory name
    basename "$current_dir"
}

# Function to set terminal title
set_title() {
    local title="$1"

    # For Windows Terminal (WSL)
    echo -ne "\033]0;${title}\007"

    # For tmux
    if [ -n "$TMUX" ]; then
        tmux rename-window "$title"
    fi

    # For screen
    if [ -n "$STY" ]; then
        screen -X title "$title"
    fi
}

# Main logic
if [ -n "$1" ]; then
    # User provided a title
    TITLE="$1"
else
    # Auto-detect from directory
    TITLE=$(detect_project_name)
fi

# Set the title
set_title "$TITLE"

# Also update PS1 to maintain title
export PROMPT_COMMAND='echo -ne "\033]0;'"$TITLE"'\007"'

echo "✓ Terminal title set to: $TITLE"
