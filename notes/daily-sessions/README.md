# Daily Sessions

This directory contains daily terminal session captures created by the end-of-day script.

## Files

- `YYYY-MM-DD.md` - Daily session capture with summary, terminal states, and tasks
- `YYYY-MM-DD-plan.md` - Next day's plan file with carry-over tasks

## Usage

Generated automatically by:
```bash
./scripts/end-of-day.sh
# or
/eod (in Claude Code)
# or
eod (if aliases installed)
```

## What's Captured

Each session file includes:
- Summary of the day's work
- Current directory and git status
- Recent command history
- Modified files
- Active tasks from WORKFLOW_STATE.md
- Running processes
- Tmux sessions
- Notes for tomorrow

## Starting Fresh Tomorrow

1. Review yesterday's file: `cat notes/daily-sessions/YYYY-MM-DD.md`
2. Check tomorrow's plan: `cat notes/daily-sessions/YYYY-MM-DD-plan.md`
3. Sync context: `./scripts/context-sync.sh`
4. Continue working with full context preserved!
