# Port Management System

**Version:** 1.0.0
**Last Updated:** 2025-10-30
**Purpose:** Centralized port management for multi-project development

---

## Problem Solved

When running multiple projects in parallel (SERP Master, My-ERP-Plan, ROK Copilot, Prism Specialties), port conflicts occur frequently:

- Projects randomly pick ports (usually starting at 3000)
- Port conflicts cause startup failures
- Hard to remember which project uses which port
- Difficult to open correct URL in incognito mode
- No systematic way to manage ports across projects

**Solution:** Central port registry with automatic assignment and conflict resolution.

---

## Quick Start

### 1. Load Aliases

```bash
# Add to ~/.bashrc
source ~/projects/terminal-work/config/bash-aliases-ports.sh

# Reload
source ~/.bashrc
```

### 2. View All Ports

```bash
ports
```

### 3. See What's Running

```bash
ports-running
```

### 4. Open Project in Incognito

```bash
open-serp      # SERP Master
open-erp       # My-ERP-Plan
open-rok       # ROK Copilot
open-prism     # Prism Specialties
```

---

## Port Registry

### Current Assignments

| Project | Frontend | Backend | Status | Notes |
|---------|----------|---------|--------|-------|
| serp-master | 3000 | 8000 | Active | Next.js + FastAPI |
| my-erp-plan | 3001 | - | Active | Next.js only |
| rok-copilot | 3002 | - | Active | Next.js only |
| prism-specialties | 3003 | - | Active | Static HTML |
| recipe-keeper-app | 3004 | - | Inactive | Next.js only |
| amplify-engine | 3005 | - | Inactive | - |
| bullseye-archon | 3006 | - | Inactive | - |
| project-genesis | 3007 | - | Inactive | - |

### Reserved Ranges

- **3000-3019**: Frontend services
- **8000-8019**: Backend APIs
- **9000-9019**: Microservices
- **5432**: PostgreSQL (Supabase local)
- **6379**: Redis

### Next Available

- Frontend: 3008
- Backend: 8001

---

## Commands Reference

### View & Status

```bash
# Show all registered ports
ports

# Show currently running services
ports-running
ports-status     # Alias

# Get help
ports-help
```

### Check & Kill Ports

```bash
# Check if port is in use
port-check 3000

# Kill service on port
port-kill 3000

# Quick kill common ports
kill-3000
kill-3001
kill-3002
kill-3003
kill-8000
```

### Open Projects (Incognito)

```bash
# Open in incognito/private mode
open-serp        # SERP Master
open-erp         # My-ERP-Plan
open-rok         # ROK Copilot
open-prism       # Prism Specialties
open-recipe      # Recipe Keeper
```

### Get Port Numbers

```bash
# Get assigned port for project
serp-port        # Returns 3000
erp-port         # Returns 3001
rok-port         # Returns 3002
prism-port       # Returns 3003
```

### Start Servers with Correct Ports

```bash
# Automatically use assigned ports
start-serp       # SERP Master (3000 frontend, 8000 backend)
start-erp        # My-ERP-Plan (3001)
start-rok        # ROK Copilot (3002)
start-prism      # Prism Specialties (3003)
```

---

## Architecture

### Files

```
terminal-work/
├── config/
│   ├── port-registry.json           # Central port database
│   └── bash-aliases-ports.sh        # Port management aliases
├── scripts/
│   └── port-manager.sh              # Port management script
└── docs/
    └── PORT_MANAGEMENT.md           # This file
```

### Port Registry (JSON)

**Location:** `~/projects/terminal-work/config/port-registry.json`

```json
{
  "version": "1.0.0",
  "ports": {
    "project-name": {
      "frontend": 3000,
      "backend": 8000,
      "status": "active",
      "notes": "Description"
    }
  },
  "reservedPorts": {
    "3000-3019": "Frontend services"
  },
  "nextAvailable": {
    "frontend": 3008,
    "backend": 8001
  }
}
```

### Port Manager Script

**Location:** `~/projects/terminal-work/scripts/port-manager.sh`

