---
name: genesis-terminal-orchestration
description: Multi-AI terminal workflow orchestration and optimization patterns
version: 1.0.0
---

# Genesis Terminal Orchestration SKILL

## When to Use This SKILL

Load this skill when user mentions:
- "multi-terminal" OR "multiple AI" OR "parallel AI"
- "orchestrate" OR "coordinate" OR "distribute tasks"
- "Claude Code and Gemini" OR "multiple assistants"
- "terminal workflow" OR "AI workflow"
- "voice commands" OR "voice control"

## AI Assignment Matrix

### Task Type → Optimal AI Mapping

| Task Type | Primary AI | Rationale |
|-----------|-----------|-----------|
| **Architecture** | Claude Code | Deep reasoning, complex context management |
| **Security Analysis** | Claude Code | Critical analysis, subagent support |
| **Quick Research** | Claude Code WebSearch | Fast (5s), structured, actionable decisions |
| **Deep Research** | Perplexity CLI | Thorough (30-40s), cited sources, comprehensive |
| **Documentation** | Gemini CLI | Large context window (1M tokens) |
| **Large File Analysis** | Gemini CLI | Superior context handling |
| **Code Generation** | Grok CLI | High speed, cost-effective |
| **Test Creation** | Grok CLI | Automation, volume |
| **Quick Prototyping** | Gemini CLI | Fast iterations |
| **Complex Reasoning** | Claude Code | Multi-step logic, agents |

## Parallel Execution Template

### Four-Tab Terminal Layout

```bash
# Tab 1: WSL/Ubuntu - System monitoring and git operations
watch -n 2 "git status"

# Tab 2: Claude Code - Architecture and complex tasks
claude "Use multi-ai-orchestrator subagent to plan execution"

# Tab 3: Gemini CLI - Documentation and analysis
gemini "Analyze project structure and document patterns"

# Tab 4: Grok CLI - Code generation and testing
grok "Generate implementation and test suite"
```

## Context Synchronization Patterns

### Pattern 1: Shared Markdown Files

Create and maintain these files for cross-AI context:

**AI_CONTEXT.md**:
```markdown
# Current Project State
- Phase: [learning/development/production]
- Active AIs: [list]
- Completed: [tasks by AI]
- In Progress: [current tasks]
- Blockers: [issues]
```

**WORKFLOW_STATE.md**:
```markdown
# Workflow State
## Claude Code Tasks
- [x] Architecture designed
- [ ] Security review

## Gemini CLI Tasks
- [x] Documentation started
- [ ] API docs

## Grok CLI Tasks
- [ ] Tests pending
```

### Pattern 2: JSON State Management

**.ai-state.json**:
```json
{
  "project": "project-name",
  "phase": "current-phase",
  "completed_tasks": [],
  "current_tasks": {
    "claude_code": "task",
    "gemini_cli": "task",
    "grok_cli": "task"
  },
  "metrics": {
    "sessions": 0,
    "patterns": 0
  }
}
```

### Pattern 3: Git-Based Synchronization

```bash
# Each AI commits work with prefixed messages
git commit -m "Claude Code: Architecture complete"
git commit -m "Gemini CLI: Documentation updated"
git commit -m "Grok CLI: Tests generated"

# Other AIs read git log for context
git log --oneline -10
```

## Voice Integration Points

### Command Categories

**AI Activation**:
- "activate claude" → Switch to Claude Code terminal
- "activate gemini" → Switch to Gemini CLI terminal
- "activate grok" → Switch to Grok CLI terminal

**Task Execution**:
- "claude analyze security" → Security analysis
- "gemini generate docs" → Documentation
- "grok create tests" → Test generation

**Multi-AI Workflows**:
- "run full analysis" → Parallel execution across all AIs
- "sync context" → Update shared context files

### Voice Command Setup

**voice2json** (Offline, privacy-focused):
```bash
# Install and configure
mkdir -p ~/.config/voice2json
# Download English profile
# Configure sentences.ini with commands
```

