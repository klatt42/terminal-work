---
description: Morning briefing - shows all projects status and where to resume
---

Run the morning briefing to see:
- Yesterday's work summary
- All projects with their current git status
- Which projects have uncommitted changes
- Exact `cd` commands to resume work in each project
- Quick commands reference

This helps you start fresh with full context of where every project left off.

Run the most recent morning briefing:
```bash
ls -t ~/projects/terminal-work/notes/daily-sessions/*-morning-briefing.sh | head -1 | xargs bash
```
