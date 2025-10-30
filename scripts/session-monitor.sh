#!/bin/bash

# Terminal Session Monitor - Data Collection Script
# Collects real-time data about terminal sessions and generates JSON for dashboard

DASHBOARD_DIR="/home/klatt42/projects/terminal-work/superdesign/design_iterations"
SESSION_DATA_FILE="$DASHBOARD_DIR/session-data.json"

# Define all project directories to monitor (matching scan-projects.sh)
PROJECT_DIRS=(
    "$HOME/projects"
    "$HOME/serp-master"
    "$HOME/projects/genesis-skills-test/my-erp-plan"
)

# Function to get git status for a directory
get_git_status() {
    local dir=$1
    cd "$dir" 2>/dev/null || return

    if [ -d ".git" ]; then
        local branch=$(git branch --show-current 2>/dev/null || echo "unknown")
        local uncommitted=$(git status --porcelain 2>/dev/null | wc -l)
        local status="clean"
        if [ "$uncommitted" -gt 0 ]; then
            status="dirty"
        fi
        echo "$branch|$status|$uncommitted"
    else
        echo "none|n/a|0"
    fi
}

# Function to get last command from history
get_last_command() {
    local dir=$1
    local history_file="$dir/.bash_history"
    if [ -f "$history_file" ]; then
        tail -1 "$history_file"
    else
        echo "No history available"
    fi
}

# Function to detect AI in use based on recent commands
detect_ai() {
    local dir=$1
    local history_file="$dir/.bash_history"

    if [ -f "$history_file" ]; then
        local recent=$(tail -10 "$history_file")
        if echo "$recent" | grep -q "claude\|code"; then
            echo "Claude Code"
        elif echo "$recent" | grep -q "gemini"; then
            echo "Gemini CLI"
        elif echo "$recent" | grep -q "opencode\|grok"; then
            echo "OpenCode"
        elif echo "$recent" | grep -q "^ai "; then
            echo "Perplexity"
        elif echo "$recent" | grep -q "codex"; then
            echo "Codex"
        else
            echo "None"
        fi
    else
        echo "None"
    fi
}

# Function to check if tmux session is active for a project
is_tmux_active() {
    local project_name=$1
    tmux list-sessions 2>/dev/null | grep -q "$project_name" && echo "true" || echo "false"
}

# Function to get session uptime (placeholder - would need more sophisticated tracking)
get_session_uptime() {
    # In production, this would track actual session start time
    # For now, return a placeholder
    echo "Unknown"
}

# Main function to collect all session data
collect_session_data() {
    local sessions="["
    local first=true
    local session_count=0

    # Scan all configured project directories
    for dir in "${PROJECT_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            # If it's a directory with projects inside
            if [ -d "$dir/.git" ]; then
                # It's a git repo itself
                local project_dir="$dir"
                local project_name=$(basename "$project_dir")

            # Get git info
            local git_info=$(get_git_status "$project_dir")
            IFS='|' read -r branch status uncommitted <<< "$git_info"

            # Detect AI in use
            local ai=$(detect_ai "$project_dir")

            # Check if tmux session is active
            local active=$(is_tmux_active "$project_name")

            # Get last command
            local last_cmd=$(get_last_command "$project_dir" | head -c 50)

            # Get uptime
            local uptime=$(get_session_uptime "$project_name")

            # Get recent commands (last 3)
            local recent_cmds="["
            if [ -f "$project_dir/.bash_history" ]; then
                local cmd_first=true
                while IFS= read -r cmd; do
                    if [ "$cmd_first" = false ]; then
                        recent_cmds+=","
                    fi
                    recent_cmds+="{\"prompt\":\"\$\",\"command\":\"$(echo "$cmd" | sed 's/"/\\"/g' | head -c 50)\"}"
                    cmd_first=false
                done < <(tail -3 "$project_dir/.bash_history" 2>/dev/null)
            fi
            recent_cmds+="]"

            # Build session JSON
            if [ "$first" = false ]; then
                sessions+=","
            fi

            sessions+="{
                \"id\":$session_count,
                \"title\":\"$project_name\",
                \"active\":$active,
                \"ai\":\"$ai\",
                \"path\":\"$project_dir\",
                \"uptime\":\"$uptime\",
                \"lastCommand\":\"$last_cmd\",
                \"gitStatus\":\"$status\",
                \"branch\":\"$branch\",
                \"uncommittedChanges\":$uncommitted,
                \"recentCommands\":$recent_cmds
            }"

                first=false
                ((session_count++))
            else
                # It's a directory containing multiple projects
                for project_dir in "$dir"/*; do
                    if [ -d "$project_dir/.git" ]; then
                        local project_name=$(basename "$project_dir")

                        # Get git info
                        local git_info=$(get_git_status "$project_dir")
                        IFS='|' read -r branch status uncommitted <<< "$git_info"

                        # Detect AI in use
                        local ai=$(detect_ai "$project_dir")

                        # Check if tmux session is active
                        local active=$(is_tmux_active "$project_name")

                        # Get last command
                        local last_cmd=$(get_last_command "$project_dir" | head -c 50)

                        # Get uptime
                        local uptime=$(get_session_uptime "$project_name")

                        # Get recent commands (last 3)
                        local recent_cmds="["
                        if [ -f "$project_dir/.bash_history" ]; then
                            local cmd_first=true
                            while IFS= read -r cmd; do
                                if [ "$cmd_first" = false ]; then
                                    recent_cmds+=","
                                fi
                                recent_cmds+="{\"prompt\":\"\$\",\"command\":\"$(echo "$cmd" | sed 's/"/\\"/g' | head -c 50)\"}"
                                cmd_first=false
                            done < <(tail -3 "$project_dir/.bash_history" 2>/dev/null)
                        fi
                        recent_cmds+="]"

                        # Build session JSON
                        if [ "$first" = false ]; then
                            sessions+=","
                        fi

                        sessions+="{
                            \"id\":$session_count,
                            \"title\":\"$project_name\",
                            \"active\":$active,
                            \"ai\":\"$ai\",
                            \"path\":\"$project_dir\",
                            \"uptime\":\"$uptime\",
                            \"lastCommand\":\"$last_cmd\",
                            \"gitStatus\":\"$status\",
                            \"branch\":\"$branch\",
                            \"uncommittedChanges\":$uncommitted,
                            \"recentCommands\":$recent_cmds
                        }"

                        first=false
                        ((session_count++))
                    fi
                done
            fi
        fi
    done

    sessions+="]"

    # Calculate stats
    local ai_counts=$(echo "$sessions" | grep -o '"ai":"[^"]*"' | sort | uniq -c)
    local active_count=$(echo "$sessions" | grep -c '"active":true')

    # Build final JSON
    local json="{
        \"timestamp\":\"$(date -Iseconds)\",
        \"stats\":{
            \"activeSessions\":$active_count,
            \"totalProjects\":$session_count,
            \"aiCommands\":0,
            \"gitOps\":0
        },
        \"sessions\":$sessions
    }"

    echo "$json"
}

# Create the data file
echo "Collecting terminal session data..."
SESSION_JSON=$(collect_session_data)

# Write to file
echo "$SESSION_JSON" > "$SESSION_DATA_FILE"

echo "Session data written to: $SESSION_DATA_FILE"
echo ""
echo "To view the dashboard:"
echo "  xdg-open $DASHBOARD_DIR/terminal-session-monitor-v1.html"
