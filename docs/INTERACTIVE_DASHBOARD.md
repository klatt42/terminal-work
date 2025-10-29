# Interactive Terminal Session Dashboard

## Overview

A live, interactive dashboard that provides real-time monitoring of all your terminal sessions, AI activity, git status, and project states at a glance.

**Created**: 2025-10-29
**Location**: `superdesign/design_iterations/terminal-session-monitor-v1.html`

---

## Features

### 1. Real-Time Session Monitoring
- **Active Sessions**: Track which terminal sessions are currently running
- **Project Status**: See git branch, uncommitted changes, and working directory state
- **AI Detection**: Automatically detects which AI assistant is being used in each session
- **Uptime Tracking**: Monitor how long each session has been active

### 2. Live Statistics
- **Active Sessions Count**: Number of currently running terminal sessions
- **Total Projects**: All projects being monitored
- **AI Commands**: Count of AI assistant commands executed
- **Git Operations**: Uncommitted changes across all projects

### 3. AI Assistant Status
Shows real-time status of all 5 AI assistants:
- Claude Code
- Perplexity
- Gemini CLI
- OpenCode (Grok)
- Codex

### 4. Command History
- View recent commands for each session
- Track last executed command per project
- Terminal-style display with syntax highlighting

### 5. Visual Indicators
- **Green glow**: Active sessions
- **Status badges**: AI in use, git status, running state
- **Pulsing dot**: Live monitoring indicator
- **Color-coded cards**: Easy visual scanning

---

## Quick Start

### View the Dashboard

```bash
# Open in browser
xdg-open ~/projects/terminal-work/superdesign/design_iterations/terminal-session-monitor-v1.html

# Or use alias (after setup)
dashboard
```

### Collect Session Data

```bash
# Run data collection script
~/projects/terminal-work/scripts/session-monitor.sh

# The dashboard will auto-refresh every 5 seconds
```

---

## Setup

### 1. Create Dashboard Alias

Add to your `~/.bashrc`:

```bash
alias dashboard='xdg-open ~/projects/terminal-work/superdesign/design_iterations/terminal-session-monitor-v1.html'
alias monitor='~/projects/terminal-work/scripts/session-monitor.sh'
```

Then reload:
```bash
source ~/.bashrc
```

### 2. Auto-Refresh Data (Optional)

For live data updates, run the monitor script in the background:

```bash
# Run every 5 seconds
watch -n 5 ~/projects/terminal-work/scripts/session-monitor.sh &

# Or add to your morning workflow
echo "watch -n 5 ~/projects/terminal-work/scripts/session-monitor.sh &" >> ~/.bashrc
```

### 3. Add to Morning Workflow

Update your morning command to show the dashboard:

```bash
# Edit your morning script to include:
dashboard &
```

---

## How It Works

### Data Collection (`session-monitor.sh`)

The script collects:
- All projects in `/home/klatt42/projects/`
- Git status (branch, uncommitted changes)
- Recent command history
- AI detection based on command patterns
- Tmux session activity

### Dashboard Display

The HTML dashboard:
- Auto-refreshes every 5 seconds
- Updates timestamp every second
- Shows color-coded session cards
- Displays live statistics
- Provides interactive hover effects

---

## Dashboard Layout

```
┌─────────────────────────────────────────────────┐
│ Terminal Session Monitor          [Live] [↻]   │
├─────────────────────────────────────────────────┤
│ [Active] [Projects] [AI Cmds] [Git Ops]        │
├─────────────────────────────────────────────────┤
│ Active AI Assistants                            │
│ ● Claude Code (2)  ● Perplexity (1)            │
│ ○ Gemini CLI (0)   ● OpenCode (1)              │
├─────────────────────────────────────────────────┤
│ ┌─ terminal-work ────────────────────────────┐ │
│ │ [Running] [Claude Code] [Clean]            │ │
│ │ ⏱️ 2h 34m | 🔀 main                        │ │
│ │ /home/klatt42/projects/terminal-work       │ │
│ │                                             │ │
│ │ Last Command: SuperDesign integration      │ │
│ │ Recent: $ npm run build                    │ │
│ │         $ git status                       │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│ ┌─ project-genesis ─────────────────────────┐  │
│ │ [Running] [Perplexity] [Dirty]            │  │
│ │ ⏱️ 45m | 🔀 feature/superdesign | 📝 3    │  │
│ └─────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────┘
```

---

## Multi-AI Integration

The dashboard is **SuperDesign-powered** and integrates with your multi-AI orchestration system:

### AI Detection Logic

```bash
# Claude Code
Commands with: claude, code

# Gemini CLI
Commands with: gemini

# Perplexity
Commands with: ai <query>

# OpenCode/Grok
Commands with: opencode, grok

# Codex
Commands with: codex
```

### Workflow Integration

```bash
# Morning workflow
$ morning                    # Shows project status
$ dashboard                  # Opens interactive dashboard
$ monitor                    # Starts live data collection

# During work
Dashboard auto-updates every 5s showing:
- Which AI you're using in each project
- Git status for quick context switching
- Command history for continuity

# End of day
$ eod                        # Captures state, includes dashboard snapshot
```

---

## Use Cases

