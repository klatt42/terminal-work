# Master Terminal Workflow

**Last Updated:** 2025-10-30
**Status:** Standard Operating Procedure
**Purpose:** Multi-terminal development with clean context separation

---

## The Problem You're Solving

When running multiple terminals with Claude Code (or other AIs):
- **Can't tell which project is in which terminal** by looking at the screen
- Context bleeds between projects when switching terminals
- Need one "command center" for cross-project work
- Want to delegate tasks to different AIs in parallel

---

## The Solution: Master Terminal + Project Terminals

```
┌─────────────────────────────────────────────────────────────┐
│  🎯 MASTER TERMINAL (terminal-work)                         │
│  • Claude Code for orchestration                            │
│  • Cross-project problem solving                            │
│  • AI delegation (Gemini, Codex, Grok, Perplexity)         │
│  • General system commands (ports, docker, morning)         │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
┌───────▼─────────┐ ┌──────▼────────┐ ┌────────▼────────┐
│ SERP Master     │ │ My-ERP-Plan   │ │ ROK Copilot     │
│ Port 3000, 8000 │ │ Port 3001     │ │ Port 3002       │
│ Claude Code     │ │ Claude Code   │ │ Claude Code     │
│ SINGLE PROJECT  │ │ SINGLE PROJECT│ │ SINGLE PROJECT  │
└─────────────────┘ └───────────────┘ └─────────────────┘
```

---

## Visual Terminal Identification

### Problem: All tabs look the same
```
┌─────┬─────┬─────┬─────┐
│bash │bash │bash │bash │  ← Which project is which? 😕
└─────┴─────┴─────┴─────┘
```

### Solution: Named tabs with context
```
┌──────────┬──────────┬──────────┬──────────┐
│🎯 MASTER │SERP Master│My-ERP-Plan│ROK Copilot│  ← Clear! 😊
└──────────┴──────────┴──────────┴──────────┘
```

---

## Quick Setup Commands

### Set Terminal Context (Automatically sets tab title + changes directory)

```bash
set-master      # Master Terminal - terminal-work
set-serp        # SERP Master project
set-erp         # My-ERP-Plan project
set-rok         # ROK Copilot project
set-prism       # Prism Specialties project
```

### Manual Title Setting

```bash
title "My Custom Title"       # Set any title
set-title "My Custom Title"   # Same thing
```

### Auto-detect from directory

```bash
cd ~/projects/my-erp-plan
title                         # Auto-detects: "my-erp-plan"
```

---

## Master Terminal Standard Process

### 1. Opening Master Terminal

**Every morning or when starting work:**

```bash
# Open new terminal
set-master

# This automatically:
# - Sets tab title to "🎯 MASTER"
# - Changes to ~/projects/terminal-work
# - Shows Master Terminal welcome screen
```

**Welcome screen shows:**
```
════════════════════════════════════════════════════════════════
  MASTER TERMINAL - Cross-Project Command & Control
════════════════════════════════════════════════════════════════

Location: terminal-work
Purpose: General work, multi-project coordination, AI delegation

Available AIs:
  • Claude Code (this session)
  • Gemini CLI (gemini)
  • Codex (codex)
  • Grok (opencode)
  • Perplexity (ai)

Quick commands: morning, scan, ports, docker-show, archon-status
════════════════════════════════════════════════════════════════
```

### 2. Master Terminal - What To Use It For

**✅ DO use Master Terminal for:**

1. **Morning briefings and status checks**
   ```bash
   morning              # Project status across all projects
   scan                 # Git status all projects
   ports-running        # What's running where
   docker-show          # Docker containers
   archon-status        # Archon OS status
   ```

2. **Cross-project problem solving**
   - Port conflicts affecting multiple projects
   - System-wide issues (Docker, Git, dependencies)
   - Terminal-work enhancements
   - Documentation and organization

3. **AI delegation and parallel work**
   ```bash
   # Stay in Claude Code for orchestration
   # Launch Gemini for research
   gemini "research best practices for X"

   # Launch Codex for code generation
   codex "generate component for Y"

   # Launch Perplexity for quick questions
   ai "what's the latest version of Next.js?"
   ```

4. **General terminal-work tasks**
   - Creating new scripts
   - Updating documentation
   - Managing port registry
   - Enhancing monitoring systems

