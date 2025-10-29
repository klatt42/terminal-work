#!/bin/bash

# AI Installation Helper Script
# Guides through installation of Gemini CLI and Grok CLI

set -e  # Exit on error

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Terminal Superuser AI Installation ===${NC}\n"

# Check Claude Code
echo -e "${YELLOW}1. Checking Claude Code...${NC}"
if command -v claude &> /dev/null; then
    echo -e "${GREEN}✓ Claude Code is installed${NC}"
    claude --version
else
    echo -e "${RED}✗ Claude Code not found${NC}"
    echo "Please install Claude Code first"
    exit 1
fi

echo ""

# Check/Install Gemini CLI
echo -e "${YELLOW}2. Checking Gemini CLI...${NC}"
if command -v gemini &> /dev/null; then
    echo -e "${GREEN}✓ Gemini CLI is already installed${NC}"
    gemini --version
else
    echo -e "${BLUE}Installing Gemini CLI...${NC}"
    read -p "Install Gemini CLI? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm install -g @google/gemini-cli
        echo -e "${GREEN}✓ Gemini CLI installed${NC}"
        echo -e "${YELLOW}Run 'gemini' to authenticate${NC}"
    else
        echo "Skipping Gemini CLI installation"
    fi
fi

echo ""

# Check/Install Grok CLI
echo -e "${YELLOW}3. Checking Grok CLI (optional)...${NC}"
if command -v grok &> /dev/null; then
    echo -e "${GREEN}✓ Grok CLI is already installed${NC}"
    grok --version
else
    echo -e "${BLUE}Grok CLI not found${NC}"
    read -p "Install Grok CLI? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm install -g @vibe-kit/grok-cli
        echo -e "${GREEN}✓ Grok CLI installed${NC}"
        echo ""
        echo -e "${YELLOW}API Key Setup:${NC}"
        echo "1. Get your API key from https://console.x.ai/"
        echo "2. Run: export GROK_API_KEY='your-key'"
        echo "3. Add to ~/.bashrc: echo 'export GROK_API_KEY=\"your-key\"' >> ~/.bashrc"
    else
        echo "Skipping Grok CLI installation (optional)"
    fi
fi

echo ""

# Check tmux
echo -e "${YELLOW}4. Checking tmux (recommended)...${NC}"
if command -v tmux &> /dev/null; then
    echo -e "${GREEN}✓ tmux is installed${NC}"
else
    echo -e "${YELLOW}! tmux not found (recommended for multi-terminal workflows)${NC}"
    read -p "Install tmux? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo apt-get update && sudo apt-get install -y tmux
        echo -e "${GREEN}✓ tmux installed${NC}"
    fi
fi

echo ""

# Initialize context
echo -e "${YELLOW}5. Initializing project context...${NC}"
if [ -f "./scripts/context-sync.sh" ]; then
    ./scripts/context-sync.sh
    echo -e "${GREEN}✓ Context initialized${NC}"
else
    echo -e "${RED}✗ context-sync.sh not found${NC}"
    echo "Make sure you're in the terminal-work directory"
fi

echo ""
echo -e "${GREEN}=== Installation Summary ===${NC}"
echo ""
echo "Installed AIs:"
command -v claude &> /dev/null && echo "  ✓ Claude Code"
command -v gemini &> /dev/null && echo "  ✓ Gemini CLI" || echo "  - Gemini CLI (not installed)"
command -v grok &> /dev/null && echo "  ✓ Grok CLI" || echo "  - Grok CLI (not installed)"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "1. Read QUICKSTART.md for detailed instructions"
echo "2. If you installed Gemini CLI, run: gemini (to authenticate)"
echo "3. If you installed Grok CLI, set your API key"
echo "4. Try your first multi-AI workflow (see QUICKSTART.md)"
echo ""
echo -e "${YELLOW}Quick Test:${NC}"
echo "  claude 'Explain this project'"
echo "  gemini 'Show me the project structure'"
echo "  grok 'List all scripts'"
echo ""
echo -e "${GREEN}Happy multi-AI orchestration! 🚀${NC}"
