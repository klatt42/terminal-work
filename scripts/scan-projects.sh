#!/bin/bash
# Scan all projects for uncommitted changes and unpushed commits

# Define all project directories to scan
PROJECT_DIRS=(
    "$HOME/projects"
    "$HOME/serp-master"
)

echo "═══════════════════════════════════════════════════════════════"
echo "🔍 REAL-TIME PROJECT SCAN"
echo "═══════════════════════════════════════════════════════════════"
echo ""

has_issues=0

# Function to scan a single project
scan_project() {
    local project_dir="$1"

    if [ ! -d "$project_dir/.git" ]; then
        return
    fi

    cd "$project_dir"
    project_name=$(basename "$project_dir")
    branch=$(git branch --show-current 2>/dev/null)

    # Check uncommitted changes
    uncommitted_count=$(git status -s 2>/dev/null | wc -l)

    # Check unpushed commits
    unpushed_count=$(git log origin/$branch..$branch --oneline 2>/dev/null | wc -l)

    # Check if branch exists on remote
    if ! git rev-parse origin/$branch >/dev/null 2>&1; then
        unpushed_count="?"
    fi

    # Only show if there are issues
    if [ "$uncommitted_count" -gt 0 ] || [ "$unpushed_count" != "0" ]; then
        has_issues=1
        echo "⚠️  $project_name"
        echo "   📌 Branch: $branch"

        if [ "$uncommitted_count" -gt 0 ]; then
            echo "   📝 Uncommitted: $uncommitted_count files"
            git status -s | head -5 | sed 's/^/      /'
            if [ "$uncommitted_count" -gt 5 ]; then
                echo "      ... and $((uncommitted_count - 5)) more"
            fi
        fi

        if [ "$unpushed_count" != "0" ]; then
            if [ "$unpushed_count" = "?" ]; then
                echo "   ⬆️  Unpushed: Branch not on remote (needs first push)"
            else
                echo "   ⬆️  Unpushed: $unpushed_count commits"
                git log origin/$branch..$branch --oneline 2>/dev/null | head -3 | sed 's/^/      /'
                if [ "$unpushed_count" -gt 3 ]; then
                    echo "      ... and $((unpushed_count - 3)) more"
                fi
            fi
        fi

        echo "   📍 cd $project_dir"
        echo ""
    fi
}

# Scan all configured project directories
for dir in "${PROJECT_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        # If it's a directory with projects inside
        if [ -d "$dir/.git" ]; then
            # It's a git repo itself
            scan_project "$dir"
        else
            # It's a directory containing multiple projects
            for project_dir in "$dir"/*; do
                if [ -d "$project_dir/.git" ]; then
                    scan_project "$project_dir"
                fi
            done
        fi
    fi
done

if [ "$has_issues" -eq 0 ]; then
    echo "✅ All projects are clean and pushed!"
    echo ""
fi

echo "═══════════════════════════════════════════════════════════════"
echo "🖥️  ACTIVE TERMINAL SESSIONS"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Check tmux sessions
tmux_sessions=$(tmux ls 2>/dev/null)
if [ -n "$tmux_sessions" ]; then
    echo "📺 Tmux Sessions:"
    echo "$tmux_sessions" | sed 's/^/   /'
    echo ""
else
    echo "   No tmux sessions active"
    echo ""
fi

# Check for running AI processes
ai_processes=$(ps aux | grep -E "(claude|gemini|grok|code --extensionDevelopmentPath)" | grep -v grep)
if [ -n "$ai_processes" ]; then
    echo "🤖 AI Processes:"
    echo "$ai_processes" | awk '{print "   " $11}' | head -5
    echo ""
else
    echo "   No AI processes detected"
    echo ""
fi

echo "═══════════════════════════════════════════════════════════════"
