# Daily Workflow Guide

Quick reference for your daily terminal work routine.

---

## During the Day: Frequent Commits

### Option 1: Direct Script
```bash
./scripts/quick-commit.sh "Add: morning standup notes"
./scripts/quick-commit.sh "Create: backup automation script"
./scripts/quick-commit.sh "Update: daily learning summary"
```

### Option 2: Claude Code Slash Command
```
/commit Add: morning standup notes
/commit Create: backup automation script
/commit Update: daily learning summary
```

### Option 3: Shell Aliases (after installation)
```bash
qc "Add: morning standup notes"
commit "Create: backup automation script"
acp "Update: docs"  # add, commit, push in one command
```

**Tip**: Commit often! Multiple commits per day = better history.

---

## End of Day: Capture & Push

### What It Does
1. **Scans ALL projects** in ~/projects/ directory
2. Captures each project's git status, branch, recent commits
3. Captures terminal states (pwd, git status, command history)
4. Prompts for your daily summary
5. Updates AI context files
6. Commits all changes
7. Pushes to GitHub
8. **Generates executable morning briefing script**

### Run It

**Option 1: Direct Script**
```bash
./scripts/end-of-day.sh
```

**Option 2: Claude Code Slash Command**
```
/eod
```

**Option 3: Shell Alias (after installation)**
```bash
eod
```

### What You'll Be Asked
- **Daily summary**: What did you accomplish today?
- **Commit message**: Final commit message for the day

### Files Created
- `notes/daily-sessions/YYYY-MM-DD.md` - Full session with ALL projects status
- `notes/daily-sessions/YYYY-MM-DD-morning-briefing.sh` - Executable briefing script

---

## Starting Fresh Tomorrow: Morning Briefing

### Run Your Morning Briefing

**Option 1: Shell Alias (Recommended)**
```bash
morning
# or
briefing
# or
standup
```

**Option 2: Direct Execution**
```bash
~/projects/terminal-work/notes/daily-sessions/YYYY-MM-DD-morning-briefing.sh
```

**Option 3: Claude Code Slash Command**
```
/morning
```

### What You'll See

The morning briefing shows you:

1. **Yesterday's Summary** - What you accomplished
2. **ALL Projects Status** - Every project in ~/projects/
   - Current git branch
   - Uncommitted changes (⚠️ flagged)
   - Last commit
   - Files modified yesterday
   - **Exact `cd` command to resume work**
3. **Next Steps** - Prioritized action items
4. **Quick Commands** - Reference for today's workflow

### Example Output

```
╔══════════════════════════════════════════════════════════════╗
║              MORNING BRIEFING - 2025-10-30                   ║
╚══════════════════════════════════════════════════════════════╝

📅 Yesterday: 2025-10-29
📅 Today: 2025-10-30

═══════════════════════════════════════════════════════════════
📋 YESTERDAY'S SUMMARY
═══════════════════════════════════════════════════════════════
Completed multi-AI terminal setup, created workflow automation...

═══════════════════════════════════════════════════════════════
📁 ALL PROJECTS STATUS
═══════════════════════════════════════════════════════════════

📦 copilot-app
   Location: /home/user/projects/copilot-app
   ⚠️  UNCOMMITTED CHANGES:
      M src/components/Chat.tsx
      M package.json
   📌 Branch: feature/new-ui
   💬 Last: Add: Chat component improvements
   📝 15 files modified yesterday
   🚀 Open with: cd /home/user/projects/copilot-app

📦 genesis-saas
   Location: /home/user/projects/genesis-saas
   ✓ Clean working directory
   📌 Branch: main
   💬 Last: Update: Supabase schema
   🚀 Open with: cd /home/user/projects/genesis-saas

📦 terminal-work
   Location: /home/user/projects/terminal-work
   ✓ Clean working directory
   📌 Branch: main
   💬 Last: Add: Morning briefing system
   🚀 Open with: cd /home/user/projects/terminal-work
```

