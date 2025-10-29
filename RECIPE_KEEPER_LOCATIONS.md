# Recipe Keeper Projects - Complete Directory Map

## Overview

You have **3 recipe keeper projects** in different locations:

---

## 1️⃣ Primary: `~/recipe-keeper`

**Full Path**: `/home/klatt42/recipe-keeper`
**Size**: 6.4M
**Git Remote**: https://github.com/klatt42/recipe-keeper.git
**Type**: Genesis Framework / SDK / Agent System

### Purpose
This appears to be the **Genesis framework implementation** for recipe keeper - the SDK, agents, and core architecture.

### Key Directories
```
recipe-keeper/
├── agents/                    # Agent implementations
├── api/                       # API layer
├── cli/                       # CLI tools
├── docs/                      # Documentation
├── enterprise/                # Enterprise features
├── genesis-agents-mcp/        # MCP integration
├── maintenance/               # Maintenance scripts
├── patterns-discovered/       # Design patterns
├── scripts/                   # Automation scripts
├── sdk/                       # Software Development Kit
└── templates/                 # Code templates
```

### Key Files
- GENESIS_KERNEL.md
- GENESIS_PHASE2_WEEK5_EXECUTION.md
- CLAUDE_CODE_INTEGRATION.md
- CLI_INTEGRATION_STATUS.md
- Multiple WEEK_*_COMPLETE.md files (Weeks 5-11)
- PHASE_1_SUMMARY.md through PHASE_2_COMPLETE.md
- genesis_agent_sdk_analysis.md
- genesis_agent_sdk_implementation.md

### Status
Advanced Genesis framework implementation with completed phases and weekly milestones documented.

---

## 2️⃣ Application: `~/Developer/projects/recipe-keeper-app`

**Full Path**: `/home/klatt42/Developer/projects/recipe-keeper-app`
**Size**: 911M (includes node_modules)
**Git Remote**: https://github.com/klatt42/recipe-keeper-app.git
**Type**: Next.js Application

### Purpose
This is the **actual recipe keeper web application** - the frontend/backend app that users interact with.

### Key Directories
```
recipe-keeper-app/
├── app/                       # Next.js 13+ app directory
├── components/                # React components
├── lib/                       # Library code
├── migrations/                # Database migrations
├── public/                    # Static assets
└── node_modules/              # Dependencies (large)
```

### Key Files
- **Configuration**:
  - next.config.ts
  - tsconfig.json
  - package.json
  - eslint.config.mjs
  - postcss.config.mjs

- **Documentation**:
  - PROJECT_STATUS.md
  - QUICK_START.md
  - SETUP.md
  - TECH_STACK.md
  - CONTEXT_RECOVERY.md

- **Features**:
  - FAMILY_COOKBOOK_IMPLEMENTATION.md
  - USAGE_DASHBOARD.md
  - RECIPE_IMPORT_SETUP.md
  - GEMINI_IMPORT_SETUP.md
  - SEARCH_ENHANCEMENT.md
  - PRINT_FEATURE_ENHANCEMENT.md
  - PHASE_2B_NUTRITION_COMPLETE.md
  - PHASE_2_AI_VARIATIONS_COMPLETE.md

- **Database**:
  - check_premium.sql
  - find_recipe.sql
  - test-share-table.sql

- **Scripts**:
  - restart-project.sh
  - middleware.ts

### Status
Active Next.js application with premium features, AI integration, nutrition tracking, and family cookbook functionality.

---

## 3️⃣ Duplicate: `~/Developer/projects/recipe-keeper`

