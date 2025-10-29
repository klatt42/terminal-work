# Terminal Patterns - Discovered Best Practices

**Purpose**: Document terminal AI patterns discovered during learning and development.

---

## Pattern Discovery Log

### Pattern 1: Project Initialization with Multi-AI Setup

**Date**: 2025-10-28
**Context**: Initial project setup
**Pattern**: Structured directory layout for multi-AI collaboration

**Implementation**:
```
terminal-work/
├── .claude/agents/          # Claude Code subagents
├── .grok/                   # Grok CLI config
├── config/                  # Voice command configs
├── scripts/                 # Automation scripts
├── workflows/               # Workflow templates
├── skills/                  # Genesis SKILLs
├── notes/                   # Learning documentation
└── logs/                    # Voice and execution logs
```

**Benefits**:
- Clear separation of AI-specific configurations
- Easy to locate and update subagents
- Shared context files in root
- Scalable structure for future tools

**Lessons Learned**:
- Keep AI configs in their own directories
- Shared context files (AI_CONTEXT.md, etc.) in root for all AIs
- Scripts directory for cross-AI automation

---

## AI Specialization Patterns

### Claude Code Strengths
- Complex architectural decisions
- Security analysis (with code-reviewer subagent)
- Multi-step reasoning workflows
- Subagent orchestration

### Gemini CLI Strengths
(To be documented after first use)
- Expected: Large context handling
- Expected: Fast documentation generation

### Grok CLI Strengths
(To be documented after first use)
- Expected: High-speed code generation
- Expected: Test automation

---

## Workflow Patterns

### Pattern: Context Synchronization
**Trigger**: Before starting multi-AI workflows
**Script**: `./scripts/context-sync.sh`
**Purpose**: Ensure all AIs have current project state

**Files Updated**:
- AI_CONTEXT.md
- .ai-state.json

---

## Subagent Patterns

### Pattern: Specialized Subagent Creation

**Template Structure**:
```markdown
---
name: agent-name
description: Brief description
tools: Tool1, Tool2, Tool3
model: sonnet
---

You are a [role] specialist focused on:
- Objective 1
- Objective 2
- Objective 3

[Approach or methodology]
```

**Created Subagents**:
1. terminal-researcher - Command research and documentation
2. multi-ai-orchestrator - Cross-AI workflow coordination
3. code-reviewer - Security and quality analysis
4. docs-generator - Documentation creation
5. workflow-optimizer - Performance optimization
6. voice-command-handler - Voice integration

---

## Voice Command Patterns

(To be documented after voice setup)

---

## Performance Patterns

(To be documented as metrics are collected)

---

## Integration Patterns

### Pattern: Genesis SKILL Integration

**Location**: `skills/genesis-terminal-orchestration/`
**Purpose**: Reusable multi-AI orchestration patterns
**Version**: 1.0.0

**Key Components**:
- AI Assignment Matrix
- Parallel Execution Templates
- Context Synchronization Strategies
- Voice Integration Points

---

## Anti-Patterns (Things to Avoid)

1. **Don't**: Start multi-AI workflows without context sync
   **Do**: Run `./scripts/context-sync.sh` first

2. **Don't**: Use same AI for all tasks
   **Do**: Leverage each AI's strengths per assignment matrix

3. **Don't**: Forget to document new patterns
   **Do**: Add to this file immediately when pattern discovered

---

## Next Patterns to Discover

- [ ] First multi-AI workflow execution
- [ ] Voice command accuracy optimization
- [ ] Cross-AI conflict resolution
- [ ] Productivity measurement methodology
- [ ] Optimal task decomposition strategies

---

**Note**: This file grows throughout the learning journey. Add patterns as soon as they're discovered.
