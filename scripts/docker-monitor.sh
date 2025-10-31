#!/bin/bash
# Docker Container Monitoring for Multi-Project Development

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if Docker is running
is_docker_running() {
    docker info >/dev/null 2>&1
    return $?
}

# Function to show all containers
show_containers() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}               DOCKER CONTAINERS STATUS                        ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""

    if ! is_docker_running; then
        echo -e "${RED}Docker is not running or not accessible${NC}"
        return 1
    fi

    # Running containers
    local running=$(docker ps --format "{{.Names}}" | wc -l)
    local stopped=$(docker ps -a --filter "status=exited" --format "{{.Names}}" | wc -l)

    echo -e "${GREEN}Running Containers: $running${NC}"
    echo -e "${YELLOW}Stopped Containers: $stopped${NC}"
    echo ""

    if [ "$running" -gt 0 ]; then
        echo -e "${GREEN}▶ Running:${NC}"
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | tail -n +2 | while read -r line; do
            echo -e "  ${GREEN}●${NC} $line"
        done
        echo ""
    fi

    if [ "$stopped" -gt 0 ]; then
        echo -e "${YELLOW}■ Stopped:${NC}"
        docker ps -a --filter "status=exited" --format "table {{.Names}}\t{{.Status}}" | tail -n +2 | while read -r line; do
            echo -e "  ${YELLOW}●${NC} $line"
        done
        echo ""
    fi

    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
}

# Function to show Archon OS status
show_archon() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}                   ARCHON OS STATUS                            ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""

    if ! is_docker_running; then
        echo -e "${RED}Docker is not running${NC}"
        return 1
    fi

    # Check Archon containers
    local archon_containers=("Archon-UI" "Archon-MCP" "Archon-Server" "Archon-Agents")
    local all_running=true

    for container in "${archon_containers[@]}"; do
        if docker ps --filter "name=$container" --filter "status=running" | grep -q "$container"; then
            local status=$(docker ps --filter "name=$container" --format "{{.Status}}")
            local ports=$(docker ps --filter "name=$container" --format "{{.Ports}}")
            echo -e "  ${GREEN}✓${NC} $container"
            echo -e "    Status: ${GREEN}$status${NC}"
            echo -e "    Ports: ${BLUE}$ports${NC}"
            echo ""
        else
            echo -e "  ${RED}✗${NC} $container ${RED}(not running)${NC}"
            all_running=false
            echo ""
        fi
    done

    if [ "$all_running" = true ]; then
        echo -e "${GREEN}✓ All Archon OS services healthy${NC}"
        echo -e "${BLUE}▶ Access UI: http://localhost:3737${NC}"
    else
        echo -e "${YELLOW}⚠ Some Archon OS services are down${NC}"
    fi

    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
}

# Function to get container logs
show_logs() {
    local container=$1
    local lines=${2:-50}

    if [ -z "$container" ]; then
        echo "Usage: docker-monitor.sh logs <container-name> [lines]"
        return 1
    fi

    if ! docker ps -a --format "{{.Names}}" | grep -q "^${container}$"; then
        echo -e "${RED}Container '$container' not found${NC}"
        return 1
    fi

    echo -e "${BLUE}Last $lines lines from $container:${NC}"
    echo ""
    docker logs --tail "$lines" "$container" 2>&1
}

# Function to start Archon OS
start_archon() {
    echo -e "${BLUE}Starting Archon OS...${NC}"

    # Check if docker-compose file exists
    local archon_dir=$(find ~ -name "archon-os" -type d 2>/dev/null | head -1)

    if [ -z "$archon_dir" ]; then
        echo -e "${RED}Archon OS directory not found${NC}"
        echo "Please specify the Archon OS directory"
        return 1
    fi

    cd "$archon_dir" || return 1

    if [ -f "docker-compose.yml" ]; then
        docker-compose up -d
        echo -e "${GREEN}Archon OS started${NC}"
        sleep 2
        show_archon
    else
        echo -e "${RED}docker-compose.yml not found in $archon_dir${NC}"
        return 1
    fi
}

