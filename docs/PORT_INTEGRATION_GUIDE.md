# Port Management Integration Guide

**Last Updated:** 2025-10-30
**Purpose:** How to integrate port registry into projects to prevent conflicts

---

## Problem: Port Conflicts

Without integration, projects still assign ports randomly:
- Next.js defaults to 3000
- FastAPI defaults to 8000
- live-server picks random ports
- Projects conflict when multiple run simultaneously

## Solution: Active Registry Integration

Projects should **check the registry before starting** to get their assigned port.

---

## Integration Methods

### Method 1: Use Starter Functions (Easiest)

**Instead of:**
```bash
cd ~/projects/my-erp-plan
npm run dev   # Picks 3000, may conflict
```

**Use:**
```bash
start-erp     # Automatically uses 3001 from registry
```

**Available starters:**
- `start-serp` - SERP Master (3000, 8000)
- `start-erp` - My-ERP-Plan (3001)
- `start-rok` - ROK Copilot (3002)
- `start-prism` - Prism Specialties (3003)

---

### Method 2: Update package.json Scripts

**For Next.js Projects:**

Edit `package.json` to include port-specific dev scripts:

```json
{
  "name": "my-erp-plan",
  "scripts": {
    "dev": "next dev",
    "dev:managed": "PORT=$(~/projects/terminal-work/scripts/port-manager.sh get my-erp-plan frontend 2>/dev/null || echo 3001) next dev -p $PORT",
    "dev:3001": "PORT=3001 next dev"
  }
}
```

Then run:
```bash
npm run dev:managed   # Uses registry port
# OR
npm run dev:3001      # Hardcoded to 3001
```

**For Static Sites (live-server):**

```json
{
  "name": "prism-specialties",
  "scripts": {
    "dev": "npx live-server public --port=3003",
    "dev:managed": "npx live-server public --port=$(~/projects/terminal-work/scripts/port-manager.sh get prism-specialties-dmv-empire frontend 2>/dev/null || echo 3003)"
  }
}
```

---

### Method 3: Project-Specific Startup Scripts

Create a `start.sh` in each project root:

**Example: `~/projects/my-erp-plan/start.sh`**
```bash
#!/bin/bash

PROJECT_NAME="my-erp-plan"
PORT_MANAGER="$HOME/projects/terminal-work/scripts/port-manager.sh"

# Get assigned port from registry
if [ -x "$PORT_MANAGER" ]; then
    PORT=$($PORT_MANAGER get "$PROJECT_NAME" frontend 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$PORT" ]; then
        echo "🚀 Starting $PROJECT_NAME on port $PORT (from registry)"
        PORT=$PORT npm run dev
    else
        echo "⚠️  Registry not found, using default port 3001"
        PORT=3001 npm run dev
    fi
else
    echo "⚠️  Port manager not available, using default port 3001"
    PORT=3001 npm run dev
fi
```

Make it executable:
```bash
chmod +x start.sh
```

Then use:
```bash
cd ~/projects/my-erp-plan
./start.sh
```

---

### Method 4: Environment Variables (.env.local)

**For Next.js projects**, create `.env.local`:

**`~/projects/my-erp-plan/.env.local`**
```bash
PORT=3001
```

**`~/serp-master/.env.local`**
```bash
PORT=3000
BACKEND_PORT=8000
```

Then just run `npm run dev` - Next.js will use the PORT from .env.local.

**Pros:**
- Simple and automatic
- No script modifications needed
- gitignored by default

**Cons:**
- Port hardcoded (not dynamic from registry)
- Need to manually update if port changes

---

## Recommended Setup: Combined Approach

### For Each Project:

1. **Add .env.local with assigned port** (simple, works immediately)
   ```bash
   echo "PORT=3001" > ~/projects/my-erp-plan/.env.local
   ```

2. **Add managed script to package.json** (for when you need flexibility)
   ```json
   "dev:managed": "PORT=$(~/projects/terminal-work/scripts/port-manager.sh get my-erp-plan frontend 2>/dev/null || echo 3001) next dev -p $PORT"
   ```

3. **Use starter functions** (easiest, already set up)
   ```bash
   start-erp
   ```

---

## Quick Setup for Each Project