**linux-voice-control** (Flexible):
```bash
# Install
git clone https://github.com/omegaui/linux-voice-control
pip install -r requirements.txt
# Configure .lvc-commands.json
```

## Workflow Optimization Patterns

### Pattern: Task Decomposition

1. **Analysis** (Claude Code):
   ```bash
   claude "Analyze task and decompose into parallel subtasks"
   ```

2. **Assignment** (Multi-AI Orchestrator):
   - Architecture → Claude Code
   - Documentation → Gemini CLI
   - Implementation → Grok CLI
   - Testing → Grok CLI

3. **Execution** (Parallel):
   All AIs work simultaneously in separate terminals

4. **Synchronization**:
   ```bash
   ./scripts/context-sync.sh
   ```

5. **Integration**:
   Review and merge work from all AIs

### Pattern: Iterative Enhancement

1. **Round 1 - Foundation**:
   - Claude: Design architecture
   - Gemini: Create documentation outline
   - Grok: Set up project structure

2. **Round 2 - Implementation**:
   - Claude: Implement complex logic
   - Gemini: Expand documentation
   - Grok: Generate boilerplate code

3. **Round 3 - Refinement**:
   - Claude: Security review
   - Gemini: Final documentation
   - Grok: Complete test coverage

## Performance Metrics

### Track These Metrics

```json
{
  "week": 1,
  "metrics": {
    "claude_code_sessions": 0,
    "gemini_cli_sessions": 0,
    "grok_cli_sessions": 0,
    "voice_commands_executed": 0,
    "voice_accuracy": 0.0,
    "multi_ai_workflows": 0,
    "time_saved_hours": 0,
    "patterns_documented": 0
  }
}
```

### Productivity Calculations

```
Time Saved = (Single AI Time) - (Parallel AI Time)
Efficiency Gain = Time Saved / Single AI Time × 100%
```

## Integration with Genesis v1.6.0

### Domain Detection

Genesis should detect terminal AI tools:
- Keywords: "Claude Code", "Gemini CLI", "Grok CLI"
- Context: Terminal, command line, multi-AI
- Domain: `terminal-ai-orchestration`

### Skills Factory Integration

Generate custom skills using Genesis patterns:

```bash
cd ~/projects/project-genesis/skills/factory/
claude "Generate terminal-specific SKILL using Skills Factory"
```

### ROK Copilot Context Preservation

Configure `.claude/copilot-config.json`:
```json
{
  "context_files": [
    "AI_CONTEXT.md",
    "WORKFLOW_STATE.md",
    ".ai-state.json"
  ],
  "session_recovery": {
    "auto_load_context": true
  }
}
```

## Common Workflows

### Workflow 1: New Feature Development

```bash
# Claude Code: Architecture
claude "Design [feature] with security-first approach"

# Gemini CLI: Documentation
gemini "Create documentation for [feature] from architecture"

# Grok CLI: Implementation & Tests
grok "Implement [feature] and generate comprehensive tests"

# System: Integration
git add .
git commit -m "New feature: [feature] (multi-AI collaboration)"
```

### Workflow 2: Code Review & Refactoring

```bash
# Claude Code: Deep analysis
claude "Use code-reviewer subagent for security and quality analysis"

# Gemini CLI: Documentation updates
gemini "Update documentation based on refactoring"

# Grok CLI: Test updates
grok "Update and expand test suite for refactored code"
```

### Workflow 3: Documentation Sprint

```bash
# Gemini CLI: Primary documentation
gemini "Comprehensive documentation generation"

# Claude Code: Technical review
claude "Review documentation for accuracy and completeness"

# Grok CLI: Code examples
grok "Generate working code examples for documentation"
```

### Workflow 4: Research & Decision Making

**Two-Phase Research Pattern** (validated 2025-10-29):

