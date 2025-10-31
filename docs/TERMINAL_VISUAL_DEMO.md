# Terminal Context System - Visual Demo

**What You'll Actually See**

---

## 🎬 Demo: Setting Up Terminals

### Step 1: This Terminal (Make it Master)

**You type:**
```bash
source ~/.bashrc
set-master
```

**You see in terminal:**
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

**Tab title changes to:** `🎯 MASTER`

**Prompt changes to:** `[🎯 MASTER] user@host:~/projects/terminal-work$`

---

### Step 2: Open New Terminal for SERP Master

**You do:**
1. Click `+` or `Ctrl+Shift+T` to open new WSL tab
2. New terminal opens (you're in ~ or wherever)

**You type:**
```bash
set-serp
```

**You see in terminal:**
```
✓ Context: SERP Master (SEO Platform)
  Port: 3000 (frontend), 8000 (backend)
  Start: start-serp or npm run dev
```

**What changed:**
- Tab title → `SERP Master`
- You're now in → `~/serp-master`
- Prompt → `[SERP] user@host:~/serp-master$`

**Now start the server:**
```bash
npm run dev
```

You'll see:
```
> serp-master@0.1.0 dev
> next dev

   ▲ Next.js 14.2.x
   - Local:        http://localhost:3000
   - Ready in 2.3s
```

✅ Notice: It used port 3000 automatically (from .env.local)

---

### Step 3: Open Third Terminal for My-ERP-Plan

**You do:**
1. Click `+` again for another new tab
2. New terminal opens

**You type:**
```bash
set-erp
```

**You see:**
```
✓ Context: My-ERP-Plan (Emergency Response)
  Port: 3001
  Start: start-erp or npm run dev
```

**What changed:**
- Tab title → `My-ERP-Plan`
- You're now in → `~/projects/genesis-skills-test/my-erp-plan`
- Prompt → `[ERP] user@host:~/projects/.../my-erp-plan$`

**Start server:**
```bash
npm run dev
```

You'll see:
```
> my-erp-plan@0.1.0 dev
> next dev

   ▲ Next.js 14.2.x
   - Local:        http://localhost:3001
   - Ready in 1.8s
```

✅ Notice: It used port 3001 (no conflict with SERP's 3000!)

---

### Step 4: Open Fourth Terminal for ROK Copilot

**You type:**
```bash
set-rok
```

**You see:**
```
✓ Context: ROK Copilot (AI Assistant)
  Port: 3002
  Start: start-rok or npm run dev
```

**Tab title:** `ROK Copilot`
**Directory:** `~/projects/rok-copilot`
**Prompt:** `[ROK] user@host:~/projects/rok-copilot$`

---

## 📺 What Your Screen Looks Like

### Tab Bar (Top of Windows Terminal)

```
┌──────────┬──────────┬──────────┬──────────┐
│🎯 MASTER │SERP Master│My-ERP-Plan│ROK Copilot│
│  (active)│   3000   │   3001   │   3002   │
└──────────┴──────────┴──────────┴──────────┘
```

### Inside Master Terminal Tab

```
[🎯 MASTER] klatt42@hostname:~/projects/terminal-work (main)$

# You can run:
morning              # Check all projects
ports-running        # See what's running
docker-show          # Docker status
gemini "research X"  # Delegate to Gemini
```

### Inside SERP Master Terminal Tab

```
[SERP] klatt42@hostname:~/serp-master (main)$ npm run dev

> serp-master@0.1.0 dev
> next dev

   ▲ Next.js 14.2.x
   - Local:        http://localhost:3000
   - Environments: .env.local

   Ready in 2.3s

# Server is running, you can now work on SERP Master
```

### Inside My-ERP-Plan Terminal Tab

```
[ERP] klatt42@hostname:~/projects/genesis-skills-test/my-erp-plan (main)$ npm run dev

> my-erp-plan@0.1.0 dev
> next dev

   ▲ Next.js 14.2.x
   - Local:        http://localhost:3001

   Ready in 1.8s

# Server is running, you can now work on My-ERP-Plan
```

---

## 🎯 Using Claude Code in Each Terminal

### Can You Give Commands to Project CC?

**YES!** Here's how it works:

### Option 1: Open Separate Claude Code Sessions (Recommended)

**In SERP Master terminal:**
```bash
# After set-serp, you're in ~/serp-master
code .
# Opens VS Code with Claude Code in that project
# Claude Code context: SERP Master only
```

**In My-ERP-Plan terminal:**
```bash
# After set-erp, you're in ~/my-erp-plan
code .
# Opens VS Code with Claude Code in that project
# Claude Code context: My-ERP-Plan only
```

### Option 2: Use This Master Terminal for All Claude Code (Your Current Setup)

**You keep:**
- **This terminal** = Master Terminal with Claude Code
- **Other terminals** = Just for running servers and git commands

**When you need Claude Code help:**
- Switch back to Master Terminal (🎯 MASTER tab)
- Tell Claude Code which project you're working on
- Claude Code helps from here

**Example:**
```
You: "In SERP Master terminal, I'm seeing an error..."
Claude: [helps with SERP Master]

You: "Now in My-ERP-Plan terminal, I need to add a feature..."
Claude: [switches context to help with My-ERP-Plan]
```

### Option 3: Hybrid (Most Flexible)

**Master Terminal (this one):**
- Claude Code for cross-project work
- General coordination
- Research and planning

**SERP Master Terminal:**
- Open separate Claude Code session: `code .`
- OR just run commands: `npm run dev`, `git status`, etc.
- Come back to Master Terminal when you need Claude Code

---

## 🔄 Typical Workflow

### Morning Setup

**Terminal 1 (Master):**
```bash
set-master
morning
# Review status, plan day
# Keep Claude Code here for coordination
```

**Terminal 2 (SERP):**
```bash
set-serp
npm run dev
# Server starts on 3000
# Work on SERP, run git commands
```

**Terminal 3 (ERP):**
```bash
set-erp
npm run dev
# Server starts on 3001
# Work on ERP, run git commands
```

**Terminal 4 (ROK):**
```bash
set-rok
npm run dev
# Server starts on 3002
# Work on ROK, run git commands
```

### During Work

**Switching between terminals:**
- Click tab to switch
- Instantly see which project from tab title
- Prompt confirms project context

**Using Claude Code:**
- Stay in Master Terminal tab
- Tell Claude Code which project you need help with
- Or open separate Claude Code sessions in each project

**Checking status:**
- Master Terminal: `ports-running` (see all projects)
- Project Terminal: `git status` (just that project)

---

## 💡 Pro Tips

### 1. Tab Bar Shows Everything

Just glance at tab bar:
```
🎯 MASTER  - Command center, Claude Code
SERP Master - Development server running
My-ERP-Plan - Development server running
ROK Copilot - Development server running
```

### 2. Prompt Confirms Context

Before every command, you see:
```
[SERP] $ ← You're in SERP Master
[ERP] $  ← You're in My-ERP-Plan
[🎯 MASTER] $ ← You're in Master Terminal
```

### 3. No More "Where Am I?"

You'll never wonder which terminal has which project!

---

## 🎬 Try It Now!

### In This Terminal:

```bash
# 1. Load the new commands
source ~/.bashrc

# 2. Set as Master
set-master

# 3. See the welcome screen
# Tab title should change to "🎯 MASTER"
```

### Open New Terminal:

```bash
# In new terminal tab
set-serp

# You'll see the SERP context message
# Tab title changes to "SERP Master"
# You're automatically in ~/serp-master
```

---

## ❓ FAQ

### Q: Do I need to be in the correct directory first?

**A: No!** `set-serp` works from anywhere. It changes directory for you.

```bash
# You're anywhere
pwd
# /home/klatt42/random/location

set-serp
# Now you're in ~/serp-master
```

### Q: Can I use Claude Code in project terminals?

**A: Yes, three ways:**

1. **Separate sessions:** Run `code .` in each project terminal
2. **Master only:** Keep Claude Code only in Master Terminal (simplest)
3. **Hybrid:** Use both as needed

### Q: What if tab title doesn't change?

**A: It's working!** The escape codes `]0;Title` are sent to Windows Terminal. You won't see the codes in the terminal output, but the tab title updates.

**To verify:**
- Look at the actual tab at the top of Windows Terminal
- Should show "🎯 MASTER", "SERP Master", etc.

### Q: How do I switch back to Master?

**A: Click the 🎯 MASTER tab**, or in any terminal:

```bash
set-master
```

---

## 🎉 Summary

**Simple answer to your question:**

1. **Open new WSL terminal** (from anywhere)
2. **Type:** `set-serp` (or set-erp, set-rok, etc.)
3. **Done!** Tab title changes, directory changes, context set

**You can:**
- Run these commands from any directory
- They work in any terminal
- Tab title updates automatically
- Prompt shows project badge
- Directory changes to correct project

**Try it now:**
```bash
source ~/.bashrc
set-master
# Then open new terminal and try: set-serp
```

---

**Status:** ✅ Ready to Use Immediately
