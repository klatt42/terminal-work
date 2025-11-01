# MCP Container Orchestrator - Setup Guide

## Overview

The MCP Container Orchestrator provides on-demand Docker container management for Model Context Protocol (MCP) servers. Spin up specialized AI capabilities when needed: browser automation, YouTube transcripts, Docker registry management, and research tools.

## Quick Start

### 1. Install Prerequisites

```bash
# Install jq (JSON processor)
sudo apt-get update && sudo apt-get install -y jq

# Verify installation
jq --version
```

### 2. Load Bash Aliases

```bash
source ~/.bashrc
```

### 3. View Available MCPs

```bash
mcp-list
```

## Available MCP Servers

### Docker Hub MCP (Port 9001)
**Capabilities**: Docker registry management, image search, tag management
```bash
mcp-launch docker-hub
```

**Use Cases**:
- Search Docker Hub for images
- Check available tags
- Get repository information
- Manage Docker registries

### Playwright MCP (Port 9002)
**Capabilities**: Browser automation, screenshots, PDF generation, web scraping
```bash
mcp-launch playwright
```

**Use Cases**:
- Automated browser testing
- Screenshot capture
- PDF generation from web pages
- Web scraping
- E2E testing

### Perplexity MCP (Port 9003)
**Capabilities**: Research, web search with citations, fact checking
```bash
# Requires PERPLEXITY_API_KEY environment variable
export PERPLEXITY_API_KEY="your-api-key"
mcp-launch perplexity
```

**Use Cases**:
- Research with source citations
- Fact checking
- Current events lookup
- Citation-backed answers

### YouTube Transcript MCP (Port 9004)
**Capabilities**: Extract video transcripts, analyze content, search timestamps
```bash
mcp-launch youtube-transcript
```

**Use Cases**:
- Extract YouTube video transcripts
- Search for specific content in videos
- Download captions
- Timestamp-based search

### Archon MCP (Port 8051) - Already Running
**Capabilities**: Agent orchestration, RAG operations, file processing
```bash
# Managed by Archon OS - already running
mcp-list archon-mcp
```

## Common Commands

### Launch MCP Server
```bash
mcp-launch <mcp-name>
# or
mcp-start <mcp-name>
```

### Stop MCP Server
```bash
mcp-stop <mcp-name>

# Stop all MCPs
mcp-stop --all
```

### List MCP Status
```bash
mcp-list                # Show all MCPs
mcp-ps                  # Quick alias
mcps                    # Another alias

mcp-list docker-hub     # Detailed info + logs
```

### View Logs
```bash
docker logs mcp-docker-hub
docker logs mcp-playwright
```

## Advanced Configuration

### Registry Location
```
~/projects/terminal-work/config/mcp-registry.json
```

### State Files
```
~/.config/terminal-work/mcp/<mcp-name>.json
```

### Network
All MCPs run on isolated Docker network: `terminal-work-mcp`

### Port Range
MCPs use ports 9000-9099 (configurable in registry)

## Adding Custom MCPs

Edit `~/projects/terminal-work/config/mcp-registry.json`:

```json
{
  "mcpServers": {
    "your-mcp": {
      "name": "Your MCP Name",
      "description": "Description of capabilities",
      "image": "your-registry/your-mcp:latest",
      "port": 9005,
      "healthEndpoint": "/health",
      "capabilities": [
        "capability1",
        "capability2"
      ],
      "autoStart": false,
      "idleTimeout": 3600,
      "env": {
        "API_KEY": "${YOUR_API_KEY}"
      }
    }
  }
}
```

## Integration with Genesis

### ROK Copilot Integration

The Genesis MCP Client in ROK Copilot can connect to orchestrated MCPs:

```typescript
import { getMCPClient } from '@/lib/genesis/mcp-client';

const client = getMCPClient({
  serverUrl: 'http://localhost:9001', // Docker Hub MCP
  timeout: 10000
});

const results = await client.searchPatterns({
  query: 'docker images',
  categories: ['docker_registry']
});
```

### Archon Integration (Phase 2)

Future enhancement: Archon OS will manage MCP lifecycle automatically based on task requirements.

## Troubleshooting

### MCP Won't Start
```bash
# Check Docker is running
docker ps

# Check logs
docker logs mcp-<name>

# Try pulling image manually
docker pull ghcr.io/docker/hub-mcp:latest
```

### Port Already in Use
```bash
# Check what's using the port
lsof -i :9001

# Stop conflicting service or change port in registry
```

### Health Check Fails
```bash
# Check container logs
docker logs mcp-<name>

# Try health endpoint manually
curl http://localhost:9001/health
```

### jq Not Found
```bash
sudo apt-get install -y jq
```

## Examples

### Example 1: Browser Automation
```bash
# Launch Playwright MCP
mcp-launch playwright

# Use via API (port 9002)
curl -X POST http://localhost:9002/screenshot \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'
```

### Example 2: YouTube Transcript
```bash
# Launch YouTube MCP
mcp-launch youtube-transcript

# Get transcript
curl http://localhost:9004/transcript?v=VIDEO_ID
```

### Example 3: Docker Search
```bash
# Launch Docker Hub MCP
mcp-launch docker-hub

# Search images
curl http://localhost:9001/search?q=postgres
```

## Performance Tips

1. **Idle Timeout**: MCPs auto-stop after configured idle time (default: 30-60 min)
2. **Resource Limits**: Add Docker resource limits in registry if needed
3. **Network**: All MCPs share isolated network for inter-MCP communication
4. **State**: MCP state persisted in `~/.config/terminal-work/mcp/`

## Next Steps

1. Install `jq`: `sudo apt-get install jq`
2. Test launch: `mcp-launch docker-hub`
3. Check status: `mcp-list`
4. Integrate with your projects
5. Add custom MCPs to registry

## Support

- Registry: `~/projects/terminal-work/config/mcp-registry.json`
- Scripts: `~/projects/terminal-work/scripts/mcp-*.sh`
- Docs: `~/projects/terminal-work/docs/MCP_ORCHESTRATOR_SETUP.md`

---

**Created**: 2025-11-01
**Version**: 1.0.0
**Status**: Phase 1 Complete
