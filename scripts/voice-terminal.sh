#!/bin/bash

# Terminal Voice Command Processor
# Integrates with voice2json for AI and system control

FIFO="/tmp/voice-commands"
LOG_FILE="$HOME/projects/terminal-work/logs/voice-commands.log"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Create named pipe if doesn't exist
[[ ! -p $FIFO ]] && mkfifo $FIFO

# Create log directory
mkdir -p "$(dirname "$LOG_FILE")"

log_command() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

echo -e "${BLUE}Voice Terminal Started${NC}"
echo "Listening for voice commands..."

# Process voice commands
voice2json -p en-us transcribe-wav | \
  voice2json -p en-us recognize-intent | \
  jq -r '.intent.name' > $FIFO &

# Execute commands from pipe
while read -r intent; do
  echo -e "${GREEN}Intent:${NC} $intent"
  log_command "Intent: $intent"

  case $intent in
    # Claude Code commands
    ClaudeActivate)
      tmux select-pane -t 2
      echo "Activated Claude Code terminal"
      ;;
    ClaudeShowCode)
      tmux send-keys -t 2 "claude 'show me the code structure'" Enter
      ;;
    ClaudeRunTests)
      tmux send-keys -t 2 "claude 'run all tests'" Enter
      ;;
    ClaudeCommit)
      tmux send-keys -t 2 "claude 'commit recent changes with appropriate message'" Enter
      ;;
    ClaudeSecurity)
      tmux send-keys -t 2 "claude 'Use code-reviewer subagent for security analysis'" Enter
      ;;
    ClaudeReview)
      tmux send-keys -t 2 "claude 'Use code-reviewer subagent to review code quality'" Enter
      ;;

    # Gemini CLI commands
    GeminiActivate)
      tmux select-pane -t 3
      echo "Activated Gemini CLI terminal"
      ;;
    GeminiAnalyze)
      tmux send-keys -t 3 "gemini 'Analyze the codebase structure'" Enter
      ;;
    GeminiDocs)
      tmux send-keys -t 3 "gemini 'Generate comprehensive documentation'" Enter
      ;;
    GeminiReadme)
      tmux send-keys -t 3 "gemini 'Create or update README with current project state'" Enter
      ;;

    # Grok CLI commands
    GrokActivate)
      tmux select-pane -t 4
      echo "Activated Grok CLI terminal"
      ;;
    GrokQuickCode)
      tmux send-keys -t 4 "grok 'Quick code generation based on current context'" Enter
      ;;
    GrokSearch)
      tmux send-keys -t 4 "grok 'Search files for pattern'" Enter
      ;;
    GrokTests)
      tmux send-keys -t 4 "grok 'Generate comprehensive test suite'" Enter
      ;;
    GrokRunTests)
      tmux send-keys -t 4 "grok 'Run all tests and report results'" Enter
      ;;

    # System commands
    SystemList)
      tmux send-keys -t 1 "ls -la" Enter
      ;;
    SystemCD)
      # Note: CD location would need to be extracted from voice2json slots
      echo "Change directory command received"
      ;;
    SystemGitStatus)
      tmux send-keys -t 1 "git status" Enter
      ;;
    SystemGitCommit)
      tmux send-keys -t 1 "git add . && git commit" Enter
      ;;
    SystemNpmInstall)
      tmux send-keys -t 1 "npm install" Enter
      ;;

    # Multi-AI commands
    MultiAIAnalysis)
      echo -e "${YELLOW}Running full multi-AI analysis${NC}"
      tmux send-keys -t 2 'claude "Comprehensive security and architecture analysis"' Enter
      sleep 1
      tmux send-keys -t 3 'gemini "Generate analysis documentation"' Enter
      sleep 1
      tmux send-keys -t 4 'grok "Create task list and tests from analysis"' Enter
      ;;
    MultiAIParallel)
      echo -e "${YELLOW}Starting parallel AI execution${NC}"
      ;;
    MultiAISync)
      tmux send-keys -t 1 "./scripts/context-sync.sh" Enter
      ;;

    *)
      echo -e "${YELLOW}Unknown intent:${NC} $intent"
      log_command "Unknown intent: $intent"
      ;;
  esac
done < $FIFO
