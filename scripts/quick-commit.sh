#!/bin/bash

# Quick Commit Script
# Usage: ./scripts/quick-commit.sh "Add: morning standup notes"
# Usage: ./scripts/quick-commit.sh  (prompts for message)

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get commit message
if [ -z "$1" ]; then
    echo -e "${BLUE}Enter commit message:${NC}"
    read -r COMMIT_MSG
else
    COMMIT_MSG="$1"
fi

if [ -z "$COMMIT_MSG" ]; then
    echo -e "${YELLOW}No commit message provided. Exiting.${NC}"
    exit 1
fi

# Check if there are changes
if [[ -z $(git status -s) ]]; then
    echo -e "${YELLOW}No changes to commit.${NC}"
    exit 0
fi

echo -e "${BLUE}Committing changes...${NC}"
git add -A

# Create commit with user's message
git commit -m "$COMMIT_MSG"

echo -e "${GREEN}✓ Committed: $COMMIT_MSG${NC}"
echo ""
echo -e "${YELLOW}Push to GitHub? (y/n)${NC}"
read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push
    echo -e "${GREEN}✓ Pushed to GitHub${NC}"
else
    echo -e "${YELLOW}Not pushed. Run 'git push' when ready.${NC}"
fi
