# Project State Snapshot System

**Status:** ✅ Complete and Tested
**Date:** 2025-10-30
**Implementation:** Option A from Strategic Recommendations

## Overview

The Project State Snapshot System provides comprehensive project state capture and resume functionality, enabling seamless context switching between projects and AI sessions. This system solves the problem of losing context when switching between multiple projects or handing work between Claude.AI and Claude Code.

## Features

### 1. Snapshot Creation (`snapshot-create`)
Captures comprehensive project state including:
- Git status (branch, commits, uncommitted changes, modified files, stashes)
- Development environment (package.json, dependencies, dev server status)
- Project metadata (type detection for Next.js, Vite, React, etc.)
- Environment files (.env, .env.local, etc.)
- Recent terminal commands
- Claude session context (if using handoff system)
- Active tasks/TODO files

### 2. Snapshot Resume (`snapshot-resume`)
Intelligently restores and displays project state with:
- Side-by-side comparison of snapshot state vs current state
- Warnings for branch changes or missing dependencies
- Quick action suggestions (install deps, start server, review changes)
- Task file preview for immediate context
- Clear next steps for resuming work

### 3. AI Session Handoff (`handoff-to-cc` / `handoff-from-cc`)
Seamlessly transfer work context between Claude.AI and Claude Code:
- **handoff-to-cc**: Captures PRD/requirements from Claude.AI, creates session context
- **handoff-from-cc**: Generates formatted summary of work done for Claude.AI

## Installation

The system is already installed and configured in `terminal-work`. Aliases are available after sourcing bash-aliases.sh:

```bash
source ~/projects/terminal-work/config/bash-aliases.sh
```

## Usage

### Basic Snapshot Workflow

```bash
# Navigate to your project
cd ~/projects/my-app

# Create a snapshot
snapshot-create "Completed user authentication"

# Work on something else...

# Resume later
snapshot-resume

# List all snapshots
snapshot-list
```

### AI Handoff Workflow

**Starting from Claude.AI:**

1. In Claude.AI, create a PRD for your feature
2. Save the PRD to your project: `~/projects/my-app/prd-payment-system.md`
3. In terminal:
```bash
cd ~/projects/my-app
handoff-to-cc prd-payment-system.md
```

4. Work with Claude Code to implement the feature
5. When done:
```bash
handoff-from-cc
# Summary is copied to clipboard automatically
```

6. Paste summary back into Claude.AI conversation for review/iteration

**Interactive Mode (no PRD file):**

```bash
cd ~/projects/my-app
handoff-to-cc
# Answer prompts for PRD file, goal, and Claude.AI URL
```

### Advanced Usage

**Resume specific snapshot:**
```bash
snapshot-resume 20251030-143022
```

**Create snapshot without copying summary:**
```bash
handoff-from-cc --no-copy
```

**Manual snapshot inspection:**
```bash
cat .snapshots/latest-summary.txt
cat .snapshots/snapshot-20251030-143022.json
```

## File Structure

Each project using snapshots will have:

```
my-project/
├── .snapshots/                    # Git-ignored snapshot directory
│   ├── snapshot-YYYYMMDD-HHMMSS.json
│   ├── latest.json               # Symlink to most recent
│   └── latest-summary.txt        # Human-readable summary
├── .claude-session               # Git-ignored session context
├── .handoff-summary.md           # Generated handoff summary
└── .gitignore                    # Auto-updated to ignore snapshots
```

## Available Commands

### Snapshot Commands
- `snapshot` - Create snapshot (alias for snapshot-create)
- `snapshot-create [message]` - Create snapshot with optional message
- `snapshot-resume [timestamp]` - Resume latest or specific snapshot
- `snapshot-list` - List all available snapshots

### Handoff Commands
- `handoff-to-cc [prd-file]` - Initialize Claude Code session from PRD
- `handoff-from-cc` - Generate summary for Claude.AI

## How It Answers Your Question

**Your Question:** "How will CC know which Claude.AI to feed back to?"

**Answer:** The system uses a `.claude-session` file created by `handoff-to-cc` that stores:
- PRD filename reference
- Original goal/description
- Optional Claude.AI conversation URL
- Session start timestamp

