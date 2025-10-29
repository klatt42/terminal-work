# Terminal Superuser - Quick Start Guide

**Version**: 0.1.0
**Last Updated**: 2025-10-28

---

## What is Terminal Superuser?

A multi-AI terminal orchestration project for mastering terminal-based development workflows using:
- **Claude Code** (Primary AI - Advanced reasoning)
- **Gemini CLI** (Secondary AI - Large context, fast iterations)
- **Grok CLI** (Tertiary AI - Cost-effective, open-source)
- **Voice Commands** (Optional - Hands-free operation)

---

## Prerequisites

- WSL/Ubuntu or Linux environment
- Node.js and npm installed
- Git
- Terminal multiplexer (tmux recommended)
- Anthropic account (for Claude Code)
- Google account (for Gemini CLI - free tier available)
- X.AI account (for Grok CLI - optional)

---

## Quick Installation

### Step 1: Verify Claude Code
Claude Code should already be installed (you're using it now!).

```bash
# Verify installation
claude --version

# Initialize project (if not done)
cd ~/projects/terminal-work
```

### Step 2: Install Gemini CLI

```bash
# Using npx (no installation required)
npx @google/gemini-cli

# OR install globally
npm install -g @google/gemini-cli

# Verify
gemini --version

# Authenticate (follow prompts)
gemini
```

### Step 3: Install Grok CLI (Optional)

```bash
# Install globally
npm install -g @vibe-kit/grok-cli

# Set API key (get from x.ai)
export GROK_API_KEY="your-xai-api-key"
echo 'export GROK_API_KEY="your-key"' >> ~/.bashrc

# Verify
grok --version
```

### Step 4: Initialize Context

```bash
cd ~/projects/terminal-work
./scripts/context-sync.sh
```

---

## Your First Multi-AI Workflow

### Setup: Four-Tab Terminal Layout

**Option 1: Manual Setup**
```bash
# Open 4 terminal tabs:
# Tab 1: WSL/Ubuntu
# Tab 2: Claude Code (this session)
# Tab 3: Gemini CLI
# Tab 4: Grok CLI
```

**Option 2: tmux Setup** (Recommended)
```bash
# Create tmux session
tmux new -s ai-terminal

# Split into 4 panes
tmux split-window -h
tmux split-window -v
tmux select-pane -t 0
tmux split-window -v

# Tab 1 (top-left): WSL
# Tab 2 (bottom-left): Claude Code
# Tab 3 (top-right): Gemini CLI
# Tab 4 (bottom-right): Grok CLI
```

### Test Workflow: Project Analysis

**Tab 1 (WSL)**: Monitor changes
```bash
cd ~/projects/terminal-work
watch -n 5 "git status"
```

**Tab 2 (Claude Code)**: Architecture analysis
```bash
claude "Analyze this project structure and document key patterns"
```

**Tab 3 (Gemini CLI)**: Documentation generation
```bash
cd ~/projects/terminal-work
gemini "Generate comprehensive README for this project"
```

**Tab 4 (Grok CLI)**: Quick analysis
```bash
cd ~/projects/terminal-work
grok "List all scripts and describe their purposes"
```

---

## Understanding Subagents

Claude Code has 6 specialized subagents configured:

### Available Subagents

1. **terminal-researcher**: Research terminal commands and tools
   ```bash
   claude "Use terminal-researcher subagent to document git workflows"
   ```

2. **multi-ai-orchestrator**: Coordinate multi-AI workflows
   ```bash
   claude "Use multi-ai-orchestrator to plan this task across all AIs"
   ```

3. **code-reviewer**: Security and quality analysis
   ```bash
   claude "Use code-reviewer subagent for security analysis"
   ```

4. **docs-generator**: Documentation creation
   ```bash
   claude "Use docs-generator to create API documentation"
   ```

5. **workflow-optimizer**: Performance optimization
   ```bash
   claude "Use workflow-optimizer to improve our development process"
   ```

6. **voice-command-handler**: Voice integration (when voice is set up)
   ```bash
   claude "Use voice-command-handler to design voice workflows"
   ```

---

## Context Management

### Important Files

**AI_CONTEXT.md**: Current project state (read by all AIs)
**WORKFLOW_STATE.md**: Task tracking and workflow status
**.ai-state.json**: Programmatic state for automation
**TERMINAL_PATTERNS.md**: Discovered patterns and best practices

### Sync Context Before Multi-AI Workflows

```bash
./scripts/context-sync.sh
```

This ensures all AIs have the latest project state.

---

## AI Assignment Strategy

Use the right AI for the right task:

| Task Type | Use This AI | Why |
|-----------|-------------|-----|
| Architecture | Claude Code | Deep reasoning |
| Security | Claude Code | Critical analysis |
| Documentation | Gemini CLI | Large context (1M tokens) |
| Large files | Gemini CLI | Superior context handling |
| Code generation | Grok CLI | Speed + cost-effective |
| Testing | Grok CLI | Automation |
| Complex reasoning | Claude Code | Multi-step logic |

---

## Common Commands

### Claude Code
```bash
# Interactive mode (you're in it now)
claude

# Single task
claude "analyze this codebase"

# With subagent
claude "Use code-reviewer subagent for security scan"

# Thinking modes
claude "think: what's the best approach?"
claude "think hard: complex architectural decision"
```

### Gemini CLI
```bash
# Interactive mode
gemini

# Single prompt
gemini -p "explain this code"

# JSON output
gemini -p "analyze" --output-format json
```

### Grok CLI
```bash
# Interactive mode
grok

# Single prompt
grok -p "show package.json"

# Specific model
grok -m grok-code-fast-1 "quick task"

# More tool rounds for complex tasks
grok --max-tool-rounds 50 "complex refactoring"
```

---

## Voice Commands (Optional)

Voice integration is optional but powerful for hands-free operation.

### Quick Setup: linux-voice-control

```bash
# Install
git clone https://github.com/omegaui/linux-voice-control
cd linux-voice-control
pip install -r requirements.txt --break-system-packages
sudo ./install.sh

# Configure
# Edit ~/.lvc-commands.json (already created in config/)
cp ~/projects/terminal-work/config/lvc-commands.json ~/.lvc-commands.json

# Start
linux-voice-control
```

### Voice Commands Available

- "activate claude" - Switch to Claude Code terminal
- "activate gemini" - Switch to Gemini CLI terminal
- "activate grok" - Switch to Grok CLI terminal
- "run tests" - Execute test suite
- "git status" - Check git status
- "sync context" - Update AI context files

See `config/lvc-commands.json` for full list.

---

## Genesis SKILL Integration

### Load the Terminal Orchestration SKILL

```bash
# The genesis-terminal-orchestration SKILL provides:
# - AI assignment matrix
# - Parallel execution templates
# - Context synchronization patterns
# - Voice integration points

# Location: skills/genesis-terminal-orchestration/skill.md
```

This SKILL can be integrated into Genesis v1.6.0+ for reusable patterns.

---

## Learning Progression

### Phase 1: Foundation (Week 1-2)

**Objectives**:
- [ ] Install all AI assistants
- [ ] Master basic commands
- [ ] Test first multi-AI workflow
- [ ] Set up voice commands (optional)

**Daily Practice**:
```bash
# Day 1: Claude Code exploration
claude "Teach me about subagents and best practices"

# Day 2: Gemini CLI exploration
gemini "Explain Gemini CLI's strengths"

# Day 3: Grok CLI exploration
grok "Show me what makes Grok CLI unique"

# Day 4-7: Multi-AI coordination practice
# Run parallel workflows across all AIs
```

### Track Your Progress

Update these files as you learn:
- `WORKFLOW_STATE.md` - Task completion
- `.ai-state.json` - Metrics and progress
- `TERMINAL_PATTERNS.md` - New patterns discovered
- `notes/daily-progress/` - Daily learnings

---

## Example Workflows

### Workflow 1: Documentation Sprint

```bash
# Claude Code (Tab 2): Review and plan
claude "Use docs-generator to create documentation structure"

# Gemini CLI (Tab 3): Generate content
gemini "Generate comprehensive documentation from codebase"

# Grok CLI (Tab 4): Code examples
grok "Create working code examples for docs"

# WSL (Tab 1): Commit results
git add .
git commit -m "Documentation: Multi-AI sprint"
```

### Workflow 2: Security Analysis

```bash
# Claude Code: Deep security review
claude "Use code-reviewer subagent for comprehensive security analysis"

# Gemini CLI: Document findings
gemini "Create security report from analysis"

# Grok CLI: Fix generation
grok "Generate security fixes based on findings"
```

### Workflow 3: Feature Development

```bash
# Claude Code: Architecture
claude "Design [feature] with security-first approach"

# Gemini CLI: Documentation
gemini "Document [feature] architecture and usage"

# Grok CLI: Implementation
grok "Implement [feature] based on architecture"
grok "Generate comprehensive test suite for [feature]"
```

---

## Troubleshooting

### Gemini CLI Authentication Issues
```bash
# Clear credentials
rm -rf ~/.config/gemini-cli/

# Re-authenticate
gemini
```

### Grok CLI Not Found
```bash
# Verify installation
npm list -g @vibe-kit/grok-cli

# Reinstall if needed
npm install -g @vibe-kit/grok-cli
```

### Context Sync Issues
```bash
# Manually run sync
./scripts/context-sync.sh

# Check files were created
ls -la AI_CONTEXT.md WORKFLOW_STATE.md .ai-state.json
```

### Voice Commands Not Working
```bash
# Check tmux session
tmux ls

# Verify command config
cat ~/.lvc-commands.json

# Check logs
tail -f ~/projects/terminal-work/logs/voice-commands.log
```

---

## Next Steps

1. **Install remaining AIs** (Gemini, Grok)
2. **Test first multi-AI workflow** (use example above)
3. **Document your first pattern** in TERMINAL_PATTERNS.md
4. **Set up voice commands** (optional)
5. **Start Phase 1 learning** (see WORKFLOW_STATE.md)

---

## Resources

### Documentation
- [Claude Code Docs](https://docs.claude.com/en/docs/claude-code)
- [Gemini CLI GitHub](https://github.com/google-gemini/gemini-cli)
- [Grok CLI GitHub](https://github.com/superagent-ai/grok-cli)

### Project Files
- `README.md` - Project overview
- `AI_CONTEXT.md` - Current state (read this often!)
- `WORKFLOW_STATE.md` - Task tracking
- `TERMINAL_PATTERNS.md` - Pattern library
- `workflows/parallel-ai-template.md` - Workflow examples

### Scripts
- `scripts/context-sync.sh` - Sync AI context
- `scripts/ai-orchestrator.sh` - Multi-AI coordination
- `scripts/voice-terminal.sh` - Voice command handler

---

## Support

For issues or questions:
1. Check TERMINAL_PATTERNS.md for common patterns
2. Review AI_CONTEXT.md for current state
3. Check logs/ directory for error messages
4. Ask Claude Code for help using subagents

---

**Happy multi-AI orchestration!** 🚀

Remember: The goal is progressive mastery, not perfection. Document everything, experiment boldly, and enjoy the journey.
