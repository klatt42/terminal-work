#!/bin/bash

# MCP Container Orchestrator - List Script

REGISTRY_FILE="$HOME/projects/terminal-work/config/mcp-registry.json"
STATE_DIR="$HOME/.config/terminal-work/mcp"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Check if container is running
is_running() {
    local container_name="$1"
    docker ps --filter "name=$container_name" --format "{{.Names}}" 2>/dev/null | grep -q "^${container_name}$"
}

# Get container uptime
get_uptime() {
    local container_name="$1"
    docker ps --filter "name=$container_name" --format "{{.Status}}" 2>/dev/null
}

# List all MCPs
list_mcps() {
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}           MCP Container Status${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""

    local running_count=0
    local stopped_count=0

    for mcp_name in $(jq -r '.mcpServers | keys[]' "$REGISTRY_FILE"); do
        local config=$(jq -r ".mcpServers.\"$mcp_name\"" "$REGISTRY_FILE")
        local mcp_display_name=$(echo "$config" | jq -r '.name')
        local port=$(echo "$config" | jq -r '.port')
        local container_name=$(echo "$config" | jq -r '.containerName // empty')
        local managed_externally=$(echo "$config" | jq -r '.managedExternally // false')

        if [ -z "$container_name" ]; then
            container_name="mcp-${mcp_name}"
        fi

        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${MAGENTA}$mcp_display_name${NC} (${mcp_name})"

        if is_running "$container_name"; then
            running_count=$((running_count + 1))
            local uptime=$(get_uptime "$container_name")

            echo -e "${GREEN}  Status:${NC} Running ✓"
            echo -e "${CYAN}  Container:${NC} $container_name"
            echo -e "${CYAN}  Port:${NC} $port"
            echo -e "${CYAN}  Uptime:${NC} $uptime"
            echo -e "${CYAN}  Endpoint:${NC} http://localhost:$port"

            if [ "$managed_externally" == "true" ]; then
                echo -e "${YELLOW}  Note:${NC} Managed externally"
            fi
        else
            stopped_count=$((stopped_count + 1))
            echo -e "${YELLOW}  Status:${NC} Stopped"
            echo -e "${CYAN}  Port:${NC} $port (when running)"
            echo -e "${CYAN}  Start with:${NC} mcp-launch $mcp_name"
        fi

        # Show capabilities
        local capabilities=$(echo "$config" | jq -r '.capabilities[]' | tr '\n' ', ' | sed 's/,$//')
        echo -e "${CYAN}  Capabilities:${NC} $capabilities"
    done

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${GREEN}Running:${NC} $running_count  ${YELLOW}Stopped:${NC} $stopped_count"
    echo ""
}

# Show detailed info for specific MCP
show_mcp_info() {
    local mcp_name="$1"

    local config=$(jq -r ".mcpServers.\"$mcp_name\"" "$REGISTRY_FILE")

    if [ "$config" == "null" ]; then
        echo -e "${RED}Error: MCP '$mcp_name' not found${NC}"
        exit 1
    fi

    local mcp_display_name=$(echo "$config" | jq -r '.name')
    local description=$(echo "$config" | jq -r '.description')
    local image=$(echo "$config" | jq -r '.image')
    local port=$(echo "$config" | jq -r '.port')
    local container_name=$(echo "$config" | jq -r '.containerName // empty')

    if [ -z "$container_name" ]; then
        container_name="mcp-${mcp_name}"
    fi

    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}           MCP Details: $mcp_display_name${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${BLUE}Description:${NC} $description"
    echo -e "${BLUE}Image:${NC} $image"
    echo -e "${BLUE}Container:${NC} $container_name"
    echo -e "${BLUE}Port:${NC} $port"
    echo ""

    if is_running "$container_name"; then
        echo -e "${GREEN}Status: Running ✓${NC}"
        echo -e "${CYAN}Uptime:${NC} $(get_uptime "$container_name")"
        echo -e "${CYAN}Endpoint:${NC} http://localhost:$port"
        echo ""
        echo "Logs (last 20 lines):"
        docker logs --tail 20 "$container_name"
    else
        echo -e "${YELLOW}Status: Stopped${NC}"
        echo ""
        echo "Start with: mcp-launch $mcp_name"
    fi
}

# Show usage
show_usage() {
    echo ""
    echo -e "${CYAN}MCP Container Orchestrator - List${NC}"
    echo ""
    echo "Usage:"
    echo "  mcp-list              # List all MCPs"
    echo "  mcp-list <mcp-name>   # Show detailed info"
    echo ""
    echo "Examples:"
    echo "  mcp-list"
    echo "  mcp-list docker-hub"
    echo ""
}

# Main
if [ $# -eq 0 ]; then
    list_mcps
elif [ "$1" == "--help" ]; then
    show_usage
else
    show_mcp_info "$1"
fi
