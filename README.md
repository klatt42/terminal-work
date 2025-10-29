# Terminal Superuser

Multi-AI terminal orchestration and mastery project for learning and development.

## Overview

Master terminal-based development workflows by orchestrating multiple AI assistants simultaneously. This project demonstrates how to leverage each AI's unique strengths for maximum productivity.

## Stack

- **Claude Code** (Primary) - Advanced reasoning, security analysis, complex orchestration
- **Gemini CLI** (Secondary) - Large context analysis (1M tokens), fast documentation
- **Grok CLI** (Tertiary) - High-speed code generation, cost-effective testing
- **Voice Commands** (Optional) - Hands-free terminal operation

## Quick Start

```bash
# 1. Verify Claude Code (already installed)
claude --version

# 2. Install Gemini CLI
npm install -g @google/gemini-cli
gemini  # Follow authentication prompts

# 3. Install Grok CLI (optional)
npm install -g @vibe-kit/grok-cli
export GROK_API_KEY="your-xai-api-key"

# 4. Initialize context
./scripts/context-sync.sh

# 5. Read the quick start guide
cat QUICKSTART.md
```

## Project Structure

```
terminal-work/
├── .claude/agents/          # 6 specialized Claude Code subagents
├── .grok/                   # Grok CLI configuration
├── config/                  # Voice command configurations
├── scripts/                 # Automation and orchestration scripts
├── workflows/               # Workflow templates
├── skills/                  # Genesis SKILL definitions
├── notes/                   # Learning documentation
├── AI_CONTEXT.md            # Current project state (all AIs read this)
├── WORKFLOW_STATE.md        # Task tracking
├── TERMINAL_PATTERNS.md     # Discovered best practices
└── QUICKSTART.md            # Detailed setup guide
```

## Key Features

### 6 Specialized Claude Code Subagents
- **terminal-researcher** - Command research and documentation
- **multi-ai-orchestrator** - Cross-AI workflow coordination
- **code-reviewer** - Security and quality analysis
- **docs-generator** - Documentation creation
- **workflow-optimizer** - Performance optimization
- **voice-command-handler** - Voice integration

### Multi-AI Orchestration
Run different tasks simultaneously across multiple AI assistants:
```bash
# Tab 1: System monitoring
watch -n 5 "git status"

# Tab 2: Claude Code - Architecture
claude "Design system with security-first approach"

# Tab 3: Gemini CLI - Documentation
gemini "Generate comprehensive documentation"

# Tab 4: Grok CLI - Testing
grok "Create complete test suite"
```

### Context Synchronization
All AIs stay synchronized through shared context files:
- `AI_CONTEXT.md` - Current project state
- `WORKFLOW_STATE.md` - Active tasks
- `.ai-state.json` - Programmatic state

### Voice Control (Optional)
Hands-free terminal operation with voice commands:
- "activate claude" → Switch to Claude Code
- "run tests" → Execute test suite
- "sync context" → Update shared state

### Genesis Integration
Includes `genesis-terminal-orchestration` SKILL for reusable patterns compatible with Genesis v1.6.0+.

## AI Assignment Strategy

| Task Type | Optimal AI | Why |
|-----------|-----------|-----|
| Architecture | Claude Code | Deep reasoning |
| Security | Claude Code | Critical analysis |
| Documentation | Gemini CLI | Large context (1M tokens) |
| Code Generation | Grok CLI | Speed + cost |
| Testing | Grok CLI | Automation |

## Learning Progression

### Phase 1: Foundation (Week 1-2)
- Install and configure all AI assistants
- Master basic terminal commands
- Test first multi-AI workflow
- Optional: Set up voice commands

### Phase 2: Intermediate (Week 3-4)
- Master subagent patterns
- Optimize parallel workflows
- Create custom SKILLs
- Voice-triggered automation

### Phase 3: Advanced (Week 5-6)
- Complex multi-AI workflows
- Genesis SKILL contributions
- Maximum productivity optimization

### Phase 4: Mastery (Week 7-8)
- Train others
- Develop proprietary workflows
- Open-source contributions

## Documentation

- **QUICKSTART.md** - Detailed setup and first workflows
- **AI_CONTEXT.md** - Current project state (read regularly!)
- **WORKFLOW_STATE.md** - Task tracking and progress
- **TERMINAL_PATTERNS.md** - Discovered patterns and best practices
- **workflows/** - Workflow templates and examples
- **skills/** - Genesis SKILL definitions

## Scripts

- `scripts/context-sync.sh` - Synchronize AI context
- `scripts/ai-orchestrator.sh` - Multi-AI coordination helper
- `scripts/voice-terminal.sh` - Voice command handler

## Status

✅ **Phase 1 Setup Complete**
- [x] Project structure initialized
- [x] Claude Code configured with 6 subagents
- [x] AI configuration files created
- [x] Workflow templates established
- [x] Voice command configs ready
- [x] Genesis SKILL created
- [x] Documentation complete

**Next Steps**:
- [ ] Install Gemini CLI
- [ ] Install Grok CLI (optional)
- [ ] Test first multi-AI workflow
- [ ] Set up voice commands (optional)
- [ ] Begin Phase 1 learning progression

## Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Gemini CLI GitHub](https://github.com/google-gemini/gemini-cli)
- [Grok CLI GitHub](https://github.com/superagent-ai/grok-cli)

## Philosophy

> The goal is progressive mastery, not perfection. Document everything, experiment boldly, and enjoy the journey.

This is a learning project focused on:
- Mastering terminal-based development
- Understanding AI strengths and specializations
- Building efficient multi-AI workflows
- Creating reusable patterns for the community

---

**Version**: 0.1.0
**Last Updated**: 2025-10-28
**License**: MIT (for scripts and patterns)
**Author**: Learning through multi-AI orchestration
