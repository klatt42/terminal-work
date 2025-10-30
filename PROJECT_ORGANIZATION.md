# Project Organization Strategy

**Last Updated:** 2025-10-30
**Purpose:** Document project location strategy and monitoring setup

---

## Overview

This system monitors **11 projects across 4 locations** using a flexible, multi-directory architecture. Projects are organized by size, purpose, and type rather than forcing everything into a single directory.

---

## Project Locations

### 📁 Standard Location: `~/projects/`

**Purpose:** Default location for most development projects

**Current Projects (8):**
1. **amplify-engine** - Project amplification tools
2. **bullseye-archon-enhanced** - Archon integration
3. **project-genesis** - Genesis framework
4. **recipe-keeper-app** - Recipe management app
5. **rok-copilot** - AI assistant (Phase 4, 970MB) ✅ ACTIVE
6. **rok-copilot-genesis-backup** - Genesis build backup
7. **rok-copilot-history** - Historical snapshots
8. **terminal-work** - Monitoring hub (THIS PROJECT)

**Subdirectory:**
- `~/projects/genesis-skills-test/my-erp-plan` - ERP SaaS (1.5GB) ✅ ACTIVE

**Size Range:** 100MB - 2GB
**Total:** 8 projects + monitoring hub

---

### 🏢 Production Platform: `~/serp-master`

**Purpose:** Large, standalone production SEO platform

**Project:**
- **serp-master** - Production SEO platform (12GB) ✅ ACTIVE
  - Phase 2 AGO enhancement (40% complete)
  - Next.js 15 + FastAPI backend
  - 284 Python dependencies
  - Too large to nest in ~/projects/

**Size:** 12GB (largest project)
**Status:** Production-ready, active development

---

### 🎯 Marketing Sites: `~/prism-specialties-dmv-empire`

**Purpose:** Standalone marketing/landing page empires

**Project:**
- **prism-specialties-dmv-empire** - Landing page empire (546MB) ✅ ACTIVE
  - 195+ specialty restoration landing pages
  - GoHighLevel CRM integration
  - Static HTML/CSS/JS
  - Phase 1 complete, Phase 2 ready

**Size:** 546MB
**Status:** Stagnant (31+ days), ready to resume

---

### 📦 Future Special Projects: `~/[project-name]`

**Purpose:** Large standalone projects that don't fit in ~/projects/

**Criteria for Root-Level Projects:**
- Size > 1GB
- Standalone production systems
- Unique infrastructure needs
- Marketing/landing page empires

**Examples of Future Projects:**
- `~/client-project-name` - Client work
- `~/large-saas-platform` - Enterprise systems
- `~/landing-page-empire-2` - Marketing sites

---

## Monitoring Configuration

### All Projects Tracked

**Monitoring Scripts:**
- `~/projects/terminal-work/scripts/scan-projects.sh`
- `~/projects/terminal-work/scripts/session-monitor.sh`

**Configuration:**
```bash
PROJECT_DIRS=(
    "$HOME/projects"
    "$HOME/serp-master"
    "$HOME/projects/genesis-skills-test/my-erp-plan"
    "$HOME/prism-specialties-dmv-empire"
)
```

**Monitoring Features:**
- Real-time git status (uncommitted/unpushed)
- Morning briefing reports
- Interactive dashboard
- Multi-terminal session tracking
- AI process detection

---

## Location Decision Tree

### When Starting a New Project:

```
Is it a standard development project?
├─ YES → ~/projects/new-project-name
└─ NO  → Continue...

Is it > 1GB or a production platform?
├─ YES → ~/project-name
└─ NO  → ~/projects/new-project-name

Is it client work or a landing page empire?
├─ YES → ~/client-name or ~/landing-page-name
└─ NO  → ~/projects/new-project-name
```

### Default: Always use `~/projects/` unless there's a specific reason not to

---

## Project Size Guidelines

**Small Projects (< 500MB):**
- Location: `~/projects/project-name`
- Examples: Recipe Keeper, ROK Copilot

**Medium Projects (500MB - 2GB):**
- Location: `~/projects/project-name` or `~/projects/category/project-name`
- Examples: My-ERP-Plan, Prism Specialties

**Large Projects (> 2GB):**
- Location: `~/project-name` (root level)
- Examples: SERP Master (12GB)

---

## Active Projects Status

### Currently Active (4 terminals)

1. **SERP Master** (`~/serp-master`)
   - Terminal 1
   - Phase 2 AGO enhancement
   - 12GB production platform

2. **My-ERP-Plan** (`~/projects/genesis-skills-test/my-erp-plan`)
   - Terminal 2
   - Phase 2 Week 3
   - AI-powered ERP SaaS

3. **ROK Copilot** (`~/projects/rok-copilot`)
   - Terminal 3
   - Phase 4 Task 5
   - AI assistant with Claude Code integration

