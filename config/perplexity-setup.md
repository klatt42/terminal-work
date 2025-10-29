# Perplexity API Setup

The AI CLI is installed and ready to use with your Perplexity API key.

## Setup Steps

### 1. Initialize AI CLI

```bash
ai init
```

This creates `~/.airc.json` config file.

### 2. Add Your Perplexity API Key

Edit the config file:
```bash
nano ~/.airc.json
```

Or create it manually:
```json
{
  "provider": "perplexity",
  "apiKey": "YOUR_PERPLEXITY_API_KEY_HERE"
}
```

### 3. Get Your API Key

If you don't have your API key handy:
1. Go to: https://www.perplexity.ai/settings/api
2. Copy your API key
3. Paste it into `~/.airc.json`

## Usage

Once configured:

```bash
# Ask a research question
ai "What are the latest developments in WebAssembly?"

# Deep research mode
ai "Research the best practices for React Server Components in 2025"

# Quick lookup
ai "How do I configure CORS in Express?"
```

## Why Perplexity?

- **Real-time web search** - Gets latest information
- **Research-focused** - Great for finding current best practices
- **Citation-backed** - Shows sources
- **Fast** - Quick responses for research queries

## Integration with Your Workflow

Use Perplexity for:
- Researching current best practices
- Finding up-to-date library documentation
- Checking latest API changes
- Getting current tech news/trends

Then use Claude Code, Codex, or Gemini for implementation!

## Example Multi-AI Research Workflow

```bash
# Terminal 1: Research with Perplexity
ai "What's the current best approach for authentication in Next.js 14?"

# Terminal 2: Implementation with Codex
codex
# "Implement Next.js 14 authentication based on best practices"

# Terminal 3: Review with Claude Code
claude "Review this auth implementation for security"

# Terminal 4: Document with Gemini
gemini "Create comprehensive docs for this auth system"
```

---

**Ready to configure?** Run `ai init` to get started!
