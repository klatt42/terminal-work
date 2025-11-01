#!/bin/bash

# Enhanced AI Router with Capability Matrix
# Smart AI selection based on task type, project context, and AI strengths

CONFIG_FILE="$HOME/projects/terminal-work/config/ai-capabilities.json"

# Color codes
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Advanced task categorization
categorize_task() {
    local task="$1"
    local task_lower=$(echo "$task" | tr '[:upper:]' '[:lower:]')

    # Check for task categories
    if echo "$task_lower" | grep -qE "implement|build|create|develop|write code"; then
        echo "implementation:sonnet,codex"
    elif echo "$task_lower" | grep -qE "refactor|improve|optimize|restructure|clean"; then
        echo "refactoring:sonnet,haiku"
    elif echo "$task_lower" | grep -qE "research|find|search|investigate|explore|compare"; then
        echo "research:perplexity,gemini"
    elif echo "$task_lower" | grep -qE "explain|what is|how does|describe|help me understand"; then
        echo "explanation:haiku,gemini"
    elif echo "$task_lower" | grep -qE "debug|fix|error|bug|not working|broken"; then
        echo "debugging:sonnet,codex"
    elif echo "$task_lower" | grep -qE "review|analyze|check|audit|assess"; then
        echo "code_review:sonnet,haiku"
    elif echo "$task_lower" | grep -qE "quick|simple|list|show|display|status"; then
        echo "quick_query:haiku,grok"
    elif echo "$task_lower" | grep -qE "analyze data|process|parse|extract|transform"; then
        echo "data_analysis:gemini,sonnet"
    else
        echo "general:haiku,sonnet"
    fi
}

# Get project context
get_project_context() {
    local cwd=$(pwd)
    local project_name=$(basename "$cwd")

    case "$project_name" in
        serp-master)
            echo "SEO Platform (React/Node) - Recommend: Sonnet"
            ;;
        rok-copilot)
            echo "AI Assistant (React/AI) - Recommend: Sonnet"
            ;;
        terminal-work)
            echo "Automation Scripts (Bash/Python) - Recommend: Haiku"
            ;;
        my-erp-plan)
            echo "ERP System (Full-stack) - Recommend: Sonnet"
            ;;
        *)
            echo "General Project - Recommend: Based on task"
            ;;
    esac
}

# Show enhanced routing suggestions
show_smart_routing() {
    local task="$1"
    local category_info=$(categorize_task "$task")
    local category=$(echo "$category_info" | cut -d: -f1)
    local recommended=$(echo "$category_info" | cut -d: -f2)
    local project_ctx=$(get_project_context)

    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}           Smart AI Router - Enhanced Task Analysis${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}Task:${NC} $task"
    echo ""
    echo -e "${YELLOW}Task Category:${NC} ${MAGENTA}${category}${NC}"
    echo -e "${YELLOW}Project Context:${NC} ${BLUE}${project_ctx}${NC}"
    echo ""
    echo -e "${GREEN}🎯 Recommended AIs (in order):${NC}"

    # Parse and display recommendations
    IFS=',' read -ra AIS <<< "$recommended"
    local rank=1
    for ai in "${AIS[@]}"; do
        case "$ai" in
            sonnet)
                echo -e "  ${rank}. ${GREEN}Claude Sonnet 4.5${NC} - Best for complex tasks (via Claude Code)"
                ;;
            haiku)
                echo -e "  ${rank}. ${BLUE}Claude Haiku 4.5${NC} - 80% cheaper, great for this task"
                ;;
            gemini)
                echo -e "  ${rank}. ${MAGENTA}Gemini${NC} - Multimodal, research-focused"
                ;;
            perplexity)
                echo -e "  ${rank}. ${YELLOW}Perplexity${NC} - Research with citations"
                ;;
            codex)
                echo -e "  ${rank}. ${CYAN}Codex${NC} - Code generation specialist"
                ;;
            grok)
                echo -e "  ${rank}. ${GREEN}Grok${NC} - Free alternative (OpenCode)"
                ;;
        esac
        ((rank++))
    done

    echo ""
    echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
    echo -e "${YELLOW}💡 Smart Suggestion:${NC}"

    # Provide contextual advice
    case "$category" in
        implementation|refactoring|debugging)
            echo "  This is a complex task. Claude Sonnet (via Claude Code) is recommended."
            echo "  Estimated cost savings with Haiku: Not recommended for this complexity."
            ;;
        research)
            echo "  Research tasks work best with Perplexity (citations) or Gemini (multimodal)."
            echo "  Estimated cost savings: 50-70% vs Sonnet"
            ;;
        explanation|quick_query)
            echo "  Simple task! Use Haiku or Grok to save 80-100% vs Sonnet."
            echo "  You don't need the expensive model for this."
            ;;
        code_review)
            echo "  Code review can use either Sonnet (thorough) or Haiku (quick)."
            echo "  Estimated cost savings with Haiku: 80%"
            ;;
        *)
            echo "  Based on task analysis, Haiku should work well (80% cheaper)."
            ;;
    esac

    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
}

# Main routing function
main() {
    local task="$*"

    if [ -z "$task" ]; then
        echo ""
        echo "Smart AI Router - Enhanced with Capability Matrix"
        echo ""
        echo "Usage:"
        echo "  ai-route-task \"your task description\""
        echo ""
        echo "Examples:"
        echo "  ai-route-task \"implement OAuth authentication\""
        echo "    → Recommends: Sonnet (complex implementation)"
        echo ""
        echo "  ai-route-task \"explain how JWT tokens work\""
        echo "    → Recommends: Haiku (simple explanation, 80% cheaper)"
        echo ""
        echo "  ai-route-task \"research best React state management libraries\""
        echo "    → Recommends: Perplexity (research with citations)"
        echo ""
        return 0
    fi

    show_smart_routing "$task"

    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Use ${GREEN}ai-router${NC} to actually run the task with your chosen AI"
    echo "  2. Or start a Claude Code session if using Sonnet"
    echo "  3. Track your savings with ${GREEN}ai-stats${NC}"
    echo ""
}

main "$@"