**❌ DON'T use Master Terminal for:**
- Single-project development work
- Deep diving into one project's codebase
- Long-running project-specific tasks

---

## Project-Specific Terminals

### Opening a Project Terminal

```bash
# Open new terminal tab/window
set-serp         # SERP Master context

# OR
set-erp          # My-ERP-Plan context

# OR
set-rok          # ROK Copilot context
```

### Project Terminal Rules

**ONE PROJECT PER TERMINAL - Keep Context Clean**

✅ **DO in project terminals:**
- Work exclusively on that one project
- Keep Claude Code context focused on that project only
- Run the dev server for that project
- Make commits for that project
- Review and approve changes for that project

❌ **DON'T in project terminals:**
- Switch to other projects
- Work on cross-project issues
- Run global commands that affect multiple projects
- Mix contexts between different projects

### Switching Projects

**Wrong way:**
```bash
# In SERP Master terminal
cd ~/projects/my-erp-plan     # ❌ Context contamination!
# Now Claude Code has mixed context
```

**Right way:**
```bash
# Stay in SERP Master terminal - keep working on SERP
# Open NEW terminal tab/window for My-ERP-Plan
# In new terminal:
set-erp                       # ✓ Clean context!
```

---

## Daily Workflow Example

### Morning Startup

1. **Open Master Terminal**
   ```bash
   set-master
   morning                    # Check all project status
   ports-running             # What's already running
   docker-show               # Docker status
   ```

2. **Review and plan**
   - Check uncommitted changes across projects
   - Identify priorities
   - Plan which projects need work today

3. **Open project terminals**
   ```bash
   # New terminal tab 1
   set-serp
   start-serp                # Start dev server

   # New terminal tab 2
   set-erp
   start-erp                 # Start dev server

   # New terminal tab 3
   set-rok
   start-rok                 # Start dev server
   ```

4. **Your terminal tabs now look like:**
   ```
   ┌──────────┬──────────┬──────────┬──────────┐
   │🎯 MASTER │SERP Master│My-ERP-Plan│ROK Copilot│
   └──────────┴──────────┴──────────┴──────────┘
   ```

### During Development

**In Master Terminal:**
- Monitor overall system status
- Handle port conflicts
- Delegate research to Gemini
- Delegate code generation to Codex
- Quick questions to Perplexity
- Cross-project coordination

**In Project Terminals:**
- Deep work on that specific project
- Claude Code focused on project context only
- Review changes with clear context
- Make commits without confusion

### End of Day

**In Master Terminal:**
```bash
scan                      # Check all projects for uncommitted work
eod                       # Run end-of-day workflow
```

**In Each Project Terminal:**
```bash
git status               # Check final state
# Commit any remaining work if needed
```

---

## AI Delegation Strategy (From Master Terminal)

### Claude Code (Master Orchestrator)
**Use for:**
- Overall coordination
- Complex problem solving requiring multiple steps
- Cross-project architecture decisions
- Code review and quality checks

### Gemini CLI
**Use for:**
```bash
gemini "research the best approach for X"
gemini "explain how technology Y works"
gemini "compare options A vs B"
```
- Research and information gathering
- Explaining concepts
- Comparing alternatives

### Codex
**Use for:**
```bash
codex "generate a React component for X"
codex "create a utility function that does Y"
codex "write tests for Z"
```
- Quick code generation
- Boilerplate creation
- Simple utilities

### Grok (OpenCode)
**Use for:**
```bash
opencode "generate landing page for X"
opencode "create marketing copy for Y"
```
- Creative content
- Marketing materials
- Quick prototypes

### Perplexity
**Use for:**
```bash
ai "what's the current version of Next.js"
ai "how do I fix error X in Y"
ai "quick syntax for Z"
```
- Quick factual questions
- Error messages
- Documentation lookups

---

## Benefits of This Workflow

### 1. Visual Clarity
- Instantly see which project is in which terminal tab
- No confusion when switching between terminals
- Quick identification during screen sharing

### 2. Clean Context
- Claude Code maintains focus on one project per terminal
- No context bleeding between projects
- Clearer approvals and reviews

### 3. Efficient AI Delegation
- Master Terminal as coordination hub
- Parallel AI work (Gemini researching while Codex generates)
- Quick switching between AI tools

