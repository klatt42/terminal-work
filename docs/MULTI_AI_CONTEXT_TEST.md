# Multi-AI Context Synchronization Test

**Date**: 2025-10-29
**Test Objective**: Validate context sharing between Claude Code, Gemini CLI, and Codex terminals

## Test Scenario

We'll simulate a collaborative task where:
1. **Claude Code** (Terminal 1) - Plans architecture for a new feature
2. **Gemini CLI** (Terminal 2) - Reads Claude's plan and writes documentation
3. **Codex** (Terminal 3) - Reads both contexts and implements the feature

## Pre-Test Setup

### Current State
- ✅ AI_CONTEXT.md exists and is current
- ✅ WORKFLOW_STATE.md exists with task tracking
- ✅ .ai-state.json contains programmatic state
- ✅ Context sync script available at `scripts/context-sync.sh`

### Terminal Setup Required

```bash
# Terminal 1: Claude Code (Already running - this session)
cd ~/projects/terminal-work

# Terminal 2: Gemini CLI
cd ~/projects/terminal-work
gemini

# Terminal 3: Codex
cd ~/projects/terminal-work
codex
```

## Test Procedure

### Step 1: Claude Code - Initial Planning (Terminal 1)

**Task**: Plan a simple "Task Logger" feature

**Actions**:
1. Read current context files
2. Update WORKFLOW_STATE.md with new task
3. Create architecture plan in docs/TASK_LOGGER_ARCHITECTURE.md
4. Update AI_CONTEXT.md with Claude's contribution
5. Run context sync

**Expected Output**:
- New architecture document created
- WORKFLOW_STATE.md shows Claude's task complete
- AI_CONTEXT.md reflects new active task
- .ai-state.json updated with metrics

### Step 2: Gemini CLI - Documentation (Terminal 2)

**Task**: Read Claude's architecture and create user documentation

**Gemini Commands**:
```bash
# Read context files first
cat AI_CONTEXT.md
cat WORKFLOW_STATE.md
cat docs/TASK_LOGGER_ARCHITECTURE.md

# Task for Gemini
"Create user documentation for the Task Logger feature based on the architecture in docs/TASK_LOGGER_ARCHITECTURE.md. Save to docs/TASK_LOGGER_USER_GUIDE.md"

# After completion
# Update WORKFLOW_STATE.md to mark Gemini's task complete
# Run: ~/projects/terminal-work/scripts/context-sync.sh
```

**Expected Output**:
- Gemini reads Claude's architecture successfully
- Creates comprehensive user guide
- Updates WORKFLOW_STATE.md
- Context sync propagates changes

### Step 3: Codex - Implementation (Terminal 3)

**Task**: Implement the Task Logger based on architecture and docs

**Codex Commands**:
```bash
# Read all context
cat AI_CONTEXT.md
cat WORKFLOW_STATE.md
cat docs/TASK_LOGGER_ARCHITECTURE.md
cat docs/TASK_LOGGER_USER_GUIDE.md

# Task for Codex
"Implement the Task Logger feature based on the architecture and documentation. Create src/task-logger.ts with the core functionality."

# After completion
# Update WORKFLOW_STATE.md
# Update .ai-state.json metrics
# Run context sync
```

**Expected Output**:
- Codex reads both Claude's and Gemini's work
- Implements feature according to spec
- All context files reflect 3-AI collaboration

### Step 4: Back to Claude Code - Verification (Terminal 1)

**Task**: Review all changes and verify context synchronization

**Actions**:
1. Read updated AI_CONTEXT.md
2. Read updated WORKFLOW_STATE.md
3. Read .ai-state.json
4. Verify all three AIs' contributions are visible
5. Run final context sync

**Expected Output**:
- All context files show complete workflow
- Can see contributions from all 3 AIs
- Metrics updated (3 sessions recorded)

## Success Criteria