```bash
# Phase 1: Quick Decision (Claude Code WebSearch - 5 seconds)
claude "Quick research on [topic]"
# Returns: Fast, structured, actionable summary
# Use for: Technical decisions, quick evaluations

# Phase 2: Deep Research (Perplexity - 30-40 seconds)
ai "Comprehensive research on [topic]: features, pros/cons, pricing, should I adopt?"
# Returns: Thorough analysis with citations [1][2][3]
# Use for: Major decisions, documentation, verification

# Phase 3: Synthesis (Claude Code)
claude "Compare both research outputs and recommend action"
# Analyzes differences, makes final recommendation
```

**Example: Twingate ZTNA Research**
```bash
# Quick evaluation
claude "Research Twingate zero trust network access for solo developers"
→ Result: 5s, key benefits identified, adoption recommended

# Deep dive
ai "Research Twingate zero trust: technical details, pros/cons table, free tier limits"
→ Result: 40s, comprehensive with citations, structured pros/cons

# Decision
claude "Compare WebSearch vs Perplexity results on Twingate"
→ Synthesis: Both recommend adoption, free tier suitable, 15min setup
```

**When to Use Each**:
- **WebSearch only**: Quick technical decisions, time-sensitive
- **Perplexity only**: Research papers, citations needed, documentation
- **Both (recommended)**: Major technology adoptions, architecture decisions

## Troubleshooting

### Issue: Context Drift Between AIs

**Solution**: Use context-sync.sh script regularly
```bash
./scripts/context-sync.sh
```

### Issue: Conflicting Changes

**Solution**: Git-based coordination
```bash
# Each AI works on different files/areas
# Use git status to monitor conflicts
# Resolve with Claude Code for complex merges
```

### Issue: Voice Commands Not Triggering

**Solution**:
1. Check tmux session is running
2. Verify voice recognition accuracy
3. Review command configuration files
4. Check logs: `tail -f logs/voice-commands.log`

## Best Practices

1. **Always sync context** before starting complex multi-AI workflows
2. **Use git commits** for atomic AI contributions
3. **Document patterns** in TERMINAL_PATTERNS.md as discovered
4. **Track metrics** weekly for productivity insights
5. **Assign tasks** based on AI strengths from assignment matrix
6. **Voice commands** for hands-free operation in repetitive workflows
7. **Subagents** in Claude Code for specialized subtasks

## Resources

- Claude Code Docs: https://docs.claude.com/en/docs/claude-code
- Gemini CLI: https://github.com/google-gemini/gemini-cli
- Grok CLI: https://github.com/superagent-ai/grok-cli
- voice2json: https://voice2json.org/

## Research Tools Comparison

| Feature | Claude Code WebSearch | Perplexity CLI | Claude Code WebFetch |
|---------|----------------------|----------------|---------------------|
| **Speed** | ~5 seconds | ~30-40 seconds | ~10 seconds |
| **Output** | Structured summary | Detailed analysis | Page-specific content |
| **Citations** | No | Yes [1][2][3] | No |
| **Best for** | Quick decisions | Deep research | Documentation scraping |
| **Format** | Bullet points | Tables + paragraphs | Raw content analysis |
| **Pros/Cons** | Basic | Comprehensive | Depends on site |
| **Limitations** | US only | Requires API key | Fails on JS-heavy sites |

**Perplexity CLI Setup**:
```bash
# Install
npm install -g @callstack/ai-cli

# Configure ~/.airc.json
{
  "providers": {
    "perplexity": {
      "apiKey": "pplx-YOUR-KEY",
      "model": "sonar"
    }
  },
  "defaultProvider": "perplexity"
}

# Models available:
# - sonar: Fast, cost-effective (recommended)
# - sonar-pro: More thorough research
# - sonar-reasoning: Logical reasoning tasks
# - sonar-deep-research: Expert-level research
```

---

**SKILL Version**: 1.1.0
**Compatible With**: Genesis v1.6.0+
**Last Updated**: 2025-10-29
**Changelog**: Added Research & Decision Making workflow (Workflow 4), Perplexity CLI integration, research tools comparison