### 4. Reduced Cognitive Load
- Don't have to remember which terminal is which
- Less mental energy spent on terminal management
- More focus on actual development

---

## Troubleshooting

### Tab title not updating

```bash
# Reload bash configuration
source ~/.bashrc

# Try setting title again
set-master
```

### Lost track of which terminal is which

```bash
# In any terminal, show current project
pwd                          # Shows directory

# Or auto-detect and set title
title                        # Auto-detects from directory
```

### Want to change terminal context

```bash
# Don't! Open a new terminal instead
# But if you must:
set-erp                      # Changes context to My-ERP-Plan
```

### Master Terminal accidentally in project directory

```bash
set-master                   # Resets to proper Master context
```

---

## Terminal Layout Recommendation

### Option 1: Vertical Split
```
┌─────────────────────┬─────────────────────┐
│                     │                     │
│   🎯 MASTER         │   SERP Master       │
│   terminal-work     │   Port 3000         │
│                     │                     │
│   Commands:         │   Deep work:        │
│   • morning         │   • Feature dev     │
│   • scan            │   • Bug fixes       │
│   • ports           │   • Commits         │
│                     │                     │
├─────────────────────┼─────────────────────┤
│                     │                     │
│   My-ERP-Plan       │   ROK Copilot       │
│   Port 3001         │   Port 3002         │
│                     │                     │
└─────────────────────┴─────────────────────┘
```

### Option 2: Tabbed
```
┌──────────┬──────────┬──────────┬──────────┐
│🎯 MASTER │SERP Master│My-ERP-Plan│ROK Copilot│
└──────────┴──────────┴──────────┴──────────┘
│                                              │
│  [Active terminal content]                   │
│                                              │
└──────────────────────────────────────────────┘
```

---

## Standard Commands Summary

### Context Setting
```bash
set-master         # Set Master Terminal context
set-serp           # Set SERP Master context
set-erp            # Set My-ERP-Plan context
set-rok            # Set ROK Copilot context
set-prism          # Set Prism Specialties context
title "Custom"     # Set custom title
```

### Master Terminal Commands
```bash
morning            # Morning briefing
scan               # Scan all projects
ports              # Show port assignments
ports-running      # Show running services
docker-show        # Docker containers
archon-status      # Archon OS status
eod                # End of day workflow
```

### AI Commands (From Master Terminal)
```bash
# Claude Code - already running
gemini "query"     # Gemini CLI
codex "query"      # Codex
opencode "query"   # Grok
ai "query"         # Perplexity
```

---

## Integration with Existing Workflows

### Morning Briefing
```bash
set-master         # Set context
morning            # Run morning briefing
# Review output, plan day
# Open project terminals as needed
```

### End of Day
```bash
# Do project-specific commits in project terminals first
# Then return to Master Terminal:
set-master
eod                # Consolidated end-of-day
```

### Port Management
```bash
# Always from Master Terminal
set-master
ports-running      # Check status
kill-3000          # Kill conflicts
# Then start projects in their terminals
```

---

## Best Practices

### ✅ DO:
- Always set terminal context when opening new terminal
- Keep Master Terminal in terminal-work directory
- Use project terminals for single-project work only
- Delegate to appropriate AI from Master Terminal
- Check terminal tab title before starting work

### ❌ DON'T:
- Mix project contexts in same terminal
- Use project terminal for cross-project work
- Forget to set terminal title
- Keep all work in Master Terminal
- Switch project directories within project terminals

---

## Quick Reference Card

**Opening terminals:**
- `set-master` → 🎯 MASTER
- `set-serp` → SERP Master
- `set-erp` → My-ERP-Plan
- `set-rok` → ROK Copilot

**Master Terminal purpose:**
- Cross-project coordination
- System monitoring (morning, scan, ports, docker)
- AI delegation (gemini, codex, opencode, ai)
- Terminal-work enhancements

**Project Terminal purpose:**
- Single project focus
- Deep development work
- Clean Claude Code context
- Project-specific commits

**Golden Rule:**
ONE PROJECT PER TERMINAL = CLEAN CONTEXT

---

**Documentation maintained by:** terminal-work project
**Status:** Standard Operating Procedure ✅
**Review:** Monthly or when workflow changes
