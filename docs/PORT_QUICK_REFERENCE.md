# Port Management - Quick Reference Card

## 🎯 How Projects Know Their Port

### **Answer: Three Ways**

1. **`.env.local` file** (Automatic - JUST CREATED FOR YOU ✅)
   - Each project now has PORT set in .env.local
   - Next.js automatically reads it on `npm run dev`
   - No conflicts, no checking needed

2. **Starter functions** (Convenient)
   - `start-serp`, `start-erp`, `start-rok`, `start-prism`
   - Check registry and use correct port automatically

3. **Manual check** (When needed)
   - `port-manager.sh get <project> frontend`
   - Returns assigned port from registry

---

## 📋 Your Current Port Assignments

| Project | Port | Location | Status |
|---------|------|----------|--------|
| **SERP Master** | 3000 (frontend)<br>8000 (backend) | ~/serp-master | ✅ .env.local created |
| **My-ERP-Plan** | 3001 | ~/projects/genesis-skills-test/my-erp-plan | ✅ .env.local created |
| **ROK Copilot** | 3002 | ~/projects/rok-copilot | ✅ .env.local created |
| **Prism Specialties** | 3003 | ~/prism-specialties-dmv-empire | Use `start-prism` |
| **Recipe Keeper** | 3004 | ~/projects/recipe-keeper-app | Inactive |
| **Archon OS** | 3737 (UI) | Docker | Always running |

---

## 🚀 How to Start Projects (No More Conflicts!)

### Method 1: Just Run npm (RECOMMENDED - Already Set Up!)
```bash
cd ~/projects/genesis-skills-test/my-erp-plan
npm run dev
# ✓ Automatically uses port 3001 from .env.local
```

### Method 2: Use Starter Functions
```bash
start-erp        # My-ERP-Plan on 3001
start-serp       # SERP Master on 3000
start-rok        # ROK Copilot on 3002
start-prism      # Prism Specialties on 3003
```

### Method 3: Manual Port Check
```bash
PORT=$(~/projects/terminal-work/scripts/port-manager.sh get my-erp-plan frontend)
PORT=$PORT npm run dev
```

---

## 🔍 Quick Status Check Commands

```bash
ports                 # Show all port assignments
ports-running         # What's running RIGHT NOW
port-check 3001       # Is this specific port in use?
```

---

## 🛑 Kill Stuck Processes

```bash
kill-3000            # Kill whatever is on port 3000
kill-3001            # Kill whatever is on port 3001
kill-3002            # Kill whatever is on port 3002
kill-8000            # Kill backend on 8000

# Or generic:
port-kill 3005       # Kill any port
```

---

## 🌐 Open Projects in Browser

```bash
open-serp            # Opens localhost:3000 (incognito)
open-erp             # Opens localhost:3001 (incognito)
open-rok             # Opens localhost:3002 (incognito)
open-prism           # Opens localhost:3003 (incognito)
open-archon          # Opens localhost:3737 (Archon OS)
```

---

## 🐳 Docker (Archon OS) Commands

```bash
archon-status        # Show all 4 Archon services
docker-show          # Show all Docker containers
archon-start         # Start Archon OS
archon-stop          # Stop Archon OS
archon-restart       # Restart Archon OS
```

---

## ⚡ Daily Workflow

### Starting Your Day:
```bash
morning              # Check all projects status
ports-running        # See what's already running
start-erp            # Start My-ERP-Plan
start-serp           # Start SERP Master
```

### During Development:
```bash
# Just use npm run dev - ports are preset!
cd ~/projects/genesis-skills-test/my-erp-plan
npm run dev          # Uses 3001 automatically

# Open in browser
open-erp             # Opens incognito window
```

### When Port Conflicts Happen:
```bash
# 1. Check what's using the port
port-check 3001

# 2. Kill it
kill-3001

# 3. Try again
npm run dev
```

### End of Day:
```bash
eod                  # Commit changes, push to GitHub
```

---

## 🔥 Troubleshooting

### "Port 3000 already in use"
```bash
port-check 3000      # See what's using it
kill-3000            # Kill it
npm run dev          # Try again
```

### "I forgot which port my project uses"
```bash
ports                # Shows all assignments
# OR
erp-port             # Returns: 3001
serp-port            # Returns: 3000
```

### "Project started on wrong port"
```bash
# Check if .env.local exists
ls -la ~/projects/my-project/.env.local

# If not, create it
echo "PORT=3001" > ~/projects/my-project/.env.local

# Restart project
npm run dev
```

---

## 💡 Key Point: No More Manual Port Management!

**Before (port conflicts):**
```bash
npm run dev
# Error: Port 3000 already in use
# 😫 Have to find and kill processes manually
```

**After (with .env.local files):**
```bash
npm run dev
# ✓ Each project uses its assigned port automatically
# 😎 No conflicts, no hassle
```

---

## 📚 More Info

- Full documentation: `~/projects/terminal-work/docs/PORT_MANAGEMENT.md`
- Integration guide: `~/projects/terminal-work/docs/PORT_INTEGRATION_GUIDE.md`
- Port registry: `~/projects/terminal-work/config/port-registry.json`

---

**Last Updated:** 2025-10-30
**Status:** ✅ Active - All Projects Configured