**Full Path**: `/home/klatt42/Developer/projects/recipe-keeper`
**Size**: 6.4M
**Git Remote**: https://github.com/klatt42/recipe-keeper.git
**Type**: Genesis Framework (duplicate of #1)

### Purpose
**Duplicate of the primary recipe-keeper project** - identical structure and remote repository.

### Contents
Identical to #1 above - same directories, same files, same size.

---

## Project Relationships

```
┌─────────────────────────────────────────────────────────┐
│ recipe-keeper (Framework/SDK)                           │
│ /home/klatt42/recipe-keeper                             │
│                                                          │
│ • Genesis agents                                        │
│ • SDK implementation                                    │
│ • CLI tools                                             │
│ • Templates & patterns                                  │
└─────────────────────────────────────────────────────────┘
                        ↓ Powers
┌─────────────────────────────────────────────────────────┐
│ recipe-keeper-app (Application)                         │
│ /home/klatt42/Developer/projects/recipe-keeper-app      │
│                                                          │
│ • Next.js web app                                       │
│ • User interface                                        │
│ • Database integration                                  │
│ • Feature implementation                                │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ recipe-keeper (Duplicate)                               │
│ /home/klatt42/Developer/projects/recipe-keeper          │
│                                                          │
│ ⚠️  DUPLICATE - Same as #1                              │
└─────────────────────────────────────────────────────────┘
```

---

## Which One to Use?

### For Framework/SDK Development:
```bash
cd ~/recipe-keeper
# or
cd /home/klatt42/recipe-keeper
```

### For Application Development:
```bash
cd ~/Developer/projects/recipe-keeper-app
# or
cd /home/klatt42/Developer/projects/recipe-keeper-app
```

### For Cleanup (Duplicate):
The third location (`~/Developer/projects/recipe-keeper`) appears to be a duplicate and could potentially be removed if it's not actively used.

---

## Quick Access Commands

```bash
# Framework/SDK
cd ~/recipe-keeper

# Application
cd ~/Developer/projects/recipe-keeper-app

# Check git status of both
cd ~/recipe-keeper && git status
cd ~/Developer/projects/recipe-keeper-app && git status
```

---

## Technology Stack

### Framework (recipe-keeper)
- Genesis architecture
- MCP (Model Context Protocol) integration
- Agent-based system
- CLI tools
- SDK for extensions

### Application (recipe-keeper-app)
- **Frontend**: Next.js 13+ (App Router)
- **Language**: TypeScript
- **Styling**: PostCSS
- **Database**: SQL (migrations included)
- **Features**:
  - Family cookbook
  - Recipe import (Gemini AI)
  - Nutrition tracking
  - AI recipe variations
  - Search enhancement
  - Print feature
  - Usage dashboard
  - Premium features

---

## Project Status

### Framework
- Phase 1: ✅ Complete
- Phase 2: ✅ Complete
- Weeks 5-11: ✅ Complete
- Genesis Kernel: ✅ Implemented
- SDK Analysis: ✅ Complete
- SDK Implementation: ✅ Complete
- Claude Code Integration: ✅ Complete
- CLI Integration: ✅ Complete

### Application
- Phase 2B Nutrition: ✅ Complete
- Phase 2 AI Variations: ✅ Complete
- Family Cookbook: ✅ Implemented
- Usage Dashboard: ✅ Implemented
- Recipe Import: ✅ Setup complete
- Search Enhancement: ✅ Complete
- Print Feature: ✅ Enhanced

---

## Recommendations

### 1. Consolidate Duplicate
Consider removing the duplicate at `~/Developer/projects/recipe-keeper` since it mirrors `~/recipe-keeper`.

### 2. Project Organization
Current structure is good:
- Framework/SDK in home directory
- Application in Developer/projects

### 3. For Terminal-Work Integration
Both recipe keeper projects could benefit from:
- Adding to morning briefing scan
- Dashboard monitoring
- Context synchronization
- EOD capture

---

## Add to Projects Scan

To include recipe keeper in your morning briefing and project scans, these paths should be monitored:
1. `/home/klatt42/recipe-keeper`
2. `/home/klatt42/Developer/projects/recipe-keeper-app`

---

## Full Directory Paths

Copy-paste ready:

```bash
# Framework
/home/klatt42/recipe-keeper

# Application
/home/klatt42/Developer/projects/recipe-keeper-app

# Duplicate (consider removing)
/home/klatt42/Developer/projects/recipe-keeper
```

---

## Summary

You have **2 active recipe keeper projects**:

1. **Framework/SDK** (`~/recipe-keeper`) - Genesis-based architecture with agents, CLI, and SDK
2. **Web Application** (`~/Developer/projects/recipe-keeper-app`) - Next.js app with full feature set

Plus one **duplicate** that shares the same remote as #1.

Both are at advanced stages with completed phases and extensive feature implementation.
