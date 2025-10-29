# AI CLI Reference Guide

Complete reference for all installed AI assistants in your terminal workspace.

---

## Installed AI CLIs

| AI | Version | Command | Best For |
|---|---------|---------|----------|
| **Claude Code** | 2.0.20 | `claude` | Advanced reasoning, security, orchestration |
| **Gemini CLI** | 0.11.0 | `gemini` | Large context (2M tokens), documentation |
| **OpenCode** | 0.15.23 | `opencode` | Free Grok access, fast coding |

---

## Claude Code

**Installed**: ✓ Already configured
**Authentication**: Via Anthropic account

### Usage

```bash
# Interactive mode (you're in it now!)
claude

# Single prompt
claude "explain this code"

# With thinking
claude "think: analyze this architecture"
claude "think hard: complex design decision"
```

### Strengths
- Deep reasoning and analysis
- Security-focused code review
- Complex multi-step workflows
- 6 specialized subagents configured

### When to Use
- Architecture decisions
- Security audits
- Complex refactoring
- Multi-file changes

---

## Gemini CLI

**Installed**: ✓ (version 0.11.0)
**Authentication**: Required on first use

### First-Time Setup

```bash
# Launch Gemini (will prompt for authentication)
gemini

# Follow the prompts to authenticate with your Google account
```

### Usage

```bash
# Interactive mode
gemini

# Single prompt
gemini "analyze this project"

# With model selection
gemini -m gemini-2.0-flash-exp "quick task"

# JSON output
gemini -o json "return structured data"

# Auto-approve edit tools
gemini --approval-mode auto_edit

# YOLO mode (auto-approve all)
gemini -y "automated task"
```

### Strengths
- **Massive context**: 2M tokens (handles large codebases)
- Fast iterations
- Good for documentation generation
- Excellent at understanding large contexts

### When to Use
- Analyzing entire codebases
- Generating comprehensive documentation
- Working with large files
- Multi-file context understanding

---

## OpenCode (Free Grok Access)

**Installed**: ✓ (version 0.15.23)
**Authentication**: Not required for free Grok
**Cost**: FREE (limited time via OpenCode)

### First-Time Setup

```bash
# Launch OpenCode
opencode

# Run /models command to see available models
/models

# Select "Grok Code Free" for free access
```

### Usage

```bash
# Interactive mode
opencode

# Once in OpenCode:
/models              # List available models
/model grok-free     # Switch to free Grok
/help                # Show available commands
```

### Available Models via OpenCode
- **Grok Code Fast 1** (FREE) - Fast coding tasks
- Anthropic Claude (requires API key)
- OpenAI GPT (requires API key)
- And many more...

### Strengths
- FREE Grok access (no API key needed)
- Very fast code generation
- Cost-effective for testing
- Good for rapid prototyping

### When to Use
- Quick code generation
- Testing ideas rapidly
- Learning/experimentation
- Cost-conscious development

### Important Notes
- Free Grok is **limited time** - xAI collecting feedback
- Request logs used to improve Grok Code
- Make sure you're on latest OpenCode version

---

## Multi-AI Workflow Strategy

### Task Assignment Matrix

| Task Type | Primary AI | Secondary AI | Why |
|-----------|-----------|--------------|-----|
| **Architecture** | Claude Code | Gemini | Deep reasoning + context |
| **Security Review** | Claude Code | - | Critical analysis required |
| **Documentation** | Gemini | OpenCode | Large context + speed |
| **Large Codebase** | Gemini | Claude Code | 2M token context |
| **Quick Prototyping** | OpenCode | - | Free + fast |
| **Code Generation** | OpenCode/Gemini | Claude Code | Speed vs quality |
| **Testing** | OpenCode | Gemini | Automation + cost |
| **Refactoring** | Claude Code | Gemini | Complexity + context |

---

## Authentication Status

### Claude Code ✓
- Authenticated via your Anthropic account
- No additional setup needed

### Gemini CLI ⚠️
- **Needs authentication on first use**
- Run: `gemini` and follow prompts
- Uses Google account
- Free tier available

### OpenCode ✓
- No authentication needed for free Grok
- Just run: `opencode`
- Select "Grok Code Free" model

---

## Quick Start Commands

### Testing Each AI

```bash
# Test Claude Code (you're in it!)
claude "What AI CLIs are installed?"

# Test Gemini (will prompt for auth first time)
gemini "List files in current directory"

# Test OpenCode with free Grok
opencode
# Then in OpenCode:
/models
# Select "Grok Code Free"
# Then: "Show me project structure"
```

---

## Tips for Multi-AI Usage

### 1. Use the Right Tool
Don't use Claude for everything. Match the AI to the task:
- Quick code → OpenCode (free!)
- Large files → Gemini (2M context)
- Complex logic → Claude Code

### 2. Parallel Workflows
Open multiple terminals:
- Terminal 1: Claude Code (architecture)
- Terminal 2: Gemini (documentation)
- Terminal 3: OpenCode (code generation)
- Terminal 4: Monitoring (`watch git status`)

### 3. Context Sync
Before switching AIs, sync context:
```bash
ctx                  # Sync context (alias)
# or
./scripts/context-sync.sh
```

### 4. Morning Briefing Shows All
```bash
morning              # Your workflow already tracks all AIs
```

---

## Terminal Layout Recommendations

### Option 1: Four-Panel (tmux)
```
┌─────────────┬─────────────┐
│ WSL         │ Claude Code │
│ (monitoring)│ (primary)   │
├─────────────┼─────────────┤
│ Gemini CLI  │ OpenCode    │
│ (docs)      │ (fast code) │
└─────────────┴─────────────┘
```

### Option 2: Three-Panel
```
┌─────────────────────────────┐
│   Claude Code (primary)     │
├──────────────┬──────────────┤
│  Gemini CLI  │  OpenCode    │
│  (context)   │  (speed)     │
└──────────────┴──────────────┘
```

---

## Cost Comparison

| AI | Cost | Notes |
|---|------|-------|
| Claude Code | Included in subscription | Part of your Anthropic plan |
| Gemini CLI | Free tier + paid | Free quota available |
| OpenCode (Grok) | **FREE** | Limited time, then API key needed |

**Pro Tip**: Use OpenCode's free Grok for prototyping, Claude Code for production!

---

## Next Steps

1. **Authenticate Gemini**:
   ```bash
   gemini
   # Follow authentication prompts
   ```

2. **Test OpenCode with Free Grok**:
   ```bash
   opencode
   # In OpenCode: /models
   # Select: Grok Code Free
   ```

3. **Try First Multi-AI Workflow**:
   ```bash
   # Terminal 1: Claude Code (already open!)
   claude "Design user authentication system"

   # Terminal 2: Gemini
   gemini "Generate docs for auth system"

   # Terminal 3: OpenCode
   opencode
   # /models → Grok Code Free
   # "Generate auth middleware code"
   ```

4. **Read Full Workflow Guide**:
   ```bash
   cat ~/projects/terminal-work/WORKFLOW.md
   ```

---

**All AI CLIs installed and ready! 🚀**

See `QUICKSTART.md` for detailed multi-AI workflows.
