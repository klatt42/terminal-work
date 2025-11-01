#!/bin/bash

# Supabase SQL Executor
# Executes SQL files or queries on Supabase projects from terminal

set -e

SUPABASE_BIN="$HOME/bin/supabase"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to detect project from current directory
detect_project() {
    local cwd=$(pwd)
    local project_name=$(basename "$cwd")

    case "$project_name" in
        serp-master)
            echo "SERP Master"
            ;;
        my-erp-plan)
            echo "My-ERP-Plan"
            ;;
        rok-copilot)
            echo "ROK Copilot"
            ;;
        prism-specialties-dmv-empire)
            echo "Prism Specialties"
            ;;
        recipe-keeper-app)
            echo "Recipe Keeper"
            ;;
        *)
            echo "Unknown"
            ;;
    esac
}

# Function to show usage
show_usage() {
    echo ""
    echo -e "${BLUE}Supabase SQL Executor${NC}"
    echo ""
    echo "Execute SQL files or queries on Supabase projects"
    echo ""
    echo "Usage:"
    echo "  supabase-sql <file.sql>           # Execute SQL file"
    echo "  supabase-sql -q \"SELECT * ...\"    # Execute SQL query"
    echo "  supabase-sql --help               # Show this help"
    echo ""
    echo "Examples:"
    echo "  supabase-sql schema.sql"
    echo "  supabase-sql migrations/001_initial.sql"
    echo "  supabase-sql -q \"SELECT * FROM users LIMIT 10\""
    echo ""
    echo "Project Detection:"
    echo "  Automatically detects project from current directory"
    echo "  Supported: serp-master, my-erp-plan, rok-copilot, prism-specialties, recipe-keeper"
    echo ""
    echo "Supabase CLI Commands:"
    echo "  $SUPABASE_BIN db execute -f file.sql   # Execute file"
    echo "  $SUPABASE_BIN db query \"SELECT...\"     # Execute query"
    echo "  $SUPABASE_BIN db diff                  # Show schema diff"
    echo "  $SUPABASE_BIN db push                  # Push migrations"
    echo "  $SUPABASE_BIN link                     # Link to project"
    echo ""
}

# Check if Supabase CLI is installed
if [ ! -f "$SUPABASE_BIN" ]; then
    echo -e "${RED}Error: Supabase CLI not found at $SUPABASE_BIN${NC}"
    echo "Install with: curl -L https://github.com/supabase/cli/releases/latest/download/supabase_linux_amd64.tar.gz | tar -xz -C ~/bin"
    exit 1
fi

# Parse arguments
if [ $# -eq 0 ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    show_usage
    exit 0
fi

# Detect current project
PROJECT=$(detect_project)

echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}           Supabase SQL Executor${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Detected Project:${NC} $PROJECT"
echo -e "${YELLOW}Current Directory:${NC} $(pwd)"
echo ""

# Check if project is linked
if [ ! -f "supabase/config.toml" ]; then
    echo -e "${YELLOW}⚠️  No Supabase project detected in current directory${NC}"
    echo ""
    echo "To link this project to Supabase:"
    echo "  1. Run: $SUPABASE_BIN login"
    echo "  2. Run: $SUPABASE_BIN init (if not initialized)"
    echo "  3. Run: $SUPABASE_BIN link --project-ref <your-project-ref>"
    echo ""
    echo "Or execute SQL manually:"
    echo "  1. Run: $SUPABASE_BIN db query \"<your-sql>\""
    echo ""
    exit 1
fi

# Execute based on arguments
if [ "$1" == "-q" ] || [ "$1" == "--query" ]; then
    # Execute query
    QUERY="$2"
    echo -e "${GREEN}Executing query...${NC}"
    echo ""
    echo -e "${BLUE}Query:${NC}"
    echo "$QUERY"
    echo ""

    $SUPABASE_BIN db query "$QUERY"

elif [ -f "$1" ]; then
    # Execute file
    SQL_FILE="$1"
    echo -e "${GREEN}Executing SQL file: $SQL_FILE${NC}"
    echo ""

    # Show preview of SQL file (first 10 lines)
    echo -e "${BLUE}Preview (first 10 lines):${NC}"
    head -10 "$SQL_FILE"
    echo ""

    # Execute
    $SUPABASE_BIN db execute -f "$SQL_FILE"

    echo ""
    echo -e "${GREEN}✓ SQL file executed successfully${NC}"

else
    echo -e "${RED}Error: File not found: $1${NC}"
    echo ""
    show_usage
    exit 1
fi

echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