### SERP Master
```bash
cd ~/serp-master
cat > .env.local << 'EOF'
PORT=3000
BACKEND_PORT=8000
EOF
```

### My-ERP-Plan
```bash
cd ~/projects/genesis-skills-test/my-erp-plan
echo "PORT=3001" > .env.local
```

### ROK Copilot
```bash
cd ~/projects/rok-copilot
echo "PORT=3002" > .env.local
```

### Prism Specialties
```bash
cd ~/prism-specialties-dmv-empire
# For live-server, use the start function instead
alias start-prism='cd ~/prism-specialties-dmv-empire && npx live-server public --port=3003'
```

---

## How to Check Ports Before Starting

### Option 1: Use ports command
```bash
ports           # Shows all assigned ports
ports-running   # Shows what's currently running
```

### Option 2: Check specific port
```bash
port-check 3000   # Is port 3000 in use?
```

### Option 3: Get project's port
```bash
erp-port        # Returns: 3001
serp-port       # Returns: 3000
rok-port        # Returns: 3002
```

---

## Handling Port Conflicts

### If a port is already in use:

1. **Check what's using it:**
   ```bash
   port-check 3000
   # Shows: node process using port 3000
   ```

2. **Kill the process:**
   ```bash
   kill-3000     # Quick kill
   # OR
   port-kill 3000
   ```

3. **Find alternative port:**
   ```bash
   PORT=$(~/projects/terminal-work/scripts/port-manager.sh get my-new-project frontend)
   # Will return next available (3008, 3009, etc.)
   ```

---

## Adding New Projects

### 1. Register in port-registry.json

Edit `~/projects/terminal-work/config/port-registry.json`:

```json
{
  "ports": {
    "my-new-project": {
      "frontend": 3008,
      "backend": null,
      "status": "active",
      "notes": "Description of project"
    }
  }
}
```

### 2. Create .env.local

```bash
cd ~/projects/my-new-project
echo "PORT=3008" > .env.local
```

### 3. Add aliases (optional)

Edit `~/projects/terminal-work/config/bash-aliases-ports.sh`:

```bash
alias open-newproject='port-manager.sh open my-new-project'

start-newproject() {
    cd ~/projects/my-new-project
    local port=$(~/projects/terminal-work/scripts/port-manager.sh get my-new-project frontend)
    echo "Starting My New Project on port $port"
    PORT=$port npm run dev
}
```

### 4. Reload aliases

```bash
source ~/.bashrc
```

---

## Best Practices

### ✅ DO:
- Always check `ports-running` before starting a project
- Use the `start-<project>` functions when available
- Add PORT to .env.local for consistency
- Check registry before manually starting servers
- Update registry when adding new projects

### ❌ DON'T:
- Run `npm run dev` without checking port availability
- Hardcode ports in code (use environment variables)
- Forget to kill old processes before restarting
- Start multiple projects on same port
- Skip updating the registry for new projects

---

## Troubleshooting

### "Port already in use" error

```bash
# 1. Check what's running
ports-running

# 2. Check specific port
port-check 3001

# 3. Kill the process
kill-3001

# 4. Try again
start-erp
```

### "Project not found in registry"

```bash
# Add to port-registry.json
vim ~/projects/terminal-work/config/port-registry.json

# Or let port-manager assign dynamically
PORT=$(port-manager.sh get my-project frontend)
```

### Can't find port-manager.sh

```bash
# Check if it exists
ls -la ~/projects/terminal-work/scripts/port-manager.sh

# Make executable
chmod +x ~/projects/terminal-work/scripts/port-manager.sh

# Test directly
~/projects/terminal-work/scripts/port-manager.sh show
```

---

## Summary: Preventing Port Conflicts

**The system works in three layers:**

1. **Registry** - Central database of port assignments
2. **port-manager.sh** - Script to check/assign/kill ports
3. **Starter functions** - Convenient aliases that use the registry

**To prevent conflicts:**
- Use `start-<project>` functions (they check registry automatically)
- Add PORT to .env.local files
- Always check `ports-running` before starting
- Kill old processes before restarting

**Manual check before starting any project:**
```bash
# Check if port is free
port-check 3001

# If not free, kill it
kill-3001

# Start using assigned port
start-erp
```

---

**Documentation maintained by:** terminal-work project
**Status:** Active - Production Ready ✅
