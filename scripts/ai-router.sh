#!/bin/bash

# AI Router - Smart LLM Selection System
# Choose the right AI for your task and save tokens

CONFIG_DIR="$HOME/.config/terminal-work"
USAGE_LOG="$CONFIG_DIR/ai-usage.json"
mkdir -p "$CONFIG_DIR"

# Initialize usage log if it doesn't exist
if [ ! -f "$USAGE_LOG" ]; then
    echo '{"sessions": [], "total_cost_saved": 0}' > "$USAGE_LOG"
fi

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Task complexity analyzer
analyze_task_complexity() {
    local task="$1"
    local complexity="medium"
    local reason=""

    # Convert to lowercase for matching
    local task_lower=$(echo "$task" | tr '[:upper:]' '[:lower:]')

    # Simple tasks (good for Haiku/cheaper models)
    if echo "$task_lower" | grep -qE "explain|what is|how do|simple|quick|list|show|display|check|status|help"; then
        complexity="simple"
        reason="Informational query or simple operation"

    # Complex tasks (need Sonnet/better models)
    elif echo "$task_lower" | grep -qE "refactor|architect|design|implement|complex|algorithm|debug|optimize|migrate|security|performance"; then
        complexity="complex"
        reason="Requires deep reasoning or complex implementation"

    # Code review/analysis (medium)
    elif echo "$task_lower" | grep -qE "review|analyze|compare|suggest|improve"; then
        complexity="medium"
        reason="Analysis or improvement task"
    fi

    echo "$complexity:$reason"
}

# Display available AIs with recommendations
show_ai_menu() {
    local task="$1"
    local complexity_info=$(analyze_task_complexity "$task")
    local complexity=$(echo "$complexity_info" | cut -d: -f1)
    local reason=$(echo "$complexity_info" | cut -d: -f2-)

    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}                    AI Router - Smart LLM Selection${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}Task:${NC} $task"
    echo ""
    echo -e "${YELLOW}Complexity Analysis:${NC} ${MAGENTA}$complexity${NC}"
    echo -e "${YELLOW}Reason:${NC} $reason"
    echo ""
    echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
    echo -e "${GREEN}Available AI Models:${NC}"
    echo ""

    # Recommended based on complexity
    if [ "$complexity" = "simple" ]; then
        echo -e "  ${GREEN}1)${NC} Claude Haiku 4.5     ${CYAN}[RECOMMENDED]${NC} - Fast & cheap (80% cost savings)"
        echo -e "  ${BLUE}2)${NC} Gemini               ${CYAN}[RECOMMENDED]${NC} - Good for quick queries"
    elif [ "$complexity" = "complex" ]; then
        echo -e "  ${GREEN}1)${NC} Claude Sonnet 4.5    ${CYAN}[RECOMMENDED]${NC} - Best for complex tasks"
        echo -e "  ${BLUE}2)${NC} Claude Haiku 4.5     - Cheaper alternative (may need guidance)"
    else
        echo -e "  ${GREEN}1)${NC} Claude Haiku 4.5     ${CYAN}[RECOMMENDED]${NC} - Good balance of cost/quality"
        echo -e "  ${BLUE}2)${NC} Claude Sonnet 4.5    - If you need extra power"
    fi

    echo ""
    echo -e "${CYAN}Other Options:${NC}"
    echo -e "  3) Gemini               - Google's multimodal AI"
    echo -e "  4) Codex                - Code-focused AI"
    echo -e "  5) OpenCode (Grok)      - Free alternative"
    echo -e "  6) Perplexity           - Research & web search"
    echo ""
    echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
    echo ""
}