When you run `handoff-from-cc`, it:
1. Reads the `.claude-session` file to understand the original context
2. Generates a summary that references the original PRD and goal
3. Shows you which Claude.AI conversation it corresponds to (if you provided URL)
4. Copies the formatted summary to clipboard for easy pasting

Since Claude Code can't directly access Claude.AI conversations, the handoff is manual (copy/paste), but the system makes it intelligent by tracking which conversation you were working from and formatting the summary appropriately.

## Benefits

1. **Never lose context** - Resume work immediately with full state awareness
2. **Smart comparison** - See what changed since last snapshot
3. **Multi-AI workflow** - Seamlessly move between Claude.AI (planning) and Claude Code (implementation)
4. **Automatic detection** - Warns about missing dependencies, branch changes, stopped servers
5. **Git-friendly** - All state files are git-ignored to prevent repo pollution
6. **Zero overhead** - Snapshots are fast, lightweight JSON files
7. **Human-readable** - Both JSON and text summaries available

## Integration with Existing Tools

The snapshot system integrates with:
- **Morning briefing** - Could show recent snapshots across all projects
- **Dashboard** - Could display snapshot status for each project
- **End-of-day** - Could auto-create snapshots before shutdown
- **Quick commit** - Could create snapshot after successful commits

## Future Enhancements (Not Yet Implemented)

From the strategic recommendations list:

- **Option B (PRD → Implementation Tracker)** - Track tasks from PRD to completion
- **Option C (Multi-AI Task Router)** - Automatically route tasks to best AI
- **Option D (Error Pattern Learning)** - Learn from repeated errors
- **Option E (AI Pair Programming)** - Real-time multi-AI collaboration
- **Option F (Cross-Project Intelligence)** - Share learnings between projects
- **Option G (Voice Control)** - Voice commands for snapshot/handoff
- **Option H (Progress Analytics)** - Track velocity and patterns
- **Option I (Automated Documentation)** - Auto-generate docs from snapshots

## Technical Details

### Snapshot Data Structure

```json
{
    "snapshot_meta": {
        "timestamp": "20251030-143022",
        "human_time": "2025-10-30 14:30:22",
        "message": "User's snapshot message",
        "project_name": "my-app",
        "project_path": "/home/user/projects/my-app",
        "project_type": "Next.js"
    },
    "git": {
        "branch": "main",
        "commit": "abc123...",
        "commit_message": "Last commit message",
        "uncommitted_changes": 5,
        "stashes": 0,
        "modified_files": ["src/app.ts", "package.json"]
    },
    "development": {
        "has_package_json": true,
        "package_name": "my-app",
        "package_version": "1.0.0",
        "node_modules_installed": true,
        "env_files": [".env.local"],
        "dev_server_running": true,
        "dev_server_port": "3000",
        "dev_server_pid": "12345"
    },
    "context": {
        "claude_session_active": true,
        "prd_reference": "prd-payment-system.md",
        "tasks_file": "NEXT_SESSION_TASKS.md",
        "recent_commands": ["npm run dev", "git status", "snapshot-create"]
    }
}
```

### Session File Structure

```yaml
# Claude Code Session Context
# Created: 2025-10-30 14:30:22
# Handoff from Claude.AI → Claude Code

project_name: my-app
prd_file: prd-payment-system.md
goal: Implement Stripe payment processing with subscription management
claude_url: https://claude.ai/chat/abc-123-def
session_start: 2025-10-30T14:30:22-04:00

# Session Notes
# Add any additional context or notes below:
```

## Testing

System has been tested on `terminal-work` project with:
- ✅ Snapshot creation
- ✅ Snapshot resume
- ✅ Snapshot listing
- ✅ Handoff summary generation
- ✅ Git status tracking
- ✅ Modified file detection
- ✅ Auto-gitignore updates

## Scripts

Located in `~/projects/terminal-work/scripts/`:
- `snapshot-create.sh` - Create project snapshots
- `snapshot-resume.sh` - Resume from snapshots
- `handoff-to-cc.sh` - Initialize Claude Code session
- `handoff-from-cc.sh` - Generate handoff summary

## Support

For issues or enhancements, update this README or create tasks in the terminal-work project.

---

**Generated:** 2025-10-30
**System Version:** 1.0.0
**Status:** Production Ready ✅
