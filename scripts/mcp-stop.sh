#!/bin/bash

# MCP Container Orchestrator - Stop Script

set -e

REGISTRY_FILE="$HOME/projects/terminal-work/config/mcp-registry.json"
STATE_DIR="$HOME/.config/terminal-work/mcp"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Get MCP config
get_mcp_config() {
    local mcp_name="$1"
    jq -r ".mcpServers.\"$mcp_name\"" "$REGISTRY_FILE"
}

# Stop MCP
stop_mcp() {
    local mcp_name="$1"

    # Get config
    local config=$(get_mcp_config "$mcp_name")

    if [ "$config" == "null" ]; then
        echo -e "${RED}Error: MCP '$mcp_name' not found${NC}"
        exit 1
    fi

    local container_name=$(echo "$config" | jq -r '.containerName // empty')
    if [ -z "$container_name" ]; then
        container_name="mcp-${mcp_name}"
    fi

    # Check if running
    if ! docker ps --filter "name=$container_name" --format "{{.Names}}" 2>/dev/null | grep -q "^${container_name}$"; then
        echo -e "${YELLOW}MCP '$mcp_name' is not running${NC}"
        return 0
    fi

    echo -e "${BLUE}Stopping MCP: $mcp_name${NC}"
    docker stop "$container_name" >/dev/null
    docker rm "$container_name" >/dev/null

    # Remove state file
    rm -f "$STATE_DIR/${mcp_name}.json"

    echo -e "${GREEN}✓ MCP stopped and removed${NC}"
}

# Stop all MCPs
stop_all() {
    echo -e "${BLUE}Stopping all MCP containers...${NC}"
    local stopped=0

    for mcp_name in $(jq -r '.mcpServers | keys[]' "$REGISTRY_FILE"); do
        local config=$(get_mcp_config "$mcp_name")
        local managed_externally=$(echo "$config" | jq -r '.managedExternally // false')

        # Skip externally managed
        if [ "$managed_externally" == "true" ]; then
            continue
        fi

        local container_name=$(echo "$config" | jq -r '.containerName // empty')
        if [ -z "$container_name" ]; then
            container_name="mcp-${mcp_name}"
        fi

        if docker ps --filter "name=$container_name" --format "{{.Names}}" 2>/dev/null | grep -q "^${container_name}$"; then
            echo -e "  Stopping: $mcp_name"
            docker stop "$container_name" >/dev/null
            docker rm "$container_name" >/dev/null
            rm -f "$STATE_DIR/${mcp_name}.json"
            stopped=$((stopped + 1))
        fi
    done

    echo -e "${GREEN}✓ Stopped $stopped MCP containers${NC}"
}

# Show usage
show_usage() {
    echo ""
    echo -e "${CYAN}MCP Container Orchestrator - Stop${NC}"
    echo ""
    echo "Usage:"
    echo "  mcp-stop <mcp-name>    # Stop specific MCP"
    echo "  mcp-stop --all         # Stop all MCPs"
    echo ""
    echo "Examples:"
    echo "  mcp-stop docker-hub"
    echo "  mcp-stop playwright"
    echo "  mcp-stop --all"
    echo ""
}

# Main
if [ $# -eq 0 ]; then
    show_usage
    exit 0
fi

if [ "$1" == "--all" ]; then
    stop_all
else
    stop_mcp "$1"
fi
