#!/bin/bash
# Port Management System for Multi-Project Development

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORT_REGISTRY="$SCRIPT_DIR/../config/port-registry.json"
PORT_CACHE="$HOME/.port-cache.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if port is in use
is_port_in_use() {
    local port=$1
    lsof -i :"$port" -sTCP:LISTEN -t >/dev/null 2>&1
    return $?
}

# Function to get project's assigned port
get_project_port() {
    local project=$1
    local service=${2:-frontend}

    if [ -f "$PORT_REGISTRY" ]; then
        port=$(jq -r ".ports.\"$project\".\"$service\" // empty" "$PORT_REGISTRY" 2>/dev/null)
        if [ -n "$port" ] && [ "$port" != "null" ]; then
            echo "$port"
            return 0
        fi
    fi
    return 1
}

# Function to find next available port
find_next_port() {
    local start_port=${1:-3000}
    local max_port=$((start_port + 100))

    for ((port=start_port; port<=max_port; port++)); do
        if ! is_port_in_use $port; then
            echo $port
            return 0
        fi
    done

    echo "ERROR: No available ports found between $start_port and $max_port" >&2
    return 1
}

# Function to show all registered ports
show_registry() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}                    PORT REGISTRY                              ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""

    if [ ! -f "$PORT_REGISTRY" ]; then
        echo -e "${RED}Port registry not found: $PORT_REGISTRY${NC}"
        return 1
    fi

    echo -e "${GREEN}Active Projects:${NC}"
    echo ""

    # Read and display active projects
    jq -r '.ports | to_entries[] | select(.value.status == "active") |
        "\(.key)|\(.value.frontend // "N/A")|\(.value.backend // "N/A")|\(.value.notes)"' "$PORT_REGISTRY" | \
    while IFS='|' read -r project frontend backend notes; do
        printf "  ${GREEN}%-30s${NC} Frontend: ${YELLOW}%-6s${NC} Backend: ${YELLOW}%-6s${NC}\n" "$project" "$frontend" "$backend"
        printf "  └─ %s\n\n" "$notes"
    done

    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Reserved Port Ranges:${NC}"
    echo "  • 3000-3019: Frontend services"
    echo "  • 8000-8019: Backend APIs"
    echo "  • 9000-9019: Microservices"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
}

# Function to show what's currently running
show_running() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}                CURRENTLY RUNNING SERVICES                     ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""

    local found=false

    # Check each registered port
    if [ -f "$PORT_REGISTRY" ]; then
        jq -r '.ports | to_entries[] | "\(.key)|\(.value.frontend)|\(.value.backend)"' "$PORT_REGISTRY" | \
        while IFS='|' read -r project frontend backend; do
            local services_running=""

            if [ "$frontend" != "null" ] && is_port_in_use "$frontend"; then
                services_running="${GREEN}Frontend:$frontend${NC}"
                found=true
            fi

            if [ "$backend" != "null" ] && is_port_in_use "$backend"; then
                if [ -n "$services_running" ]; then
                    services_running="$services_running, ${GREEN}Backend:$backend${NC}"
                else
                    services_running="${GREEN}Backend:$backend${NC}"
                fi
                found=true
            fi

            if [ -n "$services_running" ]; then
                echo -e "  ${YELLOW}$project${NC}"
                echo -e "    └─ $services_running"
                echo -e "    └─ ${BLUE}http://localhost:$frontend${NC}"
                echo ""
            fi
        done
    fi

    if [ "$found" = false ]; then
        echo "  No registered services currently running"
        echo ""
    fi

    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
}

# Function to open project in browser
open_project() {
    local project=$1
    local port=$(get_project_port "$project" "frontend")

    if [ -z "$port" ]; then
        echo -e "${RED}Project '$project' not found in registry${NC}"
        return 1
    fi

    if ! is_port_in_use "$port"; then
        echo -e "${YELLOW}Warning: Port $port is not in use. Service may not be running.${NC}"
        read -p "Open anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi

    local url="http://localhost:$port"
    echo -e "${GREEN}Opening $project at $url${NC}"

    # Open in incognito/private mode
    if command -v google-chrome &> /dev/null; then
        google-chrome --incognito "$url" &
    elif command -v chromium &> /dev/null; then
        chromium --incognito "$url" &
    elif command -v firefox &> /dev/null; then
        firefox --private-window "$url" &
    else
        xdg-open "$url" &
    fi
}

