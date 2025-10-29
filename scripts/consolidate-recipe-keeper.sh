#!/bin/bash

# Recipe Keeper Consolidation Script
# Moves recipe-keeper-app to ~/projects/ and removes duplicates

set -e  # Exit on any error

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       RECIPE KEEPER CONSOLIDATION & CLEANUP                  ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Define paths
SOURCE_APP="$HOME/Developer/projects/recipe-keeper-app"
DEST_APP="$HOME/projects/recipe-keeper-app"
DUP1="$HOME/recipe-keeper"
DUP2="$HOME/Developer/projects/recipe-keeper"

# Step 1: Verify source exists
echo -e "${YELLOW}Step 1: Verifying source project...${NC}"
if [ ! -d "$SOURCE_APP" ]; then
    echo -e "${RED}✗ Source not found: $SOURCE_APP${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Source verified: $SOURCE_APP${NC}"
echo ""

# Step 2: Check git status
echo -e "${YELLOW}Step 2: Checking git status...${NC}"
cd "$SOURCE_APP"
if [[ -n $(git status -s) ]]; then
    echo -e "${RED}⚠️  Uncommitted changes found!${NC}"
    git status -s
    echo ""
    read -p "Commit these changes before moving? (y/n): " commit_choice
    if [ "$commit_choice" = "y" ]; then
        read -p "Enter commit message: " msg
        git add -A
        git commit -m "$msg"
        echo -e "${GREEN}✓ Changes committed${NC}"
    else
        echo -e "${YELLOW}⚠️  Proceeding with uncommitted changes${NC}"
    fi
else
    echo -e "${GREEN}✓ Working directory clean${NC}"
fi
echo ""

# Step 3: Stop dev server if running
echo -e "${YELLOW}Step 3: Stopping any running dev servers...${NC}"
pkill -f "next dev" || echo "  No dev server running"
sleep 2
echo -e "${GREEN}✓ Dev servers stopped${NC}"
echo ""

# Step 4: Create backup
echo -e "${YELLOW}Step 4: Creating backup...${NC}"
BACKUP_FILE="$HOME/recipe-keeper-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
tar -czf "$BACKUP_FILE" -C "$HOME/Developer/projects" recipe-keeper-app 2>/dev/null
echo -e "${GREEN}✓ Backup created: $BACKUP_FILE${NC}"
echo ""

# Step 5: Ensure destination directory exists
echo -e "${YELLOW}Step 5: Preparing destination...${NC}"
mkdir -p "$HOME/projects"
if [ -d "$DEST_APP" ]; then
    echo -e "${RED}⚠️  Destination already exists: $DEST_APP${NC}"
    read -p "Overwrite? (y/n): " overwrite
    if [ "$overwrite" != "y" ]; then
        echo "Aborting."
        exit 1
    fi
    rm -rf "$DEST_APP"
fi
echo -e "${GREEN}✓ Destination ready${NC}"
echo ""

# Step 6: Move the app
echo -e "${YELLOW}Step 6: Moving recipe-keeper-app to ~/projects/...${NC}"
mv "$SOURCE_APP" "$DEST_APP"
echo -e "${GREEN}✓ Moved to: $DEST_APP${NC}"
echo ""

# Step 7: Verify git still works
echo -e "${YELLOW}Step 7: Verifying git repository...${NC}"
cd "$DEST_APP"
git remote -v
git status
echo -e "${GREEN}✓ Git repository intact${NC}"
echo ""

# Step 8: Remove duplicate #1
echo -e "${YELLOW}Step 8: Removing duplicate #1...${NC}"
if [ -d "$DUP1" ]; then
    echo "  Removing: $DUP1"
    rm -rf "$DUP1"
    echo -e "${GREEN}✓ Removed $DUP1${NC}"
else
    echo "  Not found (already clean)"
fi
echo ""

# Step 9: Remove duplicate #2
echo -e "${YELLOW}Step 9: Removing duplicate #2...${NC}"
if [ -d "$DUP2" ]; then
    echo "  Removing: $DUP2"
    rm -rf "$DUP2"
    echo -e "${GREEN}✓ Removed $DUP2${NC}"
else
    echo "  Not found (already clean)"
fi
echo ""

# Step 10: Clean up empty directories
echo -e "${YELLOW}Step 10: Cleaning up empty directories...${NC}"
[ -d "$HOME/Developer/projects" ] && rmdir "$HOME/Developer/projects" 2>/dev/null && echo "  Removed empty Developer/projects" || echo "  Developer/projects not empty (kept)"
[ -d "$HOME/Developer" ] && rmdir "$HOME/Developer" 2>/dev/null && echo "  Removed empty Developer" || echo "  Developer not empty (kept)"
echo -e "${GREEN}✓ Cleanup complete${NC}"
echo ""

# Step 11: Summary
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                 CONSOLIDATION COMPLETE ✓                     ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📊 Results:${NC}"
echo "   ✅ Moved: $SOURCE_APP"
echo "      → to: $DEST_APP"
echo "   ✅ Removed: $DUP1"
echo "   ✅ Removed: $DUP2"
echo "   ✅ Backup: $BACKUP_FILE"
echo ""
echo -e "${BLUE}📁 New structure:${NC}"
echo "   ~/projects/"
echo "   ├── terminal-work/                  ✓"
echo "   └── recipe-keeper-app/              ✓ (just moved here)"
echo ""
echo -e "${BLUE}🔍 Verification:${NC}"
echo "   Git status: $(cd $DEST_APP && git status -s | wc -l) uncommitted files"
echo "   Remote: $(cd $DEST_APP && git remote get-url origin)"
echo ""
echo -e "${BLUE}🎯 Next steps:${NC}"
echo "   1. cd ~/projects/recipe-keeper-app"
echo "   2. npm run dev  # Test that it still works"
echo "   3. Run 'morning' to see it in project scan"
echo ""
echo -e "${YELLOW}💡 Tip: If anything went wrong, restore from:${NC}"
echo "   $BACKUP_FILE"
echo ""
