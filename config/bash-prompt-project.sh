#!/bin/bash
# Enhanced Bash Prompt with Project Context
# Adds visual project name to prompt for quick identification

# Colors
COLOR_RESET='\[\033[0m\]'
COLOR_USER='\[\033[1;32m\]'      # Green for username
COLOR_DIR='\[\033[1;34m\]'       # Blue for directory
COLOR_GIT='\[\033[1;36m\]'       # Cyan for git branch
COLOR_PROJECT='\[\033[1;35m\]'   # Magenta for project name

# Function to get git branch
git_branch() {
    git branch 2>/dev/null | grep '^*' | sed 's/* //'
}

# Function to detect project context
detect_project() {
    local current_dir=$(pwd)

    # Check for known projects
    case "$current_dir" in
        */terminal-work*)
            echo "🎯 MASTER"
            ;;
        */serp-master*)
            echo "SERP"
            ;;
        */my-erp-plan*)
            echo "ERP"
            ;;
        */rok-copilot*)
            echo "ROK"
            ;;
        */prism-specialties*)
            echo "PRISM"
            ;;
        */commercial-lead-gen*)
            echo "COMMERCIAL"
            ;;
        *)
            # Check if in git repo
            if git rev-parse --git-dir > /dev/null 2>&1; then
                local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
                if [ -n "$git_root" ]; then
                    basename "$git_root" | tr '[:lower:]' '[:upper:]' | cut -c1-10
                fi
            fi
            ;;
    esac
}

# Build the prompt
build_prompt() {
    local project=$(detect_project)
    local git_br=$(git_branch)

    # Start with project name if available
    if [ -n "$project" ]; then
        PS1="${COLOR_PROJECT}[$project]${COLOR_RESET} "
    else
        PS1=""
    fi

    # Add username@host
    PS1+="${COLOR_USER}\u@\h${COLOR_RESET}:"

    # Add directory
    PS1+="${COLOR_DIR}\w${COLOR_RESET}"

    # Add git branch if in repo
    if [ -n "$git_br" ]; then
        PS1+="${COLOR_GIT} ($git_br)${COLOR_RESET}"
    fi

    # Add prompt symbol
    PS1+="\$ "
}

# Set PROMPT_COMMAND to rebuild prompt on each command
PROMPT_COMMAND='build_prompt'

# Initial build
build_prompt