# Function to stop Archon OS
stop_archon() {
    echo -e "${YELLOW}Stopping Archon OS...${NC}"

    local containers=("Archon-UI" "Archon-MCP" "Archon-Server" "Archon-Agents")

    for container in "${containers[@]}"; do
        if docker ps --filter "name=$container" | grep -q "$container"; then
            docker stop "$container"
            echo -e "  ${YELLOW}●${NC} Stopped $container"
        fi
    done

    echo -e "${GREEN}Archon OS stopped${NC}"
}

# Function to restart Archon OS
restart_archon() {
    stop_archon
    echo ""
    sleep 2
    start_archon
}

# Function to export JSON for dashboard
export_json() {
    if ! is_docker_running; then
        echo '{"error":"Docker not running","containers":[]}'
        return 1
    fi

    echo "{"
    echo '  "timestamp":"'$(date -Iseconds)'",'
    echo '  "docker_running":true,'
    echo '  "containers":['

    local first=true
    docker ps -a --format '{{json .}}' | while read -r container; do
        if [ "$first" = false ]; then
            echo ","
        fi
        echo "    $container"
        first=false
    done

    echo ""
    echo '  ],'
    echo '  "archon_status":{'

    # Check Archon containers
    local archon_ui=$(docker ps --filter "name=Archon-UI" --filter "status=running" --format "{{.Status}}" || echo "not running")
    local archon_mcp=$(docker ps --filter "name=Archon-MCP" --filter "status=running" --format "{{.Status}}" || echo "not running")
    local archon_server=$(docker ps --filter "name=Archon-Server" --filter "status=running" --format "{{.Status}}" || echo "not running")
    local archon_agents=$(docker ps --filter "name=Archon-Agents" --filter "status=running" --format "{{.Status}}" || echo "not running")

    echo '    "ui":"'$archon_ui'",'
    echo '    "mcp":"'$archon_mcp'",'
    echo '    "server":"'$archon_server'",'
    echo '    "agents":"'$archon_agents'"'
    echo '  }'
    echo "}"
}

# Main command dispatcher
case "${1:-help}" in
    show|list|status)
        show_containers
        ;;
    archon)
        show_archon
        ;;
    logs)
        show_logs "$2" "${3:-50}"
        ;;
    start)
        if [ "$2" = "archon" ]; then
            start_archon
        else
            echo "Usage: docker-monitor.sh start archon"
        fi
        ;;
    stop)
        if [ "$2" = "archon" ]; then
            stop_archon
        else
            echo "Usage: docker-monitor.sh stop archon"
        fi
        ;;
    restart)
        if [ "$2" = "archon" ]; then
            restart_archon
        else
            echo "Usage: docker-monitor.sh restart archon"
        fi
        ;;
    json|export)
        export_json
        ;;
    help|--help|-h)
        echo "Docker Monitor - Container Management for Development"
        echo ""
        echo "Usage: docker-monitor.sh <command> [options]"
        echo ""
        echo "Commands:"
        echo "  show, list, status   Show all containers"
        echo "  archon               Show Archon OS status"
        echo "  logs <container>     Show container logs"
        echo "  start archon         Start Archon OS"
        echo "  stop archon          Stop Archon OS"
        echo "  restart archon       Restart Archon OS"
        echo "  json, export         Export JSON for dashboard"
        echo "  help                 Show this help message"
        echo ""
        echo "Examples:"
        echo "  docker-monitor.sh show"
        echo "  docker-monitor.sh archon"
        echo "  docker-monitor.sh logs Archon-UI"
        echo "  docker-monitor.sh start archon"
        echo "  docker-monitor.sh restart archon"
        ;;
    *)
        echo "Unknown command: $1"
        echo "Run 'docker-monitor.sh help' for usage"
        exit 1
        ;;
esac
