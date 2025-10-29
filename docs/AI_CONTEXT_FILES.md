# AI Context Synchronization System

## Overview

Each AI has its own context file in the home directory (`~/`) that provides AI-specific instructions and shared project context. These files ensure all AIs have synchronized understanding of:
- Project structure and goals
- Active ports and running services
- Multi-AI workflow roles
- User preferences
- Shared context files

---

## AI-Specific Context Files

### Location
All files are in home directory: `~/`

| File | AI | Purpose |
|------|---|---------|
| `~/CLAUDE.md` | Claude Code | Primary AI context, user instructions |
| `~/GEMINI.md` | Gemini CLI | 2M token context specialist |
| `~/CODEX.md` | Codex | Interactive coding agent |
| `~/GROK.md` | OpenCode/Grok | Free Grok access |
| `~/PERPLEXITY.md` | Perplexity | Real-time research |

---

## What's in Each File

Each AI context file contains:

1. **Project Information** - Primary project paths and git repo
2. **Port Usage** - Active services to avoid conflicts
3. **Multi-AI Setup** - List of all 5 AIs and their roles
4. **Your Role** - Specific AI's strengths and use cases
5. **Workflow Integration** - How to sync with other AIs
6. **Available Commands** - Workflow shortcuts (morning, eod, qc, etc.)
7. **Shared Context Files** - Links to AI_CONTEXT.md, WORKFLOW_STATE.md, etc.
8. **User Preferences** - Keep ports running, multi-project awareness
9. **Last Updated** - Auto-synced timestamp

---

## Auto-Sync System

### When Context Syncs

Context files are updated automatically when you run:

```bash
ctx                                      # Alias
# or
./scripts/context-sync.sh                # Direct
# or
morning / eod                            # Part of daily workflow
```

### What Gets Synced

1. **Timestamps** - All AI files get updated timestamp
2. **AI_CONTEXT.md** - Project-wide context
3. **.ai-state.json** - Programmatic state
4. **WORKFLOW_STATE.md** - Task tracking (if exists)

---

## How It Works

```bash
# User runs context sync
ctx

# Script updates:
1. ~/projects/terminal-work/AI_CONTEXT.md
2. ~/projects/terminal-work/.ai-state.json
3. ~/CLAUDE.md (timestamp)
4. ~/GEMINI.md (timestamp)
5. ~/CODEX.md (timestamp)
6. ~/GROK.md (timestamp)
7. ~/PERPLEXITY.md (timestamp)
```

---

## Why This Matters

### Problem Without Sync
- Claude knows about Project A
- Gemini doesn't know Project A exists
- Codex makes changes that conflict
- ❌ AIs work in silos

### Solution With Sync
- All AIs read same context files
- All AIs know active ports
- All AIs understand their roles
- ✅ AIs work as coordinated team

---

## Viewing Context Files

### See What an AI Knows

```bash
# Claude Code
cat ~/CLAUDE.md

# Gemini CLI
cat ~/GEMINI.md

# Codex
cat ~/CODEX.md

# Grok/OpenCode
cat ~/GROK.md

# Perplexity
cat ~/PERPLEXITY.md
```

### See Shared Context

```bash
# Project-wide context
cat ~/projects/terminal-work/AI_CONTEXT.md

# Programmatic state
cat ~/projects/terminal-work/.ai-state.json

# Task tracking
cat ~/projects/terminal-work/WORKFLOW_STATE.md
```

---

## Updating Context

### Manual Update

Edit any AI's context file:
```bash
nano ~/GEMINI.md
```

Then sync to update timestamps:
```bash
ctx
```

### Automatic Updates

Context syncs automatically during:
- `morning` - Morning briefing
- `eod` - End of day workflow
- Manual `ctx` calls

---

## Best Practices

### 1. Sync Before Multi-AI Workflows
```bash
ctx                          # Sync context
# Then open multiple terminals with different AIs
```

### 2. Keep Ports Updated
If you start new services, update `~/CLAUDE.md` port section:
```markdown
## Port Usage
- Copilot: 3006
- Archon OS: 3737
- MyNewApp: 4000  # Add new ports here
```

Then sync:
```bash
ctx
```

### 3. Add Project-Specific Instructions
Add to any AI's context file:
```markdown
## Project-Specific Notes
- Use pnpm, not npm
- Always run tests before committing
- Follow ESLint rules strictly
```

### 4. Sync After Major Changes
Completed big feature? Update context:
```bash
# Work on feature...
qc "Add: new auth system"

# Update shared context
ctx

# Other AIs now know about auth system
```

---

## Context File Structure

### Template for New AIs

If you add another AI, create `~/NEWAI.md` with:

```markdown
# [AI Name] Context

## Project Information
- Primary Project: ~/projects/terminal-work
- Git Repository: https://github.com/klatt42/terminal-work

## Port Usage
- [List active ports]

## Multi-AI Setup
[List all 5 AIs and their roles]

## Your Role ([This AI])
**Strengths**: [What this AI does best]
**Best Used For**: [When to use this AI]

## Workflow Integration
[How to sync with other AIs]

## Shared Context Files
- AI_CONTEXT.md
- WORKFLOW_STATE.md
- .ai-state.json
- [All AI-specific .md files]

## User Preferences
[User's workflow preferences]

---

**Last Updated**: [Auto-synced timestamp]
```

Then add to `scripts/context-sync.sh`:
```bash
for ai_file in "$HOME"/CLAUDE.md "$HOME"/GEMINI.md "$HOME"/CODEX.md "$HOME"/GROK.md "$HOME"/PERPLEXITY.md "$HOME"/NEWAI.md; do
```

---

## Troubleshooting

### Context Files Not Syncing?

```bash
# Check if files exist
ls -la ~/{CLAUDE,GEMINI,CODEX,GROK,PERPLEXITY}.md

# Run sync manually
~/projects/terminal-work/scripts/context-sync.sh

# Check for errors
echo $?  # Should be 0
```

### AI Doesn't Seem to Know Context?

Some AIs may not automatically read these files. You can:
1. Copy relevant sections into your prompt
2. Ask AI to read the file: "Read ~/GEMINI.md"
3. Use Claude Code which reads CLAUDE.md automatically

---

## Summary

**5 AI Context Files** → **Auto-synced** → **Coordinated Multi-AI Team**

Every AI knows:
- ✓ What other AIs are doing
- ✓ Active ports and services
- ✓ Project structure
- ✓ User preferences
- ✓ Their specific role

Run `ctx` to sync. That's it!

---

**See also**: AI_CLI_REFERENCE.md for AI usage guides