✅ **Context Sharing**:
- [ ] Gemini successfully read Claude's architecture
- [ ] Codex successfully read both Claude's and Gemini's work
- [ ] All AIs can see each other's updates in shared files

✅ **File Synchronization**:
- [ ] AI_CONTEXT.md reflects all 3 AIs' work
- [ ] WORKFLOW_STATE.md shows task progression across AIs
- [ ] .ai-state.json accurately counts sessions and metrics

✅ **Workflow Integrity**:
- [ ] Tasks completed in logical order
- [ ] No conflicts or overwrites
- [ ] Each AI's contribution builds on previous work

✅ **Context Sync Script**:
- [ ] Timestamps update correctly
- [ ] All home directory AI files synced (~/CLAUDE.md, ~/GEMINI.md, ~/CODEX.md)
- [ ] No errors during sync

## Test Commands Reference

### For User to Execute

```bash
# Open Terminal 2 (Gemini)
# In a new WSL terminal window:
cd ~/projects/terminal-work
gemini

# Open Terminal 3 (Codex)
# In another new WSL terminal window:
cd ~/projects/terminal-work
codex

# Check Gemini CLI is working
gemini --version

# Check Codex is working
codex --version
```

### Context Sync Command (run after each AI completes a task)
```bash
~/projects/terminal-work/scripts/context-sync.sh
```

## Architecture Plan (for Claude to Create)

**File**: `docs/TASK_LOGGER_ARCHITECTURE.md`

**Content Template**:
```markdown
# Task Logger Architecture

## Overview
Simple task logging utility for terminal-work project

## Components
1. TaskLogger class
2. Task storage (JSON file)
3. CLI interface

## API
- addTask(description: string): Task
- listTasks(): Task[]
- completeTask(id: string): void

## Data Structure
{
  id: string,
  description: string,
  status: "pending" | "completed",
  createdAt: Date,
  completedAt?: Date
}

## Integration
- Store tasks in data/tasks.json
- CLI command: `tw-task add "task description"`
```

## Validation Checklist

After test completion, verify:

- [ ] Can open Gemini terminal successfully
- [ ] Can open Codex terminal successfully
- [ ] Both can navigate to ~/projects/terminal-work
- [ ] Both can read AI_CONTEXT.md, WORKFLOW_STATE.md, .ai-state.json
- [ ] Both can write/update files
- [ ] Context sync works from all terminals
- [ ] Changes propagate to home directory AI files
- [ ] No permission issues
- [ ] No file conflicts
- [ ] Git tracking works across all sessions

## Troubleshooting

### If Gemini Can't Read Context Files
```bash
# Check file permissions
ls -la ~/projects/terminal-work/AI_CONTEXT.md

# Fix if needed
chmod 644 ~/projects/terminal-work/AI_CONTEXT.md
chmod 644 ~/projects/terminal-work/WORKFLOW_STATE.md
chmod 644 ~/projects/terminal-work/.ai-state.json
```

### If Context Sync Fails
```bash
# Run manually with verbose output
bash -x ~/projects/terminal-work/scripts/context-sync.sh

# Check home directory files exist
ls -la ~/*.md

# Check write permissions
ls -ld ~/projects/terminal-work/
```

### If Codex Session Can't Execute
```bash
# Verify installation
which codex
codex --version

# Reinstall if needed
npm install -g @openai/codex
```

## Expected Timeline

- Step 1 (Claude): 5 minutes
- Step 2 (Gemini): 10 minutes
- Step 3 (Codex): 10 minutes
- Step 4 (Verification): 5 minutes

**Total**: ~30 minutes

## Post-Test Actions

1. Document findings in notes/testing/multi-ai-context-test-results.md
2. Update genesis-terminal-orchestration skill with any issues found
3. Improve context-sync.sh if needed
4. Add any discovered patterns to TERMINAL_PATTERNS.md
5. Commit all changes with message: "Test: Multi-AI context synchronization"

---

**Status**: Ready to Execute
**Next Step**: Claude Code creates architecture plan