**Features:**
- Check if port is in use
- Get project's assigned port
- Find next available port
- Kill service on port
- Open project in browser (incognito)
- Show registry and running services

---

## Usage Examples

### Daily Workflow

```bash
# Morning: Check what's running
ports-running

# Start SERP Master
start-serp
# or
cd ~/serp-master && PORT=3000 npm run dev

# Open in incognito
open-serp

# Later: Check ports again
ports-running

# Kill a stuck service
kill-3000

# Start another project
start-erp
open-erp
```

### Port Conflict Resolution

```bash
# Problem: Port 3000 already in use

# Check what's using it
port-check 3000

# Kill the service
kill-3000

# Or: Get alternative port
port=$(port-manager.sh get my-project frontend)
PORT=$port npm run dev
```

### Adding New Project

```bash
# 1. Add to port-registry.json
vim ~/projects/terminal-work/config/port-registry.json

# Add:
"new-project": {
  "frontend": 3008,
  "backend": null,
  "status": "active",
  "notes": "Description"
}

# 2. Create aliases (optional)
vim ~/projects/terminal-work/config/bash-aliases-ports.sh

# Add:
alias open-newproject='port-manager.sh open new-project'
alias start-newproject='...'

# 3. Reload aliases
source ~/.bashrc

# 4. Use it
ports                    # See new project
open-newproject          # Open in browser
```

---

## Integration with Project Restart Scripts

### Next.js Projects

**Modify restart-project.sh or package.json:**

```bash
# Get assigned port
PORT=$(~/projects/terminal-work/scripts/port-manager.sh get my-erp-plan frontend)

# Start with specific port
PORT=$PORT npm run dev
```

**Or in package.json:**

```json
{
  "scripts": {
    "dev": "next dev",
    "dev:erp": "PORT=3001 next dev",
    "dev:rok": "PORT=3002 next dev"
  }
}
```

### Static HTML (live-server)

```bash
# Prism Specialties example
PORT=$(~/projects/terminal-work/scripts/port-manager.sh get prism-specialties-dmv-empire frontend)
npx live-server public --port=$PORT
```

### FastAPI Backend

```bash
# SERP Master backend
PORT=$(~/projects/terminal-work/scripts/port-manager.sh get serp-master backend)
uvicorn main:app --reload --port $PORT
```

---

## Incognito Browser Opening

### Why Incognito?

- Avoids cache issues
- Clean testing environment
- No cookie/session interference
- Fresh state for each test

### Supported Browsers

The `open` command tries browsers in order:
1. **Google Chrome** - `google-chrome --incognito`
2. **Chromium** - `chromium --incognito`
3. **Firefox** - `firefox --private-window`
4. **Fallback** - `xdg-open` (default browser)

### Custom Browser

```bash
# Set preferred browser
export BROWSER="google-chrome"

# Or open manually
chrome --incognito http://localhost:3001
firefox --private-window http://localhost:3001
```

---

## Troubleshooting

### Port Still in Use After Kill

```bash
# Find process
lsof -i :3000

# Force kill
lsof -ti :3000 | xargs kill -9

# Or use port manager
port-kill 3000
```

### Can't Find Assigned Port

```bash
# Check registry
ports

# Check if project registered
jq '.ports["my-project"]' ~/projects/terminal-work/config/port-registry.json

# Manually get/assign port
port-manager.sh get my-project frontend
```

### Port Conflicts on Startup

```bash
# Check what's using the port
port-check 3000

# Options:
# 1. Kill the service
kill-3000

# 2. Use different port
PORT=3010 npm run dev

# 3. Update registry to use free port
vim ~/projects/terminal-work/config/port-registry.json
```

### Registry Out of Sync

```bash
# Show what's really running
ports-running

# Compare with registry
ports

# Manually update registry if needed
vim ~/projects/terminal-work/config/port-registry.json
```

---

## Best Practices

### 1. Always Use Assigned Ports

```bash
# Good
PORT=3001 npm run dev

# Bad
npm run dev  # Uses default 3000, may conflict
```

### 2. Check Before Starting

