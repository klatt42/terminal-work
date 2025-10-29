# AI CLI Reference Guide

Complete reference for all installed AI assistants in your terminal workspace.

---

## Installed AI CLIs

| AI | Version | Command | Best For |
|---|---------|---------|----------|
| **Claude Code** | 2.0.20 | `claude` | Advanced reasoning, security, orchestration |
| **Codex** | 0.50.0 | `codex` | OpenAI coding agent, codebase editing |
| **Gemini CLI** | 0.11.0 | `gemini` | Large context (2M tokens), documentation |
| **OpenCode** | 0.15.23 | `opencode` | Free Grok access, fast coding |
| **Perplexity** | 0.11.0 | `ai` | Real-time research, current information |

---

## Codex (OpenAI)

**Installed**: ✓ (version 0.50.0)
**Authentication**: Required on first use (OpenAI account)

### First-Time Setup

```bash
# Launch Codex (will prompt for authentication)
codex

# Follow prompts to authenticate with OpenAI
```

### Usage

```bash
# Interactive mode
codex

# The Codex CLI provides an interactive terminal interface
# It can read your codebase, make edits, and run commands
```

### Strengths
- **Deep codebase understanding** - Reads and comprehends entire projects
- **Interactive editing** - Live code modifications with preview
- **Command execution** - Can run terminal commands
- **Zero-dependency** - Rust-based, fast and secure
- **Internet access** - Can fetch current information

### When to Use
- Complex multi-file refactoring
- Understanding unfamiliar codebases
- Interactive code generation with feedback
- Tasks requiring both code edits AND command execution

---

## Perplexity (via AI CLI)

**Installed**: ✓ (version 0.11.0)
**Authentication**: Requires your Perplexity API key
**Command**: `ai`

### First-Time Setup

```bash
# Initialize AI CLI
ai init

# This creates ~/.airc.json
# Add your Perplexity API key to the config
```

**Manual config** (if needed):
```bash
# Edit config
nano ~/.airc.json

# Add:
{
  "provider": "perplexity",
  "apiKey": "YOUR_PERPLEXITY_API_KEY"
}
```

Get your API key from: https://www.perplexity.ai/settings/api

### Usage

```bash
# Research query
ai "What are the latest developments in Next.js 15?"

# Deep research
ai "Research best practices for WebAssembly in 2025"

# Quick lookup
ai "How to configure TypeScript path aliases?"
```

### Strengths
- **Real-time web search** - Gets current, up-to-date information
- **Research-focused** - Perfect for finding best practices
- **Citation-backed** - Shows sources for verification
- **Fast responses** - Quick research queries
- **Current trends** - Knows what's happening NOW

### When to Use
- Researching current best practices
- Finding latest library documentation
- Checking recent API changes
- Getting current tech trends/news
- Verifying information before implementation

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
| **Research** | **Perplexity** (`ai`) | - | Real-time web search |
| **Architecture** | Claude Code | Codex | Deep reasoning + implementation |
| **Security Review** | Claude Code | - | Critical analysis required |
| **Documentation** | Gemini | OpenCode | Large context + speed |
| **Large Codebase** | Gemini | Codex | 2M token context + understanding |
| **Quick Prototyping** | OpenCode | Codex | Free Grok + OpenAI |
| **Code Generation** | Codex | OpenCode | Interactive + fast |
| **Testing** | OpenCode | Gemini | Automation + cost |
| **Refactoring** | Codex | Claude Code | Interactive + reasoning |
| **Current Info** | **Perplexity** (`ai`) | - | Latest best practices |
| **Multi-file Edits** | Codex | Claude Code | Interactive + context |

---

## Authentication Status

### Claude Code ✓
- Authenticated via your Anthropic account
- No additional setup needed

### Codex ⚠️
- **Needs authentication on first use**
- Run: `codex` and follow prompts
- Requires OpenAI account

### Gemini CLI ⚠️
- **Needs authentication on first use**
- Run: `gemini` and follow prompts
- Uses Google account
- Free tier available

### OpenCode ✓
- No authentication needed for free Grok
- Just run: `opencode`
- Select "Grok Code Free" model

### Perplexity ⚠️
- **Needs API key configuration**
- Run: `ai init`
- Add your API key to `~/.airc.json`
- Get key from: https://www.perplexity.ai/settings/api

---

## Quick Start Commands

### Testing Each AI

```bash
# Test Claude Code (you're in it!)
claude "What AI CLIs are installed?"

# Test Codex (will prompt for auth first time)
codex
# Interactive terminal interface will open

# Test Gemini (will prompt for auth first time)
gemini "List files in current directory"

# Test OpenCode with free Grok
opencode
# Then in OpenCode:
/models
# Select "Grok Code Free"
# Then: "Show me project structure"

# Test Perplexity (after adding API key)
ai "What are the latest TypeScript features in 2025?"
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

### Option 1: Full Multi-AI (5 terminals)
```
┌──────────┬──────────┬──────────┐
│Perplexity│Claude Code│  Codex   │
│(research)│ (design) │  (impl)  │
├──────────┼──────────┴──────────┤
│  Gemini  │     OpenCode        │
│  (docs)  │   (test/speed)      │
└──────────┴─────────────────────┘
```

### Option 2: Research + Development (4-panel)
```
┌─────────────┬─────────────┐
│ Perplexity  │ Claude Code │
│ (research)  │ (primary)   │
├─────────────┼─────────────┤
│   Codex     │  Gemini     │
│ (implement) │   (docs)    │
└─────────────┴─────────────┘
```

### Option 3: Focused Development (3-panel)
```
┌─────────────────────────────┐
│   Claude Code (primary)     │
├──────────────┬──────────────┤
│    Codex     │ Perplexity   │
│ (implement)  │  (research)  │
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