### 1. Morning Briefing
Open dashboard to see:
- Which projects have uncommitted changes
- Which sessions are still active from yesterday
- Git branches you're working on

### 2. Context Switching
Quickly see:
- What you were working on in each project
- Last command executed
- Current git branch

### 3. Multi-Project Management
Monitor:
- 3+ projects simultaneously
- Different AI assistants in each
- Git status at a glance

### 4. Team Collaboration
Share dashboard to show:
- Active work streams
- Project states
- AI tools being used

---

## Customization

### Change Refresh Rate

Edit `terminal-session-monitor-v1.html`:

```javascript
// Current: 5 seconds
setInterval(refreshData, 5000);

// Change to 10 seconds
setInterval(refreshData, 10000);
```

### Add Custom Projects

Edit `session-monitor.sh`:

```bash
# Change projects directory
PROJECTS_DIR="/home/klatt42/projects"

# Add additional directories
PROJECTS_DIR="/home/klatt42/projects:/home/klatt42/work"
```

### Customize Colors

Edit CSS in `terminal-session-monitor-v1.html`:

```css
/* Main accent color */
--primary: #00d9ff;    /* Cyan */
--secondary: #7b2cbf;   /* Purple */
--success: #00ff88;     /* Green */
```

---

## Future Enhancements

### Planned Features
- [ ] Voice integration ("show dashboard")
- [ ] Real-time tmux session monitoring
- [ ] Git commit graph per project
- [ ] AI command analytics
- [ ] Session time tracking
- [ ] Export reports (daily/weekly)
- [ ] Slack/Discord integration
- [ ] Mobile-optimized view

### Advanced Features
- [ ] WebSocket for true real-time updates
- [ ] Backend API for data persistence
- [ ] Historical session tracking
- [ ] AI productivity metrics
- [ ] Multi-user support
- [ ] Dashboard customization UI

---

## Troubleshooting

### Dashboard Not Updating

**Problem**: Data appears stale

**Solution**:
```bash
# Manually run monitor script
~/projects/terminal-work/scripts/session-monitor.sh

# Check if watch is running
ps aux | grep session-monitor

# Restart watch
killall watch
watch -n 5 ~/projects/terminal-work/scripts/session-monitor.sh &
```

### Sessions Not Detected

**Problem**: Projects not showing up

**Solution**:
```bash
# Check projects directory
ls ~/projects

# Verify script has correct path
grep PROJECTS_DIR ~/projects/terminal-work/scripts/session-monitor.sh

# Run script manually to see output
bash -x ~/projects/terminal-work/scripts/session-monitor.sh
```

### AI Detection Not Working

**Problem**: "None" shows for AI field

**Solution**:
```bash
# Command history needs to contain AI commands
# Run some AI commands, then refresh:
claude "test"
~/projects/terminal-work/scripts/session-monitor.sh
```

---

## Integration with Other Tools

### With Morning Command

```bash
# ~/.bashrc or morning script
morning() {
    # Existing morning code...

    # Show dashboard
    dashboard &

    # Start monitoring
    monitor &
}
```

### With EOD Command

```bash
# scripts/end-of-day.sh
# Capture dashboard state
cp superdesign/design_iterations/terminal-session-monitor-v1.html \
   notes/daily-sessions/$(date +%Y-%m-%d)-dashboard.html
```

### With Context Sync

```bash
# scripts/context-sync.sh
# Update dashboard data before syncing
~/projects/terminal-work/scripts/session-monitor.sh
```

---

## Files

### Dashboard
- **HTML**: `superdesign/design_iterations/terminal-session-monitor-v1.html`
- **Data**: `superdesign/design_iterations/session-data.json`
- **Script**: `scripts/session-monitor.sh`

### Dependencies
- `bash` - Shell script execution
- `git` - Git status detection
- `tmux` (optional) - Session activity detection
- `xdg-open` - Open dashboard in browser

---

## Keyboard Shortcuts (Future)

When dashboard is active:

- `R` - Manual refresh
- `S` - Sort sessions by activity
- `F` - Filter by AI assistant
- `G` - Filter by git status
- `?` - Show help

---

## SuperDesign Method

This dashboard was created using **SuperDesign Method #1: Interactive Canvas**:

1. Generated initial design with Claude Code + SuperDesign
2. Iterated on color scheme and layout
3. Added live data integration
4. Created backend data collection script
5. Integrated with multi-AI orchestration system

**Design Philosophy**:
- Terminal-inspired aesthetic
- Real-time updates (5s refresh)
- Color-coded visual hierarchy
- Mobile-responsive layout
- Minimal but informative

---

## Summary

The **Interactive Terminal Session Dashboard** provides:

✅ **Real-time monitoring** of all terminal sessions
✅ **AI detection** showing which assistant is active
✅ **Git status** at a glance
✅ **Command history** for context
✅ **Live statistics** and metrics
✅ **Auto-refresh** every 5 seconds
✅ **Beautiful UI** with SuperDesign
✅ **Integrated** with multi-AI workflows

**Ready to use**: Open the dashboard and start monitoring!

```bash
dashboard
```

---

**Created by**: Claude Code + SuperDesign
**Date**: 2025-10-29
**Version**: 1.0.0
**Status**: Production Ready