# Execute task with selected AI
execute_with_ai() {
    local ai="$1"
    local task="$2"
    local model_name=""
    local cost_multiplier=1.0

    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"

    case "$ai" in
        1|haiku)
            model_name="Claude Haiku 4.5 (OpenRouter)"
            cost_multiplier=0.2
            echo -e "${GREEN}Using Claude Haiku 4.5 via OpenRouter${NC}"
            echo -e "${YELLOW}Note: You need OpenRouter API key configured${NC}"
            echo ""
            echo "Command would be:"
            echo "  curl https://openrouter.ai/api/v1/chat/completions \\"
            echo "    -H \"Authorization: Bearer \$OPENROUTER_API_KEY\" \\"
            echo "    -d '{\"model\": \"anthropic/claude-3-5-haiku\", \"messages\": [...]}'"
            ;;

        2|sonnet)
            model_name="Claude Sonnet 4.5 (Claude Code)"
            cost_multiplier=1.0
            echo -e "${GREEN}Using Claude Sonnet 4.5 via Claude Code${NC}"
            echo -e "${YELLOW}Start a new Claude Code session for this task${NC}"
            ;;

        3|gemini)
            model_name="Gemini"
            cost_multiplier=0.3
            echo -e "${GREEN}Using Gemini${NC}"
            echo ""
            gemini "$task"
            ;;

        4|codex)
            model_name="Codex"
            cost_multiplier=0.4
            echo -e "${GREEN}Using Codex${NC}"
            echo ""
            codex "$task"
            ;;

        5|grok|opencode)
            model_name="OpenCode (Grok)"
            cost_multiplier=0.0
            echo -e "${GREEN}Using OpenCode (Free Grok)${NC}"
            echo ""
            opencode "$task"
            ;;

        6|perplexity|ai)
            model_name="Perplexity"
            cost_multiplier=0.5
            echo -e "${GREEN}Using Perplexity${NC}"
            echo ""
            ai "$task"
            ;;

        *)
            echo -e "${RED}Invalid selection${NC}"
            return 1
            ;;
    esac

    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"

    # Log usage
    log_usage "$model_name" "$task" "$cost_multiplier"

    # Show cost savings if not using Sonnet
    if [ "$ai" != "2" ] && [ "$ai" != "sonnet" ]; then
        local savings=$( echo "scale=0; (1.0 - $cost_multiplier) * 100" | bc )
        echo ""
        echo -e "${GREEN}💰 Estimated cost savings: ${savings}% vs Claude Sonnet${NC}"
    fi
}

# Log AI usage for tracking
log_usage() {
    local model="$1"
    local task="$2"
    local cost_multiplier="$3"
    local timestamp=$(date -Iseconds)

    # Append to usage log (simplified - would be JSON in production)
    echo "[$timestamp] $model - Cost multiplier: $cost_multiplier - Task: $task" >> "$CONFIG_DIR/ai-usage.log"
}

# Show usage statistics
show_stats() {
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}                    AI Usage Statistics${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""

    if [ ! -f "$CONFIG_DIR/ai-usage.log" ]; then
        echo "No usage data yet. Start using the AI router to track your savings!"
        return
    fi

    echo -e "${GREEN}Recent AI Usage:${NC}"
    echo ""
    tail -10 "$CONFIG_DIR/ai-usage.log" | while read line; do
        echo "  $line"
    done
    echo ""

    # Count usage by model
    echo -e "${GREEN}Usage by Model:${NC}"
    echo ""
    grep -o "Using [^-]*" "$CONFIG_DIR/ai-usage.log" 2>/dev/null | sort | uniq -c | while read count model; do
        echo "  $count sessions - $model"
    done

    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
}

# Main function
main() {
    local task="$*"

    # If no task provided, show help
    if [ -z "$task" ]; then
        echo ""
        echo "AI Router - Smart LLM Selection System"
        echo ""
        echo "Usage:"
        echo "  ai-router \"your task description\""
        echo "  ai-router stats              # Show usage statistics"
        echo ""
        echo "Examples:"
        echo "  ai-router \"explain how async/await works\""
        echo "  ai-router \"refactor this complex algorithm\""
        echo "  ai-router \"list available npm packages\""
        echo ""
        return 0
    fi

    # Show stats command
    if [ "$task" = "stats" ] || [ "$task" = "statistics" ]; then
        show_stats
        return 0
    fi

    # Show menu and get selection
    show_ai_menu "$task"

    echo -ne "${YELLOW}Select AI (1-6):${NC} "
    read -r selection

    execute_with_ai "$selection" "$task"
}

# Run main function
main "$@"