# Function to get port for a project (creates if doesn't exist)
get_or_assign_port() {
    local project=$1
    local service=${2:-frontend}

    # Check if project already has a port
    local port=$(get_project_port "$project" "$service")

    if [ -n "$port" ]; then
        # Port assigned, check if in use
        if is_port_in_use "$port"; then
            echo -e "${YELLOW}Warning: Port $port (assigned to $project $service) is already in use${NC}"
            echo -e "${YELLOW}Finding alternative port...${NC}"

            # Find next available port
            local start_port=3000
            [ "$service" = "backend" ] && start_port=8000

            port=$(find_next_port $start_port)
            echo -e "${GREEN}Using port $port instead${NC}"
        fi

        echo "$port"
        return 0
    else
        # No port assigned, find one
        echo -e "${YELLOW}No port assigned for $project ($service), finding available port...${NC}"

        local start_port=3000
        [ "$service" = "backend" ] && start_port=8000

        port=$(find_next_port $start_port)

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Assigning port $port to $project ($service)${NC}"
            echo "$port"
            return 0
        else
            return 1
        fi
    fi
}

# Function to kill service on port
kill_port() {
    local port=$1

    if is_port_in_use "$port"; then
        echo -e "${YELLOW}Killing service on port $port...${NC}"
        lsof -ti :"$port" | xargs kill -9 2>/dev/null
        sleep 1

        if ! is_port_in_use "$port"; then
            echo -e "${GREEN}Port $port is now free${NC}"
        else
            echo -e "${RED}Failed to free port $port${NC}"
            return 1
        fi
    else
        echo -e "${GREEN}Port $port is already free${NC}"
    fi
}

# Main command dispatcher
case "${1:-help}" in
    show|list)
        show_registry
        ;;
    running|status)
        show_running
        ;;
    open)
        if [ -z "$2" ]; then
            echo "Usage: port-manager.sh open <project-name>"
            exit 1
        fi
        open_project "$2"
        ;;
    get)
        if [ -z "$2" ]; then
            echo "Usage: port-manager.sh get <project-name> [frontend|backend]"
            exit 1
        fi
        port=$(get_or_assign_port "$2" "${3:-frontend}")
        echo "$port"
        ;;
    check)
        if [ -z "$2" ]; then
            echo "Usage: port-manager.sh check <port>"
            exit 1
        fi
        if is_port_in_use "$2"; then
            echo -e "${RED}Port $2 is IN USE${NC}"
            lsof -i :"$2"
        else
            echo -e "${GREEN}Port $2 is AVAILABLE${NC}"
        fi
        ;;
    kill)
        if [ -z "$2" ]; then
            echo "Usage: port-manager.sh kill <port>"
            exit 1
        fi
        kill_port "$2"
        ;;
    help|--help|-h)
        echo "Port Manager - Multi-Project Development Port Management"
        echo ""
        echo "Usage: port-manager.sh <command> [options]"
        echo ""
        echo "Commands:"
        echo "  show, list           Show all registered ports"
        echo "  running, status      Show currently running services"
        echo "  open <project>       Open project in incognito browser"
        echo "  get <project> [type] Get or assign port for project"
        echo "  check <port>         Check if port is in use"
        echo "  kill <port>          Kill service on port"
        echo "  help                 Show this help message"
        echo ""
        echo "Examples:"
        echo "  port-manager.sh show"
        echo "  port-manager.sh running"
        echo "  port-manager.sh open serp-master"
        echo "  port-manager.sh get my-erp-plan frontend"
        echo "  port-manager.sh check 3000"
        echo "  port-manager.sh kill 3000"
        ;;
    *)
        echo "Unknown command: $1"
        echo "Run 'port-manager.sh help' for usage"
        exit 1
        ;;
esac
