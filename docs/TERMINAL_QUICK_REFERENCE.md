# Terminal Management - Quick Reference

**Last Updated:** 2025-10-30
**Status:** Active

---

## 🎯 The Problem This Solves

**Before:**
```
┌─────┬─────┬─────┬─────┐
│bash │bash │bash │bash │  ← Which project is which? 😕
└─────┴─────┴─────┴─────┘
```

**After:**
```
┌──────────┬──────────┬──────────┬──────────┐
│🎯 MASTER │SERP Master│My-ERP-Plan│ROK Copilot│  ← Crystal clear! 😊
└──────────┴──────────┴──────────┴──────────┘
```

**Plus visible in prompt:**
```
[🎯 MASTER] user@host:~/projects/terminal-work (main)$
[SERP] user@host:~/serp-master (main)$
[ERP] user@host:~/projects/my-erp-plan (feature-branch)$
```

---

## ⚡ Quick Commands

### Set Terminal Context

```bash
set-master      # 🎯 MASTER - terminal-work
set-serp        # SERP Master - port 3000, 8000
set-erp         # My-ERP-Plan - port 3001
set-rok         # ROK Copilot - port 3002
set-prism       # Prism Specialties - port 3003
```

**What each command does:**
1. Sets terminal tab title
2. Updates prompt with project badge
3. Changes to project directory
4. Shows context banner

### Manual Title Setting

```bash
title "Custom Title"        # Set any title
title                       # Auto-detect from directory
```

---

## 🏗️ Terminal Setup

### Master Terminal (Command Center)

```bash
set-master
```

**Shows:**
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

**Prompt looks like:**
```
[🎯 MASTER] user@host:~/projects/terminal-work (main)$
```

### Project Terminals

```bash
# Terminal 2
set-serp

# Terminal 3
set-erp

# Terminal 4
set-rok
```

**Each shows:**
```
✓ Context: [Project Name]
  Port: [Port Number]
  Start: [Start Command]
```

**Prompt looks like:**
```
[SERP] user@host:~/serp-master (main)$
[ERP] user@host:~/projects/my-erp-plan (main)$
[ROK] user@host:~/projects/rok-copilot (main)$
```

---

## 📋 Use Cases

### Master Terminal - What To Do Here

✅ **Morning startup:**
```bash
set-master
morning              # Check all projects
ports-running        # What's running
docker-show          # Docker status
```

✅ **Cross-project work:**
```bash
ports                # Manage ports
scan                 # Git status all projects
eod                  # End of day workflow
```

✅ **AI delegation:**
```bash
gemini "research X"
codex "generate Y"
ai "quick question about Z"
```

❌ **Don't:**
- Work on single project code
- Keep context focused on one project
- Run project dev servers

### Project Terminals - What To Do Here

✅ **Single project work:**
```bash
set-serp             # Set context
npm run dev          # Start server (uses correct port)
# Work on SERP Master only
git status
git add .
git commit -m "feat: X"
```

❌ **Don't:**
- Switch to other projects
- Mix contexts
- Do cross-project work

---

## 🎨 Visual Identification

### Tab Title
- Set automatically by `set-master`, `set-serp`, etc.
- Visible in terminal tab bar
- Persists across commands

### Prompt Badge
- `[🎯 MASTER]` - Master Terminal
- `[SERP]` - SERP Master
- `[ERP]` - My-ERP-Plan
- `[ROK]` - ROK Copilot
- `[PRISM]` - Prism Specialties

### Color Coding (in prompt)
- **Magenta** - Project badge
- **Green** - Username
- **Blue** - Directory
- **Cyan** - Git branch

---

## 🔄 Daily Workflow

### 1. Morning

```bash
# Terminal 1 (Master)
set-master
morning

# Terminal 2 (SERP)
set-serp
start-serp

# Terminal 3 (ERP)
set-erp
start-erp

# Terminal 4 (ROK)
set-rok
start-rok
```

**Your tabs now:**
```
┌──────────┬──────────┬──────────┬──────────┐
│🎯 MASTER │SERP Master│My-ERP-Plan│ROK Copilot│
└──────────┴──────────┴──────────┴──────────┘
```

### 2. During Work

**Switch between tabs:**
- Look at tab title to know which project
- Look at prompt badge for confirmation
- Never confused about context

**Delegate from Master:**
```bash
# In Master Terminal
gemini "research best approach for feature X"
# Continue working while Gemini researches

codex "generate component Y"
# Get quick code generation
```

### 3. End of Day

```bash
# Each project terminal - commit work
git status
git add .
git commit -m "feat: X"

# Master Terminal - overall EOD
set-master
eod
```

---

## 🛠️ Advanced Usage

### Enable Enhanced Prompt Globally

Add to `~/.bashrc`:

```bash
# Enhanced project-aware prompt
source ~/projects/terminal-work/config/bash-prompt-project.sh
```

Then:
```bash
source ~/.bashrc
```

Now every terminal shows project badge automatically!

### Custom Titles

```bash
title "Feature X Development"
title "Testing Environment"
title "Production Debugging"
```

### Quick Context Check

```bash
pwd                  # Where am I?
title               # Auto-detect and set title
```

---

## 📊 Comparison

### Before Terminal Management

**Problems:**
- Can't tell which terminal has which project
- Context gets mixed between projects
- Have to check directory constantly
- Easy to make mistakes (wrong project)

**Example confusion:**
```
Terminal 1: cd ~/serp-master
Terminal 2: cd ~/my-erp-plan
Terminal 3: cd ~/serp-master (wait, which one was I in?)
```

### After Terminal Management

**Benefits:**
- Instant visual identification (tab + prompt)
- Clean context separation
- No mental overhead
- Impossible to confuse projects

**Clear identification:**
```
Tab: SERP Master       Prompt: [SERP] user@host:~/serp-master$
Tab: My-ERP-Plan       Prompt: [ERP] user@host:~/my-erp-plan$
Tab: 🎯 MASTER         Prompt: [🎯 MASTER] user@host:~/terminal-work$
```

---

## 🔧 Troubleshooting

### Tab title not showing

```bash
source ~/.bashrc
set-master           # Try setting again
```

### Prompt not updating

```bash
source ~/projects/terminal-work/config/bash-prompt-project.sh
```

### Lost context

```bash
title                # Auto-detect from current directory
# OR
pwd                  # See where you are
set-master           # Explicitly set context
```

### Want to reset

```bash
set-master           # Reset to Master Terminal
# OR
set-erp              # Reset to specific project
```

---

## 📚 Related Documentation

- **Full workflow:** `MASTER_TERMINAL_WORKFLOW.md`
- **Port management:** `PORT_MANAGEMENT.md`
- **Port quick reference:** `PORT_QUICK_REFERENCE.md`

---

## 🎯 Golden Rules

1. **ONE PROJECT PER TERMINAL** - Keep context clean
2. **SET CONTEXT ON OPEN** - Always use `set-master` or `set-<project>`
3. **MASTER FOR COORDINATION** - Cross-project work only
4. **CHECK THE TAB** - Glance before you work

---

**Status:** ✅ Active - Standard Workflow
**Last Updated:** 2025-10-30