4. **Prism Specialties** (`~/prism-specialties-dmv-empire`)
   - Terminal 4
   - Phase 2 planning
   - Landing page empire

### Monitoring Hub

- **terminal-work** (`~/projects/terminal-work`)
   - This project
   - Central monitoring
   - Documentation repository

---

## Benefits of Multi-Location Strategy

### ✅ Advantages

1. **Logical Grouping**
   - Projects organized by size and purpose
   - Large projects don't clutter ~/projects/
   - Easy to navigate

2. **Flexible Monitoring**
   - Scripts handle any directory structure
   - Easy to add new locations
   - No hardcoded paths

3. **Performance**
   - Large projects isolated
   - Faster directory listings
   - Better organization

4. **Scalability**
   - Can add projects anywhere
   - No single point of congestion
   - Adapts to project needs

### 🔧 How to Add New Project Location

```bash
# 1. Add to scan-projects.sh
vim ~/projects/terminal-work/scripts/scan-projects.sh

# Add to PROJECT_DIRS array:
PROJECT_DIRS=(
    "$HOME/projects"
    "$HOME/serp-master"
    "$HOME/projects/genesis-skills-test/my-erp-plan"
    "$HOME/prism-specialties-dmv-empire"
    "$HOME/new-project-location"  # <-- ADD HERE
)

# 2. Add to session-monitor.sh
vim ~/projects/terminal-work/scripts/session-monitor.sh

# Add to PROJECT_DIRS array (same as above)

# 3. Test monitoring
~/projects/terminal-work/scripts/scan-projects.sh

# 4. Commit changes
cd ~/projects/terminal-work
git add scripts/
git commit -m "Add: New project location monitoring"
git push
```

---

## Backup Strategy

### By Location

**~/projects/** - Standard backup
- Included in home directory backups
- Git repositories tracked
- Regular snapshots

**~/serp-master** - Special handling
- Large size requires separate backup
- Production data critical
- More frequent snapshots

**~/prism-specialties-dmv-empire** - Standard backup
- Included in home directory backups
- Multiple emergency backups exist (can consolidate)

---

## Directory Structure Summary

```
~/
├── projects/                    # Standard location (8 projects)
│   ├── amplify-engine/
│   ├── bullseye-archon-enhanced/
│   ├── project-genesis/
│   ├── recipe-keeper-app/
│   ├── rok-copilot/            ✅ ACTIVE
│   ├── rok-copilot-genesis-backup/
│   ├── rok-copilot-history/
│   ├── terminal-work/          ✅ MONITORING HUB
│   └── genesis-skills-test/
│       └── my-erp-plan/        ✅ ACTIVE
│
├── serp-master/                ✅ ACTIVE (12GB)
│
└── prism-specialties-dmv-empire/  ✅ ACTIVE (546MB)
```

---

## Guidelines for Future Projects

### DO:
✅ Use `~/projects/` for new projects by default
✅ Document special locations in this file
✅ Add to monitoring scripts when creating projects
✅ Keep related projects together (e.g., genesis-skills-test/)
✅ Consider size when choosing location

### DON'T:
❌ Move existing projects without good reason
❌ Create deep nested structures (max 2-3 levels)
❌ Forget to add to monitoring scripts
❌ Put large projects (>2GB) in ~/projects/
❌ Scatter projects randomly without documentation

---

## Monitoring Commands

### Daily Monitoring

```bash
# Morning briefing
morning

# Quick scan
~/projects/terminal-work/scripts/scan-projects.sh

# Update dashboard
~/projects/terminal-work/scripts/session-monitor.sh

# View dashboard
dashboard
```

### Check All Project Locations

```bash
# List all monitored projects
grep -A 10 "PROJECT_DIRS" ~/projects/terminal-work/scripts/scan-projects.sh

# Check project sizes
du -sh ~/projects/*
du -sh ~/serp-master
du -sh ~/prism-specialties-dmv-empire
```

---

## Conclusion

**Current Strategy:** ✅ WORKING PERFECTLY

- 11 projects monitored across 4 locations
- Flexible, scalable architecture
- Logical organization by size and purpose
- No need to consolidate or move projects

**Future Projects:** Default to `~/projects/` unless size or purpose dictates otherwise

**Monitoring:** Fully automated, supports any directory structure

---

## Quick Reference

**Add new project to monitoring:**
1. Edit `~/projects/terminal-work/scripts/scan-projects.sh`
2. Edit `~/projects/terminal-work/scripts/session-monitor.sh`
3. Add path to `PROJECT_DIRS` array
4. Test with `scan-projects.sh`
5. Commit and push

**Standard locations:**
- Small/medium projects: `~/projects/`
- Large projects (>2GB): `~/project-name`
- Client work: `~/client-name`
- Marketing sites: `~/site-name`

**Always monitored:** terminal-work tracks all locations automatically

---

**Last Updated:** 2025-10-30
**Maintained by:** terminal-work monitoring system
**Status:** Active, all projects tracked ✅