### Quick Start Flow

1. Run `morning` or `briefing`
2. Review all projects - note which have ⚠️ uncommitted changes
3. Pick a project and copy/paste the `cd` command
4. Start working!

### Full Context Preserved

You can close ALL terminals at night. The morning briefing gives you:
- Exactly where each project left off
- Which projects need attention
- Direct commands to resume work
- Full context from yesterday

---

## Installing Shell Aliases (Optional but Recommended)

```bash
echo "source ~/projects/terminal-work/config/bash-aliases.sh" >> ~/.bashrc
source ~/.bashrc
```

### Available Aliases
- `qc "message"` - Quick commit
- `commit "message"` - Quick commit (alias)
- `acp "message"` - Add all, commit, push
- `qp` - Quick push
- `eod` - End of day workflow
- `endday` - End of day (alias)
- `morning` - Morning briefing (shows all projects)
- `briefing` - Morning briefing (alias)
- `standup` - Morning briefing (alias)
- `sync-context` - Sync AI context
- `ctx` - Sync context (short)
- `tw` - Go to terminal-work
- `tws` - Go to terminal-work + git status

---

## Example Day

**Morning (9:00 AM)**
```bash
morning                         # See ALL projects status + yesterday's summary
# Review output - shows copilot-app has uncommitted changes
cd ~/projects/copilot-app       # Copy/paste from briefing output
```

**Throughout Day**
```bash
# Work on something...
qc "Add: API endpoint for users"

# More work...
qc "Update: user authentication logic"

# Document learning...
qc "Add: notes on async patterns"
```

**End of Day (5:00 PM)**
```bash
eod                             # Run end-of-day workflow
# Scans ALL projects in ~/projects/
# Enter summary when prompted
# Enter final commit message
# Everything pushed to GitHub!
# Morning briefing generated!
```

**Close ALL terminals - full context for all projects saved!**

**Next Morning**
```bash
morning                         # Instant overview of all projects
# Pick up exactly where you left off
```

---

## Tips

1. **Morning Briefing First**: Always run `morning` to see all project states
2. **Commit Often**: 3-5+ commits per day keeps history clear
3. **Descriptive Messages**: Use prefixes (Add:, Update:, Fix:, Create:)
4. **End Every Day**: Run `/eod` or `eod` to capture ALL projects
5. **Multi-Project Awareness**: The briefing shows EVERY project - not just current one
6. **Use Aliases**: Install them once, save time forever

---

## Commit Message Conventions

- `Add:` - New feature or file
- `Create:` - New script, tool, or component
- `Update:` - Changes to existing code
- `Fix:` - Bug fixes
- `Refactor:` - Code restructuring
- `Docs:` - Documentation only
- `Test:` - Adding or updating tests

---

## Troubleshooting

**Script not found?**
```bash
cd ~/projects/terminal-work
chmod +x scripts/*.sh
```

**Aliases not working?**
```bash
source ~/projects/terminal-work/config/bash-aliases.sh
```

**Context not syncing?**
```bash
./scripts/context-sync.sh
```

---

## Full Workflow Summary

```
Morning:    Run Morning Briefing → See ALL Projects → Pick One → Start Work
During Day: Work → Quick Commit → Work → Quick Commit (repeat)
End of Day: Run EOD → All Projects Scanned → Enter Summary → Push → Close ALL Terminals
Next Day:   Morning Briefing shows exactly where EVERY project left off!
```

## Key Benefits

✓ **Never lose context** - Morning briefing shows ALL projects
✓ **Know what needs attention** - Uncommitted changes flagged with ⚠️
✓ **Instant resume** - Copy/paste exact `cd` commands
✓ **Multi-project awareness** - See everything at once
✓ **Safe to close terminals** - Full state preserved every night
✓ **Daily continuity** - Yesterday's summary + today's priorities

---

**Ready to work smarter? Install aliases and start your workflow!**
