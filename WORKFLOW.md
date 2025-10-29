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
1. Captures terminal states (pwd, git status, command history)
2. Prompts for your daily summary
3. Updates AI context files
4. Commits all changes
5. Pushes to GitHub
6. Creates tomorrow's plan file

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
- `notes/daily-sessions/YYYY-MM-DD.md` - Today's session
- `notes/daily-sessions/YYYY-MM-DD-plan.md` - Tomorrow's plan

---

## Starting Fresh Tomorrow

1. Open terminal
2. Navigate to project:
   ```bash
   cd ~/projects/terminal-work
   ```

3. Review yesterday:
   ```bash
   cat notes/daily-sessions/$(date -d yesterday '+%Y-%m-%d' 2>/dev/null || date -v-1d '+%Y-%m-%d' 2>/dev/null).md
   ```

4. Check today's plan:
   ```bash
   cat notes/daily-sessions/$(date '+%Y-%m-%d')-plan.md
   ```

5. Sync context:
   ```bash
   ./scripts/context-sync.sh
   ```

6. Start working with full context!

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
- `sync-context` - Sync AI context
- `ctx` - Sync context (short)
- `tw` - Go to terminal-work
- `tws` - Go to terminal-work + git status

---

## Example Day

**Morning (9:00 AM)**
```bash
tw                              # Navigate to project
cat notes/daily-sessions/$(date '+%Y-%m-%d')-plan.md  # Review plan
ctx                             # Sync context
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
# Enter summary when prompted
# Enter final commit message
# Everything pushed to GitHub!
```

**Close terminals - your context is saved!**

---

## Tips

1. **Commit Often**: 3-5+ commits per day keeps history clear
2. **Descriptive Messages**: Use prefixes (Add:, Update:, Fix:, Create:)
3. **End Every Day**: Run `/eod` or `eod` to preserve context
4. **Review Plans**: Start each day by reading yesterday's session
5. **Use Aliases**: Install them once, save time forever

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
Morning:    Review → Sync Context → Start Work
During Day: Work → Quick Commit → Work → Quick Commit (repeat)
End of Day: Run EOD → Enter Summary → Push → Close Terminals
Next Day:   Fresh start with full context preserved!
```

---

**Ready to work smarter? Install aliases and start your workflow!**
