# Parallel AI Workflow Template

## Overview
Template for executing tasks across multiple AI assistants simultaneously.

## Standard Four-Tab Setup

```bash
# Tab 1: WSL/Ubuntu (System Commands)
# Tab 2: Claude Code (Primary AI)
# Tab 3: Gemini CLI (Secondary AI)
# Tab 4: Grok CLI (Tertiary AI)
```

## Workflow Pattern

### Task Analysis Phase
```bash
# Tab 2 (Claude Code): Analyze and plan
claude "Use multi-ai-orchestrator subagent to analyze this task and create execution plan"
```

### Parallel Execution Phase

**Architecture & Security** (Claude Code - Tab 2):
```bash
claude "Design system architecture with security-first approach"
claude "Use code-reviewer subagent for security analysis"
```

**Documentation & Analysis** (Gemini CLI - Tab 3):
```bash
gemini "Analyze codebase and generate comprehensive documentation"
gemini "Create API documentation and usage examples"
```

**Code Generation & Testing** (Grok CLI - Tab 4):
```bash
grok "Generate implementation code based on architecture"
grok "Create comprehensive test suite with unit and integration tests"
```

**System Operations** (WSL - Tab 1):
```bash
watch -n 5 "git status"  # Monitor changes
# Or execute git operations after AI work completes
```

### Synchronization Phase
```bash
# Update AI_CONTEXT.md with current state
# All AIs read updated context
# Coordinate next steps
```

## Context Sharing Strategy

### Method 1: Shared Files
- `AI_CONTEXT.md` - Current state and decisions
- `WORKFLOW_STATE.md` - Active tasks and progress
- `.ai-state.json` - Programmatic state

### Method 2: Git Commits
```bash
# Each AI commits its work
git add .
git commit -m "Claude Code: Architecture complete"
# Next AI reads commit history for context
```

## Success Metrics
- Task completion time vs single AI
- Quality of parallel work coordination
- Context synchronization effectiveness
- Overall productivity improvement