```bash
# Check if port is free
port-check 3001

# See what's running
ports-running

# Then start
start-erp
```

### 3. Use Incognito for Testing

```bash
# Good
open-erp  # Opens incognito

# Okay
xdg-open http://localhost:3001  # May use cached data
```

### 4. Document New Projects

When adding a project:
1. Add to port-registry.json
2. Create aliases in bash-aliases-ports.sh
3. Update this documentation
4. Commit to git

### 5. Keep Registry Updated

- Mark inactive projects as "inactive"
- Update notes when projects change
- Remove old projects
- Increment nextAvailable counters

---

## Advanced Usage

### Programmatic Port Assignment

```bash
#!/bin/bash
# In your project's start script

PROJECT_NAME="my-new-project"
PORT=$(~/projects/terminal-work/scripts/port-manager.sh get "$PROJECT_NAME" frontend)

if [ $? -eq 0 ]; then
    echo "Starting on port $PORT"
    PORT=$PORT npm run dev
else
    echo "Failed to get port"
    exit 1
fi
```

### Dynamic Port Discovery

```bash
# Find next available port dynamically
PORT=$(~/projects/terminal-work/scripts/port-manager.sh get unknown-project frontend)

# Will auto-assign next available (e.g., 3008)
echo "Using port: $PORT"
```

### Port Range Reservation

Edit `port-registry.json`:

```json
{
  "reservedPorts": {
    "3000-3019": "Frontend services",
    "3020-3029": "Test environments",
    "3030-3039": "Staging environments"
  }
}
```

---

## Future Enhancements

### Planned Features

- [ ] Auto-detect and register new projects
- [ ] Port usage history and analytics
- [ ] Integration with Docker containers
- [ ] Web-based port dashboard
- [ ] Automatic port cleanup on process exit
- [ ] Port conflict prevention at startup
- [ ] Integration with systemd services

### Ideas

- VS Code extension for port management
- Browser extension to show port mappings
- Slack/Discord notifications on port conflicts
- Auto-restart on port conflict detection

---

## API Reference

### port-manager.sh Commands

```bash
# Show all registered ports
port-manager.sh show
port-manager.sh list

# Show currently running services
port-manager.sh running
port-manager.sh status

# Open project in incognito browser
port-manager.sh open <project-name>

# Get or assign port for project
port-manager.sh get <project-name> [frontend|backend]

# Check if port is in use
port-manager.sh check <port>

# Kill service on port
port-manager.sh kill <port>

# Show help
port-manager.sh help
```

### Exit Codes

- `0` - Success
- `1` - Error (port not found, project not registered, etc.)

---

## Changelog

### Version 1.0.0 (2025-10-30)

**Initial Release:**
- Central port registry (port-registry.json)
- Port manager script (port-manager.sh)
- Bash aliases for common operations
- Incognito browser opening
- Port conflict detection
- Documentation

**Registered Projects:**
- SERP Master (3000, 8000)
- My-ERP-Plan (3001)
- ROK Copilot (3002)
- Prism Specialties (3003)
- Recipe Keeper (3004)
- Amplify Engine (3005)
- Bullseye Archon (3006)
- Project Genesis (3007)

---

## Contributing

### Adding New Projects

1. Edit `config/port-registry.json`
2. Add aliases to `config/bash-aliases-ports.sh`
3. Update this documentation
4. Test with `ports` and `ports-running`
5. Commit changes

### Reporting Issues

- Port conflicts not resolved
- Registry out of sync
- Missing browser support
- Feature requests

---

## Summary

**Port Management System** solves multi-project development port conflicts with:

✅ Central port registry
✅ Automatic port assignment
✅ Conflict detection and resolution
✅ Incognito browser opening
✅ Easy-to-use commands
✅ Integration with project scripts

**Quick Commands:**
- `ports` - Show all ports
- `ports-running` - Show running services
- `open-<project>` - Open in incognito
- `kill-<port>` - Free up port

**Setup:** Just source the aliases in ~/.bashrc and you're ready!

---

**Maintained by:** terminal-work project
**Status:** Active, production-ready ✅
