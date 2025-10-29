#!/bin/bash

# Context Synchronization Script
# Ensures all AIs have access to latest project state

PROJECT_DIR="$HOME/projects/terminal-work"
CONTEXT_FILE="$PROJECT_DIR/AI_CONTEXT.md"
WORKFLOW_FILE="$PROJECT_DIR/WORKFLOW_STATE.md"
STATE_FILE="$PROJECT_DIR/.ai-state.json"
PATTERNS_FILE="$PROJECT_DIR/TERMINAL_PATTERNS.md"

# Create or update AI_CONTEXT.md
update_context() {
    cat > "$CONTEXT_FILE" << 'EOF'
# AI Context - Terminal Superuser

## Project Status
**Last Updated**: TIMESTAMP_PLACEHOLDER

## Active AIs
- Claude Code (Primary): Architecture, Security, Complex Reasoning
- Gemini CLI (Secondary): Documentation, Large Context Analysis
- Grok CLI (Tertiary): Code Generation, Testing, Automation

## Current Phase
Learning & Development - Multi-AI Orchestration

## Recent Completions
- Project structure initialized
- Claude Code subagents configured
- AI configuration files created
- Workflow templates established

## Active Tasks
*Updated by each AI as they work*

## Blockers
None currently

## Next Steps
1. Complete voice command setup
2. Create Genesis SKILLs
3. Begin Phase 1 learning progression
4. Document first multi-AI workflow

## Context Files
- WORKFLOW_STATE.md - Task tracking
- .ai-state.json - Programmatic state
- TERMINAL_PATTERNS.md - Discovered patterns
EOF

    # Replace timestamp
    sed -i "s/TIMESTAMP_PLACEHOLDER/$(date '+%Y-%m-%d %H:%M:%S')/" "$CONTEXT_FILE"
}

# Initialize state file
init_state() {
    cat > "$STATE_FILE" << EOF
{
  "project": "terminal-work",
  "phase": "initialization",
  "completed_tasks": [
    "project_structure_created",
    "claude_code_agents_configured",
    "ai_config_files_created",
    "workflow_templates_created"
  ],
  "current_tasks": {
    "claude_code": "initial_setup",
    "gemini_cli": "pending",
    "grok_cli": "pending"
  },
  "blockers": [],
  "next_milestone": "voice_integration_setup",
  "metrics": {
    "claude_sessions": 1,
    "gemini_sessions": 0,
    "grok_sessions": 0,
    "patterns_documented": 0,
    "workflows_created": 4
  }
}
EOF
}

# Main execution
echo "Synchronizing AI context..."
update_context
init_state
echo "Context synchronized successfully!"
echo "Files updated:"
echo "  - $CONTEXT_FILE"
echo "  - $STATE_FILE"
