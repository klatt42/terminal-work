# Scripts Directory

Automation scripts for terminal workflow.

---

## Daily Workflow Scripts

### quick-commit.sh
Fast commits throughout the day.

```bash
./scripts/quick-commit.sh "Add: morning notes"
./scripts/quick-commit.sh  # Prompts for message
```

Asks if you want to push after committing.

### end-of-day.sh
Complete end-of-day workflow: capture, sync, commit, push.

```bash
./scripts/end-of-day.sh
```

Creates:
- Daily session file with terminal states
- Tomorrow's plan file
- Commits and pushes everything

---

## Context Management Scripts

### context-sync.sh
Synchronizes AI context files for all AI assistants.

```bash
./scripts/context-sync.sh
```

Updates:
- AI_CONTEXT.md
- WORKFLOW_STATE.md (if exists)
- .ai-state.json

---

## Installation & Setup Scripts

### install-ais.sh
Interactive installation guide for AI CLIs.

```bash
./scripts/install-ais.sh
```

Helps install:
- Gemini CLI
- Grok CLI
- tmux (optional)

### ai-orchestrator.sh
Multi-AI coordination helper (requires all AIs installed).

```bash
./scripts/ai-orchestrator.sh
```

### voice-terminal.sh
Voice command integration handler (requires voice control setup).

```bash
./scripts/voice-terminal.sh
```

---

## Quick Reference

| Script | Purpose | When to Use |
|--------|---------|-------------|
| quick-commit.sh | Fast commit | Multiple times per day |
| end-of-day.sh | Capture & push | End of each day |
| context-sync.sh | Sync AI context | Before multi-AI workflows |
| install-ais.sh | Install AI CLIs | Initial setup |
| ai-orchestrator.sh | Multi-AI tasks | Advanced workflows |
| voice-terminal.sh | Voice commands | Hands-free operation |

---

## Making Scripts Executable

If you get "Permission denied":

```bash
chmod +x scripts/*.sh
```

---

## Aliases

Install shell aliases for quick access:

```bash
source config/bash-aliases.sh
# or permanently:
echo "source ~/projects/terminal-work/config/bash-aliases.sh" >> ~/.bashrc
```

Then use:
- `qc "message"` instead of `./scripts/quick-commit.sh "message"`
- `eod` instead of `./scripts/end-of-day.sh`
- `ctx` instead of `./scripts/context-sync.sh`

See `config/INSTALL_ALIASES.md` for full list.
